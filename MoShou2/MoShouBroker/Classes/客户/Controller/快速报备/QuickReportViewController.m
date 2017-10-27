//
//  QuickReportViewController.m
//  MoShou2
//
//  Created by wangzhenzhen on 15/11/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "QuickReportViewController.h"
#import "LocalContactsViewController.h"
#import "NSString+Extension.h"
#import "OptionSelectedViewController.h"
#import "CustomerSelectViewController.h"
#import "ReportTipViewController.h"
#import "RecommendRecordController.h"
#import "CustomerTextField.h"
#import "OptionSelectedTableViewCell.h"
#import "BuildingListData.h"
#import "DataFactory+Customer.h"
#import "UserData.h"
#import "CustomerVisitInfoData.h"
#import "CustomerBaseBuildView.h"
#import "CustomerSourceViewController.h"

@interface QuickReportViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *headerView;//顶部布局，报备新客户与增加新客户布局相同，修改少一个通讯录
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, copy)   NSString    *sexString;//选择性别后生成的字符串
@property (nonatomic, copy)   NSString    *count;
@property (nonatomic, strong) UIButton    *womanButton;
@property (nonatomic, strong) UIButton    *manButton;
@property (nonatomic, assign) BOOL        bIsHiddenNum;
@property (nonatomic, strong) UIButton    *reportBtn;//报备按钮
@property (nonatomic, assign) BOOL        bIsTouched;//互斥锁，防止保存报备过程中多次点击
@property (nonatomic, strong) UILabel     *middleNum;
//@property (nonatomic, strong) UILabel     *reportLoupLabel;
@property (nonatomic, strong) CustomerTextField    *firstNum;
@property (nonatomic, strong) CustomerTextField    *tailNum;

@property (nonatomic, strong) UILabel              *blankLabel;
@property (nonatomic, strong) Customer    *custData;
@property (nonatomic, strong) NSMutableArray       *loupArr;
//@property (nonatomic, strong) NSMutableArray       *notFullPhoneLoupArr;

//@property (nonatomic, strong) UIButton    *mobileBtn;
//@property (nonatomic, strong) UIView      *mobileView;
@property (nonatomic, strong) UIView      *userInfoView;
@property (nonatomic, strong) NSMutableDictionary *visitDic;
@property (nonatomic, strong) NSMutableDictionary *confirmDic;

@property (nonatomic, strong) UITextField    *identityCardField;//客户身份证号
@property (nonatomic, strong) UILabel        *custSourceLabel;//客户来源回显使用
@property (nonatomic, strong) CustomerSourceData *sourceData;

@end

@implementation QuickReportViewController
@synthesize headerView;

@synthesize nameTextField;
@synthesize telTextField;
@synthesize manButton;
@synthesize womanButton;
@synthesize reportBtn;
//@synthesize mobileView;
@synthesize userInfoView;
//@synthesize mobileBtn;

@synthesize bIsHiddenNum;
@synthesize firstNum;
@synthesize tailNum;
@synthesize middleNum;
//@synthesize reportLoupLabel;

@synthesize loupArr;
//@synthesize notFullPhoneLoupArr;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.popGestureRecognizerEnable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"快速报备";
    self.view.backgroundColor = [UIColor whiteColor];
    loupArr = [[NSMutableArray alloc] init];
//    notFullPhoneLoupArr = [[NSMutableArray alloc] init];
    _custData = [[Customer alloc] init];
    _visitDic = [[NSMutableDictionary alloc] init];
    _confirmDic = [[NSMutableDictionary alloc] init];
    _sourceData = [[CustomerSourceData alloc] init];
    [self reloadView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height - viewTopY);
    }
    //    if (reportBtn.superview) {
    //        reportBtn.frame = CGRectMake(10, self.view.bounds.size.height-54, self.view.bounds.size.width-20, 44);
    //    }
}

