//
//  XTYearCalendarContentView.h
//  年历
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTMonthView.h"

typedef void(^YearCalendarContentViewEventCallBack)(XTMonthView* monthView);

@interface XTYearCalendarContentView : UIView
@property (nonatomic,strong)NSCalendar* calendar;
//上一年时间
@property (nonatomic,strong)NSDate * previousDate;
//今年时间
@property (nonatomic,strong)NSDate* currentDate;
//明年时间
@property (nonatomic,strong)NSDate* nextDate;

@property (nonatomic,strong)NSDate* minDate;

@property (nonatomic,strong)NSDate* maxDate;

@property (nonatomic,copy)YearCalendarContentViewEventCallBack callBack;

- (instancetype)initWithEventCallBack:(YearCalendarContentViewEventCallBack)callBack;

+ (instancetype)yearCalendarContentViewWith:(YearCalendarContentViewEventCallBack)callBack;

@end
