//
//  ASRDatabasePreviewViewController.h
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
 Вью-контроллер, управляющий отображением картинки с возможностью зума. Изображение берется из базы данных.
 */
@interface ASRDatabasePreviewViewController : UIViewController


/**
 Инициализатор
 @return Новый инстанс
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
												 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 Отобразить изображение по урлу
 @param moid id изображения в базе
 */
- (void)showImageByMOID:(nonnull NSManagedObjectID *)moid;

/**
 Для классов-наследников. Апдейтит imageView картинкой, которая в данный момент в этом контроллере.
 */
- (void)updateImageIfNeeded;

@end

NS_ASSUME_NONNULL_END
