//
//  XTWorkReportingController.m
//  ;
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTWorkReportingController.h"
#import "XTCalendarView.h"

#import "XTYearCalendarContentView.h"
#import "XTTimeIntervalArchievementContentView.h"

#import "XTReportNumberBaseView.h"
#import "XTReportNumberCommonView.h"

//一般数据容器视图
#import "XTReportNumberCommonContentView.h"

#import "RecommendRecordController.h"
#import "ShareActionSheet.h"
#import "WorkReportModel.h"

#import "DataFactory+User.h"
#import "DataFactory+Main.h"

#import "XTHelpView.h"

#import "UserData.h"

#define kRunInstruction  [NSString stringWithFormat:@"%@_%@",@"runInstruction",kAppVersion]

#define kPathOfMainBundle(x) [[NSBundle mainBundle] pathForResource:x ofType:@""]

#define MinTimeString @"2015-06-01 00:00:00"

@interface XTWorkReportingController ()


@property (nonatomic,weak)UISegmentedControl* segmentedControl;

@property (nonatomic,weak)UIButton* shareBtn;
@property (nonatomic,weak)UIButton* calendarBtn;
//日展示日历
@property (nonatomic,weak)XTCalendarView* dayCalendarView;
//年历
@property (nonatomic,weak)XTYearCalendarContentView* yearCalendarView;
//时间与业绩视图
@property (nonatomic,weak)XTTimeIntervalArchievementContentView* intervalArchievementView;

//查看记录
@property (nonatomic,weak)UIButton* viewRecord;

//报备数
@property (nonatomic,weak)XTReportNumberBaseView* recommendRecordNumberView;

//带看数
@property (nonatomic,weak)XTReportNumberBaseView* viewNumberView;

//一般数据容器视图
@property (nonatomic,weak)XTReportNumberCommonContentView* commomContentView;

//容器scrollview
@property (nonatomic,weak)UIScrollView* reportContentScrollView;

@property (nonatomic,weak)ShareActionSheet* shareAS;

//输入时间字符串格式
@property (nonatomic,strong)NSDateFormatter* inputFormatter;

//请求时间字符格式
@property (nonatomic,strong)NSDateFormatter* requestFormatter;

@property (nonatomic,strong)NSCalendar* calendar;

@property (nonatomic,strong)WorkReportModel* reportModel;

@property (nonatomic,assign)XTTimeIntervalArchievementType intervalType;

@property (nonatomic,strong)NSDate* minDate;

@property (nonatomic,strong)NSDate* todayDate;

@property (nonatomic,assign)BOOL isRefresh;

@property (nonatomic,assign)BOOL isClick;

@end

