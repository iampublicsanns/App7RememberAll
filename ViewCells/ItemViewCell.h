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
@property (nonatomic) NSString* imageUrl;

- (void)resetViews;
- (void)setImage:(UIImage*)image
          number:(NSNumber*)number;
- (void) setOnClickBlock: (void (^)(void)) block;
@end

NS_ASSUME_NONNULL_END
