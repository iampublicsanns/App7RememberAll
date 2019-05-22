//
//  ItemViewCell.h
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface ItemViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageUrl; /** Служит идентификатором ячейки */
@property (nonatomic, copy) void (^clickHandler)(void);

- (void)resetViews;

- (void)setImage:(UIImage *)image;

- (void)setLabelText:(nullable NSString *)string;

@end

NS_ASSUME_NONNULL_END
