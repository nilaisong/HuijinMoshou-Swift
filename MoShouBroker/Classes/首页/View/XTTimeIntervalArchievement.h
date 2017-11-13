//
//  XTTimeIntervalArchievement.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
// 工作时间区间与业绩

#import <UIKit/UIKit.h>




//展示类型，日，周，月 形式展示
typedef NS_ENUM(NSInteger,XTTimeIntervalArchievementType){
    XTTimeIntervalArchievementDay,
    XTTimeIntervalArchievementWeek,
    XTTimeIntervalArchievementMonth
};

@interface XTTimeIntervalArchievement : UIView

//时间展示类型，默认是天
@property (nonatomic,assign)XTTimeIntervalArchievementType intervalType;
//当前时间
@property (nonatomic,strong)NSDate* currentDate;

//业绩
@property (nonatomic,copy)NSString* performance;

@property (nonatomic,weak)NSDateFormatter* requestFormatter;

//时间区间字符串
@property (nonatomic,copy)NSString* timeIntervalString;

@end
