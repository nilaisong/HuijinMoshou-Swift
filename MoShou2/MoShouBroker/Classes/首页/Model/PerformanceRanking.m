//
//  PerformanceRanking.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/19.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "PerformanceRanking.h"

@implementation PerformanceRanking

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }
}

@end
