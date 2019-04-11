//
//  ItemViewCell.h
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemViewCell : UICollectionViewCell
//@property (weak, nonatomic)
@property (nonatomic) UIImage* image;

- (void) setOnClickBlock: (void (^)(void)) block;
@end

NS_ASSUME_NONNULL_END
