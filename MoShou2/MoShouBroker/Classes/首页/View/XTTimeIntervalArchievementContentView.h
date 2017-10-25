//
//  XTTimeIntervalArchievementContentView.h
//  时间区间业绩导航图
//
//  Created by xiaotei's on 15/12/3.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//时间区间导航图容器视图

#import <UIKit/UIKit.h>
#import "XTTimeIntervalArchievement.h"

@class XTTimeIntervalArchievementContentView;
//返回选中时间和当前类型
typedef void(^XTTimeIntervalArchievementEventCallBack)(XTTimeIntervalArchievement* currentArchievement,NSDate* date,XTTimeIntervalArchievementType intervalType);

//发出警告
typedef void(^XTTimeIntervalArchievementTipsCallBack)(XTTimeIntervalArchievementContentView* contentView,NSString* tips);

@interface XTTimeIntervalArchievementContentView : UIView

@property (nonatomic,assign)XTTimeIntervalArchievementType intervalType;

@property (nonatomic,strong)NSDate* currentDate;

@property (nonatomic,weak)NSDate* minDate;

@property (nonatomic,strong)NSDate* maxDate;

@property (nonatomic,strong)NSDate* todayDate;

@property (nonatomic,copy)NSString* performace;

@property (nonatomic,copy)XTTimeIntervalArchievementEventCallBack callBack;

@property (nonatomic,copy)XTTimeIntervalArchievementTipsCallBack tipsCallBack;


@property (nonatomic,weak)NSDateFormatter* requestFormatter;

@property (nonatomic,strong)NSMutableArray* threeDateArray;
//时间字符串
@property (nonatomic,copy)NSString* timeInterValString;

- (instancetype)initWithEventCallBack:(XTTimeIntervalArchievementEventCallBack)callBack;

- (NSDate *)getMonthBeginWith:(NSDate *)newDate;

- (NSDate*)getFirstDayOfWeek:(NSDate*)newDate;
@end
