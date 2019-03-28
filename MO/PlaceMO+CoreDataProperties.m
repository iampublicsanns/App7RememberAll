//
//  PlaceMO+CoreDataProperties.m
//  App7RememberAll
//
//  Created by Alexander on 28/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//
//

#import "PlaceMO+CoreDataProperties.h"

@implementation PlaceMO (CoreDataProperties)

+ (NSFetchRequest<PlaceMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Place"];
}

@dynamic lng;
@dynamic ltd;
@dynamic title;
@dynamic group;

@end
