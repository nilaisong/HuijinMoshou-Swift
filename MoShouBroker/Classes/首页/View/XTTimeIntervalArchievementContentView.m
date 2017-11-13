//
//  XTTimeIntervalArchievementContentView.m
//  时间区间业绩导航图
//
//  Created by xiaotei's on 15/12/3.
//  Copyright © 2015年 xiaotei's. All rights reserved.


#import "XTTimeIntervalArchievementContentView.h"
#import "DataFactory+Main.h"


@interface XTTimeIntervalArchievementContentView()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView* contentScrollView;

//三个日期区间view
@property (nonatomic,strong)NSArray* threeIntervalView;



@property (nonatomic,strong)NSCalendar* calendar;

@property (nonatomic,weak)UIButton* loadNextPage;

@property (nonatomic,weak)UIButton* loadPrePage;

@property (nonatomic,strong)NSDateFormatter* formatter;

@property (nonatomic,assign)CGFloat lastContentOffset;

@end

@implementation XTTimeIntervalArchievementContentView

- (instancetype)initWithEventCallBack:(XTTimeIntervalArchievementEventCallBack)callBack{
    if (self = [super init]) {
        _callBack = callBack;
        _lastContentOffset = kMainScreenWidth;
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

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self todayDate];
    for (int i = 0; i < self.threeIntervalView.count; i++) {
        XTTimeIntervalArchievement* interView = _threeIntervalView[i];
        if (_currentDate == nil) {
            _currentDate = [self getPreviousDayWithDate:_todayDate];
            
        }
        if (i == 0) {
            interView.currentDate = [self getPreviousDayWithDate:_currentDate];
        }else if(i == 1){
            interView.currentDate = _currentDate;
        }else if(i == 2){
            interView.currentDate = [self getNextDayWithDate:_currentDate];
        }
        interView.intervalType = _intervalType;
        
        
    }
    [self changeSwitchButtonStatus];
    [self threeDateArray];
}

- (void)layoutSubviews{
    self.contentScrollView.frame = self.bounds;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = self.frame.size.width;
    CGFloat itemH = self.frame.size.height;
    for (int i = 0 ;i < 3;i++) {
        UIView* view = self.threeIntervalView[i];
        itemX = self.frame.size.width * i;
        view.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }
    _contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    _contentScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    self.loadNextPage.frame = CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
    self.loadPrePage.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
}


- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        UIScrollView* contentView = [[UIScrollView alloc]init];
        [self addSubview:contentView];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.showsHorizontalScrollIndicator = NO;
        _contentScrollView = contentView;
    }
    _contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);

    return _contentScrollView;
}

- (NSArray *)threeIntervalView{
    if (!_threeIntervalView || _threeIntervalView.count <= 0) {
        NSMutableArray* arrayM = [NSMutableArray array];
        
        for (int i = 0; i < 3; i++) {
            XTTimeIntervalArchievement* tiaView = [[XTTimeIntervalArchievement alloc]init];
            tiaView.requestFormatter = self.requestFormatter;
            [self.contentScrollView addSubview:tiaView];
            [arrayM appendObject:tiaView];
        }
        _threeIntervalView = [NSArray arrayWithArray:arrayM];
    }
    
    return _threeIntervalView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.x <= self.frame.size.width) {
//        [self changePrviousDate];
        
        int result = [self compareOneDay:_currentDate withPrepareDate:_minDate];
        if ((result == 0 || result == 1 )&& point.x < self.frame.size.width / 2.0f){
            [self changePrviousDate];
        }else{
            if (_tipsCallBack) {
                //                _tipsCallBack(self,@"只能展示当前日之前的工作报表");
            }
            [UIView animateWithDuration:0.2 animations:^{
                
                scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
            }];
        }

    }else if(point.x > self.frame.size.width){
        int result = [self compareOneDay:_currentDate withAnotherDay:_maxDate];
        if (result == -1 && point.x > self.frame.size.width * 1.5){
            [self changeNextDate];
        }else{
            if (_tipsCallBack) {
//                _tipsCallBack(self,@"只能展示当前日之前的工作报表");
            }
            [UIView animateWithDuration:0.2 animations:^{
                
               scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
            }];
        }

    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
//
    
    if (point.x > self.frame.size.width) {
        int result = [self compareOneDay:_currentDate withAnotherDay:_maxDate];
        if (result != -1) {
//             = CGSizeMake(kMainScreenWidth * 2, 0);
        
//            CGFloat scale = (point.x - kMainScreenWidth)/kMainScreenWidth * 2 - 0.2;
//            NSLog(@"---%f",);
            
            scrollView.contentSize = CGSizeMake(kMainScreenWidth * 2.0, 0);
        }else scrollView.contentSize = CGSizeMake(kMainScreenWidth * 3.0, 0);
    }else if(point.x < self.frame.size.width){
        int result = [self compareOneDay:_currentDate withPrepareDate:_minDate];
        if (result != 1 && result != 0) {
            scrollView.contentOffset = CGPointMake(point.x + 0.8 * (kMainScreenWidth - point.x)/kMainScreenWidth, 0);
        }
    }
    
    _lastContentOffset = point.x;
}

