//
//  MyUncaughtExceptionHandler.h
//  MoShou2
//
//  Created by Mac on 2017/4/17.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;



@end
