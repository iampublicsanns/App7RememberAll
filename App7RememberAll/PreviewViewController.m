//
//  PreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "DataManager.h"
#import "PreviewViewController.h"


@interface PreviewViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation PreviewViewController


- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self->_group = dispatch_group_create();
	}
	return self;
}


- (void)viewDidLoad
{
	[super viewDidLoad];

	[self setupViews];
	[self updateImageIfNeeded];
}


- (void)reload
{
	NSData *cached = [self.dataManager tryGetCachedImage:self.url];
	if (cached)
	{
		self.image = [UIImage imageWithData:cached];
		[self updateImageIfNeeded];
	}
	
	[self.dataManager loadBigImageByUrl:self.url completion:^(UIImage *image) {
		self.image = image;
		
		if (!NSThread.isMainThread)
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self updateImageIfNeeded];
			});
		}
		
	}];
}

- (void)setupViews
{
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

	[self.view addSubview:self.scrollView];


	self.imageView = [UIImageView new];
	self.imageView.userInteractionEnabled = true;
	self.imageView.multipleTouchEnabled = true;

	[self.scrollView addSubview:self.imageView];

	//dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
	//	self.imageView.image = self->_image;
	//	[self.imageView sizeToFit];
	//	self.scrollView.contentSize = self.imageView.frame.size;
	//});
}

- (void)updateImageIfNeeded
{
	if (!self.imageView)
	{
		return;
	}
	self.imageView.image = self.image;
	[self.imageView sizeToFit];
	self.scrollView.contentSize = self.imageView.frame.size;
}


#pragma mark <UIScrollViewDelegate>

//if delegate returns nil, nothing happens
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	//если скроллвью пустой, то в этот момент в нем всё равно возникают два каких-то UIImageView.
	return self.scrollView.subviews[0];
}

@end
