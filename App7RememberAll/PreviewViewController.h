//
//  PreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

@class DataManager;

NS_ASSUME_NONNULL_BEGIN

/**
 Вью-контроллер, управляющий отображением превью с возможностью зума
 */
@interface PreviewViewController : UIViewController


/**
 Инициализатор
 @param dataManager менеджер данных для этого вью-контроллера
 @return Новый инстанс
 */
- (instancetype)initWithDataManager:(DataManager *)dataManager NS_DESIGNATED_INITIALIZER;

/**
 Отобразить изображение по урлу
 @param urlString url-адрес, по которому располагается изображение
 */
- (void)showImageWithUrlString:(NSString *)urlString;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
												 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
