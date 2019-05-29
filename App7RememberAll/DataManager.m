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


@interface DataManager ()

@property (nonatomic, nullable, strong) NSCache<NSString *, NSData *> *imagesCache;
@property (nonatomic, nullable, strong) NSMutableDictionary<NSString *, NSURLSessionDataTask *> *tasksHash; /** All tasks mapped by url */
@property (atomic, nullable, strong) dispatch_queue_t serialQueue;

@end


@implementation DataManager


#pragma mark - Init

- (nullable instancetype)initWithCache:(nonnull NSCache *)cache
{
	self = [super init];

	if (self)
	{
		_imagesCache = cache;
		_serialQueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_CONCURRENT);
		_tasksHash = [NSMutableDictionary new];
	}

	return self;
}

- (void)addCachedImage:(nonnull NSData *)imageData byUrl:(nonnull NSString *)url
{
	[self.imagesCache setObject:imageData forKey:url];
}

- (nullable NSData *)tryGetCachedImage:(nonnull NSString *)url
{
	return [self.imagesCache objectForKey:url];
}

//tasks hash
- (void)addTask:(nonnull NSURLSessionDataTask *)task byUrl:(nonnull NSString *)url
{
	dispatch_barrier_async(self.serialQueue, ^{
		self.tasksHash[url] = task;
	});
}

- (nullable NSURLSessionDataTask *)getTaskByUrl:(nonnull NSString *)url
{
	__block NSURLSessionDataTask *task;

	dispatch_async(self.serialQueue, ^{
		task = self.tasksHash[url];
	});
	return task;
}


#pragma mark - Public

/**
 Calls startLoadingAsync. По-окончании кидает в кеш то, что скачалось, и вызывает completion с ним же.
 */
- (void)loadImageByUrl:(nonnull NSString *)url priority:(float)priority completion:(nonnull void (^)(NSData * _Nullable))completion
{
	__auto_type __weak weakSelf = self;

	NSURLSessionDataTask *task = [self startLoadingAsync:url completion:^(NSData *image) {
		__auto_type __strong strongSelf = weakSelf;

		[strongSelf addCachedImage:image byUrl:url];

		if (completion)
		{
			completion(image);
		}
	} failure:^(NSData *data) {
		if (completion)
		{
			completion(nil);
		}
	}];

	if (!task)
	{
		return;
	}

	task.priority = priority;
}

- (void)loadCatalogueWithCompletion:(nonnull void (^)(NSArray<NSDictionary *> * _Nullable))completion
{

	NSString *urlString = [NSString stringWithFormat:ConfigPhotosUrl, ConfigApiKey, ConfigUserId];

	__auto_type __weak weakSelf = self;

	[self startLoadingAsync:urlString completion:^(NSData *_Nullable data) {
		if (!weakSelf)
		{
			return;
		}

		NSError *parseErr;
		id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
		if (!json)
		{
			return;
		}

		NSArray<NSDictionary *> *images = [DataManager handleGetPublicPhotosJSON:json];

		completion(images);

	} failure:^(NSData *data) {

	}];
}

- (void)loadImageByUrl:(nonnull NSString *)url completion:(nonnull void (^)(NSData * _Nullable))completion
{
	[self loadImageByUrl:url priority:NSURLSessionTaskPriorityDefault completion:completion];
}

- (void)loadBigImageByUrl:(nonnull NSString *)url completion:(nonnull void (^)(NSData * _Nullable))completion
{
	NSURLSession *session = [NSURLSession sharedSession];

	[session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> *_Nonnull tasks) {

		[tasks enumerateObjectsUsingBlock:^(__kindof NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
			[task suspend];
		}];

		[self loadImageByUrl:url priority:NSURLSessionTaskPriorityHigh completion:^(NSData *bigImage) {
			completion(bigImage);

			[tasks enumerateObjectsUsingBlock:^(__kindof NSURLSessionTask *_Nonnull task, NSUInteger idx, BOOL *_Nonnull stop) {
				[task resume];
			}];

		}];
	}];

	//[self loadImageByUrl:url  priority:NSURLSessionTaskPriorityHigh completion:^(UIImage *bigImage) {
	//	completion(bigImage);
	//}];
}

//todo check docs on json
+ (nullable NSArray<NSDictionary *> *)handleGetPublicPhotosJSON:(nonnull id)pkg
{
	NSArray<NSDictionary *> *images = pkg[@"photos"][@"photo"];

	return images;
}

+ (nullable NSString *)makeUrlStringFromJSON:(nonnull NSDictionary *)json suffix:(nonnull NSString *)suffix
{
	NSString *imageId = json[@"id"];
	NSString *server = json[@"server"];
	NSString *secret = json[@"secret"];
	NSNumber *farm = json[@"farm"];

	NSString *imageUrlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farm, server, imageId, secret, suffix];

	return imageUrlString;
}

+ (nullable NSString *)makeUrlStringFromJSON:(nonnull NSDictionary *)json
{
	return [self makeUrlStringFromJSON:json suffix:ConfigThumbnailSuffix];
}

+ (_Nullable id)validateData:(NSData *_Nullable)data response:(NSURLResponse *_Nullable)response error:(NSError *_Nullable)error
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
- (nullable NSURLSessionDataTask *)startLoadingAsync:(nonnull NSString *)urlString completion:(nonnull void (^)(NSData *_Nullable data))completion failure:(void (^)(NSData *_Nullable data))failure
{

	NSURLSessionDataTask *taskCached = [self getTaskByUrl:urlString];
	// что картинка могла загрузиться, но еще не произошел ее completionHandler. Тогда не надо запускать еще раз закачку.
	if (taskCached != nil && (taskCached.state == NSURLSessionTaskStateRunning || (taskCached.state == NSURLSessionTaskStateCompleted && taskCached.error == nil && [self tryGetCachedImage:urlString] != nil) || taskCached.state == NSURLSessionTaskStateSuspended))
	{
		return taskCached;
	}

	NSURL *url = [NSURL URLWithString:urlString];
	if (!url)
	{
		return nil;
	}
	NSURLSession *session = [NSURLSession sharedSession];

	NSLog(@"\n  start loading %@", urlString);

	NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

		dispatch_async(self.serialQueue, ^{
			if (error)
			{
				NSLog(@"\n  error loading %@ \n  %@", urlString, error);

				failure(data);
				return;
			}

			NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
			if (httpResp.statusCode < 200 || httpResp.statusCode > 300)
			{
				NSLog(@"\n  2error loading %@ \n @", urlString);

				return;
			}

			NSLog(@"\n  finished loading %@", urlString);
			//[NSThread sleepForTimeInterval: 1.0 ];

			if (completion)
			{
				completion(data);
			}
		});
	}];

	[task resume];

	[self addTask:task byUrl:urlString];

	return task;
}


@end
