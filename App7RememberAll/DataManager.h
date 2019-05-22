//
//  DataManager.h
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef DataManager_h
#define DataManager_h

@import UIKit;

@interface DataManager : NSObject

- (instancetype)initWithCache:(NSCache *)cache;

- (void)loadBigImageByUrl:(NSString *)json completion:(void (^)(UIImage *))completion;

- (void)loadImageByUrl:(NSString *)url completion:(void (^)(UIImage *image))completion;

- (NSURLSessionDataTask *)startLoadingAsync:(NSString *)imageUrlString completion:(void (^)(NSData *_Nullable data))completion failure:(void (^)(NSData *_Nullable data))failure;

/**
 * Вернет картинку, если есть в кэше, либо nil.
 * */
- (nullable NSData *)tryGetCachedImage:(NSString *)url;

+ (NSArray<NSDictionary *> *)handleGetPublicPhotosJSON:(id)pkg;

+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json;

+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json suffix:(NSString *)suffix;

+ (id)validateData:(nullable NSData *)data response:(nullable NSURLResponse *)response error:(nullable NSError *)error;

@end

#endif /* DataManager_h */
