//
//  DataManager.m
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import Foundation;

#import "DataManager.h"
#import "GalleryVC.h"


//@property (class, nonatomic) NSDictionary *cachedImages;

@implementation DataManager

static NSCache *_imagesCache;
static dispatch_queue_t _serialQueue;
static NSArray<__kindof NSURLSessionTask *> *_tasks;
/** All tasks mapped by url */
static NSMutableDictionary<NSString *, NSURLSessionDataTask *> *_tasksHash;


# pragma mark Static variable accessors

+ (void)makeCache
{
	if (_imagesCache == nil)
	{
		_imagesCache = [[NSCache alloc] init];
	}
}

+ (NSCache *)imagesCache
{
	[self makeCache];

	return _imagesCache;
}

+ (void)addCachedImage:(NSData *)imageData byUrl:(NSString *)url
{
	[self makeCache];

	[_imagesCache setObject:imageData forKey:url];
}

+ (NSData *)tryGetCachedImage:(NSString *)url
{
	return [[DataManager imagesCache] objectForKey:url];
}

//tasks hash
+ (void)makeTasksHash
{
	if (_tasksHash == nil)
	{
		_tasksHash = [[NSMutableDictionary alloc] init];
	}
}

+ (void)addTaskToHash:(NSURLSessionDataTask *)task byUrl:(NSString *)url
{
	[self makeTasksHash];

	//проблема куча тредов
	[_tasksHash setObject:task forKey:url];
}

+ (NSURLSessionDataTask *)getTaskByUrl:(NSString *)url
{
	[self makeTasksHash];

	return [_tasksHash objectForKey:url];
}

//serial queue
+ (void)makeSerialQueue
{
	if (_serialQueue == nil)
	{
		_serialQueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
	}
}

//todo must be thread-safe. It is accessed via concurrent threads.
+ (dispatch_queue_t)serialQueue
{
	[self makeSerialQueue];

	return _serialQueue;
}


#pragma mark Static methods
#pragma mark - Public

/**
 Creates a serial queue and dispatches asynchronously
 Completion handler valuated on a serial DataManager's queue.
 */
+ (void)asyncGetImageByUrl:(NSString *)url completion:(void (^)(UIImage *))completion
{

	dispatch_queue_t serial = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);

	dispatch_async(serial, ^{
		NSURLSessionDataTask *task = [DataManager startLoadingAsync:url completion:^(NSData *data) {
			[DataManager addCachedImage:data byUrl:url];
			UIImage *image = [UIImage imageWithData:data];

			if (completion)
			{
				completion(image);
			}
		} onError:^(NSData *data) {
			if (completion)
			{
				completion(nil);
			}
		}];
	});

}

+ (void)asyncGetBigImageByUrl:(NSString *)url completion:(void (^)(UIImage *))completion
{

	NSURLSession *session = [NSURLSession sharedSession];

	[session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> *_Nonnull tasks) {
		_tasks = tasks;

		[tasks enumerateObjectsUsingBlock:^(__kindof NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
			[task suspend];
		}];

		[DataManager asyncGetImageByUrl:url completion:^(UIImage *bigImage) {
			completion(bigImage);

			[tasks enumerateObjectsUsingBlock:^(__kindof NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
				[task resume];
			}];

		}];
	}];
}

//todo check docs on json
+ (NSArray<NSDictionary *> *)handleGetPublicPhotosJSON:(id)pkg
{
	NSArray<NSDictionary *> *images = pkg[@"photos"][@"photo"];

	return images;
}

+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json suffix:(NSString *)suffix
{
	NSString *imageId = json[@"id"];
	NSString *server = json[@"server"];
	NSString *secret = json[@"secret"];
	NSNumber *farm = json[@"farm"];

	NSString *imageUrlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farm, server, imageId, secret, suffix];

	return imageUrlString;
}

+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json
{
	return [self makeUrlStringFromJSON:json suffix:@"t"];
}

+ (id)sessionCheckData:(NSData *_Nullable)data response:(NSURLResponse *_Nullable)response error:(NSError *_Nullable)error
{
	if (error)
	{
		NSLog(@"\n  %@", error);
		return nil;
	}

	NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
	if (httpResp.statusCode < 200 || httpResp.statusCode > 300)
	{
		return nil;
	}

	NSError *parseErr;
	id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
	if (!json)
	{
		return nil;
	}

	return json;
}


#pragma mark - Private

/**
 Creates and starts a task.
 completion evaluates on some NSURLSession completion thread.
 --- but continues to my serial queue.
 Returns the same task for this imageUrlString.
 */
+ (NSURLSessionDataTask *)startLoadingAsync:(NSString *)imageUrlString completion:(void (^)(NSData *_Nullable data))completion onError:(void (^)(NSData *_Nullable data))onError
{

	NSURLSessionDataTask *taskCached = [DataManager getTaskByUrl:imageUrlString];
	// что картинка могла загрузиться, но еще не произошел ее completionHandler. Тогда не надо запускать еще раз закачку.
	if (taskCached != nil && (taskCached.state == NSURLSessionTaskStateRunning || (taskCached.state == NSURLSessionTaskStateCompleted && taskCached.error == nil) || taskCached.state == NSURLSessionTaskStateSuspended))
	{
		return taskCached;
	}

	NSURL *url = [NSURL URLWithString:imageUrlString];
	NSURLSession *session = [NSURLSession sharedSession];

	NSLog(@"\n  start loading %@", imageUrlString);

	NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

		dispatch_async([DataManager serialQueue], ^{
			if (error)
			{
				NSLog(@"\n  error loading %@ \n  %@", imageUrlString, error);

				onError(data);
				return;
			}

			NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
			if (httpResp.statusCode < 200 || httpResp.statusCode > 300)
			{
				NSLog(@"\n  2error loading %@ \n  %@", imageUrlString);

				return;
			}

			NSLog(@"\n  finished loading %@", imageUrlString);
			//[NSThread sleepForTimeInterval: 1.0 ];

			if (completion)
			{
				completion(data);
			}
		});
	}];

	[task resume];

	[DataManager addTaskToHash:task byUrl:imageUrlString];

	return task;
}


@end