@implementation XTWorkReportingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [se lf commonInit];
    [self hasNetwork];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)commonInit{
    self.isRefresh = NO;
    self.isClick = NO;
    self.navigationBar.hidden = NO;
    self.navigationBar.titleLabel.text = @"工作报表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    [_intervalArchievementView removeFromSuperview];
    _intervalArchievementView = nil;
    self.intervalArchievementView.intervalType = XTTimeIntervalArchievementDay;
    _intervalType = XTTimeIntervalArchievementDay;
    
    NSDateComponents* component = [NSDateComponents new];
    component.day = -1;
    
//    self.intervalArchievementView.currentDate = [self.calendar dateByAddingComponents:component toDate:[NSDate date] options:0];
    
    [self viewRecord];
    CGFloat scale = kMainScreenWidth / 375.0f;
    CGFloat width = 147 * scale;
    
    self.recommendRecordNumberView.frame = CGRectMake((self.view.frame.size.width - width - width)/3, CGRectGetMaxY(_viewRecord.frame) + 30 * scale,width, width);
    self.viewNumberView.frame = CGRectMake(((self.view.frame.size.width - width - width)/3)/2 + self.view.frame.size.width / 2,  CGRectGetMaxY(_viewRecord.frame) + 30, width, width);
    self.segmentedControl.frame = CGRectMake(37, 14, (kMainScreenWidth-74), 29);
    self.commomContentView.frame = CGRectMake(0, CGRectGetMaxY(_viewNumberView.frame) + 20, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.width / 3 * 1.6);
    
    [self calendarBtn];
    [self shareBtn];
    
    self.reportContentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_commomContentView.frame));
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        self.popGestureRecognizerEnable = YES;
        _shareBtn.hidden = NO;
        _calendarBtn.hidden =  NO;
    }else{
        _shareBtn.hidden = YES;
        _calendarBtn.hidden = YES;
    }
    
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView * loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]getWorkReportWithType:0 startDate:nil endDate:nil withCallBack:^(WorkReportModel *result) {
            [self removeRotationAnimationView:loadingView];
            if (!result) {
                [self showTips:@"获取失败"];
                return ;
            }
            NSDateComponents* componets = [NSDateComponents new];
            componets.day = 0;
            NSDate* dayDate = [self.calendar dateByAddingComponents:componets toDate:[_inputFormatter dateFromString:result.dateStart] options:0];
            NSDate* weekDate = [self.calendar dateByAddingComponents:componets toDate:[_inputFormatter dateFromString:result.dateStart] options:0];
            componets.day = 1;
            NSDate* monthDate = [self.calendar dateByAddingComponents:componets toDate:[_inputFormatter dateFromString:result.dateStart] options:0];
            
            _intervalArchievementView.todayDate = [_inputFormatter dateFromString:result.dateStart];
            _intervalArchievementView.threeDateArray = [NSMutableArray arrayWithObjects:dayDate,weekDate,monthDate,nil];
            componets.day = 1;
            _todayDate = [self.calendar dateByAddingComponents:componets toDate:[_inputFormatter dateFromString:result.dateStart] options:0];
            _intervalArchievementView.todayDate = _todayDate;
            _intervalArchievementView.maxDate = _todayDate;
            componets = [[NSDateComponents alloc]init];
             componets.day = -1;
            
            _intervalArchievementView.currentDate = [self.calendar dateByAddingComponents:componets toDate:_todayDate options:0];
            [self requestPerformanceWithType:XTTimeIntervalArchievementDay date:_intervalArchievementView.currentDate];
        }];
    }
    
    [self addHelpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        NSArray *titleArr =@[@"日报",@"周报",@"月报"];
        
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:titleArr];
        //    segment.segmentedControlStyle= UISegmentedControlStyleBordered;
        [segment setFrame:CGRectMake(37, 14, (kMainScreenWidth-74), 29)];
        segment.layer.borderWidth = 1;
        segment.layer.borderColor = [BLUEBTBCOLOR CGColor];
        segment.layer.cornerRadius = 4;
        segment.layer.masksToBounds = YES;
        segment.tintColor = BLUEBTBCOLOR;
        UIFont *font = [UIFont boldSystemFontOfSize:13.0f];

        NSDictionary *attributes = @{NSFontAttributeName:font};
        NSDictionary *attributes2 = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
        [segment setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
        [segment setTitleTextAttributes:attributes2 forState:UIControlStateSelected];
        [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        
        [self.reportContentScrollView addSubview:segment];
        _segmentedControl = segment;
    }
    return _segmentedControl;
}
-(void)segmentChange:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            _intervalArchievementView.intervalType = XTTimeIntervalArchievementDay;
            _intervalType = XTTimeIntervalArchievementDay;
            break;
        case 1:
            _intervalArchievementView.intervalType = XTTimeIntervalArchievementWeek;
            _intervalType = XTTimeIntervalArchievementWeek;
            break;
        case 2:
            _intervalArchievementView.intervalType = XTTimeIntervalArchievementMonth;
            _intervalType = XTTimeIntervalArchievementMonth;
            break;
        default:
            break;
    }
    [self requestPerformanceWithType:_intervalArchievementView.intervalType date:_intervalArchievementView.currentDate];
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 36, 20, 21, 44);
        [btn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2-down"] forState:UIControlStateHighlighted];
        [self.navigationBar addSubview:btn];
        [btn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn = btn;
        [btn setExclusiveTouch:YES];
    }
    return _shareBtn;
}

