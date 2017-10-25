//
//  MSTabBarItemModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
/////

/**
 *  标签模型，选中图片的名字，和默认图片的名字，以及。。。
 */

#import <Foundation/Foundation.h>

@interface MSTabBarItemModel : NSObject

@property (nonatomic,copy)NSString* normalImageName;

@property (nonatomic,copy)NSString* selectedImageName;

@property (nonatomic,copy)NSString* title;

-(instancetype)initWithTitle:(NSString*)title normalImage:(NSString*)normalImageName selectedImage:(NSString*)selectedImageName;

+(instancetype)tabBarItemModelWithTitle:(NSString*)title normalImage:(NSString*)normalImageName selectedImage:(NSString*)selectedImageName;
@end
