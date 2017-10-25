//
//  XTYearCalendarContentView.m
//  年历
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "XTYearCalendarContentView.h"
#import "XTYearView.h"


@interface XTYearCalendarContentView()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView* yearContentScrollView;

@property (nonatomic,weak)UIScrollView* contentScrollView;

@property (nonatomic,strong)NSArray* threeYearView;

@property (nonatomic,strong)NSDateFormatter* yearFormatter;

@property (nonatomic,weak)UILabel* yearTitleLabel;

@property (nonatomic,weak)UIButton* loadNextPage;

@property (nonatomic,weak)UIButton* loadPrePage;

@property (nonatomic,weak)UIView* backgroundView;

@end

@implementation XTYearCalendarContentView


- (instancetype)initWithEventCallBack:(YearCalendarContentViewEventCallBack)callBack{
    if (self = [super init]) {
        [self backgroundView];
        self.backgroundColor = [UIColor clearColor];
        _callBack = callBack;
        _currentDate = [NSDate date];
        
    }
    return self;
}

+ (instancetype)yearCalendarContentViewWith:(YearCalendarContentViewEventCallBack)callBack{
    return [[self alloc]initWithEventCallBack:callBack];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentDate = [NSDate date];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self loadNextPage];
    [self loadPrePage];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.yearTitleLabel.frame = CGRectMake(0, kMainScreenHeight, self.frame.size.width, 50);
    
    self.contentScrollView.frame = CGRectMake(0, CGRectGetMaxY(_yearTitleLabel.frame), self.frame.size.width, 280);
    
    _loadPrePage.frame = CGRectMake(0, _yearTitleLabel.frame.origin.y, _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.size.height);
    _loadNextPage.frame = CGRectMake(self.frame.size.width - _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.origin.y, _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.size.height);
    CGFloat yearX = 0;
    CGFloat yearY = 0;
    CGFloat yearW = _contentScrollView.frame.size.width;
    CGFloat yearH = _contentScrollView.frame.size.height;
    
    for (int i = 0; i < self.threeYearView.count; i++) {
        XTYearView* yearView = _threeYearView[i];
        
        yearView.frame = CGRectMake(yearX + _contentScrollView.frame.size.width * i, yearY, yearW, yearH);
    }
    self.contentScrollView.contentOffset = CGPointMake(_contentScrollView.frame.size.width, 0);
    
    [UIView animateWithDuration:0.27 animations:^{
        self.yearTitleLabel.frame = CGRectMake(0, kMainScreenHeight - 50 - 280, self.frame.size.width, 50);
        
        self.contentScrollView.frame = CGRectMake(0, CGRectGetMaxY(_yearTitleLabel.frame), self.frame.size.width, 280);
        
        _loadPrePage.frame = CGRectMake(0, _yearTitleLabel.frame.origin.y, _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.size.height);
        _loadNextPage.frame = CGRectMake(self.frame.size.width - _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.origin.y, _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.size.height);
        CGFloat yearX = 0;
        CGFloat yearY = 0;
        CGFloat yearW = _contentScrollView.frame.size.width;
        CGFloat yearH = _contentScrollView.frame.size.height;
        
        for (int i = 0; i < self.threeYearView.count; i++) {
            XTYearView* yearView = _threeYearView[i];
            
            yearView.frame = CGRectMake(yearX + _contentScrollView.frame.size.width * i, yearY, yearW, yearH);
        }
        self.contentScrollView.contentOffset = CGPointMake(_contentScrollView.frame.size.width, 0);
    }];
}

- (UIScrollView *)yearContentScrollView{
    if (!_yearContentScrollView) {
        UIScrollView* contentScrollView = [[UIScrollView alloc]init];
        contentScrollView.delegate = self;
        contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentScrollView];
        
        _yearContentScrollView = contentScrollView;
    }
    return _yearContentScrollView;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        UIScrollView* contentScrollView = [[UIScrollView alloc]init];
        contentScrollView.delegate = self;
        contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentScrollView];
        
        _contentScrollView = contentScrollView;
    }
    return _contentScrollView;
}

