//
//  MSTabBarItemModel.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MSTabBarItemModel.h"

@implementation MSTabBarItemModel

-(instancetype)initWithTitle:(NSString *)title normalImage:(NSString *)normalImageName selectedImage:(NSString *)selectedImageName{
    if (self = [super init]) {
        _title = title;
        _normalImageName = normalImageName;
        _selectedImageName = selectedImageName;
    }
    return self;
}

+(instancetype)tabBarItemModelWithTitle:(NSString *)title normalImage:(NSString *)normalImageName selectedImage:(NSString *)selectedImageName{
    return [[self alloc]initWithTitle:title normalImage:normalImageName selectedImage:selectedImageName];
}

@end
