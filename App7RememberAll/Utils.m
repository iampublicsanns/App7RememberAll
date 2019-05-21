//
//  Utils.m
//  App7RememberAll
//
//  Created by Alexander on 21/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

@import Foundation;

#import "Utils.h"


@implementation Utils

+ (void)performOnMainThread:(void (^)(void))block
{
	if (NULL == block)
	{
		return;
	}
	
	if (!NSThread.isMainThread)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			block();
		});
	}
	else
	{
		block();
	}
}

@end
