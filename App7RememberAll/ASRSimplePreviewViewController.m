//
//  ASRSimplePreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 10/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "AppDelegate.h"
#import "ASRMOImage+CoreDataClass.h"
#import "ASRImageDAO.h"
#import "ASRDatabasePreviewViewController.h"
#import "ASRUtils.h"
#import "ASRSimplePreviewViewController.h"

@interface ASRSimplePreviewViewController() <UIScrollViewDelegate>

@property (nonatomic) BOOL actionButtonEnabled;
@property (nonatomic, nullable, strong) UIImage *image;
@property (nonatomic, nullable, strong) UIImageView *imageView;
@property (nonatomic, nullable, strong) UIScrollView *scrollView;
@property (nonatomic, nullable, strong) AppDelegate *delegate;
@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;
@property (nonatomic, nullable, strong) NSManagedObjectID *imageMOID;

@end


@implementation ASRSimplePreviewViewController

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupViews];
	[self updateImageIfNeeded];
}


# pragma mark - Private

//ui
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

- (nullable UIView *)viewForZoomingInScrollView:(nonnull UIScrollView *)scrollView
{
	return self.imageView;
}

@end
