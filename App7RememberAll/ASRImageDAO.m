//
//  ASRImageDAO.m
//  App7RememberAll
//
//  Created by Alexander on 08/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import CoreData;
#import "ASRImageDAO.h"


#define IMAGE @"ASRMOImage"

@interface ASRImageDAO ()

@property (nonatomic, nonnull, readonly) NSPersistentContainer *persistentContainer;

@end

@implementation ASRImageDAO

#pragma mark - Core Data using. Don't forget to saveContext.

- (instancetype)initWithContainer:(nonnull NSPersistentContainer *)container
{
	//is in example?
	self = [super init];
	if (self)
	{
		_persistentContainer = container;
	}

	return self;
}

- (ASRMOImage *)createASRMOImage
{
	NSManagedObjectContext *moc = self.persistentContainer.viewContext;

	ASRMOImage *image = [NSEntityDescription insertNewObjectForEntityForName:IMAGE
		inManagedObjectContext:moc];

	return image;
}

- (ASRMOImage *)getASRMOImageByMOID:(NSManagedObjectID *)moid
{
	NSManagedObjectContext *moc = self.persistentContainer.viewContext;

	return [moc objectWithID:moid];
}

- (NSArray<ASRMOImage *> *)getASRMOImages
{
	NSManagedObjectContext *moc = self.persistentContainer.viewContext;

	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IMAGE];

	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:request error:&error];
	if (!results)
	{
		NSLog(@"Error sanz");
	}

	return results;
}

- (NSInteger)getASRMOImagesCount
{
	NSManagedObjectContext *moc = self.persistentContainer.viewContext;

	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:IMAGE];

	NSError *error = nil;
	NSInteger results = [moc countForFetchRequest:request error:&error];
	if (!results)
	{
		NSLog(@"Error sanz");
	}

	return results;
}

- (void)deleteASRMOImageByMOID:(NSManagedObjectID *)moid
{
	ASRMOImage *imageMO = [self getASRMOImageByMOID:moid];
	NSManagedObjectContext *moc = self.persistentContainer.viewContext;

	[moc deleteObject:imageMO];
}

- (void)deleteASRMOImages
{
	NSArray *results = [self getASRMOImages];

	if (results.count <= 0)
	{
		NSLog(@"nothing to delete");
		return;
	}

	NSManagedObjectContext *moc = self.persistentContainer.viewContext;

	for (ASRMOImage *p in results)
	{
		[moc deleteObject:p];
	}
}

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
