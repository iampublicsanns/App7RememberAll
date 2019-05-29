//
//  ItemViewCell.h
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

/**
 Ячейка для CollectionView, отображающая миниатюру изображения
 */
@interface ItemViewCell : UICollectionViewCell

@property (nonatomic, nullable, strong) UIImage *image; /**< Изображение для отображения в этой ячейке */
@property (nonatomic, nullable, copy) NSString *imageUrl; /**< Служит идентификатором ячейки */
@property (nonatomic, nullable, copy) void (^clickHandler)(void); /**< Действие по нажатию на изображение */


/**
 Сбросить вьюхи ячейки к некоему изначальному виду
 */
- (void)resetViews;

/**
 Присвоить изображение, и сразу отобразить в режиме aspect fill
 @param image изображение для отрисовки
 */
- (void)setImage:(nonnull UIImage *)image;

/**
 Установить строку в тестовое поле ячейки
 @param string текст для отображения в ячейке
 */
- (void)setLabelText:(nonnull NSString *)string;

@end
