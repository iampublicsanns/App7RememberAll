//
//  Utils.h
//  App7RememberAll
//
//  Created by Alexander on 21/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

@interface Utils : NSObject

+ (void)performOnMainThread:(void (^)(void))block;

@end

#endif /* Utils_h */
