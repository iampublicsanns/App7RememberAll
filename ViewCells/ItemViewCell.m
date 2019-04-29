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
@property (nonatomic) UILabel *label;
@property (nonatomic) UIButton *button;

@property (nonatomic) void(^block)(void);
@end

@implementation ItemViewCell


-(void) createImageView {
  self.imageView = [[UIImageView alloc] init];
  [self.contentView addSubview: self.imageView];
  
  self.imageView.layer.cornerRadius = 5;
  self.imageView.clipsToBounds = YES;
  
  //coursera Intro to UIImageView
  self.imageView.layer.borderWidth = 1;
  // instead of autofix:
  self.imageView.layer.borderColor = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1].CGColor;
  
  self.imageView.userInteractionEnabled = YES;
  
  UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handleClick)];
  [singleTap setNumberOfTapsRequired:1];
  [self.imageView addGestureRecognizer:singleTap];
}

- (void)resetViews{
  self.imageView.image = nil;
  self.label.text = @"reset";
}

- (void)setImage:(UIImage*)image
          number:(NSNumber*)number {
  [self setImage:image];
  
  self.label.text = [NSString stringWithFormat:@"%@", number];
}

-(void) setImage:(UIImage*) image {
  [self setupViews];
  
  self.imageView.image = image;
  
  CGSize parentSize = self.frame.size;
  
  //https://www.youtube.com/watch?v=qV4gHfqwFPU
  self.imageView.frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
}


-(void)setupViews {
  if (self.imageView == nil) [self createImageView];
  
  CGSize parentSize = self.frame.size;
  
  if (self.label == nil) {
    self.label = [[UILabel alloc] init];
    self.label.text = @"new";
    self.label.frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    
    [self.contentView addSubview:self.label];
  }
  
}

#pragma mark touch events

- (void) setOnClickBlock: (void (^)(void)) block {
  self.block = block;
}

-(void) handleClick {
  self.block();
}

-(NSString *) description {
  return [NSString stringWithFormat:@"\n  Sanz -- %@", super.description];
}

@end