- (void)reloadView
{
    UserData *user = [UserData sharedUserData];
    if (![self isBlankString:user.userInfo.maxRecommendCount]) {
        _count = user.userInfo.maxRecommendCount;
    }else
    {
        _count = @"0";
    }
    
    bIsHiddenNum = user.userInfo.mobileVisable;
    [self createTableView];
    
    [self initHeaderView];
    
    _blankLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, viewTopY+headerView.height+(self.view.bounds.size.height-viewTopY-headerView.height)/2-15, kMainScreenWidth-40, 30)];
    _blankLabel.text = @"请先选择报备楼盘!";
    _blankLabel.textAlignment = NSTextAlignmentCenter;
    _blankLabel.textColor = LABELCOLOR;
    _blankLabel.font = FONT(17);
    [self.view addSubview:_blankLabel];
    
    //    reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-54, kMainScreenWidth-20, 44)];
    //    [reportBtn.layer setMasksToBounds:YES];
    //    [reportBtn.layer setCornerRadius:4.0];
    //    [reportBtn setTitle:@"报备" forState:UIControlStateNormal];
    //    reportBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    //    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [reportBtn setBackgroundColor:BLUEBTBCOLOR];
    //    [reportBtn addTarget:self action:@selector(toggleReportButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:reportBtn];
    
    reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-8-40, 20+5, 40, 34)];
    [reportBtn setTitle:@"报备" forState:UIControlStateNormal];
    [reportBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor colorWithHexString:@"166fa2"] forState:UIControlStateHighlighted];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [reportBtn addTarget:self action:@selector(toggleReportButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:reportBtn];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height - viewTopY) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)initHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    
    UIButton *customerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-102, 10, 102, 30)];
    [customerBtn setTitle:@"客户列表添加" forState:UIControlStateNormal];
    [customerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [customerBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    customerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [customerBtn setBackgroundImage:[UIImage imageNamed:@"select-left-xian"] forState:UIControlStateNormal];
    [customerBtn setBackgroundImage:[UIImage imageNamed:@"select-left"] forState:UIControlStateHighlighted];
    [customerBtn addTarget:self action:@selector(toggleCustomerButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:customerBtn];
    
    UIButton *mailListBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, 10, 102, 30)];
    [mailListBtn setTitle:@"通讯录添加" forState:UIControlStateNormal];
    [mailListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [mailListBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    mailListBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [mailListBtn setBackgroundImage:[UIImage imageNamed:@"select-right-xian"] forState:UIControlStateNormal];
    [mailListBtn setBackgroundImage:[UIImage imageNamed:@"select-right"] forState:UIControlStateHighlighted];
    [mailListBtn addTarget:self action:@selector(toggleMailListButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:mailListBtn];
    
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, mailListBtn.bottom+10, kMainScreenWidth, 132)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:userInfoView];
    
    [userInfoView addSubview:[self createLineView:0 withX:0]];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth - 15 -10 - 120, 30)];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.placeholder = @"请输入客户姓名";
    nameTextField.font = [UIFont systemFontOfSize:16.0f];
    nameTextField.textColor = NAVIGATIONTITLE;
    //    [nameTextField addTarget:self action:@selector(nameTextFieldEndChanged) forControlEvents:UIControlEventEditingDidEnd];
    [nameTextField addTarget:self action:@selector(nameTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [userInfoView addSubview:nameTextField];
    
    womanButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 55, nameTextField.top, 40, 30)];
    [womanButton setTitle:@"女" forState:UIControlStateNormal];
    [womanButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [womanButton setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"button_selected_h"] forState:UIControlStateSelected];
    [womanButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    womanButton.tag = 1131;
    [womanButton addTarget:self action:@selector(toggleSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userInfoView addSubview:womanButton];
    
    manButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 120, womanButton.top, 40, 30)];
    [manButton setTitle:@"男" forState:UIControlStateNormal];
    [manButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [manButton setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateNormal];
    [manButton setImage:[UIImage imageNamed:@"button_selected_h"] forState:UIControlStateSelected];
    [manButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    manButton.tag = 1132;
    //    manButton.selected = YES;
    //    self.sexString = @"男";
    
    [manButton addTarget:self action:@selector(toggleSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userInfoView addSubview:manButton];
    
    [userInfoView addSubview:[self createLineView:nameTextField.bottom+7 withX:10]];
    
    if (!bIsHiddenNum) {
        telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, nameTextField.bottom+14, kMainScreenWidth - 30, 30)];
        telTextField.placeholder = @"请输入手机号";
        telTextField.delegate = self;
        telTextField.tag = 1010;
        telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        telTextField.font = [UIFont systemFontOfSize:18.0f];
        [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        telTextField.keyboardType = UIKeyboardTypePhonePad;
        telTextField.textColor = NAVIGATIONTITLE;
        //        [telTextField addTarget:self action:@selector(telTextFieldEndChanged) forControlEvents:UIControlEventEditingDidEnd];
        [userInfoView addSubview:telTextField];
    }else
    {
        firstNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(15, nameTextField.bottom+14, 60, 30)];
        firstNum.keyboardType = UIKeyboardTypePhonePad;
        firstNum.delegate = self;
        firstNum.tag = 1011;
        firstNum.placeholder = @"前三";
        firstNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        firstNum.textColor = NAVIGATIONTITLE;
        firstNum.textAlignment = NSTextAlignmentCenter;
        firstNum.font = [UIFont systemFontOfSize:18];
        [firstNum.layer setCornerRadius:4.0];
        [firstNum.layer setMasksToBounds:YES];
        [firstNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
        [firstNum.layer setBorderWidth:0.5];
        [firstNum addTarget:self action:@selector(firstNumTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
        
        middleNum = [[UILabel alloc] initWithFrame:CGRectMake(firstNum.right, firstNum.top, 45, 30)];
        middleNum.text = @"****";
        middleNum.textColor = NAVIGATIONTITLE;
        middleNum.font = [UIFont systemFontOfSize:18];
        middleNum.textAlignment = NSTextAlignmentCenter;
        
        tailNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(middleNum.right, firstNum.top, 80, 30)];
        tailNum.keyboardType = UIKeyboardTypePhonePad;
        tailNum.delegate = self;
        tailNum.tag = 1012;
        tailNum.textColor = NAVIGATIONTITLE;
        tailNum.placeholder = @"后四";
        tailNum.textAlignment = NSTextAlignmentCenter;
        tailNum.font = [UIFont systemFontOfSize:18];
        [tailNum.layer setCornerRadius:4.0];
        [tailNum.layer setMasksToBounds:YES];
        [tailNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
        [tailNum.layer setBorderWidth:0.5];
        [tailNum addTarget:self action:@selector(tailNumTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
        
        [userInfoView addSubview:firstNum];
        [userInfoView addSubview:middleNum];
        [userInfoView addSubview:tailNum];
        
        telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, nameTextField.bottom+14, kMainScreenWidth - 30, 30)];
        telTextField.enabled = NO;
        telTextField.hidden = YES;
        telTextField.tag = 1010;
        telTextField.font = [UIFont systemFontOfSize:18.0f];
        telTextField.textColor = [UIColor colorWithHexString:@"d2d1d1"];
        telTextField.backgroundColor = [UIColor whiteColor];
        [userInfoView addSubview:telTextField];
        
//        mobileBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-16-50, firstNum.top, 50, 30)];
//        [mobileBtn.layer setMasksToBounds:YES];
//        [mobileBtn.layer setCornerRadius:5.0];
//        [mobileBtn.layer setBorderWidth:0.5];
//        [mobileBtn.layer setBorderColor:BLUEBTBCOLOR.CGColor];
//        [mobileBtn setBackgroundColor:[UIColor whiteColor]];
//        [mobileBtn setTitle:@"隐号" forState:UIControlStateNormal];
//        [mobileBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//        //报备客户支持全号的楼盘需要提示仅报备全号客户；报备楼盘隐号的客户提示仅报备隐号楼盘   否则均不显示
//        mobileBtn.titleLabel.font = FONT(13);
//        [mobileBtn addTarget:self action:@selector(toggleMobileButton:) forControlEvents:UIControlEventTouchUpInside];
//        [userInfoView addSubview:mobileBtn];
//        
//        mobileView = [[UIView alloc] initWithFrame:CGRectMake(0, firstNum.top - 2, mobileBtn.left, 35)];
//        mobileView.backgroundColor = [UIColor whiteColor];
//        telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 2, mobileView.width - 30, 30)];
//        telTextField.placeholder = @"请输入手机号";
//        telTextField.delegate = self;
//        telTextField.tag = 1000;
//        telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        telTextField.font = [UIFont systemFontOfSize:18.0f];
//        [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
//        telTextField.keyboardType = UIKeyboardTypePhonePad;
//        telTextField.textColor = NAVIGATIONTITLE;
//        [mobileView addSubview:telTextField];
//        mobileView.hidden = YES;
//        [userInfoView addSubview:mobileView];
    }

    [userInfoView addSubview:[self createLineView:88 withX:10]];
    
    _identityCardField = [[UITextField alloc] initWithFrame:CGRectMake(15, 88+7, kMainScreenWidth-40, 30)];
    _identityCardField.textColor = NAVIGATIONTITLE;
    _identityCardField.placeholder = @"请输入客户身份证号";
    _identityCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _identityCardField.font = [UIFont systemFontOfSize:18.0f];
    [_identityCardField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_identityCardField addTarget:self action:@selector(identityTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [userInfoView addSubview:_identityCardField];
    
    [userInfoView addSubview:[self createLineView:userInfoView.height-0.5 withX:0]];
    
    CGFloat kHeight = userInfoView.bottom;
    if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
        //客户来源
        CustomerBaseBuildView *custView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, userInfoView.bottom+10, kMainScreenWidth, 44) Title:@"客户来源" AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:4];
        custView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:custView];
        
        _custSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7, kMainScreenWidth-150-33, 30)];
        _custSourceLabel.textColor = TFPLEASEHOLDERCOLOR;
        _custSourceLabel.textAlignment = NSTextAlignmentRight;
        _custSourceLabel.font = FONT(13);
        [custView addSubview:_custSourceLabel];
        
        [custView addSubview:[self createLineView:0 withX:0]];
        [custView addSubview:[self createLineView:custView.height-0.5 withX:0]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCustomerSource:)];
        [custView addGestureRecognizer:tapGesture];
        kHeight = custView.bottom;
    }
    //报备楼盘
    UIView *reportView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight+10, kMainScreenWidth, 44)];
    reportView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:reportView];
    
    [reportView addSubview:[self createLineView:0 withX:0]];
    [reportView addSubview:[self createLineView:reportView.height-0.5 withX:0]];
    
    UIImageView *addImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];
    [addImgView setImage:[UIImage imageNamed:@"icon_tianjia"]];
    [reportView addSubview:addImgView];
    
    NSString *str = @"报备楼盘";
    NSDictionary *attributes = @{NSFontAttributeName:FONT(17)};
    CGSize size = [str sizeWithAttributes:attributes];
    UILabel *reportL = [[UILabel alloc] initWithFrame:CGRectMake(addImgView.right+5, 7, size.width, 30)];
    reportL.text = str;
    reportL.textColor = NAVIGATIONTITLE;
    reportL.font = FONT(17);
    [reportView addSubview:reportL];
    
