//
//  CustomerDetailViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "CustomerEditViewController.h"
#import "OptionSelectedViewController.h"
#import "CustomerOperationViewController.h"
#import "CustomerSelGroupViewController.h"
#import "CustomerFollowDetailViewController.h"
#import "BuildFollowDetailViewController.h"
#import "CustAddRemindViewController.h"
#import "RemindListViewController.h"

//#import "TPKeyboardAvoidingScrollView.h"
#import "CustomerDetailEditView.h"
#import "EncodingView.h"
#import "MoshouProgressView.h"
#import "CustomerBaseBuildView.h"

#import "NSString+TKUtilities.h"
#import "TradeRecord.h"
#import "DataFactory+Customer.h"
#import "ProgressStatus.h"
#import "CustomerDetailHeaderView.h"
#import "CustomerDetailTableViewCell.h"
#import "CustomerEvaluationViewController.h"
#import "CustAddFollowViewController.h"

@interface CustomerDetailViewController ()<UIActionSheetDelegate>
{
    CGFloat               _allHeight;//跟进信息或报备信息的显示高度
    CGFloat               rowHeight;//底部展示楼盘的view的高度
}

@property (nonatomic, strong) UITableView   *tableView;

//@property (nonatomic, strong) TPKeyboardAvoidingScrollView   *scrollView;
@property (nonatomic, strong) UIWebView            *webView;//拨打电话弹出的view
@property (nonatomic, strong) UIView               *headerView;//顶部布局，包含客户信息、购房意向、备注和报备楼盘、客户跟进信息等模块
@property (nonatomic, strong) UIView               *customerView;
@property (nonatomic, strong) UIView               *bottomView;//楼盘view
@property (nonatomic, strong) UIView               *followInfoView;//客户跟进信息布局
@property (nonatomic, strong) UIButton             *baobeiBtn;
@property (nonatomic, strong) UILabel              *telLabel;
@property (nonatomic, strong) Customer             *customerList;//客户详情获取数据
@property (nonatomic, assign) BOOL                 isTouched;//互斥锁，防止误操作
@property (nonatomic, strong) OptionData           *groupData;
@property (nonatomic, strong) NSMutableArray       *phonesArr;
@property (nonatomic, strong) NSMutableArray       *louPanTradeArray;//该客户所有楼盘跟进信息数组
@property (nonatomic, strong) UIButton             *openBtn;
@property (nonatomic, strong) NSMutableArray       *cellCountArray;//0代表收起，1代表展开
@property (nonatomic, assign) BOOL                 bHasReportBuilding;

@end

@implementation CustomerDetailViewController
@synthesize headerView;
@synthesize customerView;
@synthesize followInfoView;
@synthesize customerList;

//@synthesize scrollView;
@synthesize bottomView;
@synthesize telLabel;
@synthesize phonesArr;
@synthesize louPanTradeArray;

@synthesize openBtn;
@synthesize cellCountArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"客户详情";
    self.view.backgroundColor = VIEWBGCOLOR;
    [MobClick event:@"khlb_khxq"];
    louPanTradeArray = [[NSMutableArray alloc] init];
    phonesArr = [[NSMutableArray alloc] init];
    cellCountArray = [[NSMutableArray alloc] init];
    
    UIButton *rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-49, 20, 44, 44)];
    [rightBarItem setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
//    [rightBarItem setImage:[UIImage imageNamed:@"icon_edit_h"] forState:UIControlStateHighlighted];
    [rightBarItem addTarget:self action:@selector(toggleRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:rightBarItem];
    
    [self hasNetwork];
    
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    CGFloat height = 0;
//    if ([self verifyTheRulesWithShouldJump:NO])
//    {//判断是否绑定门店
        height = self.view.bounds.size.height-viewTopY-100.0*kMainScreenWidth/750;
//    }else
//    {
//        height = self.view.bounds.size.height-viewTopY;
//    }
    if (self.tableView.superview) {
        self.tableView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, height);
    }
//    if (_baobeiBtn.superview) {
//        _baobeiBtn.frame = CGRectMake(0, self.view.bounds.size.height-44-scrollView.top+64, self.view.bounds.size.width, 44);
//    }
}

- (void)hasNetwork
{
    __weak CustomerDetailViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDetailNotification:) name:kRefreshCustomerDetailWithMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderNotification:) name:@"RefreshCustomerDetailHeader" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBottomNotification:) name:@"RefreshCustomerDetailBottom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCustoemrDetailData:) name:@"RequestCustomerDetailData" object:nil];
    
    CGFloat height = 0;
//    if ([self verifyTheRulesWithShouldJump:NO])
//    {//判断是否绑定门店
        height = self.view.bounds.size.height-viewTopY-100.0*kMainScreenWidth/750;
//    }else
//    {
//        height = self.view.bounds.size.height-viewTopY;
//    }
//    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, height)];
//    scrollView.backgroundColor = BACKGROUNDCOLOR;
//    [self.view addSubview:scrollView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = VIEWBGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initHeaderView];
    [self initBottomView];
    
    UIImageView* loadingView = [self setRotationAnimationWithView];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[DataFactory sharedDataFactory] getCustomerDetailWithId:self.custId withCallBack:^(ActionResult *actionResult,Customer *result) {
            dispatch_async(dispatch_get_main_queue(), ^{//@"2"
                //更新UI
                [self removeRotationAnimationView:loadingView];
                if (!actionResult.success) {
                    [self showTips:actionResult.message];
                }
                customerList = result;
                if (customerList.groupList.count>0) {
                    _groupData = (OptionData*)[customerList.groupList objectForIndex:0];
                }else
                {
                    _groupData =[[OptionData alloc] init];
                    _groupData.itemName = @"全部";
                    _groupData.itemValue = @"0";
                }
                [phonesArr addObjectsFromArray:result.phoneList];
                [louPanTradeArray addObjectsFromArray:result.tradeArray];
                for (int i=0; i<louPanTradeArray.count; i++) {
                    [cellCountArray addObject:@"0"];
                }
                [headerView removeAllSubviews];
                [headerView removeFromSuperview];
                [self initHeaderView];
                
//                if (self.baobeiBtn != nil) {
//                    NSString *loupanStr = customerList.count;
//                    if ([self isBlankString:loupanStr]) {
//                        loupanStr = @"0";
//                    }
//                    [self.baobeiBtn setAttributedTitle:[self transferLouPanString:loupanStr] forState:UIControlStateNormal];
//                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                if (![self isBlankString:customerList.customerId]) {
                    [dic setValue:customerList.customerId forKey:@"custProfileId"];
                }
                
                [[DataFactory sharedDataFactory] getReportBuildingWithDic:dic WithCallBack:^(ActionResult *result, NSArray *array) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _bHasReportBuilding = NO;
                        if (result.success) {
                            if (array.count > 0) {
                                _bHasReportBuilding = YES;
                            }
                        }else
                        {
                            [self showTips:result.message];
                        }
                    });
                }];
                
                [self.tableView reloadData];
            });
        }];
    }else
    {
        [self removeRotationAnimationView:loadingView];
        [self showTips:@"网络连接失败"];
    }
}

