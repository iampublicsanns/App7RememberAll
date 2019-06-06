//
//  ASRMockURLProtocol.h
//  App7RememberAllTests
//
//  Created by Alexander on 04/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ResponseCallback)(NSHTTPURLResponse *  _Nullable response, NSData * _Nullable data);
typedef void (^RequestHandler)(NSURLRequest * _Nullable request, ResponseCallback  _Nullable responseCallback);


@interface ASRMockURLProtocol : NSURLProtocol

@property (class, nonatomic, nullable, strong) RequestHandler requestHandler;

- (void)handleRequest: (NSURLRequest*)request
						withBlock: (void(^)(NSHTTPURLResponse *response, NSData *data))responseCallback;

@end

NS_ASSUME_NONNULL_END
