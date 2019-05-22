//
//  PreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "DataManager.h"
#import "PreviewViewController.h"
#import "Utils.h"


@interface PreviewViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DataManager *dataManager;

@end


@implementation PreviewViewController


- (instancetype)initWithDataManager:(DataManager *)dataManager
{
	self = [super initWithNibName:nil bundle:nil];
	if (self)
	{
		_dataManager = dataManager;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self setupViews];
	[self updateImageIfNeeded];
}

- (void)showImageWithUrlString:(NSString *)urlString
{
	NSData *cached = [self.dataManager tryGetCachedImage:urlString];
	if (cached)
	{
		self.image = [UIImage imageWithData:cached];
		[self updateImageIfNeeded];
	}

	__auto_type __weak weakSelf = self;
	
	[self.dataManager loadBigImageByUrl:urlString completion:^(NSData *image) {
		[weakSelf didLoadImageData:image];
	}];
}

- (void)didLoadImageData:(NSData *)data
{
	UIImage *image = [UIImage imageWithData:data];

	self.image = image;

	[Utils performOnMainThread: ^{
		[self updateImageIfNeeded];
	}];
}

- (void)setupViews
{
	self.scrollView = [[UIScrollView alloc] init];
	self.scrollView.frame = self.view.bounds;
	self.scrollView.layer.borderWidth = 2;
	self.scrollView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.4 blue:1 alpha:0.8].CGColor;
	self.scrollView.backgroundColor = UIColor.blackColor;
	self.scrollView.maximumZoomScale = 10.0;
	self.scrollView.minimumZoomScale = 0.1;
	self.scrollView.delegate = self;

	[self.view addSubview:self.scrollView];

	self.imageView = [UIImageView new];
	self.imageView.userInteractionEnabled = YES;
	self.imageView.multipleTouchEnabled = YES;

	[self.scrollView addSubview:self.imageView];
}

- (void)updateImageIfNeeded
{
	if (!self.imageView)
	{
		return;
	}
	
	self.imageView.image = self.image;
	self.imageView.alpha = 0.0;
	
	[self.imageView sizeToFit];
	self.scrollView.contentSize = self.imageView.frame.size;
	
	[UIView animateWithDuration:.25 animations:^{
		self.imageView.alpha = 1.0;
	}];
}


#pragma mark <UIScrollViewDelegate>

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

@end
