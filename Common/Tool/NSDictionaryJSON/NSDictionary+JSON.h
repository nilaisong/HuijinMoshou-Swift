//
//  NSDictionary+NilValue.h
//  MoShouBroker
//  解决返回NSNull的问题
//  Created by NiLaisong on 15/7/14.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
-(nullable id)valueForKey:(nonnull id)aKey;
-(nullable NSString*)stringValueForKey:(nonnull NSString*)key;
//系统默认的方法-通过下标访问字典元素
- (nullable id)objectForKeyedSubscript:(nonnull id)key;
@end
