//
//  NSArray+NBB.h
//  MoShou2
//  解决数组越界和返回NSNull的问题
//  Created by NiLaisong on 2016/11/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NBB)
//替换objectAtIndex
- (nullable id)objectForIndex:(NSUInteger)index;
//系统默认的方法-通过数组下标访问数组元素
//分类可以覆盖主类中的同名方法，另外同一个主类的多个分类如果有同名的方法，最后编译的会覆盖之前编译的
- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx;
@end
