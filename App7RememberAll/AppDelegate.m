//
//  AppDelegate.m
//  App7RememberAll
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ASRGalleryViewController.h"
#import "AppDelegate.h"
#import "ASRDataManager.h"


#define DATABASE_FILE @"ASRDatabase"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSCache *cache = [NSCache new];
	ASRDataManager *dataManager = [[ASRDataManager alloc] initWithCache:cache];

	ASRGalleryViewController *collectionViewController = [[ASRGalleryViewController alloc] initWithDataManager:dataManager];

	UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:collectionViewController];

	[UINavigationBar appearance].barTintColor = UIColor.blueColor;

	self.window.rootViewController = navigationViewController;
	[self.window makeKeyAndVisible];

	self.navigationController = navigationViewController;
	self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:188 green:255 blue:255 alpha:.8];

	return YES;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;


- (NSPersistentContainer *)persistentContainer
{
	return [self persistentContainerWithCompletion:^(NSPersistentContainer *_Nullable na) {

	}];
}

- (NSPersistentContainer *)persistentContainerWithCompletion:(void (^)(NSPersistentContainer *_Nullable))completion
{
	// The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
	@synchronized (self)
	{
		if (_persistentContainer == nil)
		{
			_persistentContainer = [[NSPersistentContainer alloc] initWithName:DATABASE_FILE];

			[_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
				if (error != nil)
				{
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					*/
					NSLog(@"Unresolved error %@, %@", error, error.userInfo);
					abort();
				}

				completion(_persistentContainer);
			}];
		}
	}

	return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
	NSManagedObjectContext *context = self.persistentContainer.viewContext;
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error])
	{
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}
}

@end
