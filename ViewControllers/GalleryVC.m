//
//  GalleryVC.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "../ModelControllers/DataManager.h"
#import "GalleryVC.h"
#import "ItemViewCell.h"
#import "PreviewViewController.h"
#import "Config.h"

@interface GalleryVC ()
//https://youtu.be/Z436l0z72R8?t=211
//UICollectionViewLayout custom
{
  NSArray *dataArr;
  BOOL cancelLoading;
}

@property (nonatomic) NSMutableArray<UIImage*> *gallery;
@property (nonatomic) NSArray<NSDictionary*> *imagesCatalogue;
@end

@implementation GalleryVC
{
  //keeping to test a leak
  PreviewViewController *previewViewController;
}

//https://www.youtube.com/watch?v=qV4gHfqwFPU
//ObjectiveC, Autoresizing mask, Autolayout
static NSString * const reuseIdentifier = @"SimpleCell";



#pragma mark Static methods

+ (id) sessionCheckData: (NSData * _Nullable) data
               response:(NSURLResponse * _Nullable) response
                  error: ( NSError * _Nullable) error {
  
  NSLog(@"%@", data.description);
  NSLog(@"%@", response.description);
  
  if(error) {
    NSLog(@"\n  %@", error);
    return nil;
  }
  
  NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
  if(httpResp.statusCode <200 || httpResp.statusCode > 300) {
    return nil;
  }
  
  NSError *parseErr;
  id json = [NSJSONSerialization JSONObjectWithData:data
                                           options:0
                                             error:&parseErr];
  if(!json){
    return nil;
  }
  
  return json;
}

//like in coursera core data course
- (id) init {
  if([super init] == nil) return nil;
  
  self.gallery = [NSMutableArray arrayWithArray: @[@1,@2,@3] ];
  [self.gallery addObject:@4];
  
  [self startLoadingCatalogue];
  
  return self;
}

- (void) initGallery {
  _gallery = [NSMutableArray arrayWithArray: @[] ];
//  [self.gallery addObject:@4];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  if([super initWithCollectionViewLayout: layout] == nil) return nil;
  
  [self initGallery];
  //[self startLoading];
  
//  self.block = ^{
//    NSLog(self);
//  };
  return self;
}

- (void)startLoadingCatalogue {
  NSString * urlString = [NSString stringWithFormat: kPhotosUrl,
                          APIKEY,
                          USERID
                          ];
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  __auto_type __weak weakSelf = self;
  NSURLSessionDataTask *task = [session dataTaskWithURL:url
          completionHandler:^(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error) {
            
            id json = [GalleryVC sessionCheckData: data
                                        response: response
                                           error: error];
            
            
            NSArray *images = [weakSelf handleGetPublicPhotosJSON: json];
            
            //[weakSelf startLoadingImagesSequentially:images];
            weakSelf.imagesCatalogue = images;
            
            // signal the collection view to start loading images
            dispatch_sync(dispatch_get_main_queue(), ^{
              [weakSelf.collectionView reloadData];
            });
            
          }
    ];
  [task resume];
}

//todo check docs on json
- (NSArray*)handleGetPublicPhotosJSON:(id)pkg
{
  NSArray *images = pkg[@"photos"][@"photo"];
  
  NSRange range;
  range.location = 0;
  range.length = 100;
  
  //return [images subarrayWithRange:range];
  return images;
}

+ (NSString*)makeUrlStringFromJSON:(NSDictionary*)json
                            suffix:(NSString*)suffix{
  NSString* imageId = json[@"id"];
  NSString* server = json[@"server"];
  NSString* secret = json[@"secret"];
  NSNumber* farm = json[@"farm"];
  
  NSString *imageUrlString = [NSString stringWithFormat:
                              @"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg",
                              farm, server, imageId, secret, suffix
                              ];
  
  return imageUrlString;
}

+ (NSString*)makeUrlStringFromJSON:(NSDictionary*)json{
    return [GalleryVC makeUrlStringFromJSON:json
                              suffix:@"z"];
}
+ (NSString*)makeUrlStringFromJSON:(NSDictionary*)json
                            number:(NSNumber*)number {
  
  
  return [GalleryVC makeUrlStringFromJSON:json
                                   suffix:@"z"];
  
//  NSNumber *num = number;
//  num++;
  return [NSString stringWithFormat: @"https://placehold.it/1640x1512&text=%@", number];
  
}


# pragma mark Synchronous loading

- (void)startLoadingPicture:(id)json {
  NSString *imageUrlString = [GalleryVC makeUrlStringFromJSON:json];

  //можно загружать синхронно, а еще
  //можно при начале загрузки зарезервировать место, в которое записать результат после загрузки
  //[self startLoadingAsync:imageUrlString];
  
  //синхр:
  NSData * _Nullable data = [GalleryVC startLoadingSync:imageUrlString];
  [self appendImage: data];
  //
  __auto_type __weak weakSelf = self;

  dispatch_sync(dispatch_get_main_queue(), ^{
    [weakSelf.collectionView reloadData];
  });
  

}

/**
 Returns an image. Synchronous request
 */
+ (UIImage*)startLoadingPictureWithUrl:(NSString*)imageUrlString{
  //problem ?
  NSData * _Nullable data = [GalleryVC startLoadingSync:imageUrlString];
  
  return [UIImage imageWithData:data];
}

