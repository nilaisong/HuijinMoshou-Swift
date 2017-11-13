//
//  XTRemindTimeView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTRemindTimeView.h"

@interface XTRemindTimeView()

@property (nonatomic,weak)UILabel* remindTimeLabel;

@property (nonatomic,weak)UILabel* remindTitleLabel;

@property (nonatomic,strong)NSDateFormatter* formatter;

@end

@implementation XTRemindTimeView

- (instancetype)initWithCallBack:(XTRemindTimeViewEventCallBack)callBack{
    if (self = [super init]) {
        [self commonInit];
        _callBack = callBack;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)commonInit{
    [self remindTitleLabel];
    
    [self remindTimeLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTimeAction:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews{
    _remindTitleLabel.frame = CGRectMake(16, 0, 80, self.frame.size.height);
    _remindTimeLabel.frame = CGRectMake(CGRectGetMaxX(_remindTitleLabel.frame), 0, self.frame.size.width - CGRectGetMaxX(_remindTitleLabel.frame) - 16, self.frame.size.height);
}

- (UILabel *)remindTimeLabel{
    if (!_remindTimeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:16];
//        label.text = @"15/12/15 周二 2：58";
        label.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        _remindTimeLabel = label;
    }
    return _remindTimeLabel;
}

- (UILabel *)remindTitleLabel{
    if (!_remindTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"提醒时间";
        [self addSubview:label];
        _remindTitleLabel = label;
        self.selectedDate = [NSDate date];
    }
    return _remindTitleLabel;
}

- (void)selectTimeAction:(UIGestureRecognizer*)gesture{
    if (_callBack) {
        _callBack(self);
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:selectedDate];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSString* yearMonth =[NSString stringWithFormat:@"%ld/%ld/%ld/ %@ %02ld:%02ld",(long)year,(long)month,(long)day,[arrWeek objectForIndex:week - 1],(long)hour,(long)minute];
//    NSString* Day =[NSString stringWithFormat:@"%ld",(long)day];
//    NSString* Week =[NSString stringWithFormat:@"%@",[arrWeek objectForIndex:week]];
    self.remindTimeLabel.text = yearMonth;
}

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        
    }
    return _formatter;
}

@end
