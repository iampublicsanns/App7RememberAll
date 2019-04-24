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
static dispatch_queue_t _serialQueue;
static NSArray<__kindof NSURLSessionTask *> *_tasks;
/** All tasks mapped by url */
static NSMutableDictionary<NSString*,NSURLSessionDataTask*> *_tasksHash;

# pragma mark Static variable accessors


//https://useyourloaf.com/blog/objective-c-class-properties
+ (void)makeCache {
  if (_imagesCache == nil) {
    //_cachedImages = [NSMutableDictionary dictionaryWithDictionary:@{}];
    _imagesCache = [[NSCache alloc] init];
  }
}
+ (NSMutableDictionary*)cachedImages{
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

//tasks hash
+ (void)makeTasksHash {
  if (_tasksHash == nil) {
    _tasksHash = [[NSMutableDictionary alloc] init];
  }
}
+ (void)addTaskToHash:(NSURLSessionDataTask*)task
                byUrl:(NSString*)url{
  [DataManager makeTasksHash];
  
  [_tasksHash setObject:task forKey:url];
}
+ (NSURLSessionDataTask*)getTaskByUrl:(NSString*)url{
  [DataManager makeTasksHash];
  
  return [_tasksHash objectForKey:url];
}

//serial queue
+ (void)makeSerialQueue {
  if (_serialQueue == nil) {
    _serialQueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
  }
}
+ (dispatch_queue_t)serialQueue {
  [DataManager makeSerialQueue];
  
  return _serialQueue;
}

#pragma mark static methods

/**
 Creates a serial queue and dispatches asynchronously
 запускай большую картинку на другой очереди.
 Хотя вооще-то что мешает загрузкам завершаться в производльном порядке? ведь так раньше и было. Добавляются-то они в очереь последовательно, но запускаются сразу, так что не имеет значения очередность - считай все разом запустились. Ведь завершения загрузки они не ждут, чтобы поставить в очередь следующую?
   Делов том , что комплишн NSURLSession всё время в одном и том же треде.
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
 Returns the same task for this imageUrlString.
 */
+ (NSURLSessionDataTask*)startLoadingAsync:(NSString*)imageUrlString
                                completion:(void(^)(NSData * _Nullable data))completion
                                onError:(void(^)(NSData * _Nullable data))onError {
  
  NSURLSessionDataTask *taskCached = [DataManager getTaskByUrl:imageUrlString];
  // считай, что картинка могла загрузиться, но еще не произошел ее completionHandler. Тогда не надо запускать еще раз закачку.
  if (taskCached != nil
  && (taskCached.state == NSURLSessionTaskStateRunning
  || taskCached.state == NSURLSessionTaskStateCompleted && taskCached.error == nil
  )) {
    return taskCached;
  }
  
  NSURL *url = [NSURL URLWithString:imageUrlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSLog(@"\n  start loading %@", imageUrlString);
  
  __auto_type __weak weakSelf = self;
  
  NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                      completionHandler:^(NSData * _Nullable data,
                                                          NSURLResponse * _Nullable response,
                                                          NSError * _Nullable error) {
                                        
                                        
                                        dispatch_async([DataManager serialQueue], ^{
                                          if(error) {
                                            NSLog(@"\n  error loading %@ \n  %@", imageUrlString, error);
                                            
                                            onError(data);
                                            return ;
                                          }
                                          
                                          NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                          if(httpResp.statusCode <200 || httpResp.statusCode > 300) {
                                            return;
                                          }
                                          
                                          NSLog(@"\n  finished loading %@", imageUrlString);
                                          [NSThread sleepForTimeInterval: 1.0 ];
                                          
                                          if(completion) completion(data);
                                        });
                                      }
                                ];
  
  [task resume];
  
  [DataManager addTaskToHash:task
                       byUrl:imageUrlString];
  
  return task;
}




@end
