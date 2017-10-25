//
//  NSMutableDictionary+JSON.m
//  MoShouQueke
//  
//  Created by NiLaisong on 2017/1/22.
//  Copyright © 2017年  5i5j. All rights reserved.
//

#import "NSMutableDictionary+JSON.h"
#import<objc/runtime.h>

@implementation NSMutableDictionary (JSON)
/*
 load是只要类所在文件被引用就会被调用，而initialize是在类或者其子类的第一个方法被调用前调用
 它们的相同点在于：方法只会被调用一次，因为这两个方法是在程序运行一开始就被调用，我们可以利用他们在类被使用前，做一些预处理工作。
 */
+(void)initialize
{
//    [super initialize];
    //通过这种方式可以实现重新定义系统提供的方法
    SEL originalSelector=@selector(objectForKeyedSubscript:);
    SEL swizzledSelector=@selector(valueForKeyedSubscript:);
    
    Method originalMethod=class_getInstanceMethod(self.class,originalSelector);
    Method swizzledMethod=class_getInstanceMethod(self.class,swizzledSelector);

    method_setImplementation(originalMethod,method_getImplementation(swizzledMethod));
    //
    originalSelector=@selector(setObject:forKeyedSubscript:);
    swizzledSelector=@selector(setValue:forKeyedSubscript:);
    
    originalMethod=class_getInstanceMethod(self.class,originalSelector);
    swizzledMethod=class_getInstanceMethod(self.class,swizzledSelector);
    
    method_setImplementation(originalMethod,method_getImplementation(swizzledMethod));
}

-(nullable id)valueForKey:(nonnull id)aKey
{
    if(aKey==nil)
        return nil;

    id value = [self  objectForKey:aKey];
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

- (void)setValue:(nonnull id)value forKey:(nonnull id<NSCopying>)aKey
{
    if(aKey==nil)
        return;

    if(value==nil)
        return;
    else
        [self setObject:value forKey:aKey];
}

- (nullable id)valueForKeyedSubscript:(nonnull id)key
{
    return [self valueForKey:key];
}

- (void)setValue:(nonnull id)value forKeyedSubscript:(nonnull id < NSCopying >)aKey
{
    [self setValue:value forKey:aKey];
}

@end
