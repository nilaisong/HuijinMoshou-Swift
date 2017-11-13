//
//  CustomerListViewController.m
//  MoShou2
//
//  Created by wangzz on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerListViewController.h"
#import "CustomerTableView.h"
#import "CustomerSelectButton.h"
#import "EditCustomerView.h"
#import "HMActionSheet.h"
#import "CreateCustomerView.h"
#import "CustomerDetailViewController.h"
#import "LocalContactsViewController.h"
#import "CustomerOperationViewController.h"
#import "AddGroupMebViewController.h"
#import "XTUserScheduleViewController.h"
#import "OptionSelectedViewController.h"
#import "IQKeyboardManager.h"
#import "TipsView.h"
#import "CustomerCopyPhoneView.h"
//#import "CreateCallView.h"

#import "DataFactory+Customer.h"
//#import <CoreTelephony/CTCallCenter.h>
//#import <CoreTelephony/CTCall.h>

@interface CustomerListViewController ()<UIScrollViewDelegate,UITextFieldDelegate,CustomerTableViewCellDelegate>
{
    CGFloat      _oldOffset;
    NSString     *searchContent;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITextField *searchBarTextField;
@property (nonatomic, strong) UIScrollView *tableScrollView;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *telArray;

@property (nonatomic, strong) CustomerTableView *tableView1;
@property (nonatomic, strong) CustomerTableView *tableView2;

@property (nonatomic, strong) NSMutableArray *addressBookTemp;//通讯录获取到的联系人集合
@property (nonatomic, strong) UILabel *firstLetterLabel;

@property (nonatomic, strong) CustomerSelectButton *btnView;

@property (nonatomic, assign) int          currentIndex;
@property (nonatomic, assign) BOOL         bIsScrollTop;

@property (nonatomic, strong) UIButton     *rightBarItem;
@property (nonatomic, strong) HMActionSheet *actionSheet;
//@property (nonatomic, strong) CTCallCenter     *center;
@property (nonatomic, strong) UIWebView    *webView;
@property (nonatomic, strong) UIImageView  *msgImgView;

@property (nonatomic, assign) BOOL         bIsFirst;
@property (nonatomic, assign) BOOL         bIsScroll;
@property (nonatomic, assign) BOOL         bIsSelected;
@property (nonatomic, assign) BOOL         bIsReload;

@end

@implementation CustomerListViewController
@synthesize topView;
@synthesize searchBarTextField;
@synthesize addBtn;
@synthesize titleArray;
@synthesize telArray;

@synthesize addressBookTemp;
@synthesize firstLetterLabel;
@synthesize btnView;

@synthesize tableScrollView;
@synthesize tableView1;
@synthesize tableView2;

@synthesize currentIndex;
@synthesize bIsScrollTop;
@synthesize bIsScroll;

@synthesize rightBarItem;
@synthesize actionSheet;

- (id)init
{
    self = [super init];
    if (self) {
        _bIsFirst = YES;
        _bIsReload = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomerData:) name:@"reloadCustomer" object:nil];//添加刷新客户列表页的通知
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BACKGROUNDCOLOR;
    self.navigationBar.titleLabel.text = @"客户";
    self.navigationBar.titleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.leftBarButton.hidden = YES;
    self.navigationBar.barBackgroundImageView.backgroundColor = BLUEBTBCOLOR;
    titleArray = [[NSMutableArray alloc] init];
    addressBookTemp = [[NSMutableArray alloc] init];
    telArray = [[NSMutableArray alloc] init];
    
    UIButton *leftBarItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 22, 40, 40)];
    [leftBarItem setImage:[UIImage imageNamed:@"icon_richeng"] forState:UIControlStateNormal];
//    [leftBarItem setImage:[UIImage imageNamed:@"icon_richeng_h"] forState:UIControlStateHighlighted];
    [leftBarItem addTarget:self action:@selector(toggleLeftBarButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:leftBarItem];
    
    _msgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 34, 6, 6)];
    [_msgImgView setImage:[UIImage imageNamed:@"椭圆-7"]];
    _msgImgView.hidden = YES;
    [self.navigationBar addSubview:_msgImgView];
    
    rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
    [rightBarItem setImage:[UIImage imageNamed:@"button_addcustomer"] forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(toggleRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:rightBarItem];

    [self hasNetwork];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (!_bIsReload) {
        if (!_bIsFirst) {
            if (tableView1.top==0) {
                tableView1.top = 0-20;
            }
            if (tableView2.top == 0)
            {
                tableView2.top = 0-20;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (bIsScroll) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            _bIsFirst = NO;
        }
        _bIsSelected = NO;
    }
}

- (void)dealloc
{
    _bIsFirst = YES;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TouchExit"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomerView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomerRemind" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCustomerListData" object:nil];
    
}
//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableScrollView.superview) {
        self.tableScrollView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-self.tabBarController.tabBar.height-0.5);
    }
//    if (self.tableView1.superview) {
//        self.tableView1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-self.tabBarController.tabBar.height);
//    }
//    if (self.tableView2.superview) {
//        self.tableView2.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-self.tabBarController.tabBar.height);
//    }
}

