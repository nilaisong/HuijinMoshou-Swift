//
//  NSDictionary+NilValue.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/7/14.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

-(id)valueForKey:(id)aKey
{
    if(aKey==nil)
        return nil;
    
    id value = [self  objectForKey:aKey];
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

-(NSString*)stringValueForKey:(NSString*)key
{

    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value stringValue];
    }
    else if(value == nil)
    {
        value = @"";
    }
    return value;
}

- (nullable id)objectForKeyedSubscript:(nonnull id)key
{
    return [self valueForKey:key];
}

@end
