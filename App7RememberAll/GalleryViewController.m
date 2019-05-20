//
//  GalleryViewController.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "DataManager.h"
#import "GalleryViewController.h"
#import "ItemViewCell.h"
#import "PreviewViewController.h"
#import "Config.h"


@interface GalleryViewController ()

@property (nonatomic, copy) NSArray<NSDictionary *> *imagesCatalogue;
@property (nonatomic, strong) DataManager *dataManager;

@end


@implementation GalleryViewController

static NSString *const GalleryVCReuseIdentifier = @"SimpleCell";


#pragma mark - Lifecycle

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
	if (![super initWithCollectionViewLayout:layout])
	{
		return nil;
	}

	//todo move to app delegate
	NSCache *cache = [NSCache new];
	_dataManager = [[DataManager alloc] initWithCache:cache];

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Register cell classes
	[self.collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:GalleryVCReuseIdentifier];

	// Do any additional setup after loading the view.
	[self startLoadingCatalogue];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self.collectionView reloadData];
}


#pragma mark - Private

/**
 * Приведет к вызову cellForItemAtIndexPath().
 */
- (void)reloadItemAt:(NSIndexPath *)indexPath
{
	[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)startLoadingCatalogue
{
	NSString *urlString = [NSString stringWithFormat:ConfigPhotosUrl, ConfigApiKey, ConfigUserId];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLSession *session = [NSURLSession sharedSession];

	__auto_type __weak weakSelf = self;
	NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
		if (!weakSelf) return;

		id json = [DataManager sessionCheckData:data response:response error:error];
		NSArray<NSDictionary *> *images = [DataManager handleGetPublicPhotosJSON:json];

		weakSelf.imagesCatalogue = images;

		// signal the collection view to start loading images
		if (!NSThread.isMainThread)
		{
			dispatch_sync(dispatch_get_main_queue(), ^{
				[weakSelf.collectionView reloadData];
			});
		}

	}];
	[task resume];
}


# pragma mark - Showing the preview

/**
  Opens the image in a new view controller.
 */
- (void)presentImageByUrl:(NSString *)url
{
	//UIImage *image = [UIImage imageWithData:[self.dataManager tryGetCachedImage:url]];

	PreviewViewController *previewViewController;

	previewViewController = [PreviewViewController new];
	previewViewController.dataManager = self.dataManager;
	previewViewController.url = url;
	[previewViewController reload];

	[self.navigationController pushViewController:previewViewController animated:YES];
}


#pragma mark <UICollectionViewDataSource>

//optional
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.imagesCatalogue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GalleryVCReuseIdentifier forIndexPath:indexPath];

	__auto_type __weak weakSelf = self;

	NSNumber *position = @(indexPath.item + 1);
	NSDictionary *json = self.imagesCatalogue[indexPath.item];
	NSString *url = [DataManager makeUrlStringFromJSON:json];
	NSData *data = [self.dataManager tryGetCachedImage:url];

	//todo stop setting an image directly. Do it with just url instead.
	cell.imageUrl = url;

	if (data)
	{
		UIImage *image = [UIImage imageWithData:data];
		[cell setImage:image];
		[cell setNumber:position];
	}
	else
	{
		[cell resetViews];

		[self.dataManager loadImageByUrl:url completion:^(UIImage *loadedImage) {

			// currently visible or not, we should notify the collection of newly income data
			if (url != cell.imageUrl)
			{
				if (NSThread.isMainThread)
				{
					[weakSelf reloadItemAt:indexPath];
				}
				else
				{
					dispatch_async(dispatch_get_main_queue(), ^{
						[weakSelf reloadItemAt:indexPath];
					});
				}

				return;
			}

			if (!NSThread.isMainThread)
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					if (loadedImage)
					{
						cell.contentView.backgroundColor = UIColor.yellowColor;
					}
					else
					{
						cell.contentView.backgroundColor = UIColor.brownColor;
						cell.contentView.layer.borderColor = [UIColor colorWithRed:0 green:1 blue:0.5 alpha:1].CGColor;
					}

					NSLog(@"\n  index %@ \n  %@", position, url);

					[cell setImage:loadedImage];
					[cell setNumber:position];
				});

			}

		}];
	}

	url = [DataManager makeUrlStringFromJSON:json suffix:@"b"];

	[cell setOnClickBlock:^{
		if (!weakSelf) return;

		[weakSelf presentImageByUrl:url];
	}];

	return cell;
}


@end