- (void)hasNetwork
{
    __weak CustomerListViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    
    currentIndex = 0;
    bIsScroll = NO;
    _bIsFirst = YES;
    bIsScrollTop = YES;
    
    firstLetterLabel=[[UILabel alloc] init];
    CGFloat x = kMainScreenWidth*2/3-25;
    CGFloat y = self.view.bounds.size.height*2/3-50;
    firstLetterLabel.frame=CGRectMake(x, y, 50, 50);
    firstLetterLabel.backgroundColor=[UIColor colorWithHexString:@"c9c9ce" alpha:0.6];
    firstLetterLabel.textColor=[UIColor colorWithHexString:@"939393"];
    firstLetterLabel.font=[UIFont boldSystemFontOfSize:30];
    firstLetterLabel.textAlignment = NSTextAlignmentCenter;
    [firstLetterLabel.layer setMasksToBounds:YES];
    [firstLetterLabel.layer setCornerRadius:5];
    firstLetterLabel.hidden = YES;
    
    if (titleArray.count>0) {
        [titleArray removeAllObjects];
    }
    OptionData* item1 = [[OptionData alloc] init];
    item1.itemName = @"全部";
    item1.itemValue=@"0";
    [titleArray insertObject:item1 forIndex:0];
    [self createTableView];
    [self createHeaderViewOfTable:viewTopY];
    [self.view addSubview:topView];
    
    [self.view bringSubviewToFront:firstLetterLabel];
    [self.view addSubview:firstLetterLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomerViewData:) name:@"reloadCustomerView" object:nil];//添加刷新客户列表页的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCustomerListData:) name:@"refreshCustomerListData" object:nil];//添加刷新客户列表页的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRemindData:) name:@"reloadCustomerRemind" object:nil];//添加刷新客户列表页的通知
    
    BOOL bHasStore = [self verifyTheRulesWithShouldJump:NO];
    
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerListViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getCustomerListWithKeyword:@"" andGroupId:@"0" withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!actionResult.success) {
                [self showTips:actionResult.message];
            }
            if (self.addressBookTemp.count>0) {
                [self.addressBookTemp removeAllObjects];
            }
            [self.addressBookTemp addObjectsFromArray:result.customerList];
            [[DataFactory sharedDataFactory] getTodayRemindStatusWithCallBack:^(ActionResult *result,BOOL hasRemind) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (hasRemind) {
                        self.msgImgView.hidden = NO;
                    }
                    if (!result.success) {
                        [self showTips:result.message];
                    }
                });
            }];
            
            [[DataFactory sharedDataFactory] getCustomerGroupListWithCallBack:^(ActionResult *actionResult,NSArray *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!actionResult.success) {
                        [self showTips:actionResult.message];
                    }
                    if (self.titleArray.count>0) {
                        [self.titleArray removeAllObjects];
                    }
                    [self.titleArray addObjectsFromArray:result];
                    OptionData* item1 = [[OptionData alloc] init];
                    item1.itemName = @"全部";
                    item1.itemValue=@"0";
                    [self.titleArray insertObject:item1 forIndex:0];
                    [btnView removeAllSubviews];
                    [btnView removeFromSuperview];
                    btnView = nil;
                    [self createButtonView];
                    tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
                    if (currentIndex%2) {
                        self.tableView2.left = self.tableScrollView.contentOffset.x;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                        }else
                        {
                            [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        }
                        
                    }else{
                        self.tableView1.left = self.tableScrollView.contentOffset.x;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                        }else
                        {
                            [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        }
                    }
                });
            }];
        });
    }];
}

- (void)reloadCustomerData:(NSNotification*)notification
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TouchExit"]) {
        if (!_bIsFirst) {
            _bIsReload = YES;
        }
    }else
    {
        _bIsReload = NO;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomerRemind" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomerView" object:nil];
    [self.view removeAllSubviews];
    [self viewDidLoad];
}

- (void)reloadCustomerViewData:(NSNotification*)notification
{
    OptionData *option = nil;
    if (titleArray.count > currentIndex) {
        option = [titleArray objectForIndex:currentIndex];
    }
    [self requestCustomerListByKeyword:searchBarTextField.text AndGroupId:option.itemValue WithIndex:currentIndex WithFlag:YES];
}

- (void)reloadRemindData:(NSNotification*)notification
{
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerListViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getTodayRemindStatusWithCallBack:^(ActionResult *result,BOOL hasRemind) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!result.success) {
                [self showTips:result.message];
            }
            if (hasRemind) {
                self.msgImgView.hidden = NO;
            }else
            {
                self.msgImgView.hidden = YES;
            }
        });
    }];
}

- (void)refreshCustomerListData:(NSNotification*)notification
{
    if (titleArray.count<3) {
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = [self setRotationAnimationWithView];
//        __weak CustomerListViewController *weakSelf = self;
        [[DataFactory sharedDataFactory] getCustomerGroupListWithCallBack:^(ActionResult *actionResult,NSArray *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!actionResult.success) {
                    [self showTips:actionResult.message];
                }
                if (self.titleArray.count>0) {
                    [self.titleArray removeAllObjects];
                }
                [self.titleArray addObjectsFromArray:result];
                OptionData* item1 = [[OptionData alloc] init];
                item1.itemName = @"全部";
                item1.itemValue=@"0";
                [self.titleArray insertObject:item1 forIndex:0];
                
                [[DataFactory sharedDataFactory] getTodayRemindStatusWithCallBack:^(ActionResult *result,BOOL hasRemind) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![self removeRotationAnimationView:loadingView]) {
                            return ;
                        }
                        if (hasRemind) {
                            self.msgImgView.hidden = NO;
                        }else
                        {
                            self.msgImgView.hidden = YES;
                        }
                    });
                }];
                
                [btnView removeAllSubviews];
                [btnView removeFromSuperview];
                btnView = nil;
                [self createButtonView];
                tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
                if (titleArray.count > currentIndex) {
                    OptionData *option = [titleArray objectForIndex:currentIndex];
                    [self requestCustomerListByKeyword:searchBarTextField.text AndGroupId:option.itemValue WithIndex:currentIndex WithFlag:YES];
                }
            });
        }];
    }else{
        if (titleArray.count > currentIndex) {
            OptionData *option = [titleArray objectForIndex:currentIndex];
            [self requestCustomerListByKeyword:searchBarTextField.text AndGroupId:option.itemValue WithIndex:currentIndex WithFlag:YES];
        }
    }
}

