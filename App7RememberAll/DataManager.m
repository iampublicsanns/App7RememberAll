//
//  DataManager.m
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import Foundation;

#import "Config.h"
#import "DataManager.h"


@interface DataManager()

@property (nonatomic, copy) NSCache *imagesCache;
@property (nonatomic, copy) NSMutableDictionary<NSString *, NSURLSessionDataTask *> *tasksHash; /** All tasks mapped by url */
@property (atomic, strong) dispatch_queue_t serialQueue;

@end


@implementation DataManager


#pragma mark - Init

- (instancetype)initWithCache:(NSCache *)cache
{
	self = [super init];
	
	if (self)
	{
		_imagesCache = cache;
		_serialQueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
	}

	return self;
}

- (void)addCachedImage:(NSData *)imageData byUrl:(NSString *)url
{
	[self.imagesCache setObject:imageData forKey:url];
}

- (nullable NSData *)tryGetCachedImage:(NSString *)url
{
	return [self.imagesCache objectForKey:url];
}

//tasks hash
- (void)makeTasksHash
{
	if (_tasksHash == nil)
	{
		_tasksHash = [[NSMutableDictionary alloc] init];
	}
}

- (void)addTask:(NSURLSessionDataTask *)task byUrl:(NSString *)url
{
	[self makeTasksHash];

	//проблема куча тредов
	[_tasksHash setObject:task forKey:url];
}

- (NSURLSessionDataTask *)getTaskByUrl:(NSString *)url
{
	[self makeTasksHash];

	return [_tasksHash objectForKey:url];
}


#pragma mark - Public

/**
 Calls startLoadingAsync. По-окончании кидает в кеш то, что скачалось, и вызывает completion с ним же.
 */
- (void)loadImageByUrl:(NSString *)url priority:(float)priority completion:(void (^)(UIImage *))completion
{
	__weak typeof(self) weakSelf = self;
	
	NSURLSessionDataTask *task = [self startLoadingAsync:url completion:^(NSData *data) {
		__strong typeof(self)strongSelf = weakSelf;
		
		[strongSelf addCachedImage:data byUrl:url];
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

	task.priority = priority;
}

- (void)loadImageByUrl:(NSString *)url completion:(void (^)(UIImage *))completion
{
	[self loadImageByUrl:url priority:NSURLSessionTaskPriorityDefault completion:completion];
}

- (void)loadBigImageByUrl:(NSString *)url completion:(void (^)(UIImage *))completion
{
	NSURLSession *session = [NSURLSession sharedSession];

	[session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> *_Nonnull tasks) {

		[tasks enumerateObjectsUsingBlock:^(__kindof NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
			[task suspend];
		}];

		[self loadImageByUrl:url  priority:NSURLSessionTaskPriorityHigh completion:^(UIImage *bigImage) {
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
	return [self makeUrlStringFromJSON:json suffix:ConfigThumbnailSuffix];
}

+ (id)validateData:(NSData *_Nullable)data response:(NSURLResponse *_Nullable)response error:(NSError *_Nullable)error
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
- (NSURLSessionDataTask *)startLoadingAsync:(NSString *)imageUrlString completion:(void (^)(NSData *_Nullable data))completion onError:(void (^)(NSData *_Nullable data))onError
{

	NSURLSessionDataTask *taskCached = [self getTaskByUrl:imageUrlString];
	// что картинка могла загрузиться, но еще не произошел ее completionHandler. Тогда не надо запускать еще раз закачку.
	if (taskCached != nil && (taskCached.state == NSURLSessionTaskStateRunning || (taskCached.state == NSURLSessionTaskStateCompleted && taskCached.error == nil && [self tryGetCachedImage:imageUrlString] != nil) || taskCached.state == NSURLSessionTaskStateSuspended))
	{
		return taskCached;
	}

	NSURL *url = [NSURL URLWithString:imageUrlString];
	NSURLSession *session = [NSURLSession sharedSession];

	NSLog(@"\n  start loading %@", imageUrlString);

	NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

		dispatch_async([self serialQueue], ^{
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

	[self addTask:task byUrl:imageUrlString];

	return task;
}


@end
