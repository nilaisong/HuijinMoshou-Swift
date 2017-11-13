//
//  AddGroupMebViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/7.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "AddGroupMebViewController.h"
#import "CustomerTableView.h"
#import "CustomerSelectButton.h"
#import "DataFactory+Customer.h"
#import "IQKeyboardManager.h"

@interface AddGroupMebViewController ()<UIScrollViewDelegate,UITextFieldDelegate,CustomerTableViewCellDelegate>
{
    CGFloat      _oldOffset;
    NSString     *searchContent;
}

@property (nonatomic, strong) UIView          *topView;
@property (nonatomic, strong) UITextField     *searchBarTextField;
@property (nonatomic, strong) UIScrollView    *tableScrollView;
@property (nonatomic, strong) UIButton        *rightBarItem;
@property (nonatomic, strong) UIView          *bottomView;//底部布局
@property (nonatomic, strong) UILabel         *selectedLabel;//显示已选择几个报备客户
@property (nonatomic, strong) NSMutableArray  *totalSeletedArray;
@property (nonatomic, strong) NSMutableArray  *titleArray;

@property (nonatomic, strong) CustomerTableView *tableView1;
@property (nonatomic, strong) CustomerTableView *tableView2;

@property (nonatomic, strong) NSMutableArray *addressBookTemp;//通讯录获取到的联系人集合
@property (nonatomic, strong) UILabel *firstLetterLabel;

@property (nonatomic, strong) CustomerSelectButton *btnView;

@property (nonatomic, assign) int          currentIndex;
@property (nonatomic, assign) BOOL         bIsScrollTop;
@property (nonatomic, assign) BOOL           bIsTouched;//互斥锁，防止保存添加组成员过程中多次点击

@end

@implementation AddGroupMebViewController
@synthesize topView;
@synthesize bottomView,selectedLabel;
@synthesize totalSeletedArray;
@synthesize searchBarTextField;

@synthesize titleArray;

@synthesize addressBookTemp;
@synthesize firstLetterLabel;
@synthesize btnView;

@synthesize tableScrollView;
@synthesize tableView1;
@synthesize tableView2;

@synthesize currentIndex;
@synthesize bIsScrollTop;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.titleLabel.text = _option.itemName;
    self.navigationBar.barBackgroundImageView.backgroundColor = BACKGROUNDCOLOR;
    
    _rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-70, 20+5, 60, 35)];
    [_rightBarItem setTitle:@"全选" forState:UIControlStateNormal];
    [_rightBarItem setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
    _rightBarItem.titleLabel.font = [UIFont systemFontOfSize:17];
    [_rightBarItem setImage:[UIImage imageNamed:@"big_selected"] forState:UIControlStateNormal];
    [_rightBarItem setImage:[UIImage imageNamed:@"big_selected_h"] forState:UIControlStateSelected];
    [_rightBarItem setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [_rightBarItem addTarget:self action:@selector(toggleRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:_rightBarItem];
    
    totalSeletedArray = [[NSMutableArray alloc] init];
    addressBookTemp = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] init];
    
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableScrollView.superview) {
        self.tableScrollView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-44);
    }
//    if (self.tableView1.superview) {
//        self.tableView1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-44);
//    }
//    if (self.tableView2.superview) {
//        self.tableView2.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-44);
//    }
    if (self.bottomView.superview) {
        self.bottomView.frame =CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    }
}

- (void)hasNetwork
{
    __weak AddGroupMebViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    bIsScrollTop = YES;
    currentIndex = 0;
    
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
    
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    
    OptionData* item1 = [[OptionData alloc] init];
    item1.itemName = @"全部";
    item1.itemValue=@"0";
    [titleArray insertObject:item1 forIndex:0];
    
    [self createTableView];
    [self createHeaderViewOfTable:viewTopY];
    [self createBottomView];
    [self.view addSubview:topView];
    
    [self.view bringSubviewToFront:firstLetterLabel];
    [self.view addSubview:firstLetterLabel];
    
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak AddGroupMebViewController *weakSelf = self;
//    __block NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [[DataFactory sharedDataFactory] getCustomerListWithKeyword:@"" andGroupId:@"0" withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!actionResult.success) {
                [self showTips:actionResult.message];
            }
            [self.addressBookTemp addObjectsFromArray:result.customerList];
            if (self.addressBookTemp.count==0) {
                self.rightBarItem.hidden = YES;
            }
            for (int i=0; i<self.custArray.count; i++) {
                Customer *cust1 = (Customer*)[self.custArray objectForIndex:i];
                for (int j=0; j<self.addressBookTemp.count; j++) {
                    Customer *cust2 = (Customer*)[self.addressBookTemp objectForIndex:j];
                    if ([cust1.customerId isEqualToString:cust2.customerId]) {
                        [self.addressBookTemp removeObject:cust2];
                        break;
                    }
                }
            }
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
                    for (OptionData *data in self.titleArray) {
                        if ([data.itemName isEqualToString:self.option.itemName]) {
                            [self.titleArray removeObject:data];
                            break;
                        }
                    }
                    [btnView removeAllSubviews];
                    [btnView removeFromSuperview];
                    btnView = nil;
                    [self createButtonView];
                    tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
                    if (currentIndex%2) {
                        self.tableView2.left = self.tableScrollView.contentOffset.x;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:NO];
                        }else
                        {
                            [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
                        }
                        
                    }else{
                        self.tableView1.left = self.tableScrollView.contentOffset.x;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:NO];
                        }else
                        {
                            [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
                        }
                    }
                });
            }];
        });
    }];
}

