//
//  GalleryVC.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "GalleryVC.h"
#import "ItemViewCell.h"
#import "PreviewViewController.h"
#import "Config.h"

@interface GalleryVC ()
//https://youtu.be/Z436l0z72R8?t=211
//UICollectionViewLayout custom
{
  NSArray *dataArr;
}

@property (nonatomic) NSMutableArray<UIImage*> *gallery;
@property (nonatomic) NSArray<NSString*> *imagesCatalogue;
@end

@implementation GalleryVC
{
  //keeping to test a leak
  PreviewViewController *previewViewController;
}

//https://www.youtube.com/watch?v=qV4gHfqwFPU
//ObjectiveC, Autoresizing mask, Autolayout
static NSString * const reuseIdentifier = @"SimpleCell";

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
  id pkg = [NSJSONSerialization JSONObjectWithData:data
                                           options:0
                                             error:&parseErr];
  if(!pkg){
    return nil;
  }
  
  return pkg;
}

/*
 Creates a serial queue and dispatches asynchronously
 */
+ (void)asyncGetImage:(id)json
           completion:(void(^)(UIImage*))completion{
  
  NSString *url = [GalleryVC makeUrlStringFromJSON:json];
  
  dispatch_queue_t serial = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
  
  dispatch_async(serial, ^{
    [GalleryVC startLoadingPictureWithUrl:url
                               completion:^(NSData *data){
                                 UIImage *image = [UIImage imageWithData:data];
                                 if(completion) completion(image);
                               }];
  });
  
}

//like in coursera core data course
- (id) init {
  if([super init] == nil) return nil;
  
  self.gallery = [NSMutableArray arrayWithArray: @[@1,@2,@3] ];
  [self.gallery addObject:@4];
  
  [self startLoading];
  
  return self;
}

- (void) setGallery {
  self.gallery = [NSMutableArray arrayWithArray: @[] ];
//  [self.gallery addObject:@4];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  if([super initWithCollectionViewLayout: layout] == nil) return nil;
  
  [self setGallery];
  //[self startLoading];
  
  return self;
}

- (void) startLoading {
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
            
            id pkg = [GalleryVC sessionCheckData: data
                                        response: response
                                           error: error];
            
            
            NSArray *images = [weakSelf handleGetPublicPhotosJSON: pkg];
            
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

+ (NSString*)makeUrlStringFromJSON:(id)json{
  NSString* imageId = json[@"id"];
  NSString* server = json[@"server"];
  NSString* secret = json[@"secret"];
  NSNumber* farm = json[@"farm"];
  
  NSString *imageUrlString = [NSString stringWithFormat:
                              @"https://farm%@.staticflickr.com/%@/%@_%@_b.jpg",
                              farm, server, imageId, secret
                              ];
  
  return imageUrlString;
}

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
/**
 Returns an image. Asynchronous request
 */
+ (void)startLoadingPictureWithUrl:(NSString*)imageUrlString
                            completion:(void(^)(NSData *data))completion{
  
  [GalleryVC startLoadingAsync:imageUrlString
                    completion:^(NSData *data){
                      completion(data);
                    }];
}



+ (void)startLoadingAsync:(NSString*)imageUrlString
               completion:(void(^)(NSData * _Nullable data))completion{
  
  NSURL *url = [NSURL URLWithString:imageUrlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSLog(@"\n  start loading %@", imageUrlString);
  
  __auto_type __weak weakSelf = self;
  
  [[session dataTaskWithURL:url
          completionHandler:^(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error) {
//do not check json here
//            id pkg = [GalleryVC sessionCheckData: data
//                                        response: response
//                                           error: error];
            
            NSLog(@"\n  finished loading %@", imageUrlString);
            if(error) {
              NSLog(@"\n  %@", error);
              return ;
            }
            
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if(httpResp.statusCode <200 || httpResp.statusCode > 300) {
              return;
            }
            
            //todo leak ??
            //[weakSelf appendImage: data];
            
//            [self displayImageId: imageId
//                          server: server
//                          secret: secret
//                            farm: farm];
            
            [NSThread sleepForTimeInterval: 1.0 ];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//              [weakSelf.collectionView reloadData];
//            });
            
            if(completion) completion(data);
          }
    ]
   resume];
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

/*
- (void) displayImageId: (NSString*) imageId
                 server: (NSString*) server
                 secret: (NSString*) secret
                   farm: (NSNumber*) farm {
  
  self.gallery = [NSMutableArray arrayWithArray: @[
                                                   
                                                   ] ];
}
*/

- (void) appendImage: (id) imageData {
  UIImage* image = [UIImage imageWithData:imageData];
  [self.gallery addObject: image ];
}



- (void) presentImage:(UIImage*) image {
  PreviewViewController *previewVC = [[PreviewViewController alloc] initWithImage: image];
  
  __auto_type __weak weakSelf = self;
  
  previewVC.completion = ^{
    [weakSelf previewDidSave];
  };
  
  previewViewController = previewVC;
  [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)previewDidSave
{
  NSLog(@"Ricardo has saved preview");
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self startLoading];
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
  
  [cell resetViews];
//  UIImage *image = self.gallery[indexPath.item];
  
  __auto_type __weak weakSelf = self;
  
  
  //todo leak?
  __block UIImage *image = nil;
  
  // Configure the cell
  cell.contentView.backgroundColor = UIColor.redColor;
  //[cell setImage: image];
  
  [GalleryVC asyncGetImage:self.imagesCatalogue[indexPath.item]
                completion:^(UIImage* loadedImage){
                  
                  image = loadedImage;
                  
                  dispatch_async(dispatch_get_main_queue(),^{
                    [cell setImage: loadedImage];
                    //[weakSelf.collectionView reloadData];
                  });
                  
  }];
  
  
// todo what is it for ?
//  [cell targetForAction:@selector(
//                                  presentImage:
//                                  )
//  withSender:image];
  
  
  [cell setOnClickBlock: ^{
    [weakSelf presentImage:image];
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
