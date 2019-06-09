//
//  ASRImageDAO.h
//  App7RememberAll
//
//  Created by Alexander on 08/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef ASRImageDAO_h
#define ASRImageDAO_h


#import "ASRMOImage+CoreDataClass.h"
//@class ASRMOImage;NSManagedObject;

@interface ASRImageDAO : NSObject

@property (nonatomic, nonnull, readonly) NSPersistentContainer *persistentContainer;

- (nullable instancetype)initWithContainer:(nonnull NSPersistentContainer *)container;
- (nonnull ASRMOImage *)createASRMOImage;
- (nullable ASRMOImage*)getASRMOImageById:(NSInteger)nid;
- (nullable ASRMOImage*)getASRMOImageByMOID:(NSManagedObjectID*)moid;
- (nullable NSArray<ASRMOImage*> *)getASRMOImages;

- (void)deleteASRMOImageByMOID:(NSManagedObjectID*)moid;
- (void)deleteASRMOImages;
- (void)saveContext;

@end

#endif /* ASRImageDAO_h */