- (void)requestCustomerListByKeyword:(NSString*)keyWord AndGroupId:(NSString*)groupId WithIndex:(NSInteger)index WithFlag:(BOOL)flag
{
//    __weak CustomerListViewController *weakSelf = self;
    BOOL bHasStore = [self verifyTheRulesWithShouldJump:NO];
    if (![self createNoNetWorkViewWithReloadBlock:^{
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = nil;
        if (flag) {
            loadingView = [self setRotationAnimationWithView];
        }
        [[DataFactory sharedDataFactory] getCustomerListWithKeyword:keyWord andGroupId:groupId withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag)
                {
                    if (![self removeRotationAnimationView:loadingView]) {
                        return ;
                    }
                }
                if (self.addressBookTemp.count > 0) {
                    [self.addressBookTemp removeAllObjects];
                }
                [self.addressBookTemp addObjectsFromArray:result.customerList];
                if (index%2) {
                    self.tableView2.left = self.tableScrollView.contentOffset.x;
                    if (self.addressBookTemp.count>0) {
                        [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                    }else
                    {
                        [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        if ([self isBlankString:self.searchBarTextField.text]) {
                            self.tableView2.searchEmptyL.hidden = YES;
                        }else {
                            if (!flag || ![self isBlankString:self.searchBarTextField.text]) {
                                self.tableView2.searchEmptyL.hidden = NO;
                            }else
                            {
                                self.tableView2.searchEmptyL.hidden = YES;
                            }
                        }
                    }
                    
                }else{
                    self.tableView1.left = self.tableScrollView.contentOffset.x;
                    if (self.addressBookTemp.count>0) {
                        [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                    }else
                    {
                        [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        if ([self isBlankString:self.searchBarTextField.text]) {
                            self.tableView1.searchEmptyL.hidden = YES;
                        }else {
                            if (!flag || ![self isBlankString:self.searchBarTextField.text]) {
                                self.tableView1.searchEmptyL.hidden = NO;
                            }else
                            {
                                self.tableView1.searchEmptyL.hidden = YES;
                            }
                        }
                    }
                }
            });
        }];
    }])
    {
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = nil;
        if (flag) {
            loadingView = [self setRotationAnimationWithView];
        }
        [[DataFactory sharedDataFactory] getCustomerListWithKeyword:keyWord andGroupId:groupId withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag)
                {
                    if (![self removeRotationAnimationView:loadingView]) {
                        return ;
                    }
                }
                if (self.addressBookTemp.count > 0) {
                    [self.addressBookTemp removeAllObjects];
                }
                [self.addressBookTemp addObjectsFromArray:result.customerList];
                if (index%2) {
                    self.tableView2.left = self.tableScrollView.contentOffset.x;
                    if (self.addressBookTemp.count>0) {
                        [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                    }else
                    {
                        [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        if ([self isBlankString:self.searchBarTextField.text]) {
                            self.tableView2.searchEmptyL.hidden = YES;
                        }else {
                            if (!flag || ![self isBlankString:self.searchBarTextField.text]) {
                                self.tableView2.searchEmptyL.hidden = NO;
                            }else
                            {
                                self.tableView2.searchEmptyL.hidden = YES;
                            }
                        }
                    }
                    
                }else{
                    self.tableView1.left = self.tableScrollView.contentOffset.x;
                    if (self.addressBookTemp.count>0) {
                        [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                    }else
                    {
                        [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        if ([self isBlankString:self.searchBarTextField.text]) {
                            self.tableView1.searchEmptyL.hidden = YES;
                        }else {
                            if (!flag || ![self isBlankString:self.searchBarTextField.text]) {
                                self.tableView1.searchEmptyL.hidden = NO;
                            }else
                            {
                                self.tableView1.searchEmptyL.hidden = YES;
                            }
                        }
                    }
                }
            });
        }];
    }
}

- (void)createTableView
{
    tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY-self.tabBarController.tabBar.height-0.5)];
    tableScrollView.backgroundColor = [UIColor whiteColor];
    tableScrollView.delegate = self;
    tableScrollView.pagingEnabled = YES;
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.bounces = NO;
    tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
    [self.view addSubview:tableScrollView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, tableScrollView.bottom, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = VIEWBGCOLOR;
    [self.view addSubview:lineView];
    
    __weak CustomerListViewController *weakSelf = self;
    if ([self verifyTheRulesWithShouldJump:NO]) {
        tableView1 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, 0, kMainScreenWidth, tableScrollView.height) tableType:0 withHasShop:YES];
    }else
    {
        tableView1 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, 0, kMainScreenWidth, tableScrollView.height) tableType:0 withHasShop:NO];//kMainScreenHeight-viewTopY-49
    }
    tableView1.cellDelegate = self;
    tableView1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView1.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [tableScrollView addSubview:tableView1];
    
    if ([self verifyTheRulesWithShouldJump:NO]) {
        tableView2 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:1 AndFrame:CGRectMake(kMainScreenWidth, 0, tableScrollView.width, tableScrollView.height) tableType:0 withHasShop:YES];
    }else
    {
        tableView2 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:1 AndFrame:CGRectMake(kMainScreenWidth, 0, tableScrollView.width, tableScrollView.height) tableType:0 withHasShop:NO];
    }
    tableView2.cellDelegate = self;
    tableView2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView2.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [tableScrollView addSubview:tableView2];
}