- (void)shareBtnClick{

    [_shareBtn setUserInteractionEnabled:NO];

    [self.view bringSubviewToFront:self.navigationBar];
//    UIImageView* imageView = [[UIImageView alloc]initWithImage:[self screenView:self.navigationController.view withRect:CGRectMake(0, _intervalArchievementView.frame.origin.y + 20, kMainScreenWidth, kMainScreenHeight - CGRectGetMaxY(_segmentedControl.frame) - 64)]];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    UIImage* image = [self captureScrollView:_reportContentScrollView];
    //[self screenView:self.reportContentScrollView withRect:CGRectMake(0,_intervalArchievementView.frame.origin.y, kMainScreenWidth, _reportContentScrollView.contentSize.height)];
    if (image) {
//        [self saveImageToPhotos:image];
    }
    NSString *documents = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/Snapshot"];
    
    NSLog(@"%@",documents);
    if(![fileManager fileExistsAtPath:documents]){
    
        [fileManager createDirectoryAtPath:documents withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970]*1000;
    NSString *fileName = [NSString stringWithFormat:@"%f.png",a];

//    NSString* fileName = [NSString stringWithFormat:@"%@workreport.jpg",[self.inputFormatter stringFromDate:[NSDate date]]];
    //拼接文件绝对路径
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    NSData * data = UIImagePNGRepresentation(image);
    //保存
//    [data writeToFile:path atomically:YES ];
    NSError* error = [[NSError alloc]init];
    [data writeToFile:path options:NSDataWritingAtomic error:&error];
    
        if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
            UIImageView *ima =[self setRotationAnimationWithView];

            if (_shareAS) {
                [_shareAS removeFromSuperview];
            }
//            UIImageView* progressView = [self setRotationAnimationWithView];
            [[DataFactory sharedDataFactory] getShareAppModelWithCallback:^(ShareModel *model) {
                [self removeRotationAnimationView:ima];
                [_shareBtn setUserInteractionEnabled:YES];
                
//                [self removeRotationAnimationView:progressView];
                model.title = [self shareTitle];
                model.img = nil;
                model.content =  [NSString stringWithFormat:@"%@查看详情点击链接%@",[self shareContent],model.linkUrl];
                model.imgPath = path;
                ShareActionSheet* shareV = [[ShareActionSheet alloc]initWithWorkReportShareType:WORKREPORT andModel:model andParent:self.view];
                _shareAS = shareV;

                _shareBtn.userInteractionEnabled = YES;

            }];

        }else{
            
            [_shareBtn setUserInteractionEnabled:YES];
        }

    

}

- (UIButton *)calendarBtn{
    if (!_calendarBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 42 - 35, 20, 21, 44);
        [btn setImage:[UIImage imageNamed:@"iconfont-calendar"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"iconfont-calendar-down"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:btn];
        _calendarBtn = btn;
    }
    return _calendarBtn;
}


- (void)calendarBtnClick:(UIButton*)btn{
//    点击了日历按钮，关闭侧滑返回，在日历返回事件为空时，开启
    
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            [self dayCalendarView];
            break;
        case 1:
            [self dayCalendarView];
            break;
        case 2:
            [self yearCalendarView];
            break;
        default:
            [self yearCalendarView];
            break;
    }
//    [self dayCalendarView];
//    [self yearCalendarView];
}

- (XTCalendarView *)dayCalendarView{
    if (!_dayCalendarView) {
        __weak typeof(self) weakSelf = self;
        XTCalendarView* calendarView = [[XTCalendarView alloc]initWithEventCallBack:^(NSDate *date) {
            if (!date) {
//                weakSelf.popGestureRecognizerEnable = YES;
                return ;
            }
            [weakSelf.dayCalendarView removeFromSuperview];
            [weakSelf requestPerformanceWithType:_intervalType date:date];
//            [self getMonthBeginAndEndWith:date];
        }];
        calendarView.selectedDate = _intervalArchievementView.currentDate;
        calendarView.frame = self.view.bounds;
        calendarView.todayDate = self.todayDate;
//        NSDateComponents* componets = [NSDateComponents new];
//        componets.day = -1;
        calendarView.maxDate = _todayDate;
        calendarView.minDate = self.minDate;
        [self.view.window addSubview:calendarView];
        
        _dayCalendarView = calendarView;
    }
    _dayCalendarView.selectedDate = _intervalArchievementView.currentDate;
    return _dayCalendarView;
}

