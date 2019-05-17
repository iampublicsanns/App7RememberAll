//
//  ItemViewCell.h
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

//#import <UIKit/UIKit.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface ItemViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageUrl;

- (void)resetViews;

- (void)setImage:(UIImage *)image;

- (void)setNumber:(NSNumber *)number;

- (void)setOnClickBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