//    reportLoupLabel = [[UILabel alloc] initWithFrame:CGRectMake(reportL.right+5, 7, 150, 30)];
//    reportLoupLabel.font = [UIFont systemFontOfSize:14];
//    reportLoupLabel.textColor = TFPLEASEHOLDERCOLOR;
//    reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",_count];
//    [reportView addSubview:reportLoupLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8, 15, 8, 14)];
    [imgView setImage:[UIImage imageNamed:@"arrow-right"]];
    [reportView addSubview:imgView];
    
    UIButton *reportLoupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportLoupBtn.frame = CGRectMake(0, 0, reportView.width, reportView.height);
    reportLoupBtn.backgroundColor = [UIColor clearColor];
    [reportLoupBtn addTarget:self action:@selector(toggleBaobeiButton:) forControlEvents:UIControlEventTouchUpInside];
    [reportView addSubview:reportLoupBtn];
    headerView.height = reportView.bottom+10;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num = 0;
//    if (bIsHiddenNum) {
//        if (notFullPhoneLoupArr.count > 0) {
//            num = 1;
//            _blankLabel.hidden = YES;
//        }else if (notFullPhoneLoupArr.count == 0) {
//            _blankLabel.hidden = NO;
//        }
//    }else
//    {
        if (loupArr.count > 0) {
            num = 1;
            _blankLabel.hidden = YES;
        }else if (loupArr.count == 0) {
            _blankLabel.hidden = NO;
        }
