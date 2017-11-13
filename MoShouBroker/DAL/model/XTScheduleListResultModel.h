//
//  XTScheduleListResultModel.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//我的日程

#import <Foundation/Foundation.h>

@interface XTScheduleListResultModel : NSObject

@property (nonatomic,strong)NSArray* remindList;//RemindResult

@property (nonatomic,strong)NSArray* phoneList;

@property (nonatomic,copy)NSString * date;//当前日期

@property (nonatomic,copy)NSString* formatDateString;//格式化字符串

@end