- (void)refreshDetailNotification:(NSNotification*)notification
{
    NSLog(@"notification:%@",notification.object);
    NSString *custId = notification.object;
    if ([custId isEqualToString:customerList.customerId]) {//2341
        [self requestForBottomView];
    }
}

- (void)refreshHeaderNotification:(NSNotification*)notification
{
    [self requestForHeaderView];
}

- (void)refreshBottomNotification:(NSNotification*)notification
{
    [self requestForBottomView];
}

- (void)requestCustoemrDetailData:(NSNotification*)notification
{
    [[DataFactory sharedDataFactory] getCustomerDetailWithId:customerList.customerId withCallBack:^(ActionResult *actionResult,Customer *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            customerList = result;
            if (customerList.groupList.count>0) {
                _groupData = (OptionData*)[customerList.groupList objectForIndex:0];
            }else
            {
                _groupData =[[OptionData alloc] init];
                _groupData.itemName = @"全部";
                _groupData.itemValue = @"0";
            }
            [louPanTradeArray removeAllObjects];
            [louPanTradeArray addObjectsFromArray:result.tradeArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
        });
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshCustomerDetailWithMsg object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshCustomerDetailHeader" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshCustomerDetailBottom" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestCustomerDetailData" object:nil];
}

- (void)requestForHeaderView
{
    UIImageView* loadingView = [self setRotationAnimationWithView];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[DataFactory sharedDataFactory] getCustomerDetailWithId:customerList.customerId withCallBack:^(ActionResult *actionResult,Customer *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI
                [self removeRotationAnimationView:loadingView];
                customerList = result;
                if (customerList.groupList.count>0) {
                    _groupData = (OptionData*)[customerList.groupList objectForIndex:0];
                }else
                {
                    _groupData =[[OptionData alloc] init];
                    _groupData.itemName = @"全部";
                    _groupData.itemValue = @"0";
                }
                [phonesArr removeAllObjects];
                [phonesArr addObjectsFromArray:result.phoneList];
                [headerView removeAllSubviews];
                [headerView removeFromSuperview];
                [self initHeaderView];
//                CGFloat height = headerView.bottom;
//                for (int i=0; i<louPanTradeArray.count; i++) {
//                    bottomView = (UIView *)[self.scrollView viewWithTag:11000+i];
//                    bottomView.top = height+10;
//                    height = bottomView.bottom;
//                    if (i==louPanTradeArray.count-1) {
//                        scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
//                    }
//                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
            });
        }];
    }else
    {
        [self removeRotationAnimationView:loadingView];
        [self showTips:@"网络连接失败"];
    }
}
//报备楼盘成功之后，跳转至本页面，刷新底部展示楼盘的布局
- (void)requestForBottomView
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:customerList.customerId]) {
        [dic setValue:customerList.customerId forKey:@"custProfileId"];
    }
    
    [[DataFactory sharedDataFactory] getReportBuildingWithDic:dic WithCallBack:^(ActionResult *result, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _bHasReportBuilding = NO;
            if (result.success) {
                if (array.count > 0) {
                    _bHasReportBuilding = YES;
                }
            }else
            {
                [self showTips:result.message];
            }
        });
    }];
//    __weak CustomerDetailViewController *weakSelf = self;
    UIImageView* loadingView = [self setRotationAnimationWithView];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[DataFactory sharedDataFactory] getCustomerDetailWithId:self.custId withCallBack:^(ActionResult *actionResult,Customer *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI
                [self removeRotationAnimationView:loadingView];
//                for (int i=0; i<louPanTradeArray.count; i++) {
//                    bottomView = (UIView *)[self.scrollView viewWithTag:11000+i];
//                    [bottomView removeAllSubviews];
//                    [bottomView removeFromSuperview];
//                }
//                rowHeight = headerView.bottom;
                self.customerList.count = result.count;
                
                [self.louPanTradeArray removeAllObjects];
                [self.louPanTradeArray addObjectsFromArray:result.tradeArray];
                [self.cellCountArray removeAllObjects];
                for (int i=0; i<self.louPanTradeArray.count; i++) {
                    [self.cellCountArray addObject:@"0"];
                }
                
//                if (weakSelf.baobeiBtn != nil) {
//                    NSString *loupanStr = weakSelf.customerList.count;
//                    if ([weakSelf isBlankString:loupanStr]) {
//                        loupanStr = @"0";
//                    }
//                    [weakSelf.baobeiBtn setAttributedTitle:[weakSelf transferLouPanString:loupanStr] forState:UIControlStateNormal];
//                }
                
                [self.tableView reloadData];
//                [self initBottomView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
            });
        }];
    }else
    {
        [self removeRotationAnimationView:loadingView];
        [self showTips:@"网络连接失败"];
    }
}

- (void)initHeaderView
{
    //购房意向
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 300)];
    [headerView setBackgroundColor:VIEWBGCOLOR];
    //顶部客户信息view
    customerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    [customerView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:customerView];
    
