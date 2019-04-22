//
//  GalleryVC.h
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GalleryVC : UICollectionViewController
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;

+ (void)asyncGetImage:(NSDictionary*)json
           completion:(void(^)(UIImage*))completion;
+ (void)asyncGetImageByUrl:(NSString*)url
                completion:(void(^)(UIImage*))completion;
+ (NSMutableDictionary*)cachedImages;
@end

NS_ASSUME_NONNULL_END