- (void)requestCustomerListByKeyword:(NSString*)keyWord AndGroupId:(NSString*)groupId WithIndex:(NSInteger)index withFlag:(BOOL)flag
{
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = nil;
    if (flag) {
        loadingView = [self setRotationAnimationWithView];
    }
//    __weak AddGroupMebViewController *weakSelf = self;
    
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
            for (int i=0; i<self.custArray.count; i++) {
                Customer *cust1 = (Customer*)[self.custArray objectForIndex:i];
                for (int j=0; j<self.addressBookTemp.count; j++) {
                    Customer *cust2 = (Customer*)[self.addressBookTemp objectForIndex:j];
                    if ([cust1.customerId isEqualToString:cust2.customerId]) {
                        [self.addressBookTemp removeObject:cust2];
                        break;
                    }
                }
            }
            if (index%2) {
                self.tableView2.left = self.tableScrollView.contentOffset.x;
                if (self.addressBookTemp.count>0) {
                    [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex LastSelectedArray:self.totalSeletedArray];
                }else
                {
                    [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex LastSelectedArray:self.totalSeletedArray];
                }
                
            }else{
                self.tableView1.left = self.tableScrollView.contentOffset.x;
                if (self.addressBookTemp.count>0) {
                    [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex LastSelectedArray:self.totalSeletedArray];
                }else
                {
                    [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex LastSelectedArray:self.totalSeletedArray];
                }
            }
            
            if (self.addressBookTemp.count == 0) {
                self.rightBarItem.hidden = YES;
            }else
            {
                self.rightBarItem.hidden = NO;
                if (self.totalSeletedArray.count < self.addressBookTemp.count) {
                    self.rightBarItem.selected = NO;
                }else if (self.totalSeletedArray.count > self.addressBookTemp.count)
                {
                    int count = 0;
                    for (int i=0; i<self.totalSeletedArray.count; i++) {
                        for (Customer *cust in self.addressBookTemp) {
                            if ([cust.customerId isEqualToString:[self.totalSeletedArray objectForIndex:i]]) {
                                count++;
                                break;
                            }
                        }
                    }
                    if (count == self.addressBookTemp.count) {
                        self.rightBarItem.selected = YES;
                    }else
                    {
                        self.rightBarItem.selected = NO;
                    }
                }else if (self.totalSeletedArray.count == self.addressBookTemp.count)
                {
                    int count = 0;
                    for (int i=0; i<self.totalSeletedArray.count; i++) {
                        for (Customer *cust in self.addressBookTemp) {
                            if ([cust.customerId isEqualToString:[self.totalSeletedArray objectForIndex:i]]) {
                                count++;
                                break;
                            }
                        }
                    }
                    if (count == self.totalSeletedArray.count) {
                        self.rightBarItem.selected = YES;
                    }else
                    {
                        self.rightBarItem.selected = NO;
                    }
                }
            }
        });
    }];
}

- (void)createTableView
{
    tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY-44)];
    tableScrollView.delegate = self;
    tableScrollView.pagingEnabled = YES;
    tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
    [self.view addSubview:tableScrollView];
    if ([self verifyTheRulesWithShouldJump:NO]) {
        tableView1 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, 0, tableScrollView.width, tableScrollView.height) tableType:1 withHasShop:YES];
    }else
    {
        tableView1 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, 0, tableScrollView.width, tableScrollView.height) tableType:1 withHasShop:NO];
    }
    
    tableView1.cellDelegate = self;
    __weak AddGroupMebViewController *weakSelf = self;
    tableView1.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [tableScrollView addSubview:tableView1];
    
    if ([self verifyTheRulesWithShouldJump:NO]) {
        tableView2 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:1 AndFrame:CGRectMake(kMainScreenWidth, 0, tableScrollView.width, tableScrollView.height) tableType:1 withHasShop:YES];
    }else
    {
        tableView2 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:1 AndFrame:CGRectMake(kMainScreenWidth, 0, tableScrollView.width, tableScrollView.height) tableType:1 withHasShop:NO];
    }
    
    tableView2.cellDelegate = self;
    tableView2.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [tableScrollView addSubview:tableView2];
}