//    [customerView addSubview:[self createLineView:0 withX:0]];
    
    UILabel *customerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, kMainScreenWidth-100, 30)];
    customerNameLabel.textColor = NAVIGATIONTITLE;
    if (![self isBlankString:customerList.name]) {
        if (customerList.name.length <= 7) {
            
            NSString *name = [NSString stringWithFormat:@"%@   %@", customerList.name,[customerList.sex isEqualToString:@"男"]?@"先生":@"女士"];//male
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:name];
            [attriString addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:17.0f]
                                range:NSMakeRange(0, name.length-2)];
            [attriString addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]
                                range:NSMakeRange(name.length-2, 2)];
            [attriString addAttribute:NSForegroundColorAttributeName
                                value:LABELCOLOR
                                range:NSMakeRange(name.length-2, 2)];
            [customerNameLabel setAttributedText:attriString];
        }else
        {
            NSString *name = [NSString stringWithFormat:@"%@...   %@", [customerList.name substringToIndex:7],[customerList.sex isEqualToString:@"男"]?@"先生":@"女士"];
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:name];
            [attriString addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:17.0f]
                                range:NSMakeRange(0, name.length-2)];
            [attriString addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]
                                range:NSMakeRange(name.length-2, 2)];
            [attriString addAttribute:NSForegroundColorAttributeName
                                value:LABELCOLOR
                                range:NSMakeRange(name.length-2, 2)];
            [customerNameLabel setAttributedText:attriString];
        }
    }
    
    //    customerNameLabel.font = [UIFont systemFontOfSize:18.0f];
    [customerView addSubview:customerNameLabel];
    UIButton *callBtn = nil;
    NSInteger tag=0;
    for (int i=0; i<phonesArr.count; i++) {
        [customerView addSubview:[self createLineView:customerNameLabel.bottom+6.5+44*i withX:10]];
        MobileVisible *mobile = (MobileVisible*)[phonesArr objectForIndex:i];
        if (![self isBlankString:mobile.hidingPhone] && ![self isBlankString:mobile.totalPhone]) {
            for (int j=0; j<2; j++) {
                telLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerNameLabel.left, customerNameLabel.bottom+7+10+44*i+20*j, 120, 20)];
                telLabel.backgroundColor = [UIColor clearColor];
                telLabel.tag = 1000+tag;
                if (j==0) {
                    telLabel.text = mobile.hidingPhone;//customerList.phone;
                }else
                {
                    telLabel.text = mobile.totalPhone;//customerList.phone;
                }
                
                telLabel.textAlignment = NSTextAlignmentLeft;
                telLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
                telLabel.textColor = LABELCOLOR;
                //长按电话号码选择复制
                UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                [longGesture setMinimumPressDuration:0.4];
                telLabel.userInteractionEnabled=YES;
                [telLabel addGestureRecognizer:longGesture];
                [customerView addSubview:telLabel];
                
                tag++;
            }
            //拨打电话按钮
            callBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-5-40, customerNameLabel.bottom + 17, 40, 40)];
            callBtn.tag = 1100+i;
            [callBtn setBackgroundColor:[UIColor clearColor]];
            [callBtn setImage:[UIImage imageNamed:@"button_call"] forState:UIControlStateNormal];
            [callBtn setImage:[UIImage imageNamed:@"button_call_h"] forState:UIControlStateHighlighted];
            [callBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [customerView addSubview:callBtn];
            
            customerView.height = callBtn.bottom+10;
        }else
        {
            telLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerNameLabel.left, customerNameLabel.bottom+7+7+44*i, 120, 30)];
            telLabel.backgroundColor = [UIColor clearColor];
            telLabel.tag = 1000+tag;
            telLabel.text = mobile.hidingPhone;
            telLabel.textAlignment = NSTextAlignmentLeft;
            telLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
            telLabel.textColor = LABELCOLOR;
            //长按电话号码选择复制
            UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            [longGesture setMinimumPressDuration:0.4];
            telLabel.userInteractionEnabled=YES;
            [telLabel addGestureRecognizer:longGesture];
            [customerView addSubview:telLabel];
            
            //拨打电话按钮
            callBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-5-40, telLabel.top-5, 40, 40)];
            callBtn.tag = 1100+i;
            [callBtn setBackgroundColor:[UIColor clearColor]];
            [callBtn setImage:[UIImage imageNamed:@"button_call"] forState:UIControlStateNormal];
            [callBtn setImage:[UIImage imageNamed:@"button_call_h"] forState:UIControlStateHighlighted];
            [callBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [customerView addSubview:callBtn];
            
//            if ([[phonesArr objectForIndex:i] rangeOfString:@"****"].location != NSNotFound) {
            if ([mobile.hidingPhone rangeOfString:@"****"].location != NSNotFound) {
                callBtn.hidden = YES;
                telLabel.text = mobile.hidingPhone;
                //        remindBtn.left = kMainScreenWidth-5-40;
            }
            tag++;
            customerView.height = callBtn.bottom+2;
        }
    }
    
    //提醒按钮
    UIButton *remindBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40-5, 2, 40, 40)];
    [remindBtn setBackgroundColor:[UIColor clearColor]];
    [remindBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    [remindBtn setImage:[UIImage imageNamed:@"clock-down"] forState:UIControlStateHighlighted];
    [customerView addSubview:remindBtn];
    
    //为拨电话与发短信按钮添加点击事件
    [remindBtn addTarget:self action:@selector(toggleRemindBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    [customerView addSubview:[self createLineView:customerView.height-0.5 withX:0]];
    //身份证号码
    if (![self isBlankString:customerList.cardId]) {
        CGFloat identityY = customerView.height;
        [customerView addSubview:[self createLineView:identityY-0.5 withX:10]];
        UILabel *identityLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerNameLabel.left, identityY+7, kMainScreenWidth-40, 30)];
        identityLabel.textColor = LABELCOLOR;
        identityLabel.font = FONT(14);
        identityLabel.text = customerList.cardId;
        [customerView addSubview:identityLabel];
        customerView.height = identityLabel.bottom+7;
    }
    //店长分配标签
    UIView *defineView = [[UIView alloc] initWithFrame:CGRectMake(0, customerView.bottom, kMainScreenWidth, 28)];
    defineView.backgroundColor = [UIColor colorWithHexString:@"f8bb61"];
    
    UILabel *defineL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 28)];
    defineL.backgroundColor = [UIColor clearColor];
    defineL.textColor = [UIColor whiteColor];
    defineL.font = FONT(13);
    defineL.text = [NSString stringWithFormat:@"%@ %@",customerList.managerAllocationTime,customerList.managerAllocationText];//@"2016-12-09 13:45 店长分配";
    [defineView addSubview:defineL];
    CGFloat theY;
