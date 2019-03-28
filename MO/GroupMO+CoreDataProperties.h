//
//  GroupMO+CoreDataProperties.h
//  App7RememberAll
//
//  Created by Alexander on 28/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//
//

#import "GroupMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GroupMO (CoreDataProperties)

+ (NSFetchRequest<GroupMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSSet<PlaceMO *> *places;

@end

@interface GroupMO (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(PlaceMO *)value;
- (void)removePlacesObject:(PlaceMO *)value;
- (void)addPlaces:(NSSet<PlaceMO *> *)values;
- (void)removePlaces:(NSSet<PlaceMO *> *)values;

@end

NS_ASSUME_NONNULL_END
