//
//  ASRDataManager.h
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import Foundation;

typedef id JSON;


/**
 Менеджер картинок с методами для скачивания или получения их кэша.
 */
@interface ASRDataManager : NSObject

/**
 Инициализатор
 @param cache Кэш, в котором будут храниться изображения
 @return Новый инстанс.
 */
- (nullable instancetype)initWithCache:(NSCache *_Nonnull)cache;

/**
 Начать загрузку каталога
 @param completion блок, в который передается результрующий каталог
 */
- (void)loadCatalogueWithCompletion:(nonnull void (^)(NSArray<NSDictionary *> *_Nullable))completion;

/**
 Начать загрузку изображения с приоритетом над остальными загрузками
 @param url адрес картинки
 @param completion блок, в который передается результрующее изображение
 */
- (void)loadBigImageByUrl:(nonnull NSString *)url completion:(nonnull void (^)(NSData *_Nullable))completion;

/**
 Начать загрузку изображения
 @param url адрес картинки
 @param completion блок, в который передается результрующее изображение
 */
- (void)loadImageByUrl:(nonnull NSString *)url completion:(nonnull void (^)(NSData * _Nullable image))completion;

/**
 Вернет картинку, если есть в кэше, либо nil
 @param url ссылка, у которой поискать, есть ли кеш
 @return Закешированное значение, если есть, либо nil
 */
- (nullable NSData *)tryGetCachedImage:(nonnull NSString *)url;


/**
 Распарсить ответ на запрос "GetPublicPhotos"
 @param pkg json-объект, который вернулся из JSONObjectWithData
 @return Ма
 */
+ (nullable NSArray<NSDictionary *> *)handleGetPublicPhotosJSON:(nonnull id)pkg;


/**
 Создать url из json-информации по одной картинке
 @param json информация об изображении на сервере
 @return url-строка, по которой доступна миниатюра
 */
+ (nullable NSString *)makeUrlStringFromJSON:(nonnull NSDictionary *)json;

/**
 Создать url из json-информации по одной картинке
 @param json информация об изображении на сервере
 @param suffix суффикс, который будет присоединен к имени файла для получения соответствующей ему версии
 @return url-строка, по которой доступно изображение
 */
+ (nullable NSString *)makeUrlStringFromJSON:(nonnull NSDictionary *)json suffix:(nonnull NSString *)suffix;

@end