//    customerList.managerAllocation = YES;
    if (customerList.managerAllocation) {
        theY = defineView.bottom;
        [headerView addSubview:defineView];
    }else
    {
        theY = customerView.bottom;
    }
    
    //备注信息
    UIView *remarksView = [[UIView alloc] initWithFrame:CGRectMake(0, theY+10, kMainScreenWidth, 0)];
    remarksView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:remarksView];
    
    CGSize remarkSize = [@"" sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    UILabel *remarkL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, remarkSize.height)];
    remarkL.text = @"备注信息";
    remarkL.font = FONT(15);
    remarkL.textColor = NAVIGATIONTITLE;
    [remarksView addSubview:remarkL];
    //备注按钮
    UIButton *remarksBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 40, remarkL.centerY-15, 30, 30)];
    [remarksBtn setImage:[UIImage imageNamed:@"icon_customer_remarks"] forState:UIControlStateNormal];
    [remarksBtn setTitleColor:redBgColor forState:UIControlStateNormal];
    [remarksBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [remarksBtn addTarget:self action:@selector(toggleRemarksBtn:) forControlEvents:UIControlEventTouchUpInside];
    [remarksView addSubview:remarksBtn];
    
    NSString *str2 = nil;
    if ([self isBlankString:customerList.remark]) {
        str2 = @"无备注";
        
    }else{
        str2 = customerList.remark;
    }
    CGFloat remarkslabelWidth = remarksView.width- 20;
    CGSize str2Size = [self textSize:str2 withConstraintWidth:remarkslabelWidth];
    CGRect remarksFrame;
    
    remarksFrame = CGRectMake(10, remarkL.bottom+10, remarkslabelWidth, str2Size.height);
    
    UILabel *remarksTextLabel = [[UILabel alloc] initWithFrame:remarksFrame];
    remarksTextLabel.text = str2;
    [remarksTextLabel setFont:[UIFont systemFontOfSize:15]];
    remarksTextLabel.adjustsFontSizeToFitWidth = YES;
    [remarksTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [remarksTextLabel setNumberOfLines:0];
    remarksTextLabel.textColor = [UIColor colorWithHexString:@"888888"];
    [remarksView addSubview:remarksTextLabel];
    
    [remarksView setHeight:remarksTextLabel.bottom+20];
    
    CGFloat kHeight = remarksView.bottom;
    if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
        //客户来源
        CustomerBaseBuildView *custSourceView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, remarksView.bottom+10, kMainScreenWidth, 44) Title:@"客户来源" AndImageName:nil AndBtnImgView:@"" WithToBeUsed:4];//arrow-right
        custSourceView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:custSourceView];
        
        UILabel *_custSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7, kMainScreenWidth-150-33, 30)];
        _custSourceLabel.textColor = TFPLEASEHOLDERCOLOR;
        _custSourceLabel.textAlignment = NSTextAlignmentRight;
        _custSourceLabel.font = FONT(13);
        if (![self isBlankString:customerList.custSource]&& ![customerList.custSource isEqualToString:@"0"]) {
            CustomerSourceData *_sourceData = [[CustomerSourceData alloc] init];
            _sourceData.code = customerList.custSource;
            _sourceData.label = customerList.custSourceLabel;
            _custSourceLabel.text = [NSString stringWithFormat:@"%@.%@",_sourceData.code,_sourceData.label];
        }
        [custSourceView addSubview:_custSourceLabel];
        //下期看情况开放点击事件
        //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCustomer:)];
        //    [custSourceView addGestureRecognizer:tapGesture];
        kHeight = custSourceView.bottom;
    }
    //    中部购房意向view
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight+10, kMainScreenWidth, 0)];
    [middleView setBackgroundColor:[UIColor whiteColor]];
#pragma mark 下期需求购房意向在详情页为可修改项，需添加点击事件 [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GFYX" andPageId:@"PAGE_KHXQ"];
    //购房意向
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 12, 20, 20)];
//    imageView.image = [UIImage imageNamed:@"icon_goufang"];
//    [middleView addSubview:imageView];
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 150, remarkL.height)];//imageView.right+5
    titlelabel.text = @"购房意向";
    titlelabel.font = [UIFont systemFontOfSize:15.0f];
    titlelabel.textColor = NAVIGATIONTITLE;
    [middleView addSubview:titlelabel];
    
    NSString *str = nil;
    if ([self isBlankString:customerList.expect]) {
        str = @"未填写";
    }else{
        str = customerList.expect;
    }
    CGFloat labelWidth = middleView.width- 20;
    CGSize strSize = [self textSize:str withConstraintWidth:labelWidth];
    UILabel *goufDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titlelabel.bottom+10, labelWidth, strSize.height)];
    goufDisplayLabel.text = str;
    [goufDisplayLabel setFont:[UIFont systemFontOfSize:15]];
    goufDisplayLabel.adjustsFontSizeToFitWidth = YES;
    [goufDisplayLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [goufDisplayLabel setNumberOfLines:0];
    goufDisplayLabel.textColor = [UIColor colorWithHexString:@"888888"];
    [middleView addSubview:goufDisplayLabel];
    
//    [middleView addSubview:[self createLineView:goufDisplayLabel.bottom+15 withX:15]];
    
    
//    [middleView addSubview:[self createLineView:0 withX:0]];
//    [middleView addSubview:[self createLineView:middleView.height-0.5 withX:0]];
    [middleView setHeight:goufDisplayLabel.bottom+20];
    [headerView addSubview:middleView];
    
    CustomerBaseBuildView *customerFollowInfoView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, middleView.bottom+10, kMainScreenWidth, 54) Title:@"客户跟进" AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:3];
    customerFollowInfoView.backgroundColor = [UIColor whiteColor];
    
