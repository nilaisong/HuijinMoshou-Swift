//
//  XTYearView.h
//  年历
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTMonthView;

typedef void(^YearViewDidTouchMonthViewCallBack)(XTMonthView* monthView);

@interface XTYearView : UIView

@property (nonatomic,strong)NSDate* currentDate;

@property (nonatomic,weak)NSCalendar* calendar;

@property (nonatomic,strong)NSDate* selectedDate;

@property (nonatomic,weak)NSDate* minDate;

@property (nonatomic,weak)NSDate* maxDate;

@property (nonatomic,copy)YearViewDidTouchMonthViewCallBack callBack;

- (instancetype)initWithCalendar:(NSCalendar*)calendar touchCallBack:(YearViewDidTouchMonthViewCallBack)callBack;

+ (instancetype)yearViewWithCalendar:(NSCalendar*)calendar touchCallBack:(YearViewDidTouchMonthViewCallBack)callBack;

@end
