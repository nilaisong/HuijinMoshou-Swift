//
//  NSMutableArray+NBB.m
//  MoShou2
//
//  Created by NiLaisong on 2016/11/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "NSMutableArray+NBB.h"

#import<objc/runtime.h>

@implementation NSMutableArray (NBB)

/*
 load是只要类所在文件被引用就会被调用，而initialize是在类或者其子类的第一个方法被调用前调用
 它们的相同点在于：方法只会被调用一次，因为这两个方法是在程序运行一开始就被调用，我们可以利用他们在类被使用前，做一些预处理工作。
 */
+(void)initialize
{
    //由于程序不调用重写的系统默认数组下标赋值方法setObject:atIndexedSubscript:，
    //只能重新定义个方法setObject:forIndexedSubscript:，并把该方法的实现设置给系统默认的方法
    SEL originalSelector=@selector(setObject:atIndexedSubscript:);
    SEL swizzledSelector=@selector(setObject:forIndexedSubscript:);
    
    Method originalMethod=class_getInstanceMethod(self.class,originalSelector);
    Method swizzledMethod=class_getInstanceMethod(self.class,swizzledSelector);
    
//    BOOL didAddMethod=
//    class_addMethod(self.class,
//                    originalSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(self.class,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//    }
//    else
//    {
//        method_exchangeImplementations(originalMethod,swizzledMethod);
//    }
    method_setImplementation(originalMethod,method_getImplementation(swizzledMethod));
}

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
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self objectForIndex:idx];
}

//array[idx] = a
- (void)setObject:(nonnull id)obj forIndexedSubscript:(NSUInteger)idx
{
    if(obj==nil)
        return;
    
    NSUInteger length = [self count];
    if(idx > length)
        return;
    
    if(idx == length)
        [self addObject:obj];
    else
        [self replaceObjectAtIndex:idx withObject:obj];
}

- (void)appendObject:(nonnull id)anObject
{
    if (anObject==nil) {
        return;
    }
    else
//        [self insertObject:anObject atIndex:self.count];
        [self addObject:anObject];
}

- (void)insertObject:(nonnull id)anObject forIndex:(NSUInteger)index
{
    if(index<=self.count)
    {
        if (anObject==nil) {
//            anObject = [NSNull null];
            return;
        }
        [self insertObject:anObject atIndex:index];
    }
    else
        return;
}

- (void)removeObjectForIndex:(NSUInteger)index
{
    if(index<self.count)
        [self removeObjectAtIndex:index];
    else
        return;
    
}

- (void)replaceObjectForIndex:(NSUInteger)index withObject:(nonnull id)anObject
{
    if(index<self.count)
    {
        if (anObject==nil) {
            return;
        }
         [self replaceObjectAtIndex:index withObject:anObject] ;
    }
    else
        return;
}

- (void)exchangeObjectForIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    if(idx1<self.count && idx2<self.count)
    {
        [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }
    else
        return;
    
}
@end
