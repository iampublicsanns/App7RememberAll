//
//  GalleryVC.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "GalleryVC.h"
#import "ItemViewCell.h"
#import "Config.h"

@interface GalleryVC ()

@property (nonatomic) NSMutableArray *gallery;
@end

@implementation GalleryVC

//https://www.youtube.com/watch?v=qV4gHfqwFPU
//ObjectiveC, Autoresizing mask, Autolayout
static NSString * const reuseIdentifier = @"SimpleCell";

+ (id) sessionCheckData: (NSData * _Nullable) data
               response:(NSURLResponse * _Nullable) response
                  error: ( NSError * _Nullable) error {
  
  NSLog(@"%@", data.description);
  NSLog(@"%@", response.description);
  NSLog(@"%@", error);
  
  if(error) {
    NSLog(@"%@", error);
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
  
  [[session dataTaskWithURL:url
          completionHandler:^(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error) {
            NSLog(@"%@", data.description);
            NSLog(@"%@", response.description);
            NSLog(@"%@", error);
            
            
            id pkg = [GalleryVC sessionCheckData: data
                                        response: response
                                           error: error];
            
            
            id images = [self handleGetPublicPhotos: pkg];
            [self startLoadingImages:images];
          }
    ]
   resume];
}

//todo check docs on json
- (id) handleGetPublicPhotos: (id) pkg {
  NSArray* images = pkg[@"photos"][@"photo"];
  
  NSRange range;
  range.location = 0;
  range.length = 4;
  
  return [images subarrayWithRange:range];
}

- (void) startLoadingPicture: (id) json {
  NSString* imageId = json[@"id"];
  NSString* server = json[@"server"];
  NSString* secret = json[@"secret"];
  NSNumber* farm = json[@"farm"];
  
  NSString *imageUrlString = [NSString stringWithFormat:
                              @"https://farm%@.staticflickr.com/%@/%@_%@_b.jpg",
                              farm, server, imageId, secret
                              ];
  NSURL *url = [NSURL URLWithString:imageUrlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSLog(@"  start loading %@", imageUrlString);
  
  [[session dataTaskWithURL:url
          completionHandler:^(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error) {
//do not check json here
//            id pkg = [GalleryVC sessionCheckData: data
//                                        response: response
//                                           error: error];
            
            if(error) {
              NSLog(@"%@", error);
              return ;
            }
            
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if(httpResp.statusCode <200 || httpResp.statusCode > 300) {
              return;
            }
            
            //todo leak ??
            [self appendImage: data];
//            [self displayImageId: imageId
//                          server: server
//                          secret: secret
//                            farm: farm];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.collectionView reloadData];
            });
          }
    ]
   resume];
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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self startLoading];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.gallery.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                   forIndexPath:indexPath];
  // Configure the cell
  cell.contentView.backgroundColor = UIColor.redColor;
  [cell setImage: self.gallery[indexPath.item]];
  
  //coursera The Full Core Data Example 2
  NSMutableString *buffer = [NSMutableString stringWithString:@""];
  [buffer appendFormat:@"\n%@ eeend", cell, nil];
  NSLog(@"345 %@", buffer);
  
  
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