//    [customerFollowInfoView addSubview:[self createLineView:0 withX:0]];
//    [customerFollowInfoView addSubview:[self createLineView:customerFollowInfoView.height-0.5 withX:0]];
    [headerView addSubview:customerFollowInfoView];
    
//    点击跳转至客户跟进信息页面的按钮
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, customerFollowInfoView.width, customerFollowInfoView.height)];
    followBtn.backgroundColor = [UIColor clearColor];
    [followBtn addTarget:self action:@selector(toggleFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [customerFollowInfoView addSubview:followBtn];
    
    CustomerBaseBuildView *customerEvaluationView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, customerFollowInfoView.bottom+10, kMainScreenWidth, 54) Title:@"客户评级" AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:3];
    customerEvaluationView.backgroundColor = [UIColor whiteColor];
//    [customerEvaluationView addSubview:[self createLineView:0 withX:0]];
//    [customerEvaluationView addSubview:[self createLineView:customerEvaluationView.height-0.5 withX:0]];
    [headerView addSubview:customerEvaluationView];
    
    //    点击跳转至客户跟进信息页面的按钮
    UIButton *evaluationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, customerEvaluationView.width, customerEvaluationView.height)];
    evaluationBtn.backgroundColor = [UIColor clearColor];
    [evaluationBtn addTarget:self action:@selector(toggleEvaluationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [customerEvaluationView addSubview:evaluationBtn];
    [headerView setHeight:customerEvaluationView.bottom+10];
    self.tableView.tableHeaderView = headerView;
//    [headerView setHeight:customerFollowInfoView.bottom+10];
//    self.tableView.tableHeaderView = headerView;
//    scrollView.contentSize = CGSizeMake(kMainScreenWidth, headerView.height);
//    [scrollView addSubview:headerView];
}
//创建报备的楼盘布局
- (void)initBottomView
{//btn_revert_h  撤销报备
    if ([self verifyTheRulesWithShouldJump:NO])
    {//判断是否绑定门店
        UIButton *addFollowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, 275.0/750*kMainScreenWidth, 100.0*kMainScreenWidth/750)];
        [addFollowBtn setBackgroundColor:BACKGROUNDCOLOR];
        [addFollowBtn setTitle:@"添加跟进" forState:UIControlStateNormal];
        [addFollowBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        addFollowBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [addFollowBtn addTarget:self action:@selector(toggleNewFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addFollowBtn];
        //报备楼盘
        _baobeiBtn = [[UIButton alloc] initWithFrame:CGRectMake(addFollowBtn.right, self.tableView.bottom, kMainScreenWidth-addFollowBtn.width, addFollowBtn.height)];//CGRectMake(0, kMainScreenHeight-44, kMainScreenWidth, 44)
//        NSString *loupanStr = customerList.count;
//        if ([self isBlankString:loupanStr]) {
//            loupanStr = @"0";
//        }
        [_baobeiBtn setBackgroundColor:BLUEBTBCOLOR];
        [_baobeiBtn setTitle:@"报备楼盘" forState:UIControlStateNormal];
        [_baobeiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _baobeiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [_baobeiBtn setAttributedTitle:[self transferLouPanString:loupanStr] forState:UIControlStateNormal];
        [_baobeiBtn addTarget:self action:@selector(toggleBaobeiButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_baobeiBtn];
    }else
    {
        UIButton *addFollowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kMainScreenWidth, 50.0*750*kMainScreenWidth)];
        [addFollowBtn setBackgroundColor:BACKGROUNDCOLOR];
        [addFollowBtn setTitle:@"添加跟进" forState:UIControlStateNormal];
        [addFollowBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        addFollowBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [addFollowBtn addTarget:self action:@selector(toggleNewFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addFollowBtn];
    }
//    if (louPanTradeArray.count>0) {
//        for (int i=0; i<louPanTradeArray.count; i++) {
//            bottomView = [[UIView alloc] init];
//            if (rowHeight==0) {
//                bottomView.frame = CGRectMake(0, headerView.bottom+10, kMainScreenWidth, 150);
//            }else
//            {
//                bottomView.frame = CGRectMake(0, rowHeight+10, kMainScreenWidth, 150);
//            }
//            
//            bottomView.tag = 11000+i;
//            bottomView.backgroundColor = [UIColor whiteColor];
//            [scrollView addSubview:bottomView];
//            
//            [bottomView addSubview:[self createLineView:0 withX:0]];
//            [bottomView addSubview:[self createLineView:bottomView.height-0.5 withX:0]];
//    
//            TradeRecord *tradeRecord = nil;
//            if (louPanTradeArray.count>i) {
//                tradeRecord = (TradeRecord*)[louPanTradeArray objectForIndex:i];
//            }
//            
//            UIImageView *loupImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
//            [loupImgView setImage:[UIImage imageNamed:@"mine_loupan"]];
//            [bottomView addSubview:loupImgView];
//            
//            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
//            CGSize size2 = [tradeRecord.buildingName sizeWithAttributes:attributes];
//            UILabel *loupanName = [[UILabel alloc] initWithFrame:CGRectMake(loupImgView.right+5, 10, MIN(size2.width, kMainScreenWidth-5-5-50-loupImgView.right), 30)];
//            loupanName.textColor = NAVIGATIONTITLE;
//            loupanName.font = [UIFont systemFontOfSize:17];
//            loupanName.text = tradeRecord.buildingName;
//            [bottomView addSubview:loupanName];
//
//            UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8, 18, 8, 14)];
//            [arrowImgView setImage:[UIImage imageNamed:@"arrow-right"]];
//            [bottomView addSubview:arrowImgView];
//            
//            [bottomView addSubview:[self createLineView:49.5 withX:15]];
//            
//            MoshouProgressView *progressView = [[MoshouProgressView alloc] initWithFrame:CGRectMake(0, 60, kMainScreenWidth, 90)];
//            progressView.progressDataSource = tradeRecord.progress;
//            [bottomView addSubview:progressView];
//            
//            UIButton *loupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            loupBtn.frame = CGRectMake(0, 0, kMainScreenWidth, bottomView.height);
//            [loupBtn setBackgroundColor:[UIColor clearColor]];
//            loupBtn.tag = 13000+i;
//            [loupBtn addTarget:self action:@selector(toggleLoupButton:) forControlEvents:UIControlEventTouchUpInside];
//            [bottomView addSubview:loupBtn];
//            
////            if ([tradeRecord.showURL boolValue]) {
////                UIButton *QRCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(loupanName.right+5, 13, 24, 24)];
////                [QRCodeBtn setImage:[UIImage imageNamed:@"iconfont_erweima"] forState:UIControlStateNormal];
////                QRCodeBtn.tag = 2001+i;
////                [QRCodeBtn addTarget:self action:@selector(toggleQRCodeButton:) forControlEvents:UIControlEventTouchUpInside];
////                [bottomView addSubview:QRCodeBtn];
////            }
//            if (i==louPanTradeArray.count-1) {
//                scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
//            }
//            rowHeight = bottomView.bottom;
//        }
//    }else
//    {
//        scrollView.contentSize = CGSizeMake(kMainScreenWidth, headerView.height);
//    }
    
}
//点击导航栏右侧的修改按钮，跳转至修改客户页面
- (void)toggleRightBarItem
{
    [MobClick event:@"khxq_bianji"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"编辑客户" otherButtonTitles:@"删除客户",@"移动分组", nil];
    [actionSheet setDestructiveButtonIndex:1];
    [actionSheet showInView:self.view];
    
    /*CustomerDetailEditView *editView = [[CustomerDetailEditView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
    __weak CustomerDetailViewController *weakSelf = self;
    [editView createCustomerDetailBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 0:
            {
//                if ([weakSelf verifyTheRulesWithShouldJump:NO])
//                {//判断是否绑定门店
                    CustomerOperationViewController *custOperVC = [[CustomerOperationViewController alloc] init];
                    custOperVC.customerViewCtrlType = kModifyCustomer;
                    custOperVC.customerData = weakSelf.customerList;
                    custOperVC.groupData =weakSelf.groupData;
                if (weakSelf.louPanTradeArray.count > 0) {
                    custOperVC.bCanModify = NO;
                }else
                {
                    custOperVC.bCanModify = YES;
                }
                    [weakSelf.navigationController pushViewController:custOperVC animated:YES];
//                }
            }
                break;
            case 1:
            {
                if (weakSelf.louPanTradeArray.count > 0) {
                    [weakSelf showTips:@"当前客户不能删除"];
                }else{
                    UIImageView* loadingView = [weakSelf setRotationAnimationWithView];
                    [[DataFactory sharedDataFactory] deleteCustomerWithId:customerList.customerId withCallBack:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //更新UI
                            [weakSelf removeRotationAnimationView:loadingView];
                            [weakSelf showTips:result.message];
                            if (result.success) {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
                                    //防止多次pop发生崩溃闪退
                                    if ([self.view superview]) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                });
                            }
                        });
                    }];
                }
            }
                break;
            case 2:
            {
//                if ([weakSelf verifyTheRulesWithShouldJump:NO])
//                {//判断是否绑定门店
                    CustomerSelGroupViewController *groupVC = [[CustomerSelGroupViewController alloc] init];
                    groupVC.bHasRequest = YES;
                    groupVC.custId = weakSelf.customerList.customerId;
                    [groupVC setData:weakSelf.groupData andGroupBlock:^(OptionData *groupData) {
    //                    weakSelf.groupData = groupData;
                        [weakSelf requestForHeaderView];
                    }];
                    [weakSelf.navigationController pushViewController:groupVC animated:YES];
//                }
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:editView];*/
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
//        case 0:
//        {
//            NSLog(@"toggle 0000");
//        }
//            break;
        case 0://编辑客户
        {
            NSLog(@"toggle 1111");
            CustomerOperationViewController *custOperVC = [[CustomerOperationViewController alloc] init];
            custOperVC.customerViewCtrlType = kModifyCustomer;
            custOperVC.customerData = self.customerList;
            custOperVC.groupData =self.groupData;
            if (self.louPanTradeArray.count > 0) {
                custOperVC.bCanModify = NO;
            }else
            {
                custOperVC.bCanModify = YES;
            }
            [self.navigationController pushViewController:custOperVC animated:YES];
        }
            break;
        case 1://删除客户
        {
            NSLog(@"toggle 3333");
            if (self.louPanTradeArray.count > 0) {
                [self showTips:@"当前客户不能删除"];
            }else{
                UIImageView* loadingView = [self setRotationAnimationWithView];
                [[DataFactory sharedDataFactory] deleteCustomerWithId:customerList.customerId withCallBack:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //更新UI
                        [self removeRotationAnimationView:loadingView];
                        [self showTips:result.message];
                        if (result.success) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
                                //防止多次pop发生崩溃闪退
                                if ([self.view superview]) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            });
                        }
                    });
                }];
            }
        }
            break;
        case 2://移动分组
        {
            NSLog(@"toggle 2222");
            CustomerSelGroupViewController *groupVC = [[CustomerSelGroupViewController alloc] init];
            groupVC.bHasRequest = YES;
            groupVC.custId = self.customerList.customerId;
            __weak typeof(self) weakSelf = self;
            [groupVC setData:self.groupData andGroupBlock:^(OptionData *groupData) {
                //                    weakSelf.groupData = groupData;
                [weakSelf requestForHeaderView];
            }];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//点击跳转至楼盘报备页面
- (void)toggleBaobeiButton:(UIButton*)sender
{
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BBLP" andPageId:@"PAGE_KHXQ"];
    if ([customerList.count integerValue]>0) {
        OptionSelectedViewController *optionSelected = [[OptionSelectedViewController alloc] init];
        optionSelected.custId = customerList.customerId;
        optionSelected.count = customerList.count;
        optionSelected.name = customerList.name;
        optionSelected.sex = customerList.sex;
        if (customerList.phoneList.count>0) {
            MobileVisible *mobile = (MobileVisible*)[customerList.phoneList objectForIndex:0];
            optionSelected.phone = mobile.hidingPhone;
        }
//        if ([customerList.listPhone rangeOfString:@"****"].location != NSNotFound) {
//            optionSelected.bIsFullPhone = @"0";
//        }else
//        {
//            optionSelected.bIsFullPhone = @"1";
//        }
        optionSelected.optionSelType = kCustomerDetailVC ;
        __weak CustomerDetailViewController *weakSelf = self;
        [optionSelected returnResultBlock:^(NSMutableArray *array,NSMutableDictionary*dic,NSMutableDictionary*confirmDic){
            if (array.count>0) {
//                NSString *loupanStr = weakSelf.customerList.count;
//                if ([weakSelf isBlankString:loupanStr]) {
//                    loupanStr = @"0";
//                }
//                [weakSelf.baobeiBtn setBackgroundColor:BLUEBTBCOLOR];
//                [weakSelf.baobeiBtn setAttributedTitle:[weakSelf transferLouPanString:loupanStr] forState:UIControlStateNormal];
                [weakSelf.cellCountArray addObject:@"0"];
                [weakSelf requestForBottomView];
            }
        }];
        [self.navigationController pushViewController:optionSelected animated:YES];
    }
    else if ([customerList.count integerValue]==0)
    {
        if ([NetworkSingleton sharedNetWork].isNetworkConnection)
        {//在网络连接的前提下，可报备客户为0，说明已经报备了5个客户，不可以再报备了
            [self showTips:@"报备楼盘已达上限，请撤消其它报备再使用!"];
        }else{
            [self showTips:@"网络连接失败"];
        }
    }
}

//创建线条
- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    lineView.backgroundColor = CustomerBorderColor;
    return lineView;
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:15];
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

