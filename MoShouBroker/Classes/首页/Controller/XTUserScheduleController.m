//
//  XTUserScheduleController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/8.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTUserScheduleController.h"
#import "XTUserScheduleCell.h"
#import "XTUserScheduleInfoCell.h"
#import "JTCalendar.h"
#import "NSString+Extension.h"
#import "UITableViewRowAction+JZExtension.h"
#import "XTNoScheduleResultView.h"
#import "XTAddUserScheduleController.h"


@interface XTUserScheduleController()<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>
//水平日历
@property (nonatomic,weak)JTHorizontalCalendarView* horizontalCalendarView;
@property (nonatomic,weak)UIView* calendarLineView;
//顶部视图
@property (nonatomic,weak)UILabel* menuLabel;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (nonatomic,strong)NSDateFormatter* formatter;
//选中数据数组
@property (nonatomic,strong)NSMutableArray* datesSelectedArray;

@property (nonatomic,strong)NSDate* todayDate;
//内容容器视图
//@property (nonatomic,weak)UIScrollView* contentScrollView;
//日程
@property (nonatomic,weak)UITableView* scheduleTableView;

//添加日程按钮
@property (nonatomic,weak)UIButton* addScheduleBtn;
//返回今天
@property (nonatomic,weak)UIButton* todayBtn;

@end

@implementation XTUserScheduleController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self calendarManager];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    _todayDate = [NSDate date];
    self.navigationBar.titleLabel.text = @"我的日程";
    self.navigationBar.titleLabel.frame = CGRectMake(0, 24.5, self.view.frame.size.width, 17);
    
    [self todayBtn];
    [self addScheduleBtn];
    
    self.menuLabel.frame =  CGRectMake(0, 41.5, self.view.frame.size.width, 22.5);
    self.menuLabel.backgroundColor = [UIColor clearColor];
    self.horizontalCalendarView.frame = CGRectMake(0, 64, self.view.frame.size.width, 365);
    
}

#pragma mark - calendar delegate
-(void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView{
    NSLog(@"%@",[self.formatter stringFromDate:dayView.date]);
    dayView.dotView.hidden = !dayView.dotView.isHidden;
    
    
    // Load the previous or next page if touch a day from another month
#if 0   //这里是跳转到时间所对应月份的方法
    if(![_calendarManager.dateHelper date:_horizontalCalendarView.date isTheSameMonthThan:dayView.date]){
        if([_horizontalCalendarView.date compare:dayView.date] == NSOrderedAscending){
            [_horizontalCalendarView loadNextPageWithAnimation];
        }
        else{
            [_horizontalCalendarView loadPreviousPageWithAnimation];
        }
    }
#endif
}

-(UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar{
    
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    view.textLabel.textColor = [UIColor blackColor];
    
    return view;
}

// Used to limit the date for the calendar
/**
 *  设置展示时间范围
 */
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    NSDate* preDate = [_calendarManager.dateHelper addToDate:date months:-12];
    NSDate* nexDate = [_calendarManager.dateHelper addToDate:date months:12];
    
    return [_calendarManager.dateHelper date:date isEqualOrAfter:preDate andEqualOrBefore:nexDate];
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    dayView.circleView.hidden = YES;
    dayView.dotView.hidden = YES;
    dayView.dotView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]&&!_calendarManager.settings.weekModeEnabled){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date] || [self date:[NSDate date] sameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        
        //        dayView.circleView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        dayView.dotView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
        dayView.dotView.hidden = NO;
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.lunarLabel.textColor= [UIColor whiteColor];
    }else{
        dayView.circleView.hidden = YES;
        dayView.dotView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        dayView.textLabel.textColor =[UIColor colorWithRed:0.40f green:0.41f blue:0.42f alpha:1.00f];
        dayView.lunarLabel.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.36f alpha:1.00f];
    }
}

#pragma mark - getter

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"yyyy年MM月";
    }
    return _formatter;
}

-(JTHorizontalCalendarView *)horizontalCalendarView{
    if (!_horizontalCalendarView) {
        JTHorizontalCalendarView* horizontalView = [[JTHorizontalCalendarView alloc]init];
        //        horizontalView.frame = CGRectMake(0, 0,300, 300);
        [self.view addSubview:horizontalView];
        _horizontalCalendarView = horizontalView;
    }
    return _horizontalCalendarView;
}

-(JTCalendarManager *)calendarManager{
    if (!_calendarManager) {
        _calendarManager = [JTCalendarManager new];
        _calendarManager.delegate = self;
//        [_calendarManager setMenuView:self.menuView];
        
        [_calendarManager setContentView:self.horizontalCalendarView];
        
        [_calendarManager setDate:[NSDate date]];
        
//        NSLog(@"test:%@",[self.formatter stringFromDate:[_calendarManager date]]);
        [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
    }
    return _calendarManager;
}

//选中时间数组
-(NSMutableArray *)datesSelectedArray{
    if (!_datesSelectedArray) {
        _datesSelectedArray = [[NSMutableArray alloc]init];
    }
    return _datesSelectedArray;
}

- (UILabel *)menuLabel{
    if (!_menuLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setTextColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f]];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.navigationBar addSubview:label];
        _menuLabel = label;
    }
    return _menuLabel;
}


