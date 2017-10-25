//
//  RemindListViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "RemindListViewController.h"
#import "CustAddRemindViewController.h"
#import "CustomerDetailViewController.h"
#import "RecommendRecordDetailController.h"
//#import "XTUserScheduleViewController.h"
#import "AppDelegate.h"
#import "UITableViewRowAction+JZExtension.h"
#import "HMTool.h"
#import "UILabel+StringFrame.h"
#import "MessageData.h"

#import "DataFactory+Customer.h"
#import "DataFactory+Main.h"

@interface RemindListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *msgTableView;
@property (nonatomic, strong) NSMutableArray *remindArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIView         *emptyPageView;

@end

@implementation RemindListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"提醒";
    UIButton *rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-49, 20, 44, 44)];
    [rightBarItem setImage:[UIImage imageNamed:@"icon_big_tianjia"] forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(toggleRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:rightBarItem];
    
    _remindArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc] init];
    
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

- (void)leftBarButtonItemClick
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CustomerDetailViewController class]] || [temp isKindOfClass:[RecommendRecordDetailController class]]) {
            // || [temp isKindOfClass:[XTUserScheduleViewController class]]
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

- (void)hasNetwork
{
    __weak RemindListViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.msgTableView.superview) {
        self.msgTableView.frame =CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY) ;
    }
}

- (void)reloadView
{
    _msgTableView = [[UITableView alloc]init];
    [_msgTableView setFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY)];
    [_msgTableView setDelegate:self];
    [_msgTableView setDataSource:self];
    _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_msgTableView];
    
    [self createEmptyPageView];
    _emptyPageView.hidden = YES;
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRemindListData:) name:@"RefreshRemindList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBarButtonItemClick) name:@"RemindLeftBarButtonItemClick" object:nil];
}

-(void)reloadData
{
    UIImageView* loadingView = [self setRotationAnimationWithView];
//    __weak RemindListViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getRemindListWithCustId:_custList.customerId withCallBack:^(ActionResult *result,NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (!result.success) {
                [self showTips:result.message];
            }
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            if (self.titleArray != nil) {
                [self.titleArray removeAllObjects];
            }
            if (self.remindArray != nil) {
                [self.remindArray removeAllObjects];
            }
            for (int i = 0; i< array.count; i++) {
                MessageData *msg = (MessageData*)[array objectForIndex:i];
                NSString *dateTime = msg.datetime;
                NSDate *date = getNSDateWithDateTimeString([dateTime stringByAppendingString:@":00"]);
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm"];
                msg.datetime = [dateFormatter stringFromDate:date];
                
                NSString *dateStr = [RemindListViewController weekdayStringFromDate:date];
                NSString *dateString = [self stringFromDate:date];
                NSString *dateTitle = [NSString stringWithFormat:@"%@ %@",dateString,dateStr];
                msg.title = dateTitle;
                if (![_titleArray containsObject:dateTitle]) {
                    [_titleArray appendObject:dateTitle];
                }
                [tempArray appendObject:msg];
            }
            [self sortDate:tempArray];
            
            if (tempArray.count > 0) {
                _emptyPageView.hidden = YES;
            }else{
                _emptyPageView.hidden = NO;
            }
            [self.msgTableView reloadData];
            
        });
    }];
}

- (void)refreshData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailHeader" object:nil];
    AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDeleage performSelectorOnMainThread:@selector(registerAllLocalNotifications) withObject:nil waitUntilDone:YES];
}

- (void)reloadRemindListData:(NSNotification*)notif
{
    [self reloadData];
    [self refreshData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshRemindList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemindLeftBarButtonItemClick" object:nil];
}

- (void)sortDate:(NSMutableArray*)array
{
    for (int i=0; i<_titleArray.count; i++) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int j=0; j<array.count; j++) {
            MessageData *msg = (MessageData*)[array objectForIndex:j];
            NSString *str = [_titleArray objectForIndex:i];
            if ([str isEqualToString:msg.title]) {
                [tempArray appendObject:msg];
            }
        }
        [_remindArray appendObject:tempArray];
    }
}

