//
//  PreviewViewController.h
//  App7RememberAll
//
//  Created by Alexander on 11/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController

@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, copy) NSString *url;

//- (instancetype)initWithImage:(UIImage *)image;
//
//- (instancetype)initWithUrl:(NSString *)url;

/** Starts download */
- (void)reload;

@end

NS_ASSUME_NONNULL_END