- (void)createHeaderViewOfTable:(CGFloat)theY
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, theY, kMainScreenWidth-15, 88)];
    topView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(10, 7, topView.width-20, 30)];
    searchBarView.backgroundColor = [UIColor whiteColor];
    [searchBarView.layer setCornerRadius:5];
    [searchBarView.layer setMasksToBounds:YES];
    [topView addSubview:searchBarView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, 14, 14)];
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [topView addSubview:searchImageView];
    
    searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(37, 10, topView.width - 47, 24)];
    searchBarTextField.delegate = self;
    searchBarTextField.returnKeyType = UIReturnKeySearch;
    searchBarTextField.placeholder = @"请输入客户姓名或手机号";
    searchBarTextField.text = searchContent;
    [searchBarTextField setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    searchBarTextField.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    searchBarTextField.textColor = NAVIGATIONTITLE;
    searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchBarTextField addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    searchBarTextField.delegate = self;
    [topView addSubview:searchBarTextField];

    UIView *scrollBgView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBarView.bottom+7, topView.width, 44)];
    scrollBgView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:scrollBgView];
    
    [self createButtonView];

    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(topView.width-30, scrollBgView.top+7, 30, 30)];
    [addBtn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"icon_tianjia_h"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(toggleAddButton) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:addBtn];
}

- (void)createButtonView
{
    btnView = [[CustomerSelectButton alloc] initWithFrame:CGRectMake(0, 44+5, topView.width - 10 - 30, 39)];//预留出4像素的蓝线
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.padding = UIEdgeInsetsMake(0, 10, 0, 10); //上,左,下,右,的边距
    btnView.lastSelected = currentIndex;
    btnView.horizontalSpace = 10;                       //横向间隔
//    headView.verticalSpace = 10;                         //纵向间隔
    btnView.dataSource = titleArray;
    __weak CustomerListViewController *customer = self;
    //数据源
    [btnView buttonSeleteBlock:^(int index,BOOL isSelected){
        if (customer.currentIndex != index) {
            customer.currentIndex = index;
            OptionData *option = nil;
            if (customer.titleArray.count > customer.currentIndex) {
                option = [customer.titleArray objectForIndex:index];
            }
            [customer.tableScrollView setContentOffset:CGPointMake(index*customer.tableScrollView.width, 0)];
            if (index == 0) {
                customer.navigationBar.titleLabel.text = @"客户";
                
                [customer.rightBarItem removeFromSuperview];
                customer.rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
                [customer.rightBarItem setImage:[UIImage imageNamed:@"button_addcustomer"] forState:UIControlStateNormal];
                [customer.rightBarItem addTarget:customer action:@selector(toggleRightBarButton) forControlEvents:UIControlEventTouchUpInside];
                [customer.navigationBar addSubview:customer.rightBarItem];
            }else
            {
                customer.navigationBar.titleLabel.text = option.itemName;
                [customer.rightBarItem removeFromSuperview];
                customer.rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
                [customer.rightBarItem setImage:[UIImage imageNamed:@"icon_customer_edit"] forState:UIControlStateNormal];
//                [customer.rightBarItem setImage:[UIImage imageNamed:@"icon_edit_h"] forState:UIControlStateHighlighted];
                [customer.rightBarItem addTarget:customer action:@selector(toggleEditCustomerButton) forControlEvents:UIControlEventTouchUpInside];
                [customer.navigationBar addSubview:customer.rightBarItem];
            }
            if (!customer.bIsReload) {
                customer.tableView1.top = 0;
                customer.tableView2.top = 0;
            }
            customer.bIsSelected = YES;
            [customer requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:index WithFlag:YES];
            
        }
    }];
    [topView addSubview:btnView];
}

- (void)textFieldDidChanged
{
    __weak CustomerListViewController *customer = self;
    OptionData *option = nil;
    if (titleArray.count > currentIndex) {
        option = [titleArray objectForIndex:currentIndex];
    }
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:customer.currentIndex WithFlag:NO];}]) {
        [self requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:customer.currentIndex WithFlag:NO];
    }
}