- (void)toggleRightBarItem
{
    CustAddRemindViewController *addRemindVC = [[CustAddRemindViewController alloc] init];
    addRemindVC.custList = _custList;
    [self.navigationController pushViewController:addRemindVC animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (_remindArray.count > section) {
        count = ((NSArray*)[_remindArray objectForIndex:section]).count;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSArray *array = [NSArray array];
    if (_remindArray.count > indexPath.section) {
        array = [_remindArray objectForIndex:indexPath.section];
    }
    MessageData *data = nil;
    if (array.count > indexPath.row) {
        data = (MessageData*)[array objectForIndex:indexPath.row];
    }
    CGFloat currentY = 10;
    if (indexPath.row == 0) {
        CGSize titleSize =[HMTool getTextSizeWithText:[_titleArray objectForIndex:indexPath.section] andFontSize:14];
        currentY = 10+titleSize.height+5;
    }
    CGSize timeSize =[HMTool getTextSizeWithText:data.datetime andFontSize:12];
    CGSize contentSize =[self textSize:data.content withConstraintWidth:kMainScreenWidth-32];
    height = currentY+timeSize.height+5+contentSize.height+10;
    return height;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak RemindListViewController *weakSelf = self;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"loupan删除"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        NSArray *array = [NSArray array];
        if (self.remindArray.count > indexPath.section) {
            array = [self.remindArray objectForIndex:indexPath.section];
        }
        MessageData *data = nil;
        if (array.count > indexPath.row) {
            data = (MessageData*)[array objectForIndex:indexPath.row];
        }
        [[DataFactory sharedDataFactory] deleteScheduleWithRemindId:[data.msgId integerValue] callBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
            
                if (result.success) {
                    [self showTips:result.message];
                    [self reloadData];
                    [self refreshData];
                }else
                {
                    [self showTips:result.message];
                }
            });
        }];
    }];
    
    return @[action1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell==nil) {
       UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
 //    for (UIView *view in cell.subviews) {
//        [view removeFromSuperview];
//    }
    NSArray *array = [NSArray array];
    if (_remindArray.count > indexPath.section) {
        array = [_remindArray objectForIndex:indexPath.section];
    }
    MessageData *data = nil;
    if (array.count > indexPath.row) {
        data = (MessageData*)[array objectForIndex:indexPath.row];
    }
    CGFloat currentY = 10;
    if (indexPath.row == 0) {
        CGSize titleSize =[HMTool getTextSizeWithText:[_titleArray objectForIndex:indexPath.section] andFontSize:14];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, titleSize.width, titleSize.height)];
        [titleLabel setText:[_titleArray objectForIndex:indexPath.section]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:TFPLEASEHOLDERCOLOR];
        if (indexPath.section == 0) {
            if ([[_titleArray objectForIndex:indexPath.section] hasPrefix:@"今天"]) {
                [titleLabel setTextColor:NAVIGATIONTITLE];
            }
        }
        [cell addSubview:titleLabel];
        currentY = titleLabel.bottom+5;
    }
    
    CGSize timeSize =[HMTool getTextSizeWithText:data.datetime andFontSize:12];
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(16, currentY, timeSize.width, timeSize.height)];
    [time setText:data.datetime];
    [time setFont:[UIFont systemFontOfSize:12]];
    [time setTextColor:TFPLEASEHOLDERCOLOR];
    [cell addSubview:time];
    
    CGSize contentSize =[self textSize:data.content withConstraintWidth:kMainScreenWidth-32];
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(16, time.bottom+5, kMainScreenWidth-32, contentSize.height)];
    [content setFont:[UIFont systemFontOfSize:12]];
    [content setTextColor:TFPLEASEHOLDERCOLOR];
    [content setText:data.content];
    content.adjustsFontSizeToFitWidth = YES;
    [content setLineBreakMode:NSLineBreakByWordWrapping];
    content.numberOfLines = 0;
    [cell addSubview:content];
    
    if (indexPath.section == 0) {
        if ([[_titleArray objectForIndex:indexPath.section] hasPrefix:@"今天"]) {
            [time setTextColor:POINTMALLGRAYLABELCOLOR];
            [content setTextColor:POINTMALLGRAYLABELCOLOR];
        }
    }
    
    UIView *line =[HMTool getLineWithFrame:CGRectMake(16, content.bottom+9.5, kMainScreenWidth-16, 0.5) andColor:LINECOLOR];
    [cell addSubview:line];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectForIndex:theComponents.weekday];
    
}

- (NSString*)stringFromDate:(NSDate*)inputDate
{
    NSString *str = nil;
    NSDate *date = [NSDate date];
//    NSDate *earlier_date = [inputDate earlierDate:date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    NSInteger year = [components year]; // gives you year
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSDateComponents* components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:inputDate]; // Get necessary date components
    NSInteger year1 = [components1 year]; // gives you year
    NSInteger month1 = [components1 month];
    NSInteger day1 = [components1 day];
    if (year != year1) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        str = [dateFormatter stringFromDate:inputDate];
        NSLog(@"%@", str);
    }else
    {
        if (month == month1 && day == day1) {
            str = @"今天";
        }
//        else if ([earlier_date isEqualToDate:inputDate]) {
//            str = @"昨天";
//        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            str = [dateFormatter stringFromDate:inputDate];
        }
    }
//    NSDate *laterDate = [inputDate laterDate:date];
//    NSLog(@"laterDate  = %@",laterDate);
    
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 - (void)createEmptyPageView
 {
     _emptyPageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _msgTableView.width, _msgTableView.height)];
     [_msgTableView addSubview:_emptyPageView];
     
     UIImageView *tempImage =[[UIImageView alloc]init];
     [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
     [tempImage setFrame:CGRectMake(140.0/375 * _emptyPageView.width, 17.0/60 * _emptyPageView.height, 98.0/600*_emptyPageView.height, 111.0/600*_emptyPageView.height)];
     [tempImage setCenterX:_emptyPageView.width/2];
     [_emptyPageView addSubview:tempImage];
     
     NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]};
     CGSize size1 = [@"没有关于Ta的事项安排，" sizeWithAttributes:attributes];
     CGSize size2 = [@"去设置" sizeWithAttributes:attributes];
     CGSize size3 = [@"吧!" sizeWithAttributes:attributes];
     
     UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(_emptyPageView.width/2-(size1.width+size2.width+size3.width)/2, tempImage.bottom+20, size1.width, size1.height)];
     label1.text = @"没有关于Ta的事项安排，";
     label1.textColor = LABELCOLOR;
     label1.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
     [_emptyPageView addSubview:label1];
     
     NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"去设置"];
     NSRange contentRange = {0, [content length]};
     [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
     UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
     btn2.frame = CGRectMake(label1.right, label1.top, size2.width, size2.height);
     [btn2 setAttributedTitle:content forState:UIControlStateNormal];
     btn2.titleLabel.textColor = BLUEBTBCOLOR;
     btn2.titleLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
     [btn2 addTarget:self action:@selector(toggleRightBarItem) forControlEvents:UIControlEventTouchUpInside];
     [_emptyPageView addSubview:btn2];
     
     UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(btn2.right, label1.top, size3.width, size3.height)];
     label3.text = @"吧!";
     label3.textColor = LABELCOLOR;
     label3.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
     [_emptyPageView addSubview:label3];
 }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
