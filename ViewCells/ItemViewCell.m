//
//  ItemViewCell.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ItemViewCell.h"

@interface ItemViewCell ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation ItemViewCell

// not called
- (instancetype) init {
  if ([super init] == nil) return nil;
  
  self.imageView = [[UIImageView alloc] init];
  [self.contentView addSubview: self.imageView];
  
  return self;
}

-(void) createImageView {
  self.imageView = [[UIImageView alloc] init];
  [self.contentView addSubview: self.imageView];
  
  //positioning
  
}
  
-(void) setImage:(UIImage*) image {
  if (self.imageView == nil) [self createImageView];
  
  //self.image = image;
  self.imageView.image = image;
  [self.imageView sizeToFit];
}

-(NSString *) description {
  return [NSString stringWithFormat:@"Sanz -- %@", super.description];
}

@end