- (void)toggleEditCustomerButton
{
    [MobClick event:@"khlb_bianji"];
    EditCustomerView *editView = [[EditCustomerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
    __weak CustomerListViewController *weakSelf = self;
    [editView editCustomerBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 0:
            {
                if (weakSelf.bIsScroll) {
                    weakSelf.bIsFirst = NO;
                    weakSelf.bIsSelected = NO;
                }
                [MobClick event:@"khlb_bj_tjzy"];
                AddGroupMebViewController *aGMVC = [[AddGroupMebViewController alloc] init];
                if (weakSelf.titleArray.count > weakSelf.currentIndex) {
                    aGMVC.option = (OptionData*)[weakSelf.titleArray objectForIndex:weakSelf.currentIndex];
                }
                aGMVC.custArray = weakSelf.addressBookTemp;
                aGMVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:aGMVC animated:YES];
            }
                break;
            case 1:
            {
                [MobClick event:@"khlb_bj_xgzm"];
                CreateCustomerView *customerGroupView = [[CreateCustomerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, weakSelf.view.bounds.size.height)];
                OptionData *option = nil;
                if (weakSelf.titleArray.count > weakSelf.currentIndex) {
                    option = [weakSelf.titleArray objectForIndex:weakSelf.currentIndex];
                }
                customerGroupView.content = option.itemName;
                [customerGroupView createCustomerBlock:^(NSString *content){
                    if ([weakSelf isBlankString:content]) {
//                        [weakSelf showTips:@"组名不能为空"];
                        [TipsView showTips:@"组名不能为空" inView:[UIApplication sharedApplication].keyWindow];
                    }
                    for (OptionData *data in weakSelf.titleArray) {
                        if ([data.itemName isEqualToString:content]) {
//                            [weakSelf showTips:@"当前组名已存在，请换个试试"];
                            [TipsView showTips:@"当前组名已存在，请换个试试" inView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                    }
                    
                    if (weakSelf.btnView != nil) {
                        if (![weakSelf isBlankString:content]) {
                            UIImageView * loadingView = [weakSelf setRotationAnimationWithView];
                            [[DataFactory sharedDataFactory] editGroupWithGroupName:content AndGroupId:option.itemValue withCallBack:^(ActionResult *result) {
                                if (![self removeRotationAnimationView:loadingView]) {
                                    return ;
                                }
                                [customerGroupView removeFromSuperview];
                                if (result.success) {
                                    [self.btnView removeAllSubviews];
                                    [self.btnView removeFromSuperview];
                                    self.btnView = nil;
                                    OptionData *data = [[OptionData alloc] init];
                                    data.itemName = content;
                                    data.itemValue = option.itemValue;
                                    if (self.titleArray.count > self.currentIndex) {
                                        [self.titleArray replaceObjectForIndex:self.currentIndex withObject:data];
                                    }
                                    [self showTips:result.message];
                                    if (self.btnView!=nil) {
                                        [self.btnView removeFromSuperview];
                                    }
                                    [self createButtonView];
                                }else
                                {
                                    [self showTips:result.message];
                                }
                            }];
                        }
//                        [weakSelf createButtonView];
                    }
                    weakSelf.tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*weakSelf.titleArray.count, 0);
                }];
                [customerGroupView cancelCustomerBlock:^{
                    [customerGroupView removeFromSuperview];
                }];
                [weakSelf.tabBarController.view addSubview:customerGroupView];
            }
                break;
            case 2:
            {
                [MobClick event:@"khlb_bj_scz"];
                if (titleArray.count <= 3) {
                    [weakSelf showTips:@"客户组数不能小于3，不能删除当前组"];
                    
                }else{
                    actionSheet = [[HMActionSheet alloc] initWithDelegate:weakSelf andTitle:@"确定删除组?" andContent:@"仅删除组，其组下客户将移至“全部”组"];
                    [weakSelf.tabBarController.view addSubview:actionSheet];
                }
            }
                break;
                
            default:
                break;
        }
    }];
    [self.tabBarController.view addSubview:editView];
}

-(void)firstBtnClickAction{
    [actionSheet disappear];
    
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerListViewController *weakSelf = self;
    OptionData *data = nil;
    if (titleArray.count > currentIndex) {
        data = (OptionData*)[titleArray objectForIndex:currentIndex];
    }
    BOOL bHasStore = [self verifyTheRulesWithShouldJump:NO];
    [[DataFactory sharedDataFactory] deleteGroupWithGroupId:data.itemValue withCallBack:^(ActionResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.success) {
                [self showTips:result.message];
                [self.titleArray removeObjectForIndex:self.currentIndex];
                self.currentIndex = 0;
//                [weakSelf.tableScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                
                self.navigationBar.titleLabel.text = @"客户";
                [self.rightBarItem removeFromSuperview];
                self.rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
                [self.rightBarItem setImage:[UIImage imageNamed:@"button_addcustomer"] forState:UIControlStateNormal];
                [self.rightBarItem addTarget:self action:@selector(toggleRightBarButton) forControlEvents:UIControlEventTouchUpInside];
                [self.navigationBar addSubview:self.rightBarItem];
                
                if (self.btnView!=nil) {
                    [self.btnView removeFromSuperview];
                }
                [self createButtonView];
                [self.btnView seletedbBtnWithScrollIndex:0];
                self.tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*self.titleArray.count, 0);
                [self.tableScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                if (!self.bIsScrollTop) {
                    if (!self.bIsReload) {
                        if (self.bIsFirst) {
                            self.tableView1.top = 0;
                        }else
                        {
                            self.tableView1.top = -20;
                        }
                    }
                }
                [[DataFactory sharedDataFactory] getCustomerListWithKeyword:self.searchBarTextField.text andGroupId:@"0" withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![self removeRotationAnimationView:loadingView]) {
                            return ;
                        }

                        if (self.addressBookTemp.count > 0) {
                            [self.addressBookTemp removeAllObjects];
                        }
                        [self.addressBookTemp addObjectsFromArray:result.customerList];
                        
                        self.tableView1.left = 0;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:bHasStore];
                        }else
                        {
                            [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                        }
                    });
                }];
                
            }else
            {
                [self showTips:result.message];
            }
        });
    }];
}

