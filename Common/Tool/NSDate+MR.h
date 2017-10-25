//
//  NSDate+MR.h
//  Sxiic
//
//  Created by Wuquancheng on 13-8-25.
//  Copyright (c) 2013年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MR)
- (NSString*)format:(NSString*)style;
+ (NSString *)textForTimeLabel:(NSString*) dateString;
//与当前时间比较
- (BOOL) isLaterSinceNow;

@end
