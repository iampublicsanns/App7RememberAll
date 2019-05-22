//
//  DataManager.h
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import Foundation;


@interface DataManager : NSObject

- (instancetype)initWithCache:(NSCache *)cache;

- (void)loadCatalogueWithCompletion:(void (^)(NSArray<NSDictionary *> *))completion;

- (void)loadBigImageByUrl:(NSString *)json completion:(void (^)(NSData *))completion;

- (void)loadImageByUrl:(NSString *)url completion:(void (^)(NSData *image))completion;

/**
 * Вернет картинку, если есть в кэше, либо nil.
 * */
- (nullable NSData *)tryGetCachedImage:(NSString *)url;

+ (NSArray<NSDictionary *> *)handleGetPublicPhotosJSON:(id)pkg;

+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json;

+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json suffix:(NSString *)suffix;

+ (id)validateData:(nullable NSData *)data response:(nullable NSURLResponse *)response error:(nullable NSError *)error;

@end