#pragma mark - Date selection

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelectedArray){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar{
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar{
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
}

- (BOOL)date:(NSDate* )dateA sameDayThan:(NSDate *)dateB{
    NSDateComponents *componentsA = [_calendarManager.dateHelper.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
    NSDateComponents *componentsB = [_calendarManager.dateHelper.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
    
    return componentsA.day == componentsB.day;
}

//改变模式
- (void)changeCalendarModel{

    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    //    _calendarView.manage.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 365;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    _horizontalCalendarView.frame = CGRectMake(0, 64, self.view.frame.size.width, newHeight);
    
    [self.view setNeedsLayout];

}

//改变模式
- (void)changeCalendarWeekEnable:(BOOL)enabel{
    
    _calendarManager.settings.weekModeEnabled = enabel;
    //    _calendarView.manage.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 365;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }

    _horizontalCalendarView.frame = CGRectMake(0, 64, self.view.frame.size.width, newHeight);

    [self.view setNeedsLayout];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.calendarLineView.frame = CGRectMake(0, CGRectGetMaxY(_horizontalCalendarView.frame), _horizontalCalendarView.frame.size.width, 12);
//    self.scheduleTableView.frame = CGRectMake(0, CGRectGetMaxY(_calendarLineView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_horizontalCalendarView.frame));
    self.scheduleTableView.frame = CGRectMake(0, _scheduleTableView.frame.origin.y, _scheduleTableView.frame.size.width, self.view.frame.size.height);
}

#pragma mark - getter
//日程记录
- (UITableView *)scheduleTableView{
    if (!_scheduleTableView) {
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendarLineView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_horizontalCalendarView.frame)) style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        _scheduleTableView = tableView;
        _scheduleTableView.delegate = self;
        _scheduleTableView.dataSource = self;
    }
    return _scheduleTableView;
}

-  (UIButton *)todayBtn{
    if (!_todayBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(goBackToday:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"today"] forState:UIControlStateNormal];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 39 - 35, 20, 22, 44);
        _todayBtn = btn;
    }
    return _todayBtn;
}


- (UIButton *)addScheduleBtn{
    if (!_addScheduleBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_tianjia_h"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addScheduleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:btn];
        btn.frame =CGRectMake([UIScreen mainScreen].bounds.size.width - 32, 20, 17, 44);
        _addScheduleBtn = btn;
    }
    return _addScheduleBtn;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        XTNoScheduleResultView* view = [[XTNoScheduleResultView alloc]initWithCallBack:^(UIButton *touchBtn) {
            NSLog(@"点击了添加时间按钮啦");
        }];
        view.frame = CGRectMake(0, 30, self.view.frame.size.width, 30);
        view.leftTitle = @"今天无事件提醒，";
        view.touchTitle = @"去添加吧";
        view.rightTitle = @"！";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:view];

    }else {
        cell = [XTUserScheduleInfoCell userScheduleInfoCellWithTableView:tableView eventCallBack:^(UIButton *btn, XTUserScheduleInfoCellEvent event) {
            switch (event) {
                case XTUserScheduleInfoCellAddFollow:
                    NSLog(@"添加跟进撒");
                    break;
                case XTUserScheduleInfoCellCallEvent:
                    NSLog(@"打电话撒");
                    break;
                default:
                    break;
            }
        }];
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self setEditing:false animated:true];
        NSLog(@"点击了删除");
    };
    
    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    
    return @[action3];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)UITableViewRowActionBtnClick{
    [_scheduleTableView reloadData];
}


float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.frame.origin.y <= 180 && scrollView.contentOffset.y  > - 2) {
        return;
    }
    _scheduleTableView.center = CGPointMake(_scheduleTableView.center.x, _scheduleTableView.center.y - scrollView.contentOffset.y);
    
    _scheduleTableView.contentOffset = CGPointZero;
    if (scrollView.contentOffset.y <= -40 && _calendarManager.settings.weekModeEnabled) {
        [self changeCalendarWeekEnable:NO];
    }else if(scrollView.contentOffset.y >= scrollView.frame.size.height + 50){
    
    }
//    [self.view setNeedsLayout];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (lastContentOffset < scrollView.contentOffset.y) {
        [self changeCalendarWeekEnable:YES];
    }else{
//        [self changeCalendarWeekEnable:NO];
    }
}

#pragma mark - 返回今日
- (void)goBackToday:(UIButton*)btn{
    [_calendarManager setDate:_todayDate];
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
}

#pragma mark - 添加日程
- (void)addScheduleBtnClick:(UIButton*)btn{
    XTAddUserScheduleController* addVC = [[XTAddUserScheduleController alloc]init];
    
    [self.navigationController pushViewController:addVC animated:YES];
}

- (UIView *)calendarLineView{
    if (!_calendarLineView) {
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        UIView* whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 10)];
        whiteView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        [lineView addSubview:whiteView];
        [self.view addSubview:lineView];
        _calendarLineView = lineView;
    }
    return _calendarLineView;
}


@end