- (void)createBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, kMainScreenWidth, 44)];
    bottomView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = CustomerBorderColor;
    [bottomView addSubview:lineView];
    
    selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kMainScreenWidth - 8 - 80, 30)];
    [selectedLabel setAttributedText:[self transferLouPanString:@"0"]];
    [bottomView addSubview:selectedLabel];
    
    UIButton *sendMsgsBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.width - 80, 0, 80, bottomView.height)];
    [sendMsgsBtn setBackgroundColor:BLUEBTBCOLOR];
    [sendMsgsBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sendMsgsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMsgsBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [sendMsgsBtn addTarget:self action:@selector(finishedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendMsgsBtn];
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
    [topView addSubview:searchBarTextField];
    
    UIView *scrollBgView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBarView.bottom+7, topView.width, 44)];
    scrollBgView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:scrollBgView];
    
    [self createButtonView];
}

- (void)createButtonView
{
    btnView = [[CustomerSelectButton alloc] initWithFrame:CGRectMake(15, 44+5, topView.width - 15, 39)];//预留出4像素的蓝线
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.padding = UIEdgeInsetsMake(0, 10, 0, 10); //上,左,下,右,的边距
    btnView.lastSelected = currentIndex;
    btnView.horizontalSpace = 10;                       //横向间隔
    //    headView.verticalSpace = 10;                         //纵向间隔
    btnView.dataSource = titleArray;
    __weak AddGroupMebViewController *customer = self;
    //数据源
    [btnView buttonSeleteBlock:^(int index,BOOL isSelected){
        if (customer.currentIndex != index) {
            customer.currentIndex = index;
            OptionData *option = nil;
            if (customer.titleArray.count > index) {
                option = [customer.titleArray objectForIndex:index];
            }
            [customer.tableScrollView setContentOffset:CGPointMake(index*customer.tableScrollView.width, 0)];
            [customer requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:index withFlag:YES];
        }
    }];
    [topView addSubview:btnView];
}

- (void)toggleRightBarButton:(UIButton*)sender
{
    if (!sender.selected) {
        sender.selected = YES;
//        [totalSeletedArray removeAllObjects];
        for (Customer *cust in addressBookTemp) {
            for (NSString *custId in totalSeletedArray) {
                if ([cust.customerId isEqualToString:custId]) {
                    [totalSeletedArray removeObject:custId];
                    break;
                }
            }
        }
        for (int i=0; i<addressBookTemp.count; i++) {
            Customer *cust = (Customer*)[addressBookTemp objectForIndex:i];
            [totalSeletedArray appendObject:cust.customerId];
        }
        if (currentIndex%2) {
            [tableView2 refreshTableViewWithCustomer:addressBookTemp ByCustomerType:currentIndex LastSelectedArray:totalSeletedArray];
        }else
        {
            [tableView1 refreshTableViewWithCustomer:addressBookTemp ByCustomerType:currentIndex LastSelectedArray:totalSeletedArray];
        }
    }else
    {
        sender.selected = NO;
//        [totalSeletedArray removeAllObjects];
        for (Customer *cust in addressBookTemp) {
            for (NSString *custId in totalSeletedArray) {
                if ([cust.customerId isEqualToString:custId]) {
                    [totalSeletedArray removeObject:custId];
                    break;
                }
            }
        }
        if (currentIndex%2) {
            [tableView2 refreshTableViewWithCustomer:addressBookTemp ByCustomerType:currentIndex LastSelectedArray:totalSeletedArray];
        }else
        {
            [tableView1 refreshTableViewWithCustomer:addressBookTemp ByCustomerType:currentIndex LastSelectedArray:totalSeletedArray];
        }
    }
    [selectedLabel setAttributedText:[self transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)totalSeletedArray.count]]];
}

- (void)finishedBtn:(UIButton*)sender
{
    if (!_bIsTouched) {
        _bIsTouched = YES;
        if (totalSeletedArray.count>0) {
            NSString *custIds = nil;
            for (int i=0; i<totalSeletedArray.count; i++) {
                if (i==0) {
                    custIds = [totalSeletedArray objectForIndex:i];
                }else {
                    custIds = [NSString stringWithFormat:@"%@,%@",custIds,[totalSeletedArray objectForIndex:i]];
                }
            }
            //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
            UIImageView * loadingView = [self setRotationAnimationWithView];
            if ([NetworkSingleton sharedNetWork].isNetworkConnection)
            {
                [[DataFactory sharedDataFactory] addMemberWithGroupId:_option.itemValue AndCustomerIds:custIds withCallBack:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _bIsTouched = NO;
                        [self removeRotationAnimationView:loadingView];
                        if (result.success) {
                            [self showTips:result.message];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
                                //防止多次pop发生崩溃闪退
                                if ([self.view superview]) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            });
                        }else
                        {
                            [self showTips:result.message];
                        }
                    });
                }];
            }else
            {
                _bIsTouched = NO;
                [self removeRotationAnimationView:loadingView];
            }
        }else
        {
            [self showTips:@"请先选择客户"];
        }
    }else
    {
        _bIsTouched = NO;
    }
}