//    }
    
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
//    if (bIsHiddenNum) {
//        count = notFullPhoneLoupArr.count;
//    }else
//    {
        count = loupArr.count;
//    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"cellIdentifier";
    //    OptionSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CustomerBuilding *buildingData = nil;
//    if (bIsHiddenNum) {
//        buildingData = (CustomerBuilding*)[notFullPhoneLoupArr objectForIndex:indexPath.row];
//    }else
//    {
    buildingData = nil;
    if (loupArr.count > indexPath.row) {
        buildingData = (CustomerBuilding*)[loupArr objectForIndex:indexPath.row];
    }
//    }
    
    UIView *lineView = nil;
    //    if (cell == nil) {
    OptionSelectedTableViewCell *cell = [[OptionSelectedTableViewCell alloc] initWithBuildListData:buildingData AndTableType:1];
    lineView = [self createLineView:70-0.5 withX:15];
    lineView.tag = 100;
    [cell.contentView addSubview:lineView];
    cell.visitLabel.hidden = YES;
    //    }
    __weak QuickReportViewController *weakSelf = self;
    [cell optionDeleteCellBlock:^(OptionSelectedTableViewCell*optionCell){
        NSIndexPath *cellIndexPath = [weakSelf.tableView indexPathForCell:optionCell];
//        if (weakSelf.bIsHiddenNum) {
//            [weakSelf.notFullPhoneLoupArr removeObjectForIndex:cellIndexPath.row];
//            if (weakSelf.notFullPhoneLoupArr.count == 0) {
//                weakSelf.blankLabel.hidden = NO;
//            }
//        }else
//        {
            [weakSelf.loupArr removeObjectForIndex:cellIndexPath.row];
            if (weakSelf.loupArr.count == 0) {
                weakSelf.blankLabel.hidden = NO;
            }
//        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createLineView:0 withX:0];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self createLineView:0 withX:0];
}

- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}
//进入选择客户页面
- (void)toggleCustomerButton:(UIButton*)sender
{
    [self.view endEditing:YES];
    CustomerSelectViewController *selectVC = [[CustomerSelectViewController alloc] init];
    __weak QuickReportViewController *weakSelf = self;
    [selectVC returnCustoemrResultBlock:^(Customer *cust) {
        weakSelf.custData = cust;
        weakSelf.nameTextField.text = cust.name;
        weakSelf.identityCardField.text = cust.cardId;
        if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
            weakSelf.sourceData.code = cust.custSource;
            weakSelf.sourceData.label = cust.custSourceLabel;
            if (![weakSelf isBlankString:cust.custSource]) {
                weakSelf.custSourceLabel.text = [NSString stringWithFormat:@"%@.%@",cust.custSource,cust.custSourceLabel];
            }else
            {
                weakSelf.custSourceLabel.text = @"";
            }
        }
//        weakSelf.nameTextField.textColor = [UIColor colorWithHexString:@"d2d1d1"];
        weakSelf.nameTextField.enabled = NO;
        if ([NSString validateIdentityCard:cust.cardId] &&[weakSelf isBlankString:cust.cardId]) {
            weakSelf.identityCardField.enabled = NO;
        }
        if (![weakSelf isBlankString:cust.count]) {
            weakSelf.count = cust.count;
        }else
        {
            weakSelf.count = @"0";
        }
//        weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",weakSelf.count];
//        weakSelf.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",weakSelf.count];
        if ([cust.sex isEqualToString:@"male"]||[cust.sex isEqualToString:@"男"]) {
            if (!weakSelf.manButton.enabled) {
                weakSelf.manButton.enabled = YES;
            }
            weakSelf.manButton.selected = YES;
            weakSelf.womanButton.enabled = NO;
            weakSelf.sexString = @"male";
        }else if ([cust.sex isEqualToString:@"female"]||[cust.sex isEqualToString:@"女"])
        {
            if (!weakSelf.womanButton.enabled) {
                weakSelf.womanButton.enabled = YES;
            }
            weakSelf.manButton.enabled = NO;
            weakSelf.womanButton.selected = YES;
            weakSelf.sexString = @"female";
        }
        if (weakSelf.bIsHiddenNum) {
            weakSelf.telTextField.hidden = NO;
            weakSelf.firstNum.enabled = NO;
            weakSelf.tailNum.enabled = NO;
            if (cust.listPhone.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[cust.listPhone substringWithRange:NSMakeRange(0, 3)],[cust.listPhone substringWithRange:NSMakeRange(3, 4)],[cust.listPhone substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
            }else{
                [weakSelf showTips:@"手机号码格式错误"];
                weakSelf.telTextField.text = cust.listPhone;
            }
//            if (cust.listPhone.length==11) {
////                [weakSelf.tailNum becomeFirstResponder];
//                weakSelf.firstNum.text = [cust.listPhone substringWithRange:NSMakeRange(0, 3)];
//                weakSelf.tailNum.text = [cust.listPhone substringWithRange:NSMakeRange(7, 4)];
////                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[cust.phone substringWithRange:NSMakeRange(0, 3)],[cust.phone substringWithRange:NSMakeRange(3, 4)],[cust.phone substringWithRange:NSMakeRange(7, 4)]];
////                weakSelf.telTextField.text = str;
//            }else
//            {
////                [weakSelf.firstNum becomeFirstResponder];
//                [weakSelf showTips:@"手机号码格式错误"];
//                weakSelf.firstNum.text = @"";
//                weakSelf.tailNum.text = @"";
//            }
        }else
        {
//            [weakSelf.telTextField becomeFirstResponder];
            if (cust.listPhone.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[cust.listPhone substringWithRange:NSMakeRange(0, 3)],[cust.listPhone substringWithRange:NSMakeRange(3, 4)],[cust.listPhone substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
                
//                if (!mobileView.hidden) {
//                    weakSelf.firstNum.text = [cust.phone substringWithRange:NSMakeRange(0, 3)];
//                    weakSelf.tailNum.text = [cust.phone substringWithRange:NSMakeRange(7, 4)];
//                }
            }else{
                [weakSelf showTips:@"手机号码格式错误"];
                weakSelf.telTextField.text = cust.listPhone;
            }
//            weakSelf.telTextField.textColor = [UIColor colorWithHexString:@"d2d1d1"];
            weakSelf.telTextField.enabled = NO;
        }
    }];
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)toggleCustomerSource:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    CustomerSourceViewController *sourceVC = [[CustomerSourceViewController alloc] init];
    sourceVC.selectedData = _sourceData;
    __weak typeof(self) weakSelf = self;
    [sourceVC selectCustomerSourceDataBlock:^(CustomerSourceData *source) {
        weakSelf.sourceData = source;
        if (![weakSelf isBlankString:source.code]) {
            weakSelf.custSourceLabel.text = [NSString stringWithFormat:@"%@.%@",source.code,source.label];
        }else
        {
            weakSelf.custSourceLabel.text = @"";
        }
    }];
    [self.navigationController pushViewController:sourceVC animated:YES];
}

