//
//  DataManager.h
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef DataManager_h
#define DataManager_h

#import <UIKit/UIKit.h>

@interface DataManager:NSObject
+ (void)asyncGetImageByUrl:(NSString*)url
                completion:(void(^)(UIImage *image))completion;

@end

#endif /* DataManager_h */