- (XTYearCalendarContentView *)yearCalendarView{
    if (!_yearCalendarView) {
        __weak typeof(self) weakSelf = self;
        XTYearCalendarContentView* yearCalendarView = [[XTYearCalendarContentView alloc]initWithEventCallBack:^(XTMonthView *monthView) {
//            当返回的值为空时，说明点击了蒙版视图，开启侧滑返回
            if (monthView == nil) {
                return;
            }
            [weakSelf.yearCalendarView removeFromSuperview];
        
            [weakSelf requestPerformanceWithType:XTTimeIntervalArchievementMonth date:monthView.date];
        }];
        yearCalendarView.maxDate = _todayDate;
        yearCalendarView.frame = self.view.bounds;
        yearCalendarView.minDate = self.minDate;        
        yearCalendarView.currentDate = _intervalArchievementView.currentDate;
        [self.view.window addSubview:yearCalendarView];
        _yearCalendarView = yearCalendarView;
        
    }
    return _yearCalendarView;
}


- (XTTimeIntervalArchievementContentView *)intervalArchievementView{
    if (!_intervalArchievementView) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        __weak typeof(self) weakSelf = self;
        XTTimeIntervalArchievementContentView* contentView = [[XTTimeIntervalArchievementContentView alloc]initWithEventCallBack:^(XTTimeIntervalArchievement *currentArchievement, NSDate *date,XTTimeIntervalArchievementType intervalType) {
            [weakSelf requestPerformanceWithType:intervalType date:date];
        }];
        contentView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        contentView.tipsCallBack = ^(XTTimeIntervalArchievementContentView* contentView,NSString* tips){
            [weakSelf showTips:tips];
        };
        contentView.todayDate = [NSDate date];
        contentView.maxDate = [NSDate date];
        contentView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame) + 14, self.view.frame.size.width, 70);
        contentView.requestFormatter = self.requestFormatter;
        NSDateComponents* componets = [NSDateComponents new];
        componets.day = -1;
//        [weakSelf requestPerformanceWithType:XTTimeIntervalArchievementDay date:[self.calendar dateByAddingComponents:componets toDate:[NSDate date] options:0]];
        [self.reportContentScrollView addSubview:contentView];
        _intervalArchievementView = contentView;
        _intervalArchievementView.minDate = self.minDate;
    }
    return _intervalArchievementView;
}

//查看记录按钮
- (UIButton *)viewRecord{
    if (!_viewRecord) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看记录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 2;
        [button.layer setMasksToBounds:YES];
        button.layer.borderColor = [UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.intervalArchievementView.frame) + 14, 90, 22);
        button.center = CGPointMake(self.view.frame.size.width / 2.0, button.center.y);
        [button addTarget:self action:@selector(viewRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.reportContentScrollView addSubview:button];
        _viewRecord = button;
    }
    return _viewRecord;
}

- (void)viewRecordBtnClick:(UIButton*)btn{
    RecommendRecordController* recordVC = [[RecommendRecordController alloc]init];
    [self.navigationController pushViewController:recordVC animated:YES];
}


- (XTReportNumberBaseView *)recommendRecordNumberView{
    if (!_recommendRecordNumberView) {
        XTReportNumberBaseView* reportView = [[XTReportNumberBaseView alloc]init];
        reportView.reportTitle = @"报备数";
        reportView.reportNumber = 0;
        reportView.direction = XTTrendDirectionDown;
        [self.reportContentScrollView addSubview:reportView];
        _recommendRecordNumberView = reportView;
    }
    return _recommendRecordNumberView;
}

- (XTReportNumberBaseView *)viewNumberView{
    if (!_viewNumberView) {
        XTReportNumberBaseView* viewNumberView = [[XTReportNumberBaseView alloc]init];
        viewNumberView.reportTitle = @"带看数";
        viewNumberView.reportNumber = 0;
        viewNumberView.direction = XTTrendDirectionUp;
        [self.reportContentScrollView addSubview:viewNumberView];
        _viewNumberView = viewNumberView;
    }
    return _viewNumberView;
}

