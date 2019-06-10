//
//  ASRPreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "ASRSimplePreviewViewController.h"

@class ASRDataManager;
@class ASRImageDAO;

NS_ASSUME_NONNULL_BEGIN

/**
 Вью-контроллер, управляющий отображением изображения с возможностью зума и сохранения в бд. Изображение скачивается с сервера.
 */
@interface ASRPreviewViewController : ASRSimplePreviewViewController

@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;

/**
 Инициализатор
 @param dataManager менеджер данных для этого вью-контроллера
 @return Новый инстанс
 */
- (nullable instancetype)initWithDataManager:(nonnull ASRDataManager *)dataManager NS_DESIGNATED_INITIALIZER;

/**
 Отобразить изображение по урлу
 @param urlString url-адрес, по которому располагается изображение
 */
- (void)showImageWithUrlString:(nonnull NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
