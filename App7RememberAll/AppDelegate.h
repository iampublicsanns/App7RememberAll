//
//  AppDelegate.h
//  App7RememberAll
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (readonly, nullable, strong) NSPersistentContainer *persistentContainer;

- (NSPersistentContainer *)persistentContainerWithCompletion:(void (^)(NSPersistentContainer *_Nullable))completion;

- (void)saveContext;

@end

