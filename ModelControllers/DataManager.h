//
//  DataManager.h
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef DataManager_h
#define DataManager_h

@import UIKit;

@interface DataManager : NSObject
+ (void)asyncGetBigImageByUrl:(NSString *)json completion:(void (^)(UIImage *))completion;

+ (void)asyncGetImageByUrl:(NSString *)url completion:(void (^)(UIImage *image))completion;

+ (NSData *)getCachedImage:(NSString *)url;

@end

#endif /* DataManager_h */
