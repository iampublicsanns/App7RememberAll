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
@property (nonatomic, nullable, strong) UIImageView *imageView;
@property (nonatomic, nullable, strong) UIScrollView *scrollView;
@property (nonatomic, nullable, strong) AppDelegate *delegate;
@property (nonatomic, nullable, strong) ASRDataManager *dataManager;
@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;
@property (nonatomic, nullable, strong) NSManagedObjectID *imageMOID;

- (instancetype)init;

@end


@implementation ASRPreviewViewController

//- (instancetype)init
//{
//	self = [super initWithNibName:nil bundle:nil];
//	if(self)
//	{
//		_delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//		_imageDAO = [[ASRImageDAO alloc] initWithContainer: _delegate.persistentContainer];
//
//		//show save button
//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)];
//		self.navigationItem.rightBarButtonItem.enabled = NO;
//	}
//	return self;
//}

////todo separate datamanagered preview from simple image preview
//- (nullable instancetype)initWithDataManager:(nonnull ASRDataManager *)dataManager
//{
//	self = [super initWithNibName:nil bundle:nil];
//	//	self = [self init];
//	if (self)
//	{
//		_dataManager = dataManager;
//
//		_delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//		_imageDAO = [[ASRImageDAO alloc] initWithContainer: _delegate.persistentContainer];
//
//		//show save button
//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)];
//		self.navigationItem.rightBarButtonItem.enabled = NO;
//	}
//	return self;
//}
- (nullable instancetype)initWithDataManager:(nonnull ASRDataManager *)dataManager
{
//	self = [super initWithNibName:nil bundle:nil];
	self = [super init];
	if (self)
	{
		_dataManager = dataManager;
		
		_delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		_imageDAO = [[ASRImageDAO alloc] initWithContainer: _delegate.persistentContainer];
		
		//show save button
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)];
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	return self;
}
//
//- (nullable instancetype)initWithImageId:(NSManagedObjectID*)imageId
//{
//	self = [super initWithNibName:nil bundle:nil];
//	if (self)
//	{
//		_imageMOID = imageId;
//
//		_delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//		_imageDAO = [[ASRImageDAO alloc] initWithContainer:_delegate.persistentContainer];
//
//		//show delete button
//		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onDelete)];
//		self.navigationItem.rightBarButtonItem.enabled = NO;
//
//		[self loadSavedImage];
//	}
//	return self;
//}
//
- (void)viewDidLoad
{
	[super viewDidLoad];

//	[self setupViews];
//	[self updateImageIfNeeded];
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
		self.image = [UIImage imageWithData:cached];
		[super updateImageIfNeeded];
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

	[ASRUtils performOnMainThread: ^{
		[weakSelf updateImageIfNeeded];

		if (image)
		{
			weakSelf.actionButtonEnabled = YES;
		}
	}];
}
//
////ui
//
//- (void)onDelete
//{
//	[self deleteImageFromDatabase];
//	self.actionButtonEnabled = NO;
//}
//- (void)onSave
//{
//	[self saveImage];
//	self.actionButtonEnabled = NO;
//}
//
//- (void)setupViews
//{
//	self.scrollView = [[UIScrollView alloc] init];
//	self.scrollView.frame = self.view.bounds;
//	self.scrollView.layer.borderWidth = 2;
//	self.scrollView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.4 blue:1 alpha:0.8].CGColor;
//	self.scrollView.backgroundColor = UIColor.blackColor;
//	self.scrollView.maximumZoomScale = 10.0;
//	self.scrollView.minimumZoomScale = 0.1;
//	self.scrollView.delegate = self;
//
//	[self.view addSubview:self.scrollView];
//
//	self.imageView = [UIImageView new];
//	self.imageView.userInteractionEnabled = YES;
//	self.imageView.multipleTouchEnabled = YES;
//
//	[self.scrollView addSubview:self.imageView];
//}
//
//- (void)updateImageIfNeeded
//{
//	if (!self.imageView)
//	{
//		return;
//	}
//
//	self.imageView.image = self.image;
//	self.imageView.alpha = 0.0;
//
//	[self.imageView sizeToFit];
//	self.scrollView.contentSize = self.imageView.frame.size;
//
//	[UIView animateWithDuration:.25 animations:^{
//		self.imageView.alpha = 1.0;
//	}];
//}
//
////business only
//- (void)deleteImageFromDatabase
//{
//	[self.imageDAO deleteASRMOImageByMOID:self.imageMOID];
//
//	[self.imageDAO saveContext];
//}
////business only
//- (void)saveImage
//{
//	ASRMOImage *imageMO = [self.imageDAO createASRMOImage];
//	imageMO.blob = UIImageJPEGRepresentation(self.image, 1.0);
//
//	[self.imageDAO saveContext];
//}
//
//#pragma mark - Image from database
//
//- (void)loadSavedImage
//{
//	ASRMOImage *imageMO = [self.imageDAO getASRMOImageByMOID:self.imageMOID];
//	UIImage *image = [UIImage imageWithData:imageMO.blob scale:1.0];
//
//	self.image = image;
//
//	self.actionButtonEnabled = true;
//}
//
//
//#pragma mark <UIScrollViewDelegate>
//
//- (nullable UIView *)viewForZoomingInScrollView:(nonnull UIScrollView *)scrollView
//{
//	return self.imageView;
//}

@end
