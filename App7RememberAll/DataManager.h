//
//  DataManager.h
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import Foundation;


/**
 Менеджер картинок с методами для скачивания или получения их кэша.
 */
@interface DataManager : NSObject

/**
 Инициализатор
 @param cache Кэш, в котором будут храниться изображения
 @return Новый инстанс.
 */
- (instancetype)initWithCache:(NSCache *)cache;

/**
 Начать загрузку каталога
 @param completion блок, в который передается результрующий каталог
 */
- (void)loadCatalogueWithCompletion:(void (^)(NSArray<NSDictionary *> *))completion;

/**
 Начать загрузку изображения с приоритетом над остальными загрузками
 @param url адрес картинки
 @param completion блок, в который передается результрующее изображение
 */
- (void)loadBigImageByUrl:(NSString *)url completion:(void (^)(NSData *))completion;

/**
 Начать загрузку изображения
 @param url адрес картинки
 @param completion блок, в который передается результрующее изображение
 */
- (void)loadImageByUrl:(NSString *)url completion:(void (^)(NSData *image))completion;

/**
 Вернет картинку, если есть в кэше, либо nil
 @param url ссылка, у которой поискать, есть ли кеш
 @return Закешированное значение, если есть, либо nil
 */
- (nullable NSData *)tryGetCachedImage:(NSString *)url;


/**
 Распарсить ответ на запрос "GetPublicPhotos"
 @param pkg json-объект, который вернулся из JSONObjectWithData
 @return Ма
 */
+ (NSArray<NSDictionary *> *)handleGetPublicPhotosJSON:(id)pkg;


/**
 Создать url из json-информации по одной картинке
 @param json информация об изображении на сервере
 @return url-строка, по которой доступна миниатюра
 */
+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json;

/**
 Создать url из json-информации по одной картинке
 @param json информация об изображении на сервере
 @param suffix суффикс, который будет присоединен к имени файла для получения соответствующей ему версии
 @return url-строка, по которой доступно изображение
 */
+ (NSString *)makeUrlStringFromJSON:(NSDictionary *)json suffix:(NSString *)suffix;

+ (id)validateData:(nullable NSData *)data response:(nullable NSURLResponse *)response error:(nullable NSError *)error;

@end