//拨打电话
- (void)toggleCallBtn:(UIButton*)sender
{
    // 提示：不要将webView添加到self.view，如果添加会遮挡原有的视图
    // 懒加载
    [MobClick event:@"khxq_bddh"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BDDH" andPageId:@"PAGE_KHXQ"];
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    NSInteger tag = sender.tag - 1100;
    NSString *phone = @"";
    if (phonesArr.count > tag) {
        MobileVisible *mobile = [phonesArr objectForIndex:tag];
        if ([self isBlankString:mobile.hidingPhone]) {
            phone = mobile.totalPhone;
        }else
        {
            phone = mobile.hidingPhone;
        }
    }
    DLog(@"%p,phone is %@", _webView,phone);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
//提醒
- (void)toggleRemindBtn:(UIButton*)sender
{
    [MobClick event:@"khxq_tixing"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_TXGN" andPageId:@"PAGE_KHXQ"];
    if ([customerList.hasRemind boolValue]) {
        RemindListViewController *remindVC = [[RemindListViewController alloc] init];
        remindVC.custList = customerList;
        [self.navigationController pushViewController:remindVC animated:YES];
    }else {
        CustAddRemindViewController *addRemindVC = [[CustAddRemindViewController alloc] init];
        addRemindVC.custList = customerList;
        [self.navigationController pushViewController:addRemindVC animated:YES];
    }
    
}
//添加备注
- (void)toggleRemarksBtn:(UIButton*)sender
{
    __weak CustomerDetailViewController *detail = self;
    CustomerEditViewController *editVC = [[CustomerEditViewController alloc] init];
//    editVC.customerMsgType = kAddRemarksMsg;
    editVC.customerMsdId = customerList.customerId;
    editVC.editString = customerList.remark;
    [editVC returnCustomerEditResultBlock:^() {
        [detail requestForHeaderView];
    }];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)toggleFollowBtn:(UIButton*)sender
{
    [MobClick event:@"khxq_gjjl"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_KHGJ" andPageId:@"PAGE_KHXQ"];
//    if (customerList.trackArray.count>0) {
        CustomerFollowDetailViewController *followVC = [[CustomerFollowDetailViewController alloc] init];
        followVC.customerList = customerList;
//        followVC.custId = customerList.customerId;
        [self.navigationController pushViewController:followVC animated:YES];
//    }else
//    {
//        __weak CustomerDetailViewController *detail = self;
//        CustomerEditViewController *editVC = [[CustomerEditViewController alloc] init];
//        editVC.customerMsgType = kAddCustomerFollowMsg;
//        editVC.customerMsdId = customerList.customerId;
//        [editVC returnCustomerEditResultBlock:^() {
//            [detail requestForHeaderView];
//        }];
//        [self.navigationController pushViewController:editVC animated:YES];
//    }
}

- (void)toggleNewFollowBtn:(UIButton*)sender
{
//    [MobClick event:@"khxq_gjjl"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_TJGJ" andPageId:@"PAGE_KHXQ"];
    
    if (_bHasReportBuilding) {
        CustAddFollowViewController *addFollowVC = [[CustAddFollowViewController alloc] init];
        addFollowVC.customerId = customerList.customerId;
        [self.navigationController pushViewController:addFollowVC animated:YES];
    }else
    {
        [self showTips:@"报备客户后才能添加跟进信息"];
    }
}

- (void)toggleEvaluationBtn:(UIButton*)sender
{
    [MobClick event:@"khxq_khpj"];//客户详情-客户评级
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_KHPJ" andPageId:@"PAGE_KHXQ"];
    CustomerEvaluationViewController *evaluationVC = [[CustomerEvaluationViewController alloc] init];
    evaluationVC.customerId = self.custId;
    evaluationVC.customerName = customerList.name;
    evaluationVC.customerPhone = customerList.listPhone;
    evaluationVC.customerExpect = customerList.expect;
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

- (void)toggleLoupButton:(UIButton*)sender
{
    [MobClick event:@"khxq_jdxq"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BBJDXQ" andPageId:@"PAGE_KHXQ"];
    NSInteger tag = sender.tag - 13000;
    BuildFollowDetailViewController *buildVC = [[BuildFollowDetailViewController alloc] init];
    TradeRecord *trade = nil;
    if (louPanTradeArray.count > tag) {
        trade = (TradeRecord*)[louPanTradeArray objectForIndex:tag];
    }
    buildVC.trade = trade;
    buildVC.customerId = customerList.customerId;
    buildVC.customerName = customerList.name;
    buildVC.customerPhone = customerList.listPhone;
    [self.navigationController pushViewController:buildVC animated:YES];
}

- (NSAttributedString *)transferLouPanString:(NSString*)number
{
    NSString *string = [NSString stringWithFormat:@"+报备楼盘[%@]",number];
    NSRange range = [string  rangeOfString:@"]"];
    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, range.location)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:24]
                        range:NSMakeRange(0, 1)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:17]
                        range:NSMakeRange(1, 4)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:18]
                        range:NSMakeRange(5, range.location-5)];
    return attriString;
}
#pragma mark - 长按手势
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    NSInteger tag = longPress.view.tag;
    telLabel = (UILabel *)[customerView viewWithTag:tag];
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *saveItem;
        [menu setMenuItems:[NSArray arrayWithObjects:saveItem, nil]];
        
        CGRect targetRect = telLabel.frame;//[self.view convertRect:telLabel.frame
//                                          fromView:telLabel];

        [menu setTargetRect:CGRectInset(CGRectMake(targetRect.origin.x/2-5, targetRect.origin.y, targetRect.size.width, targetRect.size.height),0.0f, 0.0f) inView:customerView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        [menu setMenuVisible:YES animated:YES];
        
        [menu update];
    }
}

