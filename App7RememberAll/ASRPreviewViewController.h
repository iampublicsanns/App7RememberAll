//
//  ASRPreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

@class ASRDataManager;

NS_ASSUME_NONNULL_BEGIN

/**
 Вью-контроллер, управляющий отображением превью с возможностью зума
 */
@interface ASRPreviewViewController : UIViewController


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
