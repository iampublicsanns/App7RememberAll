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

@property (nonatomic) NSMutableArray<UIImage*> *gallery;
@property (nonatomic) NSArray<NSDictionary*> *imagesCatalogue;
@end

@implementation GalleryVC

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


- (void) initGallery {
  _gallery = [NSMutableArray arrayWithArray: @[] ];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  if([super initWithCollectionViewLayout: layout] == nil) return nil;
  
  [self initGallery];
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

# pragma mark Showing the preview


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
    // Register cell classes
    [self.collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self startLoadingCatalogue];
}

- (void)viewDidAppear:(BOOL)animated {
  NSLog(@"gallery did appear");
  
  [self.collectionView reloadData];
}


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
  
  NSNumber *position = [NSNumber numberWithInteger:indexPath.item +1];
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
  
  url = [GalleryVC makeUrlStringFromJSON:json
                                  suffix:@"b"];
  
  [cell setOnClickBlock: ^{
    [weakSelf presentImageByUrl:url];
  }];
  
  return cell;
}


@end
