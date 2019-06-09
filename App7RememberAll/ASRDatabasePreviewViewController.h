//
//  ASRPreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;
@import CoreData;

@class ASRDataManager;

NS_ASSUME_NONNULL_BEGIN

/**
 Вью-контроллер, управляющий отображением превью с возможностью зума
 */
@interface ASRDatabasePreviewViewController : UIViewController


/**
 Инициализатор
 @param dataManager менеджер данных для этого вью-контроллера
 @return Новый инстанс
 */
- (nullable instancetype)initWithDataManager:(nonnull ASRDataManager *)dataManager NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithImage:(nonnull UIImage*)image NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithImageId:(NSManagedObjectID*)imageId NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
												 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 Отобразить изображение по урлу
 @param urlString url-адрес, по которому располагается изображение
 */
- (void)showImageByMOID:(nonnull NSManagedObjectID *)moid;


/**
 Для классов-наследников
 */
- (void)updateImageIfNeeded;

@end

NS_ASSUME_NONNULL_END
