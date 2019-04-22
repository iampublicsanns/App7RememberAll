//
//  DataManager.m
//  App7RememberAll
//
//  Created by Alexander on 22/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "GalleryVC.h"


@implementation DataManager


+ (void)asyncGetImageByUrl:(NSString*)url
                completion:(void(^)(UIImage * _Nonnull))completion {
  
  [GalleryVC asyncGetImageByUrl:url
                     completion:completion];
}

@end