- (void)toggleLeftBarButton
{
    if (bIsScroll) {
        _bIsFirst = NO;
        _bIsSelected = NO;
    }
    [MobClick event:@"khlb_wdrc"];
    XTUserScheduleViewController *scheduleVC = [[XTUserScheduleViewController alloc] init];
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

- (void)toggleRightBarButton
{
    if (bIsScroll) {
        _bIsFirst = NO;
        _bIsSelected = NO;
    }
    [MobClick event:@"khlb_tjkh"];
    CustomerOperationViewController *operationVC = [[CustomerOperationViewController alloc] init];
    operationVC.customerViewCtrlType = kAddNewCustomer;
    [self.navigationController pushViewController:operationVC animated:YES];
}

- (void)toggleAddButton
{
    [MobClick event:@"khlb_xjkhz"];
    if (titleArray.count>=8) {
        [self showTips:@"客户组最多为8个，不要贪多哦~"];
        return;
    }
    if (bIsScroll) {
        _bIsFirst = NO;
        _bIsSelected = NO;
    }
    BOOL bHasStore = [self verifyTheRulesWithShouldJump:NO];
    CreateCustomerView *customerGroupView = [[CreateCustomerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
    customerGroupView.content = @"";
    __weak CustomerListViewController *customer = self;
    [customerGroupView createCustomerBlock:^(NSString *content){
        if ([customer isBlankString:content]) {
//            [customer showTips:@"组名不能为空"];
            [TipsView showTips:@"组名不能为空" inView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        for (OptionData *data in customer.titleArray) {
            if ([data.itemName isEqualToString:content]) {
//                [customer showTips:@"当前组名已存在，请换个试试"];
                [TipsView showTips:@"当前组名已存在，请换个试试" inView:[UIApplication sharedApplication].keyWindow];
                return;
            }
        }
        [customerGroupView removeFromSuperview];
        
        if (customer.btnView != nil) {
            if (![customer isBlankString:content]) {
                UIImageView * loadingView = [customer setRotationAnimationWithView];
                [[DataFactory sharedDataFactory] createGroupWithGroupName:content withCallBack:^(ActionResult *result,OptionData*data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![self removeRotationAnimationView:loadingView]) {
                            return ;
                        }
                        if (result.success) {
                            if (data != nil) {
                                [self.btnView removeAllSubviews];
                                [self.btnView removeFromSuperview];
                                self.btnView = nil;
//                                [customer.titleArray insertObject:data atIndex:1];
                                [self.titleArray addObject:data];
                            }
                            [self showTips:result.message];
                            
                            self.navigationBar.titleLabel.text = data.itemName;
                            if (self.currentIndex == 0) {
                                [self.rightBarItem removeFromSuperview];
                                self.rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
                                [self.rightBarItem setImage:[UIImage imageNamed:@"icon_customer_edit"] forState:UIControlStateNormal];
                                [self.rightBarItem addTarget:self action:@selector(toggleEditCustomerButton) forControlEvents:UIControlEventTouchUpInside];
                                [self.navigationBar addSubview:self.rightBarItem];
                            }
                            
                            self.currentIndex = (int)self.titleArray.count-1;
                            
                            if (self.btnView!=nil) {
                                [self.btnView removeFromSuperview];
                            }
                            [self createButtonView];
                            [self.btnView seletedbBtnWithScrollIndex:self.currentIndex];
                            self.tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*self.titleArray.count, 0);
                            [self.tableScrollView setContentOffset:CGPointMake(kMainScreenWidth*(self.titleArray.count-1), 0) animated:YES];
                            if (!self.bIsScrollTop) {
                                if (!self.bIsReload) {
                                    if (self.bIsFirst) {
                                        self.tableView1.top = 0;
                                    }else
                                    {
                                        self.tableView1.top = -20;
                                    }
                                }
                            }
                            if (self.addressBookTemp.count > 0) {
                                [self.addressBookTemp removeAllObjects];
                            }
                            if (self.currentIndex%2) {
                                self.tableView2.left = kMainScreenWidth*(self.titleArray.count-1);
                                [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                                if ([self isBlankString:self.searchBarTextField.text]) {
                                    self.tableView2.searchEmptyL.hidden = YES;
                                }else {
                                    self.tableView2.searchEmptyL.hidden = NO;
                            }
                                
                            }else{
                                self.tableView1.left = kMainScreenWidth*(self.titleArray.count-1);
                                [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:bHasStore];
                                if ([self isBlankString:self.searchBarTextField.text]) {
                                    self.tableView1.searchEmptyL.hidden = YES;
                                }else {
                                    self.tableView1.searchEmptyL.hidden = NO;
                                }
                            }
                        }else
                        {
                            [self showTips:result.message];
                        }
                    });
                }];
            }
        }
    }];
    [customerGroupView cancelCustomerBlock:^{
        [customerGroupView removeFromSuperview];
    }];
    [self.tabBarController.view addSubview:customerGroupView];
}

- (void)addLocalCustomer:(CustomerTableView*)tableView
{
//    if (bIsScroll) {
//        _bIsFirst = NO;
//        _bIsSelected = NO;
//    }
//    LocalContactsViewController *addressContact = [[LocalContactsViewController alloc] init];
//    addressContact.bIsCustomerList = YES;
////    [addressContact returnResultBlock:^(NSInteger index,NSString *text,NSString *detailText){
////        
////    }];
//    [self.navigationController pushViewController:addressContact animated:YES];
    if (bIsScroll) {
        _bIsFirst = NO;
        _bIsSelected = NO;
    }
    [MobClick event:@"khlb_tjkh"];
    CustomerOperationViewController *operationVC = [[CustomerOperationViewController alloc] init];
    operationVC.customerViewCtrlType = kAddNewCustomer;
    [self.navigationController pushViewController:operationVC animated:YES];
}

- (void)addGroupMember:(CustomerTableView*)tableView
{
    if (bIsScroll) {
        _bIsFirst = NO;
        _bIsSelected = NO;
    }
    AddGroupMebViewController *aGMVC = [[AddGroupMebViewController alloc] init];
    if (titleArray.count > currentIndex) {
        aGMVC.option = (OptionData*)[titleArray objectForIndex:currentIndex];
    }
    aGMVC.custArray = addressBookTemp;
//    aGMVC.lastTitle = self.navigationBar.titleLabel.text;
    aGMVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aGMVC animated:YES];
}

- (void)CustomerDidSelectedCell:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath Customer:(Customer*)cust
{
    if (bIsScroll) {
        _bIsFirst = NO;
        _bIsSelected = NO;
    }
    CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc] init];
    detailVC.custId = cust.customerId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//复制电话