- (NSArray *)threeYearView{
    if (!_threeYearView || _threeYearView.count <= 0) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (int i = 0;  i< 3; i ++) {
            
            __weak typeof(self) weakSelf = self;
            XTYearView* yearView = [XTYearView yearViewWithCalendar:self.calendar touchCallBack:^(XTMonthView *monthView) {
                if (weakSelf.callBack) {
                    weakSelf.callBack(monthView);
                }
            }];
            yearView.maxDate = self.maxDate;
            yearView.minDate = _minDate;
            yearView.selectedDate = _currentDate;
            [self.contentScrollView addSubview:yearView];
            [arrayM appendObject:yearView];
        }
        _threeYearView = [NSArray arrayWithArray:arrayM];
    }
    for (int i = 0; i < _threeYearView.count; i++) {
        XTYearView* yearView = _threeYearView[i];
        if (i == 0)yearView.currentDate = _previousDate;
        else if(i == 1)yearView.currentDate = _currentDate;
        else if(i == 2)yearView.currentDate = _nextDate;
        
        yearView.selectedDate = _currentDate;
    }
    _contentScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    [self yearTitleLabel];
    
    //    [self setNeedsLayout];
    return _threeYearView;
}

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;

    XTYearView* yearView = _threeYearView[1];
    yearView.selectedDate = _currentDate;
    
    _previousDate = [self anyYearWithDate:_currentDate index:-1];
    _nextDate = [self anyYearWithDate:_currentDate index:1];
    
    [self threeYearView];
}

- (NSCalendar *)calendar{
    if(!_calendar){
//#ifdef __IPHONE_8_0
//        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//#else
        _calendar = [NSCalendar currentCalendar];
//#endif
        _calendar.timeZone = [NSTimeZone localTimeZone];
        _calendar.locale = [NSLocale currentLocale];
    }
    return _calendar;
}

- (NSDate*)anyYearWithIndex:(NSInteger)index{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:self.maxDate];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year + index;
//    componentsNewDate.month = 1;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate*)anyYearWithDate:(NSDate*)date index:(NSInteger)index{
    if (!date)return nil;
//    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
//    componentsNewDate.year = componentsCurrentDate.year + index;
    componentsNewDate.year = index;
//    componentsNewDate.month = 1;
    
    return [self.calendar dateByAddingComponents:componentsNewDate toDate:date options:0];
}

- (NSDateFormatter *)yearFormatter{
    if (!_yearFormatter) {
        _yearFormatter = [[NSDateFormatter alloc]init];
        _yearFormatter.dateFormat = @"yyyy年";
    }
    return _yearFormatter;
}

- (UILabel *)yearTitleLabel{
    if (!_yearTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        [self addSubview:label];
        _yearTitleLabel = label;
    }
    
    _yearTitleLabel.text = [self.yearFormatter stringFromDate:_currentDate];
    return _yearTitleLabel;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_contentScrollView.contentOffset.x < self.frame.size.width) {
        int resutl = [self compareOneDay:[self anyYearWithDate:_currentDate index:-1] withAnotherDay:_minDate];
        if (resutl == 1) {
            if (_contentScrollView.contentOffset.x < self.frame.size.width/2.0) {
                self.currentDate = [self anyYearWithDate:_currentDate index:-1];
            }
            
        }else
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
            }];

    }else if(_contentScrollView.contentOffset.x > self.frame.size.width){
        
        int resutl = [self compareOneDay:_currentDate withAnotherDay:self.maxDate];
        if (resutl == -1) {
            if (_contentScrollView.contentOffset.x > self.frame.size.width * 1.5) {
                self.currentDate = [self anyYearWithDate:_currentDate index:1];
            }

        }else
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
        }];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    int resutl = [self compareOneDay:[self anyYearWithDate:_currentDate index:-1] withAnotherDay:_minDate];
    if (point.x < kMainScreenWidth) {
        
        if (resutl != 1) {
            scrollView.contentOffset = CGPointMake(point.x + 0.7 * (kMainScreenWidth - point.x)/kMainScreenWidth, 0);
        }
        
        
        return;
    }
    if (resutl != -1){

//        scrollView.contentOffset = CGPointMake(point.x - 0.7 * (point.x - kMainScreenWidth)/kMainScreenWidth, 0);
        scrollView.contentSize = CGSizeMake(kMainScreenWidth * 2.0, 0);
    }else scrollView.contentSize = CGSizeMake(kMainScreenWidth* 3.0, 0);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}

