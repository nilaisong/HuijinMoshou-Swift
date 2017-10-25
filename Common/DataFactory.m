//
//  DataFactory.m
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "DataFactory.h"

@implementation DataFactory

static DataFactory *dataFactory = nil;

+ (DataFactory *)sharedDataFactory
{
    if (!dataFactory) {
        dataFactory = [[DataFactory alloc] init];
    }
    return dataFactory;
}
-(NSDictionary*)jsonObjectWithData:(NSData*)data
{
    if (data==nil) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}
-(NSString*)jsonStringWithObject:(id)object
{
    if (object==nil) {
        return nil;
    }
    NSData* data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