- (void)customerTableView:(CustomerTableView*)tableView CopyWithCustomer:(Customer*)cust
{
    CustomerCopyPhoneView *custCopyView = [[CustomerCopyPhoneView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
    custCopyView.phoneArray = cust.phoneList;
//    __weak CustomerListViewController *customer = self;
    [custCopyView copyCustomerPhoneBlock:^(NSInteger number) {
        MobileVisible *mobile = nil;
        if (cust.phoneList.count > 0) {
            mobile = (MobileVisible*)[cust.phoneList objectForIndex:0];
        }
        NSString *telString = mobile.hidingPhone;
        if (number == 1)
        {
            telString = mobile.totalPhone;
        }
        [[UIPasteboard generalPasteboard] setString:telString];
    }];
    [self.view addSubview:custCopyView];
}

- (void)customerTableView:(CustomerTableView*)tableView CallWithCustomer:(Customer*)cust
{
    [MobClick event:@"khlb_bddh"];
//    int x = 1+arc4random() % 3;
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    if (x==1) {
//        [array addObject:@"15890123456"];
//    }else if (x==2)
//    {
//        [array addObject:@"15890123456"];
//        [array addObject:@"158****0925"];
//        [array addObject:@"15845890925"];
//    }else if (x==3)
//    {
//        [array addObject:@"15890123456"];
//        [array addObject:@"13671206275"];//[array addObject:@"158****0925"];//
//        [array addObject:@"15945892580"];
//    }
//    for (int i=0; i<array.count; i++) {
//        if ([[array objectForIndex:i] rangeOfString:@"****"].location == NSNotFound) {
//            [telArray addObject:[array objectForIndex:i]];
//        }
//    }
//    
//    if (telArray.count>1) {
//        CreateCallView *callView = [[CreateCallView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
//        callView.telArray = telArray;
//        __weak CustomerListViewController *customer = self;
//        [callView callCustomerBlock:^(NSInteger number) {
//            if (customer.webView == nil) {
//                customer.webView = [[UIWebView alloc] init];
//            }
//            DLog(@"%p", customer.webView);
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[customer.telArray objectForIndex:number]]];
//            DLog(@"phoneNumber:%@",[customer.telArray objectForIndex:number]);
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            
//            [customer.webView loadRequest:request];
//            [customer.view addSubview:customer.webView];
//        }];
//        [callView cancelViewBlock:^{
//            [customer.telArray removeAllObjects];
//            [callView removeFromSuperview];
//        }];
//        [[UIApplication sharedApplication].keyWindow addSubview:callView];
//    }else
//    {
    
    if (cust.phoneList.count > 0) {
        NSString *phone = @"";
        MobileVisible *mobile = (MobileVisible*)[cust.phoneList objectForIndex:0];
        phone = mobile.hidingPhone;
        if (![self isBlankString:mobile.hidingPhone] && ![self isBlankString:mobile.totalPhone]) {
            if ([mobile.hidingPhone rangeOfString:@"****"].location != NSNotFound) {
                phone = mobile.totalPhone;
            }
        }
        if (_webView == nil) {
            _webView = [[UIWebView alloc] init];
        }
        DLog(@"%p", _webView);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
        DLog(@"phoneNumber:%@",cust.listPhone);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [_webView loadRequest:request];
        [self.view addSubview:_webView];
        [telArray removeAllObjects];
    }
    
//    }
    
#pragma mark - 监听电话状态，暂时砍掉该功能
    //        customer.center.callEventHandler = ^(CTCall *call){
    //            if ([call.callState isEqualToString:CTCallStateDisconnected])
    //            {
    //                NSLog(@"Call has been disconnected");
    //            }
    //            else if ([call.callState isEqualToString:CTCallStateConnected])
    //            {
    //                NSLog(@"Call has just been connected");
    //            }
    //            else if([call.callState isEqualToString:CTCallStateIncoming])
    //            {
    //                NSLog(@"Call is incoming");
    //            }
    //            else if ([call.callState isEqualToString:CTCallStateDialing])
    //            {
    //                NSLog(@"call is dialing");
    //            }
    //            else
    //            {
    //                NSLog(@"Nothing is done");
    //            }
    //        };
}
//delete by wangzz 161020
//- (void)customerTableView:(CustomerTableView*)tableView ReportWithCustId:(Customer*)cust
//{
////    if ([cust.count integerValue] == 0) {
////        [self showTips:@"当前客户报备数已达上限"];
////        return;
////    }
//    if (bIsScroll) {
//        _bIsFirst = NO;
//        _bIsSelected = NO;
//    }
//    OptionSelectedViewController *optionSelected = [[OptionSelectedViewController alloc] init];
//    optionSelected.custId = cust.customerId;
//    optionSelected.count = cust.count;
//    optionSelected.name = cust.name;
//    optionSelected.sex = cust.sex;
//    optionSelected.phone = cust.listPhone;
//    
////    if ([cust.listPhone rangeOfString:@"****"].location != NSNotFound) {
////        optionSelected.bIsFullPhone = @"0";
////    }else
////    {
////        optionSelected.bIsFullPhone = @"1";
////    }
//    optionSelected.optionSelType = kCustomerListVC ;
//    __weak CustomerListViewController *weakSelf = self;
//    [optionSelected returnResultBlock:^(NSMutableArray *array,NSMutableDictionary*dic,NSMutableDictionary*confirmDic){
//        if (weakSelf.currentIndex%2) {
//            [weakSelf.tableView2 reloadData];
//        }else
//        {
//            [weakSelf.tableView1 reloadData];
//        }
//    }];
//    [self.navigationController pushViewController:optionSelected animated:YES];
//}
#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CustomerTableView"]) {
//        return NO;
//    }
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}
//
//- (void)handleTapGesture:(UITapGestureRecognizer*)recognizer
//{
//    [searchBarTextField resignFirstResponder];
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    bIsScroll = YES;
    _bIsSelected = NO;
    if (!_bIsReload) {
        if (currentIndex%2) {
            if (_bIsFirst) {
                tableView2.top = 0;
            }else
            {
                tableView2.top = 0-20;
            }
        }else{
            if (_bIsFirst) {
                tableView1.top = 0;
            }else
            {
                tableView1.top = 0-20;
            }
        }
    }
    int index = (int)(tableScrollView.contentOffset.x/kMainScreenWidth);
    if (currentIndex != index) {
        currentIndex = index;
        OptionData *option = nil;
        if (titleArray.count > currentIndex) {
            option = [titleArray objectForIndex:index];
        }
        [btnView seletedbBtnWithScrollIndex:index];
        if (index == 0) {
            self.navigationBar.titleLabel.text = @"客户";
            [rightBarItem removeFromSuperview];
            rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
            [rightBarItem setImage:[UIImage imageNamed:@"button_addcustomer"] forState:UIControlStateNormal];
            [rightBarItem addTarget:self action:@selector(toggleRightBarButton) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationBar addSubview:rightBarItem];
        }else
        {
            self.navigationBar.titleLabel.text = option.itemName;
            [rightBarItem removeFromSuperview];
            rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 22, 40, 40)];
            [rightBarItem setImage:[UIImage imageNamed:@"icon_customer_edit"] forState:UIControlStateNormal];
            [rightBarItem addTarget:self action:@selector(toggleEditCustomerButton) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationBar addSubview:rightBarItem];
        }
        [self requestCustomerListByKeyword:searchBarTextField.text AndGroupId:option.itemValue WithIndex:index WithFlag:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.8];
        CGRect rect = [topView frame];
        rect.origin.x = 0;
        rect.origin.y = viewTopY;
        [topView setFrame:rect];
        [self.view bringSubviewToFront:self.navigationBar];
        [UIView commitAnimations];
        if (!bIsScrollTop) {
            bIsScrollTop = YES;
        }
        if (!_bIsReload) {
            if (index%2) {
                if (_bIsFirst) {
                    tableView2.top = 0;
                }else
                {
                    tableView2.top = 0-20;
                }
            }else{
                if (_bIsFirst) {
                    tableView1.top = 0;
                }else
                {
                    tableView1.top = 0-20;
                }
            }
        }
    }
    DLog(@"currentIndex = %d",currentIndex);
}
#pragma mark - tableview上下滑动
-(void)scrollTableView:(UIScrollView *)scrollView{
    searchContent = searchBarTextField.text;
    [searchBarTextField resignFirstResponder];
    int index = (int)(tableScrollView.contentOffset.x/kMainScreenWidth)%2;
    CGFloat height;
    if (index) {
        height = tableView2.height;
    }else{
        height = tableView1.height;
    }
    if (scrollView.contentOffset.y > _oldOffset && scrollView.contentOffset.y > 88) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        if (bIsScrollTop) {
            bIsScrollTop = NO;
            bIsScroll = YES;
            NSLog(@"向上滑动！");
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.8];
            CGRect rect = [topView frame];
            
            rect.origin.x = 0;
            rect.origin.y = -24;
            [topView setFrame:rect];
            if (!_bIsReload) {
                if (index) {
                    if (_bIsFirst) {
                        tableView2.top = 0;
                    }else
                    {
                        tableView2.top = 0-20;
                    }
                    if (_bIsSelected) {
                        tableView2.top = 0;
                    }
                }else{
                    if (_bIsFirst) {
                        tableView1.top = 0;
                    }else
                    {
                        tableView1.top = 0-20;
                    }
                    if (_bIsSelected) {
                        tableView1.top = 0;
                    }
                }
            }
            [self.view bringSubviewToFront:self.navigationBar];
            [UIView commitAnimations];
        }
    }
    else if (scrollView.contentOffset.y >= scrollView.contentSize.height - height)
    {
        if (!bIsScrollTop) {
            NSLog(@"滑到底部！");
            bIsScrollTop = YES;
            bIsScroll = YES;
        }
    }
    else if (scrollView.contentOffset.y < _oldOffset)
    {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - height-80 ) {
            bIsScrollTop = NO;
        }
        else{
            if (!bIsScrollTop) {
                NSLog(@"向下滑动！");
                bIsScroll = YES;
                bIsScrollTop = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.8];
                CGRect rect = [topView frame];
                rect.origin.x = 0;
                rect.origin.y = viewTopY;
                [topView setFrame:rect];
                if (!_bIsReload) {
                    if (index) {
                        if (_bIsFirst) {
                            tableView2.top = 0;
                        }else
                        {
                            tableView2.top = 0-20;
                        }
                        if (_bIsSelected) {
                            tableView2.top = 0;
                        }
                    }else{
                        if (_bIsFirst) {
                            tableView1.top = 0;
                        }else
                        {
                            tableView1.top = 0-20;
                        }
                        if (_bIsSelected) {
                            tableView1.top = 0;
                        }
                    }
                }

                [self.view bringSubviewToFront:self.navigationBar];
                [UIView commitAnimations];
            }
        }
    }
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

- (void)customerTableView:(CustomerTableView*)tableView FirstLetterSelecte:(NSString*)string
{
    firstLetterLabel.text = string;
    firstLetterLabel.hidden = NO;
    [CustomerListViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
}

- (void)delayMethod
{
    firstLetterLabel.hidden = YES;
}

//键盘搜索点击
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self textFieldDidChanged];
    return YES;
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

@end