- (UIButton *)loadNextPage{
    if (!_loadPrePage) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
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
        [btn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
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
        int resutl = [self compareOneDay:_currentDate withAnotherDay:self.maxDate];
        if (resutl != -1) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.contentScrollView.contentOffset = CGPointMake(self.frame.size.width* 2.0, 0);
        }];
        if (resutl == -1) {
            
            self.currentDate = [self anyYearWithDate:_currentDate index:1];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.contentScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
            }];
        }
        
    }else if(btn.tag == 0){
        int resutl = [self compareOneDay:[self anyYearWithDate:_currentDate index:-1] withAnotherDay:_minDate];
        if (resutl != 1) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.contentScrollView.contentOffset = CGPointMake(self.frame.size.width* 1/3.0, 0);
        }];
        if (resutl == 1) {
            
            self.currentDate = [self anyYearWithDate:_currentDate index:-1];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.contentScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
            }];
        }
    }
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        UIView * backView = [[UIView alloc]init];
        backView.frame = [UIScreen mainScreen].bounds;

        backView.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.30f];
        [self addSubview:backView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTap:)];
        [backView addGestureRecognizer:tap];
        
        _backgroundView = backView;
    }
    return _backgroundView;
}

- (NSDate *)maxDate{
    if (!_maxDate) {
        _maxDate = [NSDate date];
    }
    return _maxDate;
}

- (void)backgroundViewTap:(UIGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self];
    if ( point.y >= self.frame.size.height - 50 - 280)return;
//    point.y >= (self.frame.size.height - 310)/2.0 &&
    [UIView animateWithDuration:0.27 animations:^{
        self.yearTitleLabel.frame = CGRectMake(0, kMainScreenHeight, self.frame.size.width, 50);
        
        self.contentScrollView.frame = CGRectMake(0, CGRectGetMaxY(_yearTitleLabel.frame), self.frame.size.width, 280);
        
        _loadPrePage.frame = CGRectMake(0, _yearTitleLabel.frame.origin.y, _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.size.height);
        _loadNextPage.frame = CGRectMake(self.frame.size.width - _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.origin.y, _yearTitleLabel.frame.size.height, _yearTitleLabel.frame.size.height);
        CGFloat yearX = 0;
        CGFloat yearY = 0;
        CGFloat yearW = _contentScrollView.frame.size.width;
        CGFloat yearH = _contentScrollView.frame.size.height;
        
        for (int i = 0; i < self.threeYearView.count; i++) {
            XTYearView* yearView = _threeYearView[i];
            
            yearView.frame = CGRectMake(yearX + _contentScrollView.frame.size.width * i, yearY, yearW, yearH);
        }
        self.contentScrollView.contentOffset = CGPointMake(_contentScrollView.frame.size.width, 0);

    } completion:^(BOOL finished) {
        if (_callBack) {
            _callBack(nil);
        }
        [self removeFromSuperview];
    }];

}


-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    oneDay = [self anyYearWithDate:[self firstMonthOfYear:oneDay] index:1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
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

- (NSDate*)firstMonthOfYear:(NSDate*)date{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = 1;
    componentsNewDate.day = 1;
    return [self.calendar dateFromComponents:componentsNewDate];
}

@end
