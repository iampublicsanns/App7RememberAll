//
//  ASRGalleryViewController.h
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

@class ASRDataManager;
@class ASRImageDAO;

NS_ASSUME_NONNULL_BEGIN


/**
 Вью-контроллер, отрисовывающий данные, полученные из DataManager.
 */
@interface ASRGalleryViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;


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
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
