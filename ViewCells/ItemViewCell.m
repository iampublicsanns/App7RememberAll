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
  self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}
  
-(void) setImage:(UIImage*) image {
  if (self.imageView == nil) [self createImageView];
  
  //self.image = image;
  self.imageView.image = image;
  //From docs UIImageView.image :
  //Sets the frame of imageView :
  [self.imageView sizeToFit];
  
  //[self sizeThatFits:self.bounds.size];
  
  CGSize parentSize = self.frame.size;
  
  //https://www.youtube.com/watch?v=qV4gHfqwFPU
  self.imageView.frame = CGRectMake(0, 0, parentSize.width, parentSize.height);

  
  //  self.imageView.bounds = CGRect{
//    origin = CGPoint {
//      x = 5;
//      y=6;
//    }
//  }
}

-(NSString *) description {
  return [NSString stringWithFormat:@"Sanz -- %@", super.description];
}

@end
