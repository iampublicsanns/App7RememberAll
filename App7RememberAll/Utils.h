//
//  Utils.h
//  App7RememberAll
//
//  Created by Alexander on 21/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

void performOnMainThread(void (^block)(void))
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

#endif /* Utils_h */