- (void)toggleMailListButton:(UIButton*)sender
{
    [self.view endEditing:YES];
    LocalContactsViewController *addressContact = [[LocalContactsViewController alloc] init];
    __weak QuickReportViewController *weakSelf = self;
    [addressContact returnResultBlock:^(NSInteger index,NSString *text,NSString *detailText){
        weakSelf.custData = nil;
//        weakSelf.sourceData = nil;
        weakSelf.nameTextField.text = text;
//        weakSelf.nameTextField.textColor = NAVIGATIONTITLE;
        weakSelf.nameTextField.enabled = YES;
        weakSelf.manButton.enabled = YES;
        weakSelf.womanButton.enabled = YES;
        weakSelf.identityCardField.enabled = YES;
        weakSelf.identityCardField.text = @"";
//        weakSelf.custSourceLabel.text = @"";
        UserData *user = [UserData sharedUserData];
        if (![weakSelf isBlankString:user.userInfo.maxRecommendCount]) {
            weakSelf.count = user.userInfo.maxRecommendCount;
        }else
        {
            weakSelf.count = @"0";
        }
        
//        weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",weakSelf.count];
//        weakSelf.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",weakSelf.count];
        weakSelf.manButton.selected = NO;
        weakSelf.womanButton.selected = NO;
        weakSelf.sexString = @"";
        
        if (weakSelf.bIsHiddenNum) {
            if (!weakSelf.telTextField.hidden) {
                weakSelf.telTextField.text = @"";
                weakSelf.telTextField.hidden = YES;
            }
            weakSelf.firstNum.enabled = YES;
            weakSelf.tailNum.enabled = YES;
            if (detailText.length==11) {
                [weakSelf.tailNum becomeFirstResponder];
                weakSelf.firstNum.text = [detailText substringWithRange:NSMakeRange(0, 3)];
                weakSelf.tailNum.text = [detailText substringWithRange:NSMakeRange(7, 4)];
                
//                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[detailText substringWithRange:NSMakeRange(0, 3)],[detailText substringWithRange:NSMakeRange(3, 4)],[detailText substringWithRange:NSMakeRange(7, 4)]];
//                weakSelf.telTextField.text = str;
            }else
            {
                [weakSelf.firstNum becomeFirstResponder];
                [weakSelf showTips:@"手机号码格式错误"];
                weakSelf.firstNum.text = @"";
                weakSelf.tailNum.text = @"";
            }
        }else
        {
            [weakSelf.telTextField becomeFirstResponder];
            if (detailText.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[detailText substringWithRange:NSMakeRange(0, 3)],[detailText substringWithRange:NSMakeRange(3, 4)],[detailText substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
                
                [[DataFactory sharedDataFactory] validationMobileWithPhone:detailText withCallBack:^(ActionResult *result, Customer *cust) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.success) {
                            if ([cust.exist boolValue]) {
                                //[weakSelf showTips:result.message];
                                self.custData = cust;
                            }
                        }else
                        {
                            [self showTips:result.message];
                        }
                    });
                }];

//                if (!mobileView.hidden) {
//                    weakSelf.firstNum.text = [detailText substringWithRange:NSMakeRange(0, 3)];
//                    weakSelf.tailNum.text = [detailText substringWithRange:NSMakeRange(7, 4)];
//                }
            }else{
                [weakSelf showTips:@"手机号码格式错误"];
                weakSelf.telTextField.text = detailText;
            }
            weakSelf.telTextField.enabled = YES;
//            weakSelf.telTextField.textColor = NAVIGATIONTITLE;
        }
    }];
    [self.navigationController pushViewController:addressContact animated:YES];
}

