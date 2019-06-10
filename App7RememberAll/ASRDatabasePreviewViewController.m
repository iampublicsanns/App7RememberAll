//
//  ASRPreviewViewController.m
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "AppDelegate.h"
#import "ASRMOImage+CoreDataClass.h"
#import "ASRImageDAO.h"
#import "ASRDatabasePreviewViewController.h"
#import "ASRUtils.h"


@interface ASRDatabasePreviewViewController() <UIScrollViewDelegate>

@property (nonatomic) BOOL actionButtonEnabled;
@property (nonatomic, nullable, strong) UIImage *image;
@property (nonatomic, nullable, strong) UIImageView *imageView;
@property (nonatomic, nullable, strong) UIScrollView *scrollView;
@property (nonatomic, nullable, strong) AppDelegate *delegate;
@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;
@property (nonatomic, nullable, strong) NSManagedObjectID *imageMOID;

@end


@implementation ASRDatabasePreviewViewController

- (instancetype)initWithImageDAO:(ASRImageDAO *)imageDAO
{
	self = [super init];
	if (self)
	{
		_imageDAO = imageDAO;

		//show delete button
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onDelete)];
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

- (void)showImageByMOID:(nonnull NSManagedObjectID *)moid;
{
	self.imageMOID = moid;
	[self loadSavedImage];
}


# pragma mark - Private

//ui
- (void)onDelete
{
	[self deleteImageFromDatabase];
	self.actionButtonEnabled = NO;
}


#pragma mark - Image from database

//business only
- (void)deleteImageFromDatabase
{
	[self.imageDAO deleteASRMOImageByMOID:self.imageMOID];
	
	[self.imageDAO saveContext];
}

- (void)loadSavedImage
{
	ASRMOImage *imageMO = [self.imageDAO getASRMOImageByMOID:self.imageMOID];
	UIImage *image = [UIImage imageWithData:imageMO.blob scale:1.0];
	
	self.image = image;
	
	self.actionButtonEnabled = true;
}


@end
