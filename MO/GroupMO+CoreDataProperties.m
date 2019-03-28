//
//  GroupMO+CoreDataProperties.m
//  App7RememberAll
//
//  Created by Alexander on 28/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//
//

#import "GroupMO+CoreDataProperties.h"

@implementation GroupMO (CoreDataProperties)

+ (NSFetchRequest<GroupMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Group"];
}

@dynamic title;
@dynamic places;

@end