- (void)toggleBaobeiButton:(UIButton*)sender
{
    [self.view endEditing:YES];
    
//    if ([_count integerValue] == 0) {
//        [self showTips:@"当前客户报备数已达上限"];
//        return;
//    }
    
    OptionSelectedViewController *optionSelected = [[OptionSelectedViewController alloc] init];
//    if (bIsHiddenNum) {
//        optionSelected.selectedOptions = notFullPhoneLoupArr;
//    }else
//    {
        optionSelected.selectedOptions = loupArr;
    optionSelected.visitOptions = _visitDic;
    optionSelected.confirmOptions = _confirmDic;
//    }
    if (_custData != nil) {
        optionSelected.custId = _custData.customerId;
    }
    optionSelected.count = _count;
//    optionSelected.bIsFullPhone = [NSString stringWithFormat:@"%d",!bIsHiddenNum];
    optionSelected.optionSelType = kCustomerFastVC;
    __weak QuickReportViewController *weakSelf = self;
    [optionSelected returnResultBlock:^(NSMutableArray *array,NSMutableDictionary*dic,NSMutableDictionary*confirmDic){
//        if (weakSelf.bIsHiddenNum) {
//            weakSelf.notFullPhoneLoupArr = array;
//        }else
//        {
            weakSelf.loupArr = array;
        weakSelf.visitDic = dic;
        weakSelf.confirmDic = confirmDic;
//        }
        
        [weakSelf.tableView reloadData];
        if (array.count>0) {
            weakSelf.blankLabel.hidden = YES;
            
            //            weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %ld 个)",(long)([weakSelf.count integerValue]-weakSelf.loupArr.count)];
            
        }else
        {
            weakSelf.blankLabel.hidden = NO;
        }
    }];
    [self.navigationController pushViewController:optionSelected animated:YES];
}
//点击报备按钮响应事件
- (void)toggleReportButton:(UIButton*)sender
{
    //    客户姓名不能为空
    if ([self isBlankString:nameTextField.text ]) {
        [nameTextField becomeFirstResponder];
        [self showTips:@"请输入客户姓名"];
        return;
    }
    //    性别不能为空
    if ([self isBlankString:self.sexString]) {
        [self showTips:@"请选择客户性别"];
        return;
    }
    if (![NSString validateIdentityCard:_identityCardField.text] && _identityCardField.text.length>0) {
        [self showTips:@"请输入正确身份证号"];
        return;
    }
    if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
        if (_sourceData == nil || [self isBlankString:_sourceData.code]) {
            [self showTips:@"请选择客户来源"];
            return;
        }
    }
    //    电话号码不能为空
    NSString *tel = nil;
    if (!bIsHiddenNum) {
//        if ([telTextField.text rangeOfString:@"****"].location != NSNotFound) {
//            [self showTips:@"手机号为全数字,请重新输入"];
//            return;
//        }
        NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
        NSString *str = @"";
        for (int i=0; i<array.count; i++) {
            str = [str stringByAppendingString:[array objectForIndex:i]];
        }
        tel = str;
    }else
    {
        if (!telTextField.hidden) {
            NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
            NSString *str = @"";
            for (int i=0; i<array.count; i++) {
                str = [str stringByAppendingString:[array objectForIndex:i]];
            }
            tel = str;
        }else{
            if (![self isBlankString:firstNum.text] && ![self isBlankString:tailNum.text]) {
                tel = [NSString stringWithFormat:@"%@****%@",firstNum.text,tailNum.text];
            }
        }
    }
    
    if ([self isBlankString:tel] || tel.length != 11) {
        [self showTips:@"请输入11位手机号"];
        if (bIsHiddenNum) {
            [firstNum becomeFirstResponder];
        }else{
            [telTextField becomeFirstResponder];
        }
        return;
    }
    
    //    楼盘不能为空
    NSString *buildings = @"";
