//
//  YRImageView.h
//  
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.//
//

#import <UIKit/UIKit.h>
#import "MyBigImageView.h"
#import "BuildingBigImageView.h"
@interface YRImageView : BuildingBigImageView

@property (nonatomic,assign) NSInteger littleIndex;   //图片标签
@property (nonatomic,assign) NSInteger totalIndex;  //当前的索引
@property (nonatomic,assign) NSInteger groupIndex;  //在所有照片中的索引

@property (nonatomic,assign)NSInteger totalNumber;//总数
@property (nonatomic,assign)NSInteger currentIndex;//本组当前数量

@property (nonatomic,copy)NSString* titleString;

@end
