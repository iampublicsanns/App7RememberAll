//
//  AppDelegate.m
//  App7RememberAll
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "../ViewControllers/GalleryVC.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

	GalleryVC *collectionVC = [[GalleryVC alloc] initWithCollectionViewLayout:flowLayout];

	UINavigationController *navigationVC = [[UINavigationController alloc] init];
	navigationVC.viewControllers = @[collectionVC];

	[UINavigationBar appearance].barTintColor = UIColor.blueColor;

	self.window.rootViewController = navigationVC;
	[self.window makeKeyAndVisible];

	self.navigationController = navigationVC;

	return YES;
}

@end
