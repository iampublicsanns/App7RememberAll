//
//  Utils.h
//  App7RememberAll
//
//  Created by Alexander on 21/05/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

/**
 Класс со вспомогательными методами общего назначения
 * */
@interface Utils : NSObject

/**
 Если вызван с главного потока, выполнит блок сразу. Иначе - запустит асинхронно на главном.
 @param block блок, который вызвать на главном потоке
 */
+ (void)performOnMainThread:(void (^)(void))block;

@end

#endif /* Utils_h */