//    if (bIsHiddenNum) {
//        if (notFullPhoneLoupArr.count==0) {
//            [self showTips:@"请选择楼盘"];
//            return;
//        }
//        for (int i=0; i<notFullPhoneLoupArr.count; i++) {
//            CustomerBuilding *custBuild = (CustomerBuilding*)[notFullPhoneLoupArr objectForIndex:i];
//            if (i==0) {
//                buildings = custBuild.buildingId;
//            }else
//            {
//                buildings = [NSString stringWithFormat:@"%@,%@",buildings,custBuild.buildingId];
//            }
//        }
//    }else
//    {
        if (loupArr.count==0) {
            [self showTips:@"请选择楼盘"];
            return;
        }
    NSString *visitInfo = @"";
    NSString *confirmInfo = @"";
    NSMutableArray *buildArr = [[NSMutableArray alloc] init];
    NSMutableArray *confirmArr = [[NSMutableArray alloc] init];
        for (int i=0; i<loupArr.count; i++) {
            CustomerBuilding *custBuild = (CustomerBuilding*)[loupArr objectForIndex:i];
            if (i==0) {
                buildings = custBuild.buildingId;
            }else
            {
                buildings = [NSString stringWithFormat:@"%@,%@",buildings,custBuild.buildingId];
            }
            
            CustomerVisitInfoData *visitData = (CustomerVisitInfoData*)[_visitDic valueForKey:custBuild.buildingId];
            
            if ([custBuild.customerVisitEnable boolValue]) {
                NSMutableDictionary *buildDic = [[NSMutableDictionary alloc] init];
                [buildDic setValue:custBuild.buildingId forKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                NSString *startStr = [dateFormatter stringFromDate:visitData.startDate];
                NSString *endStr = [dateFormatter stringFromDate:visitData.endDate];
                if (![self isBlankString:startStr]) {
                    [buildDic setValue:startStr forKey:@"visitTimeBegin"];
                }
                if (![self isBlankString:endStr]) {
                    [buildDic setValue:endStr forKey:@"visitTimeEnd"];
                }
                [buildDic setValue:[visitData.visitCount substringToIndex:visitData.visitCount.length-1] forKey:@"numPeople"];
                [buildDic setValue:visitData.transfFunc forKey:@"trafficMode"];
                [buildArr appendObject:buildDic];
            }
            
            ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[_confirmDic valueForKey:custBuild.buildingId];
            if ([custBuild.mechanismType boolValue]) {
                NSMutableDictionary *buildDic = [[NSMutableDictionary alloc] init];
                [buildDic setValue:custBuild.buildingId forKey:@"buildingId"];
                [buildDic setValue:confirmData.confirmUserId forKey:@"confirmUserId"];
                [confirmArr appendObject:buildDic];
            }
        }
//    }
    if (buildArr.count > 0) {
        NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:buildArr,@"customerList", nil];
        visitInfo = [QuickReportViewController dictionaryToJson:phoneListDic];
    }
    if (confirmArr.count > 0) {
        NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:confirmArr,@"confirmUsers", nil];
        confirmInfo = [QuickReportViewController dictionaryToJson:phoneListDic];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:nameTextField.text forKey:@"name"];
    [dic setValue:buildings forKey:@"buildingIds"];
    [dic setValue:self.sexString forKey:@"sex"];
    [dic setValue:tel forKey:@"phone"];
    if (_custData!=nil) {
        if (![self isBlankString:_custData.customerId]) {
            [dic setValue:_custData.customerId forKey:@"customerId"];
        }
    }
    if (![self isBlankString:visitInfo]) {
        [dic setValue:visitInfo forKey:@"customerVisitInfo"];
    }
    if (![self isBlankString:confirmInfo]) {
        [dic setValue:confirmInfo forKey:@"confirmUsers"];
    }
    if (![self isBlankString:_identityCardField.text]) {
        [dic setValue:_identityCardField.text forKey:@"cardId"];
    }
    if (![self isBlankString:_sourceData.code]) {
        [dic setValue:_sourceData.code forKey:@"custSource"];
    }
    if (!_bIsTouched) {
        [reportBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];
        _bIsTouched = YES;
        if (self.loupArr.count>1) {
            [MobClick event:@"ksbb_plxzlp"];//快速报备-批量选择楼盘
        }
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = [self setRotationAnimationWithView];
//        __weak QuickReportViewController *weakSelf = self;
        [[DataFactory sharedDataFactory] fastSaveCustomerWithDict:dic withCallBack:^(ActionResult *result, ReportReturnData *returnData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
                if (result.success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
                    if (returnData.failBuildingList.count>0) {//如果部分提交成功，则打开跳转至报备提示页面，显示失败原因
                        NSString *tempStr = @"0";
                        if ([self isBlankString:returnData.count]) {
                            if ([self isBlankString:self.custData.count]) {
                                tempStr = self.count;
                            }else
                            {
                                tempStr = self.custData.count;
                            }
                        }else
                        {
                            tempStr = returnData.count;
                        }
//                        weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",tempStr];
//                        weakSelf.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",tempStr];
                        ReportTipViewController *reportTipVC = [[ReportTipViewController alloc] init];
                        reportTipVC.reportFailType = kfailBuilding;
                        reportTipVC.reportData = returnData;
                        reportTipVC.customerId = _custData.customerId;
                        reportTipVC.type = 5;
//                        if (weakSelf.bIsHiddenNum) {
//                            reportTipVC.dataArray = weakSelf.notFullPhoneLoupArr;
//                        }else
//                        {
                            reportTipVC.dataArray = self.loupArr;
//                        }
                        reportTipVC.custVisitDic = self.visitDic;
                        reportTipVC.confirmDic = self.confirmDic;
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.bIsTouched = NO;
                            [self.reportBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                            [self.navigationController pushViewController:reportTipVC animated:YES];
                            [self performSelector:@selector(clearData) withObject:nil afterDelay:3];
                        });
                    }else
                    {//如全部提交成功，则跳转至报备记录页面已报备状态下
                        [self showTips:result.message];
                        NSString *tempStr = @"0";
                        if ([self isBlankString:returnData.count]) {
                            if ([self isBlankString:self.custData.count]) {
                                tempStr = self.count;
                            }else
                            {
                                tempStr = self.custData.count;
                            }
                        }else
                        {
                            tempStr = returnData.count;
                        }
//                        weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",tempStr];
//                        weakSelf.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",tempStr];
                        RecommendRecordController* rrVC = [[RecommendRecordController alloc]init];
                        rrVC.currentIndex = 1;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.bIsTouched = NO;
                            [self.reportBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                            [self.navigationController pushViewController:rrVC animated:YES];
                            [self performSelector:@selector(clearData) withObject:nil afterDelay:3];
                        });
                    }
                }else
                {//提交失败，留在当前页
                    self.bIsTouched = NO;
                    [self showTips:result.message];
                    [self.reportBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                    
                    NSString *tempStr = @"0";
                    if ([self isBlankString:returnData.count]) {
                        if ([self isBlankString:self.custData.count]) {
                            tempStr = self.count;
                        }else
                        {
                            tempStr = self.custData.count;
                        }
                    }else
                    {
                        tempStr = returnData.count;
                    }
//                    weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",tempStr];
//                    weakSelf.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",tempStr];
                }
            });
        }];
    }
}

