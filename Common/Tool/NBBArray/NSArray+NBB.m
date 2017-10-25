//
//  NSArray+NBB.m
//  MoShou2
//
//  Created by NiLaisong on 2016/11/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "NSArray+NBB.h"

@implementation NSArray (NBB)
- (nullable id)objectForIndex:(NSUInteger)index
{
    if (index<self.count) {
        id obj = [self objectAtIndex:index];
        if([obj isMemberOfClass:[NSNull class]])
            return nil;
        else
            return obj;

    }
    else
        return nil;
}
//id a = array[idx]
- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx
{
    id obj = [self objectForIndex:idx];
    return obj;
}

@end
