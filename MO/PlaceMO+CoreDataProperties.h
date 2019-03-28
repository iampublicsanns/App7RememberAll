//
//  PlaceMO+CoreDataProperties.h
//  App7RememberAll
//
//  Created by Alexander on 28/03/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//
//

#import "PlaceMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PlaceMO (CoreDataProperties)

+ (NSFetchRequest<PlaceMO *> *)fetchRequest;

@property (nonatomic) double lng;
@property (nonatomic) double ltd;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) GroupMO *group;

@end

NS_ASSUME_NONNULL_END
