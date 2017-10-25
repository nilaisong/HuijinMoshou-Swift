//
//  NSMutableArray+NBB.h
//  MoShou2
//  解决数组越界、添加的值为nil和返回NSNull的问题
//  Created by NiLaisong on 2016/11/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NBB)

//替换objectAtIndex
- (nullable id)objectForIndex:(NSUInteger)index;
//替换addObject
- (void)appendObject:(nonnull id)anObject;
//替换insertObject:atIndex
- (void)insertObject:(nonnull id)anObject forIndex:(NSUInteger)index;
//替换removeObjectAtIndex
- (void)removeObjectForIndex:(NSUInteger)index;
//替换replaceObjectForIndex:withObject
- (void)replaceObjectForIndex:(NSUInteger)index withObject:(nonnull id)anObject;
//替换exchangeObjectForIndex:withObjectAtIndex
- (void)exchangeObjectForIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
//系统默认的方法-通过数组下标访问数组元素
- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx;
//自定义的方法-通过下标赋值数组元素
- (void)setObject:(nonnull id)obj forIndexedSubscript:(NSUInteger)idx;

@end