- (void)customerTableView:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath SelecteCustomerWithId:(NSString*)custId AndSeletedStatus:(BOOL)bIsSelected
{
    if (![self isBlankString:custId]) {
        if (bIsSelected) {
            [totalSeletedArray appendObject:custId];
        }else
        {
            [totalSeletedArray removeObject:custId];
        }
        
        [selectedLabel setAttributedText:[self transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)totalSeletedArray.count]]];
    }
//    if (totalSeletedArray.count < addressBookTemp.count) {
//        _rightBarItem.selected = NO;
//    }else if (totalSeletedArray.count == addressBookTemp.count)
//    {
//        _rightBarItem.selected = YES;
//    }
    if (addressBookTemp.count == 0) {
        _rightBarItem.selected = NO;
    }else
    {
        if (totalSeletedArray.count < addressBookTemp.count) {
            _rightBarItem.selected = NO;
        }else if (totalSeletedArray.count > addressBookTemp.count)
        {
            int count = 0;
            for (int i=0; i<totalSeletedArray.count; i++) {
                for (Customer *cust in addressBookTemp) {
                    if ([cust.customerId isEqualToString:[totalSeletedArray objectForIndex:i]]) {
                        count++;
                        break;
                    }
                }
            }
            if (count == addressBookTemp.count) {
                _rightBarItem.selected = YES;
            }else
            {
                _rightBarItem.selected = NO;
            }
        }else if (totalSeletedArray.count == addressBookTemp.count)
        {
            int count = 0;
            for (int i=0; i<totalSeletedArray.count; i++) {
                for (Customer *cust in addressBookTemp) {
                    if ([cust.customerId isEqualToString:[totalSeletedArray objectForIndex:i]]) {
                        count++;
                        break;
                    }
                }
            }
            if (count == totalSeletedArray.count) {
                _rightBarItem.selected = YES;
            }else
            {
                _rightBarItem.selected = NO;
            }
        }
    }
}

- (NSAttributedString *)transferLouPanString:(NSString*)number
{
    NSString *string = [NSString stringWithFormat:@"已选客户[%@]",number];
    NSRange range = [string  rangeOfString:@"]"];
    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:NAVIGATIONTITLE
                        range:NSMakeRange(0, 4)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]
                        range:NSMakeRange(0, 4)];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:BLUEBTBCOLOR
                        range:NSMakeRange(5, range.location-5)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:18]
                        range:NSMakeRange(5, range.location-5)];
    return attriString;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (int)(tableScrollView.contentOffset.x/kMainScreenWidth);
    
    if (currentIndex != index) {
        currentIndex = index;
        [btnView seletedbBtnWithScrollIndex:index];
        OptionData *option = nil;
        if (titleArray.count > index) {
            option = [titleArray objectForIndex:index];
        }
        [self requestCustomerListByKeyword:searchBarTextField.text AndGroupId:option.itemValue WithIndex:index withFlag:YES];
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
            NSLog(@"向下滑动！");
            bIsScrollTop = YES;
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
            NSLog(@"向上滑动！");
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.8];
            CGRect rect = [topView frame];
            
            rect.origin.x = 0;
            rect.origin.y = -24;
            [topView setFrame:rect];
            [self.view bringSubviewToFront:self.navigationBar];
            [UIView commitAnimations];
        }
    }
    else if (scrollView.contentOffset.y >= scrollView.contentSize.height - height)
    {
        if (!bIsScrollTop) {
            NSLog(@"滑到底部！");
            bIsScrollTop = YES;
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
                bIsScrollTop = YES;
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
            }
        }
    }
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

- (void)customerTableView:(CustomerTableView*)tableView FirstLetterSelecte:(NSString*)string
{
    firstLetterLabel.text = string;
    firstLetterLabel.hidden = NO;
    [AddGroupMebViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
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

- (void)textFieldDidChanged
{
    __weak AddGroupMebViewController *customer = self;
    OptionData *option = nil;
    if (titleArray.count > currentIndex) {
        option = [titleArray objectForIndex:currentIndex];
    }
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:customer.currentIndex withFlag:NO];}]) {
        [self requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:customer.currentIndex withFlag:NO];
    }
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
