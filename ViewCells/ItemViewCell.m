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
@property (nonatomic) UIButton *button;

@property (nonatomic) void(^block)(void);
@end

@implementation ItemViewCell

// not called
- (instancetype) init {
  if ([super init] == nil) return nil;
  
  self.imageView = [[UIImageView alloc] init];
  [self.contentView addSubview: self.imageView];
  
  return self;
}

-(void) initViews {
  if (self.button == nil){
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];

    [self.button setTitle:@"A button"
                 forState:UIControlStateNormal];
    [self.button sizeToFit];
    
    CGSize parentSize = self.frame.size;
    self.button.frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    
    
    [self.contentView addSubview: self.button];
    
    [self.button addTarget:self
                    action:@selector(handleClick)
          forControlEvents:UIControlEventTouchUpInside];
  }
}

-(void) createImageView {
  self.imageView = [[UIImageView alloc] init];
  [self.contentView addSubview: self.imageView];
  
  self.imageView.layer.cornerRadius = 5;
  //self.imageView.clipsToBounds = YES;
  
  //positioning
  self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}
  
-(void) setImage:(UIImage*) image {
  //if (self.imageView == nil) [self createImageView];
  [self initViews];
  [self.button setImage:image
               forState:UIControlStateNormal];
//  [self.button setBackgroundImage: image
//               forState:UIControlStateNormal];
  
  //self.image = image;
  self.imageView.image = image;
  //From docs UIImageView.image :
  //Sets the frame of imageView :
  //[self.imageView sizeToFit];
  
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

- (void) setOnClickBlock: (void (^)(void)) block {
  self.block = block;
}

-(void) handleClick {
  self.block();
}

-(NSString *) description {
  return [NSString stringWithFormat:@"Sanz -- %@", super.description];
}

@end