- (XTReportNumberCommonContentView *)commomContentView{
    if (!_commomContentView) {
        XTReportNumberCommonContentView* commonView = [[XTReportNumberCommonContentView alloc]init];
        [self.reportContentScrollView addSubview:commonView];
        
        _commomContentView = commonView;
    }
    return _commomContentView;
}

- (UIScrollView *)reportContentScrollView{
    if (!_reportContentScrollView) {
        UIScrollView* scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:scrollView];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
        _reportContentScrollView = scrollView;
    }
    return _reportContentScrollView;
}

- (NSDateFormatter *)inputFormatter{
    if (!_inputFormatter) {
        _inputFormatter = [[NSDateFormatter alloc]init];
        _inputFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    return _inputFormatter;
}

- (NSDateFormatter *)requestFormatter{
    if (!_requestFormatter) {
        _requestFormatter = [[NSDateFormatter alloc]init];
        _requestFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _requestFormatter;
}

- (void)requestPerformanceWithType:(XTTimeIntervalArchievementType)type date:(NSDate*)date{
    __weak typeof(self) weakSelf = self;
    _intervalArchievementView.currentDate = date;
    UIImageView * loadingView = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
      loadingView =  [self setRotationAnimationWithView];
    }else return;
    switch (type) {
        case XTTimeIntervalArchievementDay:
        {
            [[DataFactory sharedDataFactory] getWorkReportWithType:0 startDate:[_requestFormatter stringFromDate:date] endDate:nil withCallBack:^(WorkReportModel *result) {
                [weakSelf removeRotationAnimationView:loadingView];
                if (!result) {
                    return ;
                }
                 weakSelf.reportModel = result;
            }];
        }
            break;
        case XTTimeIntervalArchievementWeek:
        {
            NSCalendar *calendar = self.calendar;
            [calendar setFirstWeekday:1];
            NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
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
            NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            [firstDayComp setDay:day + firstDiff];
            NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
            
            NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            [lastDayComp setDay:day + lastDiff];
            NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
            [[DataFactory sharedDataFactory]getWorkReportWithType:1 startDate:[_requestFormatter stringFromDate:firstDayOfWeek] endDate:[_requestFormatter stringFromDate:lastDayOfWeek] withCallBack:^(WorkReportModel *result) {
                [weakSelf removeRotationAnimationView:loadingView];
                if (!result) {
                    return ;
                }
                weakSelf.reportModel = result;
            }];
        }
            break;
        case XTTimeIntervalArchievementMonth:
        {
            NSCalendar *calendar = self.calendar;
            NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
            comp.day = 1;
            
            [[DataFactory sharedDataFactory]getWorkReportWithType:2 startDate:[_requestFormatter stringFromDate:[calendar dateFromComponents:comp]] endDate:nil withCallBack:^(WorkReportModel *result) {
                [weakSelf removeRotationAnimationView:loadingView];
                if (!result) {
                    return ;
                }
                weakSelf.reportModel = result;
            }];
            
            
        }
            break;
        default:
            break;
    }
    weakSelf.isRefresh = YES;
}

#pragma mark - getter
- (NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDate *)todayDate{
    if (!_todayDate) {
        _todayDate = [NSDate date];
    }
    return _todayDate;
}

- (NSDate *)minDate{
    if (!_minDate) {
        _minDate = [self.inputFormatter dateFromString:MinTimeString];
    }
    return _minDate;
}


#pragma mark - setter
- (void)setReportModel:(WorkReportModel *)reportModel{
    _reportModel = reportModel;
    
    _intervalArchievementView.performace = reportModel.performance;
    
    _viewNumberView.reportNumber = reportModel.guidNum;
    _viewNumberView.direction = reportModel.lookChange;
    
    _recommendRecordNumberView.reportNumber = reportModel.recomNum;
    _recommendRecordNumberView.direction = reportModel.recmChange;
    
    _commomContentView.reportModel = reportModel;
}

- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)screenView:(UIView *)view withRect:(CGRect)clipRect{
    CGRect sizeRect = _reportContentScrollView.bounds;
    UIGraphicsBeginImageContext(sizeRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, clipRect);
    [view.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(CGSizeMake(kMainScreenWidth, scrollView.contentSize.height));
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, kMainScreenWidth, scrollView.contentSize.height);
        scrollView.clipsToBounds = NO;
        scrollView.layer.masksToBounds = NO;
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (NSString*)shareTitle{
    NSString* userName = [UserData sharedUserData].userName;
    switch (_intervalType) {
        case XTTimeIntervalArchievementDay:
            return [NSString stringWithFormat:@"%@的工作日报",userName];
            break;
        case XTTimeIntervalArchievementWeek:
            return [NSString stringWithFormat:@"%@的工作周报",userName];
            break;
        case XTTimeIntervalArchievementMonth:
            return [NSString stringWithFormat:@"%@的工作月报",userName];
            break;
        default:
            return [NSString stringWithFormat:@"%@的工作报表",userName];
            break;
    }
}

- (NSString*)shareContent{
    NSString* storeName = [UserData sharedUserData].storeName;
    NSString* userName = [UserData sharedUserData].userName;
    switch (_intervalType) {
        case XTTimeIntervalArchievementDay:
            return [NSString stringWithFormat:@"工作日报 %@  by %@  经纪人%@（分享自汇金魔售）",_intervalArchievementView.timeInterValString,storeName,userName];
            break;
        case XTTimeIntervalArchievementWeek:
            return [NSString stringWithFormat:@"工作周报 %@  by %@  经纪人%@（分享自汇金魔售）",_intervalArchievementView.timeInterValString,storeName,userName];
            break;
        case XTTimeIntervalArchievementMonth:
            return [NSString stringWithFormat:@"工作月报 %@  by %@  经纪人%@（分享自汇金魔售）",_intervalArchievementView.timeInterValString,storeName,userName];
            break;
        default:
            return [NSString stringWithFormat:@"工作报表 %@  by %@  经纪人%@（分享自汇金魔售）",_intervalArchievementView.timeInterValString,storeName,userName];
            break;
    }
}

- (void)hasNetwork{
   
    __weak typeof(self) weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//        self.popGestureRecognizerEnable = YES;
        [self commonInit];
    }else{
//        self.popGestureRecognizerEnable = NO;   
        [self createNoNetWorkViewWithReloadBlock:^{
            [weakSelf commonInit];
        }];
    }
}

