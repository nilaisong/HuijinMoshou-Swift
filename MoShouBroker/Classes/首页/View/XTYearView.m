//
//  XTYearView.m
//  年历
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "XTYearView.h"
#import "XTMonthView.h"

@interface XTYearView()

@property (nonatomic,strong)NSDateFormatter* dateFormatter;

@property (nonatomic,strong)NSArray* monthViewArray;

@property (nonatomic,strong)NSDate* date;

@end

@implementation XTYearView

- (instancetype)initWithCalendar:(NSCalendar *)calendar touchCallBack:(YearViewDidTouchMonthViewCallBack)callBack{
    if (self = [super init]) {
        _calendar = calendar;
        _callBack = callBack;
    }
    return self;
}

+ (instancetype)yearViewWithCalendar:(NSCalendar *)calendar touchCallBack:(YearViewDidTouchMonthViewCallBack)callBack{
    return [[self alloc]initWithCalendar:calendar touchCallBack:callBack];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    if(_currentDate){
        [self calendar];
        self.backgroundColor = [UIColor whiteColor];
    }

}

- (void)layoutSubviews{
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = self.frame.size.width / 3.0;
    CGFloat itemH = 70;
    
    for (int i = 0; i < _monthViewArray.count; i++) {
        UIView* view = _monthViewArray[i];
        itemX = i % 3 * itemW;
        itemY = i / 3 * itemH;
        view.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }
    
}


- (NSDateFormatter *)createDateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.timeZone = self.calendar.timeZone;
    dateFormatter.locale = self.calendar.locale;
    
    return dateFormatter;
}

- (NSDate *)date{
    if (!_date) {
        _date = [self firstMonthOfYear:self.maxDate];
    }
    return _date;
}

- (NSArray *)monthViewArray{
    
    if (!_monthViewArray || _monthViewArray.count <= 0) {
        NSMutableArray* arrayM = [NSMutableArray array];
        
        for (int i = 0;i < 12; i++) {
            XTMonthView* monthView = [[XTMonthView alloc]init];
            [monthView addTarget:self action:@selector(monthDidTouch:) forControlEvents:UIControlEventTouchUpInside];
            monthView.tag = i;
            [arrayM appendObject:monthView];
            [self addSubview:monthView];

        }
        
        _monthViewArray = [NSArray arrayWithArray:arrayM];
    }
    
    for (int i = 0;i < 12; i++) {
        XTMonthView* monthView = _monthViewArray[i];
        monthView.date = [self addToDate:_currentDate months:i];
        if ([self date:monthView.date  isTheSameMonthThan:_selectedDate]) {
            monthView.selected = YES;
        }else monthView.selected = NO;
        NSString* title = [self monthTitleWithDate:[self addToDate:_currentDate months:i]];
        [monthView setTitle:title forState:UIControlStateNormal];
        
        if ([self date:monthView.date isThanMonth:self.maxDate] || [self date:monthView.date isUnderMonth:_minDate]) {
            monthView.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.86f alpha:1.00f];
            monthView.selected = NO;
            monthView.userInteractionEnabled = NO;
        }else {
         monthView.backgroundColor = [UIColor whiteColor];
                        monthView.userInteractionEnabled = YES;
        }
    }
    
    return _monthViewArray;
}

- (NSDate*)firstMonthOfYear:(NSDate*)date{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = 1;
    componentsNewDate.day = 1;
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months
{

    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

//根据时间，返回月份
- (NSString*)monthTitleWithDate:(NSDate*)date{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSInteger currentMonthIndex = comps.month;
    
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [self createDateFormatter];
    }
    
    dateFormatter.timeZone = _calendar.timeZone;
    dateFormatter.locale = _calendar.locale;
    
    while(currentMonthIndex <= 0){
        currentMonthIndex += 12;
    }
    
    return [[dateFormatter shortStandaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
}

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = [self firstMonthOfYear:currentDate];
    
    [self monthViewArray];
}

- (void)monthDidTouch:(XTMonthView*)month{
    if (_callBack) {
        _callBack(month);
    }
}

- (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB
{
        if (!dateA || !dateB)return nil;
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month;
}

- (BOOL)date:(NSDate *)dateA isThanMonth:(NSDate *)dateB
{
        if (!dateA || !dateB)return nil;
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    
    return componentsA.year > componentsB.year || (componentsA.year == componentsB.year && componentsA.month > componentsB.month);
}

- (BOOL)date:(NSDate *)dateA isUnderMonth:(NSDate *)dateB
{
    if (!dateA || !dateB)return nil;
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    
    return componentsA.year < componentsB.year || (componentsA.year == componentsB.year && componentsA.month < componentsB.month);
}

- (NSDate *)maxDate{
    if (!_maxDate) {
        _maxDate = [NSDate date];
    }
    return _maxDate;
}

@end
