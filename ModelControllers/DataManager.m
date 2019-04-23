//
//  DataManager.m
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "GalleryVC.h"


//@property (class, nonatomic) NSDictionary *cachedImages;

@implementation DataManager

static NSMutableDictionary<NSString*,NSData*> *_cachedImages;
//можно обращаться
//NSData *data = DataManager.cachedImages[url];

static NSCache *_imagesCache;

# pragma mark Static variable accessors


//https://useyourloaf.com/blog/objective-c-class-properties
+ (void)makeCache {
  if (_imagesCache == nil) {
    //_cachedImages = [NSMutableDictionary dictionaryWithDictionary:@{}];
    _imagesCache = [[NSCache alloc] init];
  }
}
+ (NSCache*)cachedImages{
  [DataManager makeCache];
  
  return _cachedImages;
}
+ (NSCache*)imagesCache{
  [DataManager makeCache];
  
  return _imagesCache;
}
+ (void)addCachedImage:(NSData*)imageData
                 byUrl:(NSString*)url{
  [DataManager makeCache];
  
  //_cachedImages[url] = imageData;
  [_imagesCache setObject:imageData forKey:url];
}
+ (NSData*)getCachedImage:(NSString*)url {
  return [[DataManager imagesCache] objectForKey:url];
}

#pragma mark static methods

/**
 Creates a serial queue and dispatches asynchronously
 */
+ (void)asyncGetImageByUrl:(NSString*)url
                completion:(void(^)(UIImage*))completion {
  
  dispatch_queue_t serial = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
  
  dispatch_async(serial, ^{
    NSURLSessionDataTask *task = [DataManager startLoadingAsync:url
                                                   completion:^(NSData *data){
                                                     [DataManager addCachedImage:data byUrl:url];
                                                     UIImage *image = [UIImage imageWithData:data];
                                                     
                                                     if(completion) completion(image);
                                                   }];
    
    NSString *url = [[[task currentRequest] URL] absoluteString];
    
  });
  
}

/**
 completion evaluates on some NSURLSession completion thread.
 */
+ (NSURLSessionDataTask*)startLoadingAsync:(NSString*)imageUrlString
                                completion:(void(^)(NSData * _Nullable data))completion {
  
  NSURL *url = [NSURL URLWithString:imageUrlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSLog(@"\n  start loading %@", imageUrlString);
  
  __auto_type __weak weakSelf = self;
  
  NSURLSessionDataTask *task = [session dataTaskWithURL:url
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
                                        
                                        // (weakSelf.cancelLoading) unrecognized selector
                                        
                                        if(completion) completion(data);
                                      }
                                ];
  
  [task resume];
  
  return task;
}




@end