- (void)toggleSexBtn:(UIButton*)sender
{
    [self.view endEditing:YES];
    if (sender.tag == 1131) {
        if(!sender.selected) {
            sender.selected = NO;
            
            manButton.selected = YES;
            sender.selected = !sender.selected;
            manButton.selected = !manButton.selected;
            self.sexString = @"female";
        }
        
    }else if (sender.tag == 1132)
    {
        if(!sender.selected) {
            sender.selected = NO;
            womanButton.selected = YES;
            sender.selected = !sender.selected;
            womanButton.selected = !womanButton.selected;
            self.sexString = @"male";
        }
    }
}

//- (void)toggleMobileButton:(UIButton*)sender
//{
//    if (!sender.selected) {
//        [mobileBtn setTitle:@"全号" forState:UIControlStateNormal];
//        [mobileBtn setBackgroundColor:BLUEBTBCOLOR];
//        [mobileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        mobileView.hidden = NO;
//        bIsHiddenNum = NO;
//        sender.selected = YES;
//    }else{
//        [mobileBtn setTitle:@"隐号" forState:UIControlStateNormal];
//        [mobileBtn setBackgroundColor:[UIColor whiteColor]];
//        [mobileBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//        mobileView.hidden = YES;
//        bIsHiddenNum = YES;
//        sender.selected = NO;
//    }
//    [self.tableView reloadData];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    if (textField.tag == 1010) {
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
                [self showTips:@"请输入11位手机号"];
                [textField resignFirstResponder];
                return NO;
            }
            else if ([self noneSpaseString:textField.text].length + string.length - range.length == 11)
            {
                NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
                NSString *phone = @"";
                for (int i=0; i<array.count; i++) {
                    phone = [phone stringByAppendingString:[array objectForIndex:i]];
                }
                phone = [phone stringByAppendingString:string];
                [[DataFactory sharedDataFactory] validationMobileWithPhone:phone withCallBack:^(ActionResult *result, Customer *cust) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.success) {
                            if ([cust.exist boolValue]) {
                                //[weakSelf showTips:result.message];
                                self.custData = cust;
                            }
                        }else
                        {
                            [self showTips:result.message];
                        }
                        
                    });
                }];
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![string isValidNumber]){
                return NO;
            }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
    }else
    {
        //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
        if(![string isValidNumber]){
            return NO;
        }
    }
    
    
    return YES;
    
}

-(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >2) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 7) {
        [mStr insertString:@" " atIndex:8];
        
    }
    
    return  mStr;
}

- (void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    [self.view endEditing:YES];
    
}
#pragma mark - UITextFieldDelegate
//- (void)nameTextFieldEndChanged
//{
//    if ([self isBlankString:nameTextField.text]) {
//        [self showTips:@"请输入客户姓名"];
//    }
//}

- (void)nameTextFieldDidChanged
{
    if (nameTextField.text.length >= 15) {
        nameTextField.text = [nameTextField.text substringToIndex:15];
        [nameTextField resignFirstResponder];
    }
}

- (void)identityTextFieldDidChanged
{
    if (_identityCardField.text.length >= 18) {
        _identityCardField.text = [_identityCardField.text substringToIndex:18];
        [_identityCardField resignFirstResponder];
    }
}

//- (void)telTextFieldEndChanged
//{
//    NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
//    NSString *str = @"";
//    for (int i=0; i<array.count; i++) {
//        str = [str stringByAppendingString:[array objectForIndex:i]];
//    }
//    if (![NSString isValidateMobile:str] || [self isBlankString:telTextField.text]) {
//        [self showTips:@"请输入11位手机号"];
//        return;
//    }
//}

- (void)firstNumTextFieldDidChanged
{
    if (firstNum.text.length >= 3) {
        //        [firstNum resignFirstResponder];
        firstNum.text = [firstNum.text substringToIndex:3];
        if (tailNum.text.length==4) {
            [firstNum resignFirstResponder];
        }else{
            [tailNum becomeFirstResponder];
        }
    }
}
- (void)tailNumTextFieldDidChanged{
    if (tailNum.text.length >= 4) {
        tailNum.text = [tailNum.text substringToIndex:4];
        if (firstNum.text.length==3) {
            [tailNum resignFirstResponder];
        }else{
            [firstNum becomeFirstResponder];
        }
        //        [firstNum becomeFirstResponder];
    }
}

- (void)clearData
{
    if (self.custData != nil) {
        self.nameTextField.enabled = YES;
//        self.nameTextField.textColor = NAVIGATIONTITLE;
        firstNum.enabled = YES;
        tailNum.enabled = YES;
        if (bIsHiddenNum) {
            self.telTextField.hidden = YES;
        }else
        {
            self.telTextField.enabled = YES;
//            self.telTextField.textColor = NAVIGATIONTITLE;
        }
    }
    self.custData = nil;
    self.nameTextField.text = @"";
    self.telTextField.text = @"";
    self.firstNum.text = @"";
    self.tailNum.text = @"";
    self.sexString = @"";
    self.identityCardField.text = @"";
    self.custSourceLabel.text = @"";
    self.sourceData.code = nil;
    self.sourceData.label = nil;
    self.manButton.selected = NO;
    self.womanButton.selected = NO;
    [self.loupArr removeAllObjects];
    [self.visitDic removeAllObjects];
    [self.confirmDic removeAllObjects];
//    [self.notFullPhoneLoupArr removeAllObjects];
    self.blankLabel.hidden = NO;
    
//    UserData *user = [UserData sharedUserData];
//    self.count = user.maxRecommendCount;
//    if ([self isBlankString:user.maxRecommendCount]) {
//        self.count = @"0";
//    }
//    self.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",self.count];
//    self.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",self.count];
    [self.tableView reloadData];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