+ (NSData * _Nullable)startLoadingSync:(NSString*)imageUrlString{
  
  NSURL *url = [NSURL URLWithString:imageUrlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSLog(@"\n  start loading %@", imageUrlString);
  
  dispatch_semaphore_t sem;
  //если здесь остановиться на 20 секунд, то дальше уже не идет
  sem = dispatch_semaphore_create(0);
  __block NSData * result = nil;
  
  [[session dataTaskWithURL:url
          completionHandler:^(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error) {
            
            NSLog(@"\n  finished loading %@", imageUrlString);
            if(error) {
              NSLog(@"\n  %@", error);
              return ;
            }
            
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if(httpResp.statusCode <200 || httpResp.statusCode > 300) {
              return;
            }
            
            result = data;
            
            [NSThread sleepForTimeInterval: 1.0 ];
            
            dispatch_semaphore_signal(sem);
          }
    ]
   resume];
  
  dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
  
//  dispatch_semaphore_wait(sem,
//                          dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 4.0));
  
  return result;
}



- (void) startLoadingImagesSequentially: (NSArray*) images {
    dispatch_queue_t serial = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
    
    for (int i = 0; i < images.count; i++) {
      //если фотки заканчивают загрузку в том же порядке, что и начинают,
      //то неважно dispatch_sync или dispatch_async. Просто dispatch_async накидает в serial очередь задач, и они будут последовательно выполняться (в т.ч. completionHandler'ы).
      // Если complitionHandler'ы могут вызываться беспорядочно, то
      // Да вообще нет смысла dispatch_sync, раз кидаешь в serial очередь, раз они всё равно выстроятся в одну цепочку.
      
      __auto_type __weak weakSelf = self;

      dispatch_async(serial, ^{
        [weakSelf startLoadingPicture: images[i]];
      });
    }
}

- (void) startLoadingImages: (NSArray*) images {
  for (int i = 0; i < images.count; i++) {
    [self startLoadingPicture: images[i]];
  }
}

- (void) appendImage: (id) imageData {
  UIImage* image = [UIImage imageWithData:imageData];
  [self.gallery addObject: image ];
}

# pragma mark Showing the preview


- (void) presentImage:(UIImage*) image {
  PreviewViewController *previewVC = [[PreviewViewController alloc] initWithImage: image];
  
  [self.navigationController pushViewController:previewVC animated:YES];
}

/**
  Opens the image in a new view controller.
 */
- (void)presentImageByUrl:(NSString*)url {
  UIImage *image = [UIImage imageWithData:[DataManager getCachedImage:url]];
  
  PreviewViewController *previewVC;
  
  if (image == nil) {
    previewVC = [[PreviewViewController alloc] initWithUrl:url];
  } else {
    previewVC = [[PreviewViewController alloc] initWithImage:image];
  }
  
  [self.navigationController pushViewController:previewVC animated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self startLoadingCatalogue];
}

- (void)viewDidAppear:(BOOL)animated {
  NSLog(@"gallery did appear");
  
  [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//optional
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.imagesCatalogue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                   forIndexPath:indexPath];
  
  __auto_type __weak weakSelf = self;
  
  
  //todo leak?
  __block UIImage *image = nil;
  
  NSDictionary *json = self.imagesCatalogue[indexPath.item];
  NSString *url = [GalleryVC makeUrlStringFromJSON:json];
  NSData *data = [DataManager getCachedImage:url];
  
  //todo stop setting an image directly. Do it with just url instead.
  cell.imageUrl = url;
  
  if(data != nil) {
    UIImage *image = [UIImage imageWithData:data];
    [cell setImage:image
            number:position];
  } else {
    [cell resetViews];
    
    // Configure the cell
    cell.contentView.backgroundColor = UIColor.redColor;
    cell.contentView.layer.borderWidth = 1.0;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1].CGColor;
    
    [DataManager asyncGetImageByUrl:url
                         completion:^(UIImage* loadedImage) {
                    
                    
                    // currently visible or not, we should notify the collection of newly income data
                    if (url != cell.imageUrl) {
                      dispatch_async(dispatch_get_main_queue(),^{
                        // this triggers a new call to cellForItemAtIndexPath()
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                      });
                      
                      return;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                      if(loadedImage == nil) {
                        cell.contentView.backgroundColor = UIColor.brownColor;
                        cell.contentView.layer.borderColor = [UIColor colorWithRed:0 green:1 blue:0.5 alpha:1].CGColor;
                      } else {
                        cell.contentView.backgroundColor = UIColor.yellowColor;
                      }
                      
                      NSLog(@"\n  index %ld \n  %@", indexPath.item + 1, url);
                      
                      [cell setImage:loadedImage
                              number:position];
                    });
                    
                  }];
  }
  
  
  
  
  
// todo what is it for ?
//  [cell targetForAction:@selector(
//                                  presentImage:
//                                  )
//  withSender:image];
  
  url = [GalleryVC makeUrlStringFromJSON:json
                                  suffix:@"b"];
  
  [cell setOnClickBlock: ^{
    [weakSelf presentImageByUrl:url];
  }];
  
  //coursera The Full Core Data Example 2
  NSMutableString *buffer = [NSMutableString stringWithString:@""];
  [buffer appendFormat:@"\n%@ eeend", cell, nil];
  //NSLog(@"345 %@", buffer);
  
  
  return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


@end
