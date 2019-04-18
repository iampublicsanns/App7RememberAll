//
//  PreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "PreviewViewController.h"

// protocol adopting - coursera ScrollView
@interface PreviewViewController () <UIScrollViewDelegate>
{
  UIImage * _image;
}
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation PreviewViewController

- (instancetype) initWithImage: (UIImage *)image {
  _image = image;

  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self setupViews];
}

- (void)onSave{
  if (self.completion)
  {
    self.completion();
  }
}


- (void)setupViews{
  self.scrollView = [[UIScrollView alloc] init];
  
  CGSize parentSize = self.view.frame.size;
  self.scrollView.frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
  
  self.scrollView.layer.borderWidth = 2;
  self.scrollView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.4 blue:1 alpha:0.8].CGColor;
  
  CGFloat zoom = 10.0;
  self.scrollView.maximumZoomScale = zoom;
  self.scrollView.minimumZoomScale = 0.1;
  self.scrollView.delegate = self;
  
  self.scrollView.pagingEnabled = true;
  
  [self.view addSubview: self.scrollView];
  
  
  UIImageView* imageView = [[UIImageView alloc] initWithImage: _image];
  
  imageView.userInteractionEnabled = true;
  //imageView.isUserInteractionEnabled = true;
  imageView.multipleTouchEnabled = true;
  
  self.scrollView.contentSize = imageView.frame.size;
  [self.scrollView addSubview:imageView];
}


#pragma mark <UIScrollViewDelegate>

// return a view that will be scaled. if delegate returns nil, nothing happens
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.scrollView.subviews[0];
}

@end
