//
//  ASRPreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "ASRDatabasePreviewViewController.h"

@class ASRDataManager;

NS_ASSUME_NONNULL_BEGIN

/**
 Вью-контроллер, управляющий отображением изображения с возможностью зума и сохранения в бд. Изображение скачивается с сервера.
 */
@interface ASRPreviewViewController : ASRDatabasePreviewViewController


/**
 Инициализатор
 @param dataManager менеджер данных для этого вью-контроллера
 @return Новый инстанс
 */
- (nullable instancetype)initWithDataManager:(nonnull ASRDataManager *)dataManager NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
												 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 Отобразить изображение по урлу
 @param urlString url-адрес, по которому располагается изображение
 */
- (void)showImageWithUrlString:(nonnull NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