-(void)addHelpView
{
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstWorkReport"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstWorkReport"];
        CGFloat scale = kMainScreenWidth/375.0;
        NSString* prefixStr = @"iPhone";
        if(iPhone4 ||  CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)))
        {
            prefixStr = @"iPhone4";
            XTHelpView* helpView0 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help4",prefixStr] buttonY:330];
            helpView0.frame = self.view.bounds;
            [self.view addSubview:helpView0];
            XTHelpView* helpView1 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help3",prefixStr] buttonY:305];
            helpView1.frame = self.view.bounds;
            [self.view addSubview:helpView1];
            XTHelpView* helpView2 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help2",prefixStr] buttonY:305];
            helpView2.frame = self.view.bounds;
            [self.view addSubview:helpView2];
            XTHelpView* helpView3 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help1",prefixStr] buttonY:305];
            helpView3.frame = self.view.bounds;
            [self.view addSubview:helpView3];
        }else
        {
            XTHelpView* helpView0 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help4",prefixStr] buttonY:487 * scale];
            helpView0.frame = self.view.bounds;
            [self.view addSubview:helpView0];
            XTHelpView* helpView1 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help3",prefixStr] buttonY:353 * scale];
            helpView1.frame = self.view.bounds;
            [self.view addSubview:helpView1];
            XTHelpView* helpView2 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help2",prefixStr] buttonY:343 * scale];
            helpView2.frame = self.view.bounds;
            [self.view addSubview:helpView2];
            XTHelpView* helpView3 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help1",prefixStr] buttonY:353 * scale];
            helpView3.frame = self.view.bounds;
            [self.view addSubview:helpView3];
        }
    }
    
    
}



@end
