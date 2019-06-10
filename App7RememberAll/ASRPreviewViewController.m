//
//  ASRPreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "AppDelegate.h"
#import "ASRDataManager.h"
#import "ASRMOImage+CoreDataClass.h"
#import "ASRImageDAO.h"
#import "ASRPreviewViewController.h"
#import "ASRUtils.h"


@interface ASRPreviewViewController () <UIScrollViewDelegate>

@property (nonatomic) BOOL actionButtonEnabled;
@property (nonatomic, nullable, strong) UIImage *image;
@property (nonatomic, nullable, strong) AppDelegate *delegate;
@property (nonatomic, nullable, strong) ASRDataManager *dataManager;

@end


@implementation ASRPreviewViewController

- (nullable instancetype)initWithDataManager:(nonnull ASRDataManager *)dataManager
{
	self = [super init];
	if (self)
	{
		_dataManager = dataManager;

		//show save button
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)];
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}


#pragma mark - Custom Accessors

- (void)setActionButtonEnabled:(BOOL)enabled
{
	self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (BOOL)actionButtonEnabled
{
	return self.navigationItem.rightBarButtonItem.enabled;
}


#pragma mark - Public

- (void)showImageWithUrlString:(nonnull NSString *)urlString
{
	NSData *cached = [self.dataManager tryGetCachedImage:urlString];
	if (cached)
	{
		[self didLoadImageData:cached];
		return;
	}

	__auto_type __weak weakSelf = self;
	
	[self.dataManager loadBigImageByUrl:urlString completion:^(NSData *image) {
		[weakSelf didLoadImageData:image];
	}];
}


# pragma mark - Private

- (void)didLoadImageData:(nonnull NSData *)data
{
	UIImage *image = [UIImage imageWithData:data];

	self.image = image;
	__auto_type __weak weakSelf = self;

	[ASRUtils performOnMainThread:^{
		[weakSelf updateImageIfNeeded];

		if (image && self.imageDAO)
		{
			weakSelf.actionButtonEnabled = YES;
		}
	}];
}

//ui
- (void)onSave
{
	[self saveImage];
	self.actionButtonEnabled = NO;
}

//business only
- (void)saveImage
{
	if (!self.imageDAO)
	{
		return;
	}
	ASRMOImage *imageMO = [self.imageDAO createASRMOImage];
	imageMO.blob = UIImageJPEGRepresentation(self.image, 1.0);

	[self.imageDAO saveContext];
}

@end
