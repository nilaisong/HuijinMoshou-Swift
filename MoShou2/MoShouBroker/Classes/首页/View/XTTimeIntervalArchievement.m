//
//  XTTimeIntervalArchievement.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTTimeIntervalArchievement.h"
#import "DataFactory+Main.h"
@interface XTTimeIntervalArchievement()

//时间区间
@property (nonatomic,weak)UILabel* timeIntervalLabel;

@property (nonatomic,weak)UILabel* archievementLabel;

@end

@implementation XTTimeIntervalArchievement



- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat scale = kMainScreenWidth / 375.0f;
    self.timeIntervalLabel.frame = CGRectMake(0, (self.frame.size.height - 15.0 - 12 - 11.0 * scale) / 2.0, self.frame.size.width, 15.0);
    self.archievementLabel.frame = CGRectMake(0, CGRectGetMaxY(_timeIntervalLabel.frame) + 11.0 * scale, self.frame.size.width, 12);
}


- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    switch (_intervalType) {
        case XTTimeIntervalArchievementMonth:
            [self getMonthWithDate:currentDate];
            break;
        case XTTimeIntervalArchievementWeek:
            [self getWeekBeginAndEndWith:currentDate];
            break;
        case XTTimeIntervalArchievementDay:
        default: [self getDayWithDate:currentDate];
            break;
    }
    
}

//根据时间，获取周
- (void)getWeekBeginAndEndWith:(NSDate *)newDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    
    // 得到星期几
    // 1(星期天) 2（星期一） 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六) 8(星期天)
    NSInteger weekDay = [comp weekday];
    
    // 得到几号
    NSInteger day = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 0;
        lastDiff = 6;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MM月dd日"];
//    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
//    NSLog(@"当前 %@",[formater stringFromDate:newDate]);
//    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    self.timeIntervalString = [NSString stringWithFormat:@"%@ —— %@",[formater stringFromDate:firstDayOfWeek],[formater stringFromDate:lastDayOfWeek]];
    self.archievementLabel.attributedText = [[NSAttributedString alloc]initWithString:@"本周业绩-万" attributes:nil];
//    NSDateComponents* component = [NSDateComponents new];
//    component.weekOfMonth = 1;
//    newDate = [calendar dateByAddingComponents:component toDate:newDate options:0];
    //    NSLog(@"weekday = 1:%@",[formater stringFromDate:newDate]);
    //    获取下周同一天
//    [[DataFactory sharedDataFactory]getWorkReportWithType:1 startDate:[_requestFormatter stringFromDate:firstDayOfWeek] endDate:[_requestFormatter stringFromDate:lastDayOfWeek] withCallBack:^(WorkReportModel *result) {
//        if (result.performance.length <= 0) {
//            result.performance = @"-";
//        }
//        NSString* text = [NSString stringWithFormat:@"本周业绩%@万",result.performance];
//        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:text];
//        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98f green:0.32f blue:0.00f alpha:1.00f] range:NSMakeRange(4, result.performance.length)];
//        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4, result.performance.length)];
//        [_archievementLabel setText:nil];
//        _archievementLabel.attributedText = attribute;
//    }];
}

- (void)getMonthWithDate:(NSDate*)newDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    
    NSInteger month = [comp month];
    
    self.timeIntervalString = [NSString stringWithFormat:@"%zi月",month];
    self.archievementLabel.attributedText = [[NSAttributedString alloc]initWithString:@"本月业绩-万" attributes:nil];
//    self.archievementLabel.text = [NSString stringWithFormat:@"本月业绩%@万",_performance];
    comp.day = 1;
//    [[DataFactory sharedDataFactory]getWorkReportWithType:2 startDate:[_requestFormatter stringFromDate:[calendar dateFromComponents:comp]] endDate:nil withCallBack:^(WorkReportModel *result) {
//        if (result.performance.length <= 0) {
//            result.performance = @"-";
//        }
//        NSString* text = [NSString stringWithFormat:@"本月业绩%@万",result.performance];
//        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:text];
//        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98f green:0.32f blue:0.00f alpha:1.00f] range:NSMakeRange(4, result.performance.length)];
//        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4, result.performance.length)];
//        [_archievementLabel setText:nil];
//        _archievementLabel.attributedText = attribute;
//    }];
}

- (void)getDayWithDate:(NSDate*)newDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    
    // 得到星期几
    // 1(星期天) 2（星期一） 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六) 8(星期天)
    NSArray* weekDayArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSInteger weekDay = [comp weekday];

    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString* title = [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:newDate],weekDayArray[weekDay - 1]];

    self.archievementLabel.attributedText = [[NSAttributedString alloc]initWithString:@"业绩-万" attributes:nil];
    self.timeIntervalString = title;
//    [self.archievementLabel setText:[NSString stringWithFormat:@"今日业绩%@万",_archievement]];
//    [[DataFactory sharedDataFactory]getWorkReportWithType:0 startDate:[_requestFormatter stringFromDate:newDate] endDate:nil withCallBack:^(WorkReportModel *result) {
//        if (result.performance.length <= 0 || result == nil) {
//            
//            return ;
//        }
//        NSString* text = [NSString stringWithFormat:@"今日业绩%@万",result.performance];
//        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:text];
//        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98f green:0.32f blue:0.00f alpha:1.00f] range:NSMakeRange(4, result.performance.length)];
//        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4, result.performance.length)];
//        [_archievementLabel setText:nil];
//        _archievementLabel.attributedText = attribute;
//    }];
}

- (UILabel *)timeIntervalLabel{
    if (!_timeIntervalLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setTextColor:[UIColor colorWithRed:0.48f green:0.48f blue:0.49f alpha:1.00f]];
        [label setFont:[UIFont boldSystemFontOfSize:15]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _timeIntervalLabel = label;
    }
    return _timeIntervalLabel;
}



- (UILabel *)archievementLabel{
    if (!_archievementLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setTextColor:[UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f]];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _archievementLabel = label;
    }
    return _archievementLabel;
}

- (void)setIntervalType:(XTTimeIntervalArchievementType)intervalType{
    _intervalType = intervalType;
    self.currentDate = _currentDate;
    
}

- (void)setPerformance:(NSString *)performance{
    _performance = performance;
    if (performance == nil|| performance.length <= 0) {
        performance = @"-";
    }
    NSString* contentStr = nil;
    switch (_intervalType) {
        case XTTimeIntervalArchievementDay:
            contentStr = [NSString stringWithFormat:@"业绩%@万",performance];
            break;
        case XTTimeIntervalArchievementWeek:
            contentStr = [NSString stringWithFormat:@"业绩%@万",performance];
            break;
        case XTTimeIntervalArchievementMonth:
            contentStr = [NSString stringWithFormat:@"业绩%@万",performance];
            break;
        default:
            break;
    }

    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:contentStr];
    _archievementLabel.attributedText = attribute;
    
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.98f green:0.32f blue:0.00f alpha:1.00f] range:NSMakeRange(2, performance.length)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, performance.length)];
    _archievementLabel.attributedText = attribute;
}

- (void)setTimeIntervalString:(NSString *)timeIntervalString{
    _timeIntervalString = timeIntervalString;
    self.timeIntervalLabel.text = timeIntervalString;
}
@end
