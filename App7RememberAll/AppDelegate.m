//
//  AppDelegate.m
//  App7RememberAll
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "AppDelegate.h"
// у курсеры этот файл создается без +CoreDataClass
#import "../MO/PlaceMO+CoreDataClass.h"

#define PLACE @"Place"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  NSLog(@"did finish launch");
  
  return YES;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  NSLog(@"did become active");
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  
  NSLog(@"will resign active");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  
  NSLog(@"did enter bg");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  
  NSLog(@"will enter fg");
}



- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
  
  NSLog(@"will terminate");
}










#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"App7RememberAll"];
          
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
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
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}







#pragma mark - Core Data using. Don't forget to saveContext.

//- (NSManagedObjectContext*) managedObjectContext {
//
//}

- (PlaceMO *) createPlaceMO {
//  NSManagedObjectContext *moc = [self managedObjectContext];
  //from auto-generated saveContext :
  NSManagedObjectContext *moc = self.persistentContainer.viewContext;
  
  PlaceMO *placeMO = [NSEntityDescription insertNewObjectForEntityForName:PLACE
                                                   inManagedObjectContext:moc];
  
  return placeMO;
}

- (NSArray*) getPlaces {
//  NSManagedObjectContext *moc = [self managedObjectContext];
  //from auto-generated saveContext :
  NSManagedObjectContext *moc = self.persistentContainer.viewContext;
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PLACE];
  
  NSError *error = nil;
  NSArray *results = [moc executeFetchRequest:request error:&error];
  if(!results) {
    NSLog(@"Error sanz");
  }
  
  return results;
}

-(void) deletePlaces {
  NSArray* results = [self getPlaces];
  
  if(results.count <= 0) {
    NSLog(@"nothing to delete");
    return;
  }
  
  //from auto-generated saveContext :
  NSManagedObjectContext *moc = self.persistentContainer.viewContext;
  
  for(PlaceMO *p in results) {
    [moc deleteObject:p];
  }
}

@end