- (void)changePrviousDate{
    XTTimeIntervalArchievement* pre = self.threeIntervalView[0];
    XTTimeIntervalArchievement* cur = self.threeIntervalView[1];
    XTTimeIntervalArchievement* nex = self.threeIntervalView[2];
    if (_contentScrollView.contentOffset.x != self.frame.size.width)
    switch (_intervalType) {
        case XTTimeIntervalArchievementMonth:{
            nex.currentDate = cur.currentDate;
            cur.currentDate = [self getPreviousMonthWithDate:cur.currentDate];
            pre.currentDate = [self getPreviousMonthWithDate:cur.currentDate];
            [_threeDateArray replaceObjectForIndex:2 withObject:cur.currentDate];
        }
            break;
        case XTTimeIntervalArchievementWeek:{
            nex.currentDate = cur.currentDate;
            cur.currentDate = [self getPreviousWeekWithDate:cur.currentDate];
            pre.currentDate = [self getPreviousWeekWithDate:cur.currentDate];
            [_threeDateArray replaceObjectForIndex:1 withObject:cur.currentDate];
        }
            break;
        case XTTimeIntervalArchievementDay:
        default:{
            nex.currentDate = cur.currentDate;
            cur.currentDate = [self getPreviousDayWithDate:cur.currentDate];
            pre.currentDate = [self getPreviousDayWithDate:cur.currentDate];
            [_threeDateArray replaceObjectForIndex:0 withObject:cur.currentDate];
        }
            break;
    }
    if (_callBack) {
        _callBack(cur,cur.currentDate,_intervalType);
    }
    _contentScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

- (void)changeNextDate{
    XTTimeIntervalArchievement* pre = self.threeIntervalView[0];
    pre.intervalType = _intervalType;
    XTTimeIntervalArchievement* cur = self.threeIntervalView[1];
    cur.intervalType = _intervalType;
    XTTimeIntervalArchievement* nex = self.threeIntervalView[2];
    nex.intervalType = _intervalType;
    if (_contentScrollView.contentOffset.x != self.frame.size.width)
    switch (_intervalType) {
        case XTTimeIntervalArchievementMonth:{
            pre.currentDate = cur.currentDate;
            cur.currentDate = [self getNextMonthWithDate:cur.currentDate];
            nex.currentDate = [self getNextMonthWithDate:cur.currentDate];
            [_threeDateArray replaceObjectForIndex:2 withObject:cur.currentDate];
        }
            break;
        case XTTimeIntervalArchievementWeek:{
            pre.currentDate = cur.currentDate;
            cur.currentDate = [self getNextWeekWithDate:cur.currentDate];
            nex.currentDate = [self getNextWeekWithDate:cur.currentDate];
            [_threeDateArray replaceObjectForIndex:1 withObject:cur.currentDate];
        }
            break;
        case XTTimeIntervalArchievementDay:
        default:{
            pre.currentDate = cur.currentDate;
            cur.currentDate = [self getNextDayWithDate:cur.currentDate];
            nex.currentDate = [self getNextDayWithDate:cur.currentDate];
            [_threeDateArray replaceObjectForIndex:0 withObject:cur.currentDate];

        }
            break;
    }
    if (_callBack) {
        _callBack(cur,cur.currentDate,_intervalType);
    }
   _contentScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

- (NSDate*)getPreviousMonthWithDate:(NSDate*)date{
    NSDateComponents* component = [NSDateComponents new];
    component.month = -1;
    return [self.calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSDate*)getNextMonthWithDate:(NSDate*)date{
    NSDateComponents* component = [NSDateComponents new];
    component.month = 1;
    return [self.calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSDate*)getPreviousWeekWithDate:(NSDate*)date{
    
    NSDateComponents* component = [NSDateComponents new];
    component.weekOfMonth = -1;
    return [self.calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSDate*)getNextWeekWithDate:(NSDate*)date{
    NSDateComponents* component = [NSDateComponents new];
    component.weekOfMonth = 1;
    NSDate* newDate = [self.calendar dateByAddingComponents:component toDate:date options:0];
    return newDate;
}

- (NSDate*)getNextWeekFirstDayWithDate:(NSDate*)date{
    NSDateComponents* component = [NSDateComponents new];
    component.weekOfMonth = 1;
    component.weekday = 1;
    return [self.calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSDate*)getPreviousDayWithDate:(NSDate*)date{
    NSDateComponents* component = [NSDateComponents new];
    component.day = -1;
    return [self.calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSDate*)getNextDayWithDate:(NSDate*)date{
    NSDateComponents* component = [NSDateComponents new];
    component.day = 1;
    return [self.calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSDate*)getFirstDayOfWeek:(NSDate*)newDate{
    NSCalendar *calendar = self.calendar;
//    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:newDate];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
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
    return [calendar dateFromComponents:firstDayComp];
}

- (NSDate *)getMonthBeginWith:(NSDate *)newDate{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    double interval = 0;
    NSDate *beginDate = nil;
    NSCalendar *calendar = _calendar;
    
//    [calendar setFirstWeekday:1];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    
    return beginDate;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    if (!oneDay || !anotherDay) {
        return 0;
    }
    switch (_intervalType) {
        case XTTimeIntervalArchievementDay:
            oneDay = [self getNextDayWithDate:oneDay];
            break;
        case XTTimeIntervalArchievementWeek:
            oneDay = [self getNextWeekWithDate:[self getFirstDayOfWeek:oneDay]];
            
//            anotherDay = [self getFirstDayOfWeek:[self getNextWeekWithDate:anotherDay]];
            break;
        case XTTimeIntervalArchievementMonth:
            oneDay = [self getNextMonthWithDate:[self getMonthBeginWith:oneDay]];
            anotherDay = [self getNextDayWithDate:anotherDay];
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = self.formatter;

    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
//    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (int)compareOneDay:(NSDate *)oneDay withPrepareDate:(NSDate *)anotherDay
{
    if (!oneDay || !anotherDay) {
        return 0;
    }
    switch (_intervalType) {
        case XTTimeIntervalArchievementDay:
            oneDay = [self getPreviousDayWithDate:oneDay];
            break;
        case XTTimeIntervalArchievementWeek:
        {
            oneDay = [self getPreviousWeekWithDate:oneDay];
            anotherDay = [self.formatter dateFromString:@"2015-05-31"];
        }
            break;
        case XTTimeIntervalArchievementMonth:
            oneDay = [self getPreviousMonthWithDate:oneDay];
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = self.formatter;
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        [_calendar setFirstWeekday:1];
    }
    return _calendar;
}

- (UIButton *)loadNextPage{
    if (!_loadNextPage) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrow-right-blue"] forState:UIControlStateNormal];
        [btn  setImage:[UIImage imageNamed:@"arrow-right-blue-down"] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(self.frame.size.width - 30, 0, 30, 30);
        [btn addTarget:self action:@selector(changePageTouch:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1;
        [self addSubview:btn];
        _loadNextPage = btn;
    }
    return _loadNextPage;
}

- (UIButton *)loadPrePage{
    if (!_loadPrePage) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrow-left-blue"] forState:UIControlStateNormal];
        [btn  setImage:[UIImage imageNamed:@"arrow-left-blue-down"] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(changePageTouch:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 0;
        [self addSubview:btn];
        _loadPrePage = btn;
    }
    return _loadPrePage;
}

- (void)changePageTouch:(UIButton*)btn{
    if (btn.tag == 1) {
        int result = [self compareOneDay:_currentDate withAnotherDay:_todayDate];
        if (result != -1) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            _contentScrollView.contentOffset = CGPointMake(self.frame.size.width * 2.0f, 0);
        } completion:^(BOOL finished) {
            
            if (result == -1 || result == 0){
                [self changeNextDate];
            }else{
//                [UIView animateWithDuration:0.2 animations:^{
//                    _contentScrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
//                }];
            }
        }];
        
    }else if(btn.tag == 0){
        int result = [self compareOneDay:_currentDate withPrepareDate:_minDate];
        if (result != 1  && result != 0) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            _contentScrollView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            
            if (result == 1 || result == 0){
                [self changePrviousDate];
            }else{
//                [UIView animateWithDuration:0.2 animations:^{
//                    _contentScrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
//                }];
            }
        }];
    }
}

- (void)setIntervalType:(XTTimeIntervalArchievementType)intervalType{
    if (_intervalType != intervalType) {
        if (self.threeDateArray.count >= 3)
            switch (intervalType) {
                case XTTimeIntervalArchievementDay:
                    _currentDate = _threeDateArray[0];
                    break;
                case XTTimeIntervalArchievementWeek:
                {
                    _currentDate = _threeDateArray[1];
                }
                    break;
                case XTTimeIntervalArchievementMonth:
                    _currentDate = _threeDateArray[2];
                    break;
                default:
                    break;
            }
        for (XTTimeIntervalArchievement* view in _threeIntervalView) {
            view.intervalType = intervalType;
        }
        
        
        
    }
    
    
    
    _intervalType = intervalType;

}

- (NSMutableArray *)threeDateArray{
    if (!_threeDateArray || _threeDateArray.count < 3) {
        NSDateComponents* componets = [NSDateComponents new];
        componets.day = -1;
        NSDate* dayDate = [self.calendar dateByAddingComponents:componets toDate:_todayDate options:0];
        NSDate* weekDate = [self.calendar dateByAddingComponents:componets toDate:_todayDate options:0];
        NSDate* monthDate = [self.calendar dateByAddingComponents:componets toDate:_todayDate options:0];
        _threeDateArray = [NSMutableArray arrayWithObjects:dayDate,weekDate,monthDate,nil];
    }
    return _threeDateArray;
}

- (void)setPerformace:(NSString *)performace{
    _performace = performace;
    if (_threeIntervalView.count < 2)return;
    XTTimeIntervalArchievement* view = _threeIntervalView[1];
    view.performance = performace;
}


- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    for (XTTimeIntervalArchievement* view in _threeIntervalView) {
        view.currentDate = currentDate;;
    }
    if (_threeIntervalView.count < 3)return;
    XTTimeIntervalArchievement* view1 = _threeIntervalView[0];
    XTTimeIntervalArchievement* view2 = _threeIntervalView[1];
    XTTimeIntervalArchievement* view3 = _threeIntervalView[2];
    [self threeDateArray];
    switch (_intervalType) {
        case XTTimeIntervalArchievementDay:
        {
            view1.currentDate = [self getPreviousDayWithDate:currentDate];
            view2.currentDate = currentDate;
            view3.currentDate = [self getNextDayWithDate:currentDate];
            [_threeDateArray replaceObjectForIndex:0 withObject:view2.currentDate];
        }
            break;
        case XTTimeIntervalArchievementWeek:
        {
            currentDate = [self getFirstDayOfWeek:currentDate];
            view1.currentDate = [self getPreviousWeekWithDate:currentDate];
            view2.currentDate = currentDate;
            view3.currentDate = [self getNextWeekWithDate:currentDate];
            [_threeDateArray replaceObjectForIndex:1 withObject:view2.currentDate];
        }
            break;
        case XTTimeIntervalArchievementMonth:
        {
            currentDate = [self getMonthBeginWith:currentDate];
            view1.currentDate = [self getPreviousMonthWithDate:currentDate];
            view2.currentDate = currentDate;
            view3.currentDate = [self getNextMonthWithDate:currentDate];
            [_threeDateArray replaceObjectForIndex:2 withObject:view2.currentDate];
        }
            break;
        default:
            break;
    }
    
    [self changeSwitchButtonStatus];
}

- (void)changeSwitchButtonStatus{
    int result = [self compareOneDay:_currentDate withPrepareDate:_minDate];
    if ((result == 0 || result == 1 )){
//        [self changePrviousDate];
        self.loadPrePage.hidden = NO;
    }else{
        self.loadPrePage.hidden = YES;
    }
    
 
    result = [self compareOneDay:_currentDate withAnotherDay:_todayDate];
    if (result == -1){
        self.loadNextPage.hidden = NO;
    }else{
        self.loadNextPage.hidden = YES;
    }
    
}

- (NSString *)timeInterValString{
    if (_threeIntervalView.count > 1) {
        XTTimeIntervalArchievement* view = _threeIntervalView[1];
        return view.timeIntervalString;
    }
    return @"";
}


- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (NSDate *)todayDate{
    if (_todayDate == nil) {
        _todayDate = [NSDate date];
    }
    return _todayDate;
}

- (NSData *)maxDate{
    if (_maxDate == nil) {
        _maxDate = [NSDate date];
    }
    return _maxDate;
}

@end
