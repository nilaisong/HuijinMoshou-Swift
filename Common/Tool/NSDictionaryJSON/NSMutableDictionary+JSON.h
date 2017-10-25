//
//  NSMutableDictionary+JSON.h
//  MoShouQueke
//  解决添加的值为nil和返回NSNull的问题
//  Created by NiLaisong on 2017/1/22.
//  Copyright © 2017年  5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JSON)
-(nullable id)valueForKey:(nonnull id<NSCopying>)aKey;
- (void)setValue:(nonnull id)value forKey:(nonnull id<NSCopying>)aKey;
//自定义的方法-通过下标访问字典元素
- (nullable id)valueForKeyedSubscript:(nonnull id)key;
//自定义的方法-通过下标赋值字典元素
- (void)setValue:(nonnull id)value forKeyedSubscript:(nonnull id < NSCopying >)aKey;

@end
