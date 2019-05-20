//
//  AppDelegate.m
//  App7RememberAll
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "GalleryViewController.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

	GalleryViewController *collectionViewController = [[GalleryViewController alloc] initWithCollectionViewLayout:flowLayout];

	UINavigationController *navigationViewController = [[UINavigationController alloc] init];
	navigationViewController.viewControllers = @[collectionViewController];

	[UINavigationBar appearance].barTintColor = UIColor.blueColor;

	self.window.rootViewController = navigationViewController;
	[self.window makeKeyAndVisible];

	self.navigationController = navigationViewController;
	self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:188 green:255 blue:255 alpha:.8];

	return YES;
}

@end
