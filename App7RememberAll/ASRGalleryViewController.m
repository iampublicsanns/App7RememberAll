//
//  ASRGalleryViewController.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "AppDelegate.h"
#import "ASRDataManager.h"
#import "ASRGalleryViewController.h"
#import "ASRItemViewCell.h"
#import "ASRImageDAO.h"
#import "ASRMOImage+CoreDataClass.h"
#import "ASRPreviewViewController.h"
#import "ASRDatabasePreviewViewController.h"
#import "ASRUtils.h"
#import "Config.h"


@interface ASRGalleryViewController ()

@property (nonatomic, nullable, strong) UILabel *errorLabel;
@property (nonatomic, nullable, copy) NSArray<NSDictionary *> *imagesCatalogue;
@property (nonatomic, nullable, copy) NSArray<ASRMOImage *> *savedImages;
@property (nonatomic, nullable, strong) AppDelegate *delegate;
@property (nonatomic, nullable, strong) ASRDataManager *dataManager;
@property (nonatomic, nullable, strong) ASRImageDAO *imageDAO;

@end


@implementation ASRGalleryViewController

static NSString *const GalleryVCReuseIdentifier = @"SimpleCell";


#pragma mark - Lifecycle

- (instancetype)initWithDataManager:(ASRDataManager *)dataManager
{
	UILabel *label = [UILabel new];

	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);

	self = [super initWithCollectionViewLayout:flowLayout];

	if (self)
	{
		_dataManager = dataManager;
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.collectionView registerClass:[ASRItemViewCell class] forCellWithReuseIdentifier:GalleryVCReuseIdentifier];
	[self startLoadingCatalogue];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self loadSavedImages];
	[self reload];
}


#pragma mark - Private

- (void)loadSavedImages
{
	self.savedImages = [self.imageDAO getASRMOImages];
}

- (void)reload
{
	[self.collectionView reloadData];
}

- (void)reloadItemAt:(NSIndexPath *)indexPath
{
	[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)startLoadingCatalogue
{
	[self.dataManager loadCatalogueWithCompletion:^(NSArray<NSDictionary *> *images) {
		[self updateCatalogueWithImages:images];
	}];
}

- (void)updateCatalogueWithImages:(NSArray<NSDictionary *> *)images
{
	self.imagesCatalogue = images;

	__auto_type __weak weakSelf = self;

	[ASRUtils performOnMainThread:^{
		[weakSelf reload];
	}];

}


# pragma mark - Showing the preview

/**
  Opens the image in a new view controller.
 */
- (void)presentImageByUrl:(NSString *)url
{
	ASRPreviewViewController *previewViewController = [[ASRPreviewViewController alloc] initWithDataManager:self.dataManager];
	[previewViewController showImageWithUrlString:url];

	[self.navigationController pushViewController:previewViewController animated:YES];
}

- (void)presentSavedImageById:(NSInteger)imageId
{
//	ASRMOImage *imageMO = self.savedImages[imageId];
//	NSData *loadedImageData = imageMO.blob;
//	UIImage *loadedImage = [UIImage imageWithData:loadedImageData];
//
//	ASRPreviewViewController *previewViewController = [[ASRPreviewViewController alloc] initWithImage:loadedImage];
//
//	[self.navigationController pushViewController:previewViewController animated:YES];
}

- (void)presentSavedImageByMOID:(NSManagedObjectID *)imageId
{
//	ASRPreviewViewController *previewViewController = [[ASRPreviewViewController alloc] initWithImageId:imageId];
//	ASRDatabasePreviewViewController *previewViewController = [[ASRDatabasePreviewViewController alloc] initWithImageId:imageId];
	ASRDatabasePreviewViewController *previewViewController = [[ASRDatabasePreviewViewController alloc] init];
	[previewViewController showImageByMOID:imageId];

	[self.navigationController pushViewController:previewViewController animated:YES];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return self.savedImages.count;
		case 1:
			return self.imagesCatalogue.count;
		default:
			return 0;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		return [self createSavedImage:collectionView cellForItemAtIndexPath:indexPath];
	}
	else if (indexPath.section == 1)
	{
		return [self createDownload:collectionView cellForItemAtIndexPath:indexPath];
	}
	else
	{
		return nil;
	}
}

- (UICollectionViewCell *)createDownload:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ASRItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GalleryVCReuseIdentifier forIndexPath:indexPath];

	__auto_type __weak weakSelf = self;

	NSNumber *position = @(indexPath.item + 1);
	NSString *positionString = [NSString stringWithFormat:@"%@", position];
	NSDictionary *json = self.imagesCatalogue[indexPath.item];
	NSString *url = [ASRDataManager makeUrlStringFromJSON:json];
	NSData *data = [self.dataManager tryGetCachedImage:url];

	cell.imageUrl = url;

	if (data)
	{
		UIImage *image = [UIImage imageWithData:data];
		[cell setImage:image];
		[cell setLabelText:positionString];
	}
	else
	{
		[cell resetViews];

		[self.dataManager loadImageByUrl:url completion:^(NSData *loadedImageData) {
			UIImage *loadedImage = [UIImage imageWithData:loadedImageData];

			// currently visible or not, we should notify the collection of newly income data
			if (url != cell.imageUrl)
			{
				[ASRUtils performOnMainThread:^{
					[weakSelf reloadItemAt:indexPath];
				}];

				return;
			}

			[ASRUtils performOnMainThread:^{
				if (!loadedImage)
				{
					cell.contentView.backgroundColor = UIColor.brownColor;
				}

				NSLog(@"\n  index %@ \n  %@", position, url);

				[cell setImage:loadedImage];
				[cell setLabelText:positionString];
			}];

		}];
	}

	url = [ASRDataManager makeUrlStringFromJSON:json suffix:ConfigBigImageSuffix];

	cell.clickHandler = ^{
		[weakSelf presentImageByUrl:url];
	};

	return cell;
}

- (UICollectionViewCell *)createSavedImage:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ASRItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GalleryVCReuseIdentifier forIndexPath:indexPath];

	ASRMOImage *imageMO = self.savedImages[indexPath.item];
	NSData *loadedImageData = imageMO.blob;
	UIImage *loadedImage = [UIImage imageWithData:loadedImageData];

	[ASRUtils performOnMainThread:^{
		if (!loadedImage)
		{
			cell.contentView.backgroundColor = UIColor.brownColor;
		}

		[cell setImage:loadedImage];
		[cell setLabelText:@"saved"];
	}];

	__auto_type __weak weakSelf = self;

	cell.clickHandler = ^{
//		NSInteger imageId = indexPath.item;
		NSManagedObjectID *imageId = imageMO.objectID;
		[weakSelf presentSavedImageByMOID:imageId];
	};
	
	return cell;
}


#pragma mark - Flow delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		return CGSizeMake(50.0, 50.0);
	}
	
	CGFloat cellSide = ((CGRectGetWidth(collectionView.bounds) - 10.0) / 2.0);
	CGSize cellSize = CGSizeMake(cellSide, cellSide);

	return cellSize;
}

@end
