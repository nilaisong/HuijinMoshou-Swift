//
//  NSDate+MR.m
//  Sxiic
//
//  Created by Wuquancheng on 13-8-25.
//  Copyright (c) 2013年 mini. All rights reserved.
//

#import "NSDate+MR.h"

@implementation NSDate (MR)
- (NSString*)format:(NSString*)style
{
    NSDateFormatter *__dateFormate = [[NSDateFormatter alloc] init];
    [__dateFormate setLocale:[NSLocale currentLocale]];
    [__dateFormate setDateFormat:style];
    NSString *f = [__dateFormate stringFromDate:self];
	return f;
}

+ (NSString *)textForTimeLabel : (NSString*) dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *now = [NSDate date];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:date];
    //NSLog(@"%f",timeBetween);

    int days=(int)((timeBetween)/(3600*24));
    int months;
    if (days/30 <= 1) {
        months = 0;
    }else{
        months = days/30+1;
    }

    days = days - months*30;
    int hours=((int)(timeBetween)%(3600*24))/3600;
    NSString *dateContent;
    if (months == 0) {
        if (days == 0) {
            dateContent = [NSString stringWithFormat:@"%d小时前",hours];
        }
        else
        {
            dateContent = [NSString stringWithFormat:@"%d天前",days];
        }
    }else{
        dateContent = [NSString stringWithFormat:@"%d个月前",months];
    }
    return dateContent;
}

//与当前时间比较
- (BOOL) isLaterSinceNow
{
    if(0 < [self timeIntervalSinceNow])
    {
        return YES;
    }
    
    return NO;
}

@end