#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    //    self.bubbleView.selectedToShowCopyMenu = NO;
    telLabel.backgroundColor = [UIColor clearColor];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    //    self.bubbleView.selectedToShowCopyMenu = YES;
    telLabel.backgroundColor = bgViewColor;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:telLabel.text];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    if (louPanTradeArray.count>0) {
        count = 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
//    BOOL isOpen = NO;
//    if (cellCountArray.count > section) {
//        isOpen = [[cellCountArray objectForIndex:section] boolValue];
//    }
//    if (isOpen) {
//        TradeRecord *trade = nil;
//        if (louPanTradeArray.count > section) {
//            trade = (TradeRecord*)[louPanTradeArray objectForIndex:section];
//        }
//        count = trade.progress.count;
//    }
    count = louPanTradeArray.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"cellIdentifier";
//    CustomerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
    CustomerDetailTableViewCell *cell = [[CustomerDetailTableViewCell alloc] init];
//    }
    TradeRecord *tradeRecord = nil;
    if (louPanTradeArray.count>indexPath.row) {
        tradeRecord = (TradeRecord*)[louPanTradeArray objectForIndex:indexPath.row];
        cell.tradeRecord = tradeRecord;
        cell.progressDataSource = [tradeRecord.progress objectForIndex:0];//[tradeRecord.progress objectForIndex:indexPath.row];
    }
    __weak CustomerDetailViewController *weakSelf = self;
    [cell createEncodingViewBlock:^(NSString *url) {
        if (![weakSelf isBlankString:url]) {
            EncodingView *QRCodeView = [[EncodingView alloc] initWithEncodingString:url withCustomerName:customerList.name withPhone:customerList.listPhone];
            [weakSelf.view addSubview:QRCodeView];
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    return 10;
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
/*    TradeRecord *tradeRecord = nil;
    if (louPanTradeArray.count>section) {
        tradeRecord = (TradeRecord*)[louPanTradeArray objectForIndex:section];
    }
    CustomerDetailHeaderView *view = [[CustomerDetailHeaderView alloc
                                       ]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    if (cellCountArray.count > section) {
        view.isSelected = [[cellCountArray objectForIndex:section] boolValue];
    }
    view.trade = tradeRecord;
    __weak CustomerDetailViewController *weakSelf = self;
    [view createEncodingViewBlock:^(NSString *url) {
        if (![weakSelf isBlankString:url]) {
            EncodingView *QRCodeView = [[EncodingView alloc] initWithEncodingString:url withCustomerName:customerList.name withPhone:customerList.listPhone];
            [self.view addSubview:QRCodeView];
        }
    }];
    
    [view changeOpenButtonBlock:^(BOOL isOpen) {
        if (!isOpen) {
            if (weakSelf.cellCountArray.count > section) {
                [weakSelf.cellCountArray replaceObjectForIndex:section withObject:@"0"];
            }
        }else
        {
            if (weakSelf.cellCountArray.count > section) {
                [weakSelf.cellCountArray replaceObjectForIndex:section withObject:@"1"];
            }
        }
        [weakSelf.tableView reloadData];
    }];*/
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 54)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *buildL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 34)];
    buildL.text = @"已报备楼盘";
    buildL.textColor = NAVIGATIONTITLE;
    buildL.font = FONT(15);
    [view addSubview:buildL];
    
    return view;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor = VIEWBGCOLOR;
    return view;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"khxq_jdxq"];
    BuildFollowDetailViewController *buildVC = [[BuildFollowDetailViewController alloc] init];
    TradeRecord *trade = nil;
//    if (louPanTradeArray.count > indexPath.section) {
//        trade = (TradeRecord*)[louPanTradeArray objectForIndex:indexPath.section];
//    }
    if (louPanTradeArray.count > indexPath.row) {
        trade = (TradeRecord*)[louPanTradeArray objectForIndex:indexPath.row];
    }
    buildVC.trade = trade;
    buildVC.row = indexPath.row;
    buildVC.customerId = customerList.customerId;
    buildVC.customerName = customerList.name;
    buildVC.customerPhone = customerList.listPhone;
    [self.navigationController pushViewController:buildVC animated:YES];
}

@end
