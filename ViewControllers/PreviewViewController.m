//
//  PreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "../ModelControllers/DataManager.h"
#import "PreviewViewController.h"


@interface PreviewViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation PreviewViewController


- (instancetype)init
{
  self = [super init];
  if (self) {
    self->_group = dispatch_group_create();
  }
  return self;
}

- (instancetype) initWithImage: (UIImage *)image {
  self = [self init];
  
  _image = image;
  
  return self;
}

- (instancetype)initWithUrl:(NSString*)url {
  self = [self init];
  
  dispatch_group_enter(self->_group);
  
  [DataManager asyncGetBigImageByUrl:url
                     completion:^(UIImage *image) {
                       //autofix
                       self->_image = image;
                       
                       dispatch_group_leave(self->_group);
                     }];
  return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self setupViews];
}


- (void)setupViews{
  self.scrollView = [[UIScrollView alloc] init];
  
  CGFloat parentWidth = CGRectGetWidth(self.view.frame);
  CGFloat parentHeight = CGRectGetHeight(self.view.frame);
  self.scrollView.frame = CGRectMake(0, 0, parentWidth, parentHeight);
  
  self.scrollView.layer.borderWidth = 2;
  self.scrollView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.4 blue:1 alpha:0.8].CGColor;
  
  CGFloat zoom = 10.0;
  self.scrollView.maximumZoomScale = zoom;
  self.scrollView.minimumZoomScale = 0.1;
  self.scrollView.delegate = self;
  
  self.scrollView.pagingEnabled = true;
  
  [self.view addSubview: self.scrollView];
  
  
  self.imageView = [[UIImageView alloc] initWithImage:_image];
  
  self.imageView.userInteractionEnabled = true;
  //imageView.isUserInteractionEnabled = true;
  self.imageView.multipleTouchEnabled = true;
  
  [self.scrollView addSubview:self.imageView];
  
  
  dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
    self.imageView.image = self->_image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.imageView.frame.size;
  });
}


#pragma mark <UIScrollViewDelegate>

//if delegate returns nil, nothing happens
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  //если скроллвью пустой, то в этот момент в нем всё равно возникают два каких-то UIImageView.
  return self.scrollView.subviews[0];
}

@end
