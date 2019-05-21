//
//  PreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

@class DataManager;

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController

- (instancetype)initWithDataManager:(DataManager *)dataManager NS_DESIGNATED_INITIALIZER;

- (void)showImageWithUrlString:(NSString *)urlString;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
												 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
