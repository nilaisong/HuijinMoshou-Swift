//
//  CustomerReportViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerReportViewController.h"
#import "LocalContactsViewController.h"
#import "NSString+Extension.h"
#import "NSString+TKUtilities.h"
#import "ExpectSelectButton.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CustomerBaseBuildView.h"
#import "CustomerTextField.h"
#import "CustomerTextView.h"
#import "CustomerRangeSlider.h"
#import "ReportTipViewController.h"
#import "BuildingDetailViewController.h"
#import "MyBuildingViewController.h"

#import "ConfirmUserListView.h"
#import "ConfirmUserInfoObject.h"
#import "CustomerSourceViewController.h"

#import "UserData.h"
#import "CustReportSelectViewController.h"
#import "BuildingRecViewController.h"

#define heightScale 1110.0/1333
#define BUTTON_HEIGHT                  30               //按钮高


@interface CustomerReportViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *goufImgView;
    //    NSString    *visitMethod;
    //    CGPoint     point;
    
    int _row;
    CGFloat _allWidth;
    NSMutableArray *_itemArray;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSDate    *tempDate;
    BOOL      bIsStartDateButton;
    
}
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;//直接添加到self.view上的可滑动view，全部的操作都添加到这个view上面
@property (nonatomic, strong) UIView *headerView;//顶部布局，报备新客户与增加新客户布局相同，修改少一个通讯录
@property (nonatomic, strong) UIView *userInfoView;//客户姓名手机号码背景view
@property (nonatomic, strong) UIView *secondView;//客户备注和购房意向标题view
@property (nonatomic, strong) UIView *middleView;//购房意向展开页面
@property (nonatomic, strong) UIView *bottomView;//底部布局
@property (nonatomic, strong) UIView *telTextFieldView;
@property (nonatomic, strong) UITextField *nameTextField;//输入客户姓名
@property (nonatomic, strong) UITextField *telTextField;//输入电话号码，修改页面不可输入，字体颜色稍浅
@property (nonatomic, copy) NSString    *sexString;//选择性别后生成的字符串
@property (nonatomic, strong) UIButton *manButton;
@property (nonatomic, strong) UIButton *womanButton;
@property (nonatomic, strong) UIButton *saveBtn;//保存按钮
@property (nonatomic, strong) NSMutableArray *intentionTypeArray;//意向类型name数组
@property (nonatomic, strong) NSMutableArray *intentionHouseArray;//意向户型name数组
@property (nonatomic, strong) CustomerTextView *remarksTextView;//备注
@property (nonatomic, strong) NSMutableArray *typeArray;//保存的意向类型
@property (nonatomic, strong) NSMutableArray *layoutArray;//保存的意向户型
@property (nonatomic, strong) NSMutableArray *typeDataArray;//意向类型option对象数组
@property (nonatomic, strong) NSMutableArray *layoutDataArray;//意向户型。。。
@property (nonatomic, strong) NSMutableArray *purchaseArray;//修改界面的购房意向
@property (nonatomic, assign) BOOL           bIsTouched;//互斥锁，防止保存报备过程中多次点击
@property (nonatomic, assign) BOOL           bIsHiddenNum;//手机号是否全部显示 （0全部显示，1部分显示）
@property (nonatomic, strong) CustomerTextField    *firstNum;//隐号报备前三位
@property (nonatomic, strong) CustomerTextField    *tailNum;//隐号报备后四位
@property (nonatomic, strong) UILabel        *middleNum;//隐号报备中间四位*号展示
@property (nonatomic, strong) UITextField *minimumField;//最低总价
@property (nonatomic, strong) UITextField *maximumField;//最高总价
@property (nonatomic, strong) UIView        *visitInfoView;//到访信息展示
@property (nonatomic, strong) UILabel       *dateStartLabel;
@property (nonatomic, strong) UILabel       *dateEndLabel;
@property (nonatomic, strong) UILabel       *countVisitLabel;
@property (nonatomic, copy) NSString        *transfStr;//交通方式字符串
@property (nonatomic, strong) NSDate        *startDate;//开始日期
@property (nonatomic, strong) NSDate        *endDate;//结束日期

@property (nonatomic, strong) UIView         *customerView;
@property (nonatomic, strong) UIView         *dateSelectView;//到访时间展开选择
@property (nonatomic, strong) UIView         *dateView;//到访日期展示
@property (nonatomic, strong) UIView         *countView;//展示到访人数
@property (nonatomic, strong) UIView         *transfView;//交通方式
@property (nonatomic, strong) UIButton       *subBtn;//人数减少按钮
@property (nonatomic, strong) UIButton       *addBtn;//人数增加按钮
@property (nonatomic, strong) UIPickerView   *datePickerView;//日期选择器
@property (nonatomic, strong) NSMutableArray *dateArray;//时间日期数组
@property (nonatomic, strong) NSMutableArray *hourArray;//时间小时数组
@property (nonatomic, strong) NSMutableArray *minuteArray;//时间分钟数组
@property (nonatomic, strong) NSArray        *dataSource;
@property (nonatomic, assign) int            count;//看房人数

@property (nonatomic, strong) UIView         *confirmView;//确客信息
@property (nonatomic, strong) UILabel        *confirmUserLabel;//展示确客姓名使用
@property (nonatomic, strong) ConfirmUserInfoObject *confirmData;//block块返回确客信息使用
@property (nonatomic, strong) UITextField    *identityCardField;//客户身份证号
@property (nonatomic, strong) UILabel        *custSourceLabel;//客户来源回显使用
@property (nonatomic, strong) NSMutableArray *confirmArr;
@property (nonatomic, strong) CustomerSourceData *sourceData;


@end

@implementation CustomerReportViewController
@synthesize headerView;
@synthesize userInfoView;
@synthesize secondView;
@synthesize middleView;
@synthesize bottomView;
@synthesize telTextFieldView;
@synthesize nameTextField,telTextField;
@synthesize manButton;
@synthesize womanButton;
@synthesize saveBtn;
@synthesize scrollView;
@synthesize intentionHouseArray,intentionTypeArray;
@synthesize remarksTextView;
@synthesize bIsHiddenNum;
@synthesize firstNum;
@synthesize tailNum;
@synthesize middleNum;
@synthesize minimumField;
@synthesize maximumField;
@synthesize typeArray;
@synthesize layoutArray;
@synthesize typeDataArray;
@synthesize layoutDataArray;
@synthesize customerData;
@synthesize purchaseArray;
@synthesize customerView;
@synthesize dateSelectView;
@synthesize dateView;
@synthesize countView;
@synthesize transfView;
@synthesize visitInfoView;
@synthesize subBtn;
@synthesize addBtn;
@synthesize datePickerView;
@synthesize dateArray;
@synthesize hourArray;
@synthesize minuteArray;
@synthesize dataSource;
@synthesize count;
@synthesize startDate;
@synthesize endDate;
@synthesize confirmView;
@synthesize confirmUserLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.popGestureRecognizerEnable = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //数组初始化
    intentionTypeArray = [[NSMutableArray alloc] init];
    intentionHouseArray = [[NSMutableArray alloc] init];
    
    typeDataArray = [[NSMutableArray alloc] init];
    layoutDataArray = [[NSMutableArray alloc] init];
    
    typeArray = [[NSMutableArray alloc] init];
    layoutArray = [[NSMutableArray alloc] init];
    _confirmArr = [[NSMutableArray alloc] init];
    _sourceData = [[CustomerSourceData alloc] init];
    dataSource = @[@"公交",@"自驾",@"班车"];
    count = 1;
    self.navigationBar.titleLabel.text = @"报备客户";
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (scrollView.superview) {
        scrollView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-54);
    }
}

- (void)hasNetwork
{
    __weak typeof(self) customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    //手机号是否全部显示 （0全部显示，1部分显示）
    BOOL mobile = [UserData sharedUserData].userInfo.mobileVisable;
    if (mobile && ![_customerTelType boolValue]) {
        bIsHiddenNum = YES;
    }
    
/*    NSString *puchaseIntention = customerData.expect;
    puchaseIntention = [puchaseIntention stringByReplacingOccurrencesOfString:@"，" withString:@" "];
    puchaseIntention = [puchaseIntention stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    purchaseArray = [NSMutableArray arrayWithArray:[puchaseIntention componentsSeparatedByString:@" "]];
    if (purchaseArray.count>0) {
        [purchaseArray removeObjectForIndex:0];
        if (purchaseArray.count>0) {
            if ([[purchaseArray objectForIndex:purchaseArray.count-1] isEqualToString:@""]) {
                [purchaseArray removeLastObject];
            }
        }
    }*/
    
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY-54)];
    scrollView.delegate = self;
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:scrollView];
    
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-54, kMainScreenWidth-20, 44)];
    [saveBtn setTitle:@"报备" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BLUEBTBCOLOR];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [saveBtn.layer setCornerRadius:4.0];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn addTarget:self action:@selector(toggleSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    [self initHeaderView];
    [self initSecondView];
    [self initBottomView];
    if (_bIsShowVisitInfo) {
        [self createCustomerVisitView];
        if (_mechanismType) {
            [self createConfirmUserViewWithY:visitInfoView.bottom];
            bottomView.top = confirmView.bottom+10;
        }else
        {
            bottomView.top = visitInfoView.bottom;
        }
        scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
    }else
    {
        if (_mechanismType) {
            [self createConfirmUserViewWithY:secondView.bottom+10];
            bottomView.top = confirmView.bottom+10;
        }else
        {
            bottomView.top = secondView.bottom+10;
        }
        scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
    }
    if (self.mechanismType) {
        [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingID WithCallBack:^(ActionResult *result, NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_confirmArr addObjectsFromArray:array];
            });
        }];
    }
//    [self initMiddleView];
//    middleView.hidden = YES;
    
    //获取购房意向
/*    UIImageView* loadingView = [self setRotationAnimationWithView];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[DataFactory sharedDataFactory] getExpectDataWithCallBack:^(ActionResult *result,ExpectData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeRotationAnimationView:loadingView];
                if (!result.success) {
                    [self showTips:result.message];
                }
                for (int i=0; i<data.expectType.count; i++) {
                    OptionData *option = (OptionData*)[data.expectType objectForIndex:i];
                    if (![self isBlankString:option.itemName]) {
                        [intentionTypeArray appendObject:option.itemName];
                        [typeDataArray appendObject:option];
                    }
                }
                
                for (int i=0; i<data.expectLayout.count; i++) {
                    OptionData *option = (OptionData*)[data.expectLayout objectForIndex:i];
                    if (![self isBlankString:option.itemName]) {
                        [intentionHouseArray appendObject:option.itemName];
                        [layoutDataArray appendObject:option];
                    }
                }
                [middleView removeAllSubviews];
                [middleView removeFromSuperview];
                [self initMiddleView];
                middleView.hidden = YES;
            });
        }];
        [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingID WithCallBack:^(ActionResult *result, NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_confirmArr addObjectsFromArray:array];
            });
        }];
    }else
    {
        [self removeRotationAnimationView:loadingView];
        [self showTips:@"网络连接失败"];
    }*/
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - initHeaderView
- (void)initHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    UIButton *customerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-102, 10, 102, 30)];
    [customerBtn setTitle:@"客户列表导入" forState:UIControlStateNormal];
    [customerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [customerBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    customerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [customerBtn setBackgroundImage:[UIImage imageNamed:@"select-left-xian"] forState:UIControlStateNormal];
    [customerBtn setBackgroundImage:[UIImage imageNamed:@"select-left"] forState:UIControlStateHighlighted];
    [customerBtn addTarget:self action:@selector(toggleCustomerButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:customerBtn];
    
    UIButton *mailListBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, 10, 102, 30)];
    [mailListBtn setTitle:@"通讯录导入" forState:UIControlStateNormal];
    [mailListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [mailListBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    mailListBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [mailListBtn setBackgroundImage:[UIImage imageNamed:@"select-right-xian"] forState:UIControlStateNormal];
    [mailListBtn setBackgroundImage:[UIImage imageNamed:@"select-right"] forState:UIControlStateHighlighted];
    [mailListBtn addTarget:self action:@selector(toggleLocalCustomer:) forControlEvents:UIControlEventTouchUpInside];
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
    
    headerView.height = userInfoView.bottom+10;
    [scrollView addSubview:headerView];
}

#pragma mark - initSecondView
- (void)initSecondView
{
    secondView = [[UIView alloc] initWithFrame:CGRectMake(0, userInfoView.bottom, kMainScreenWidth, 0)];
    secondView.backgroundColor = BACKGROUNDCOLOR;
    [secondView addSubview:[self createLineView:0 withX:0]];
    [secondView addSubview:[self createLineView:9.5 withX:0]];
    
    UIView *remarksBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 88)];
    remarksBgView.backgroundColor = [UIColor whiteColor];
    [secondView addSubview:remarksBgView];
    
    [secondView addSubview:[self createLineView:remarksBgView.bottom-0.5 withX:0]];
    
    remarksTextView = [[CustomerTextView alloc] initWithFrame:CGRectMake(10, remarksBgView.top+7, remarksBgView.width-20, remarksBgView.height-14)];
    remarksTextView.placeHolder = @"请输入备注";
    remarksTextView.font = [UIFont systemFontOfSize:15];
    remarksTextView.delegate = self;
    remarksTextView.textColor = NAVIGATIONTITLE;
    [secondView addSubview:remarksTextView];
    
    CGFloat kHeight = remarksBgView.bottom;
    if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
        //客户来源
        [secondView addSubview:[self createLineView:remarksBgView.bottom+9.5 withX:0]];
        CustomerBaseBuildView *custView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, remarksBgView.bottom+10, kMainScreenWidth, 44) Title:@"客户来源" AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:4];
        custView.backgroundColor = [UIColor whiteColor];
        [secondView addSubview:custView];
        
        _custSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7, kMainScreenWidth-150-33, 30)];
        _custSourceLabel.textColor = TFPLEASEHOLDERCOLOR;
        _custSourceLabel.textAlignment = NSTextAlignmentRight;
        _custSourceLabel.font = FONT(13);
        [custView addSubview:_custSourceLabel];
        
        [secondView addSubview:[self createLineView:custView.bottom withX:0]];
        [secondView addSubview:[self createLineView:custView.bottom+9.5 withX:0]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCustomer:)];
        [custView addGestureRecognizer:tapGesture];
        kHeight = custView.bottom;
    }
    
    //购房意向
/*    UIView *goufangView = [[UIView alloc] initWithFrame:CGRectMake(0, custView.bottom+10, kMainScreenWidth, 44)];
    goufangView.backgroundColor = [UIColor whiteColor];
    [secondView addSubview:goufangView];
    
    [secondView addSubview:[self createLineView:goufangView.bottom withX:0]];
    
    UILabel *goufLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 150, 30)];
    goufLabel.text = @"购房意向";
    goufLabel.textColor = NAVIGATIONTITLE;
    goufLabel.font = [UIFont systemFontOfSize:16];
    [goufangView addSubview:goufLabel];
    
    goufImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 30, goufLabel.top + 11, 14, 8)];
    [goufImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    [goufangView addSubview:goufImgView];
    
    UIButton *goufBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, custView.bottom+10, kMainScreenWidth, 44)];
    [goufBtn setBackgroundColor:[UIColor clearColor]];
    [goufBtn addTarget:self action:@selector(toggleGoufBtn:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:goufBtn];*/
    secondView.height = kHeight;//goufangView.bottom;
    [scrollView addSubview:secondView];
}
#pragma mark - initMiddleView
- (void)initMiddleView
{
    middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor whiteColor];
    
    [middleView addSubview:[self createLineView:0 withX:10]];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    totalLabel.text = @"总价";
    totalLabel.textColor = TFPLEASEHOLDERCOLOR;
    totalLabel.font = [UIFont systemFontOfSize:12];
    [middleView addSubview:totalLabel];
    
    //    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-100, totalLabel.bottom+15, 8, 12)];
    //    [leftImgView setImage:[UIImage imageNamed:@"icon_rmb"]];
    //    [middleView addSubview:leftImgView];
    NSString *str= @"万";
    NSDictionary *attributes = @{NSFontAttributeName:FONT(15)};
    CGSize size = [str sizeWithAttributes:attributes];
    
    UILabel *leftLineL = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-90-size.width - 10, totalLabel.bottom+15+12+5, 70, 0.5)];//CGRectMake(leftImgView.left, leftImgView.bottom+5, 70, 0.5)
    leftLineL.backgroundColor = CustomerBorderColor;
    [middleView addSubview:leftLineL];
    
    UILabel *leftPriceL = [[UILabel alloc] initWithFrame:CGRectMake(leftLineL.right+5, leftLineL.bottom-size.height, size.width, size.height)];
    leftPriceL.textColor = TFPLEASEHOLDERCOLOR;
    leftPriceL.backgroundColor = [UIColor clearColor];
    leftPriceL.textAlignment = NSTextAlignmentLeft;
    leftPriceL.font = FONT(14);
    leftPriceL.text = str;
    [middleView addSubview:leftPriceL];
    
    UILabel *middleLineL = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-10, totalLabel.bottom+15+8, 20, 0.5)];//CGRectMake(kMainScreenWidth/2-10, leftImgView.top+8, 20, 0.5)
    middleLineL.backgroundColor = CustomerBorderColor;
    [middleView addSubview:middleLineL];
    
    //    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(middleLineL.right+15, totalLabel.bottom+15, 8, 12)];
    //    [rightImgView setImage:[UIImage imageNamed:@"icon_rmb"]];
    //    [middleView addSubview:rightImgView];
    
    UILabel *rightLineL = [[UILabel alloc] initWithFrame:CGRectMake(middleLineL.right+15, leftLineL.top, 70, 0.5)];//CGRectMake(rightImgView.left, rightImgView.bottom+5, 70, 0.5)
    rightLineL.backgroundColor = CustomerBorderColor;
    [middleView addSubview:rightLineL];
    
    UILabel *rightPriceL = [[UILabel alloc] initWithFrame:CGRectMake(rightLineL.right+5, leftLineL.bottom-size.height, size.width, size.height)];
    rightPriceL.textColor = TFPLEASEHOLDERCOLOR;
    rightPriceL.backgroundColor = [UIColor clearColor];
    rightPriceL.textAlignment = NSTextAlignmentLeft;
    rightPriceL.font = FONT(14);
    rightPriceL.text = @"万";
    [middleView addSubview:rightPriceL];
    
    minimumField = [[UITextField alloc] initWithFrame:CGRectMake(leftLineL.left+2, totalLabel.bottom+15-10, 66, 30)];//CGRectMake(leftImgView.right+1, leftImgView.top-10, 60, 30)
    minimumField.text = @"0";
    minimumField.keyboardType = UIKeyboardTypePhonePad;
    minimumField.delegate = self;
    minimumField.tag = 1003;
//    if (customerViewCtrlType == kModifyCustomer) {
        if (![self isBlankString:customerData.expectData.expectPriceMin]) {
            minimumField.text = customerData.expectData.expectPriceMin;
        }
//    }
    minimumField.textAlignment = NSTextAlignmentCenter;
    minimumField.textColor = BLUEBTBCOLOR;
    minimumField.font = [UIFont systemFontOfSize:20];
    [minimumField addTarget:self action:@selector(minimumFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview:minimumField];
    
    maximumField = [[UITextField alloc] initWithFrame:CGRectMake(rightLineL.left+2, totalLabel.bottom+15-10, 66, 30)];
    maximumField.text = @"1000";
    maximumField.keyboardType = UIKeyboardTypePhonePad;
    maximumField.delegate = self;
    maximumField.tag = 1004;
//    if (customerViewCtrlType == kModifyCustomer) {
        if (![self isBlankString:customerData.expectData.expectPriceMax]) {
            maximumField.text = customerData.expectData.expectPriceMax;
        }
//    }
    maximumField.textAlignment = NSTextAlignmentCenter;
    maximumField.textColor = BLUEBTBCOLOR;
    maximumField.font = [UIFont systemFontOfSize:20];
    [maximumField addTarget:self action:@selector(maximumFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview:maximumField];
    
    //    rangeSlider = [[CustomerRangeSlider alloc] initWithFrame:CGRectMake(25, 80, kMainScreenWidth-50, 40)];
    //    [self configureLabelSlider];
    //    [middleView addSubview:rangeSlider];
    //
    //    [middleView addSubview:[self createLineView:130 withX:10]];
    if ([self verifyTheRulesWithShouldJump:NO])
    {//判断是否绑定门店
        [middleView addSubview:[self createLineView:90 withX:10]];
        
        UILabel *intentionTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 90+5, 100, 30)];//CGRectMake(15, 130+5, 100, 30)
        intentionTypeLabel.text = @"意向类型";
        intentionTypeLabel.textColor = TFPLEASEHOLDERCOLOR;
        intentionTypeLabel.font = [UIFont systemFontOfSize:12];
        [middleView addSubview:intentionTypeLabel];
        
        ExpectSelectButton *tagView = [[ExpectSelectButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(intentionTypeLabel.frame)+5, kMainScreenWidth, 0)];
        tagView.backgroundColor = [UIColor whiteColor];
        tagView.padding = UIEdgeInsetsMake(0, 15, 10, 15); //上,左,下,右,的边距
        tagView.horizontalSpace = 10;                       //横向间隔
        tagView.verticalSpace = 10;                         //纵向间隔
        tagView.tagValue = 1221;
        tagView.btnEnabled = YES;
//        if (customerViewCtrlType == kModifyCustomer) {
            tagView.purchseArray = purchaseArray;
//        }
        tagView.dataSource = intentionTypeArray;
        __weak typeof(self) customer = self;
        //数据源
        [tagView excptButtonSeleteBlock:^(int index,BOOL isSelected){
            if (isSelected) {
                if (customer.typeDataArray.count > index) {
                    [customer.typeArray appendObject:((OptionData*)[customer.typeDataArray objectForIndex:index]).itemValue];
                }
            }else
            {
                if (customer.typeDataArray.count > index) {
                    [customer.typeArray removeObject:((OptionData*)[customer.typeDataArray objectForIndex:index]).itemValue];
                }
            }
        }];
        [middleView addSubview:tagView];
        
        [middleView addSubview:[self createLineView:CGRectGetMaxY(tagView.frame)+5 withX:10]];
        
        UILabel *intentionHouseLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tagView.frame)+10, 100, 30)];
        intentionHouseLabel.text = @"意向户型";
        intentionHouseLabel.textColor = TFPLEASEHOLDERCOLOR;
        intentionHouseLabel.font = [UIFont systemFontOfSize:12];
        [middleView addSubview:intentionHouseLabel];
        
        ExpectSelectButton *houseTagView = [[ExpectSelectButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(intentionHouseLabel.frame)+5, kMainScreenWidth, 0)];
        houseTagView.backgroundColor = [UIColor whiteColor];
        houseTagView.padding = UIEdgeInsetsMake(0, 15, 10, 15); //上,左,下,右,的边距
        houseTagView.horizontalSpace = 10;                       //横向间隔
        houseTagView.verticalSpace = 10;                         //纵向间隔
        houseTagView.tagValue = 1231;
        houseTagView.btnEnabled = YES;
//        if (customerViewCtrlType == kModifyCustomer) {
            houseTagView.purchseArray = purchaseArray;
//        }
        houseTagView.dataSource = intentionHouseArray;                        //数据源
        [houseTagView excptButtonSeleteBlock:^(int index,BOOL isSelected){
            if (isSelected) {
                if (customer.layoutDataArray.count > index) {
                    [customer.layoutArray appendObject:((OptionData*)[customer.layoutDataArray objectForIndex:index]).itemValue];
                }
            }else
            {
                if (customer.layoutDataArray.count > index) {
                    [customer.layoutArray removeObject:((OptionData*)[customer.layoutDataArray objectForIndex:index]).itemValue];
                }
            }
        }];
        [middleView addSubview:houseTagView];
        
        middleView.frame = CGRectMake(0, secondView.bottom, kMainScreenWidth, CGRectGetMaxY(houseTagView.frame));
        [middleView addSubview:[self createLineView:middleView.height-0.5 withX:0]];
    }else
    {
        middleView.frame = CGRectMake(0, secondView.bottom, kMainScreenWidth, 90);
        [middleView addSubview:[self createLineView:middleView.height-0.5 withX:0]];
    }
    
    [scrollView addSubview:middleView];
}
#pragma mark - initBottomView
- (void)initBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, secondView.bottom+10, kMainScreenWidth, 0)];//140
    bottomView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bottomView];
    
    //报备楼盘
    UIView *reportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
//    reportView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:reportView];
    
    [reportView addSubview:[self createLineView:0 withX:0]];
    [reportView addSubview:[self createLineView:reportView.height-0.5 withX:0]];
    
    UILabel *reportL = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 150, 30)];
    reportL.text = @"报备楼盘";
    reportL.textColor = NAVIGATIONTITLE;
    reportL.font = FONT(16);
    [reportView addSubview:reportL];
    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8, 15, 8, 14)];
//    [imgView setImage:[UIImage imageNamed:@"arrow-right"]];
//    [reportView addSubview:imgView];
    
    UILabel *_loupNameL = [[UILabel alloc] initWithFrame:CGRectMake(10, reportView.bottom+7, kMainScreenWidth-10-100-10, 30)];
    _loupNameL.text = _buildingName;
    _loupNameL.textColor = NAVIGATIONTITLE;
    _loupNameL.textAlignment = NSTextAlignmentLeft;
    _loupNameL.font = [UIFont boldSystemFontOfSize:16];
    [bottomView addSubview:_loupNameL];
    //距离
    UILabel *buildDistanceL = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-100-10, _loupNameL.top, 100, 30)];
    buildDistanceL.font = FONT(13);
    buildDistanceL.textColor = [UIColor colorWithHexString:@"888888"];
    buildDistanceL.text = [NSString stringWithFormat:@"%@km",_buildDistance];
    buildDistanceL.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:buildDistanceL];
    
    UIView *_yongJinView = [[UIView alloc]initWithFrame:CGRectMake(_loupNameL.left, _loupNameL.bottom, _loupNameL.width-50, 30)];
    [bottomView addSubview:_yongJinView];
    
    UILabel *yongjinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 18, 18)];
    yongjinLabel.text = @"佣";
    yongjinLabel.backgroundColor = BLUEBTBCOLOR;
    yongjinLabel.textAlignment = NSTextAlignmentCenter;
    yongjinLabel.textColor = [UIColor whiteColor];
    yongjinLabel.font = [UIFont systemFontOfSize:13.5];
    yongjinLabel.layer.cornerRadius = 3;
    yongjinLabel.layer.masksToBounds = YES;
    [_yongJinView addSubview:yongjinLabel];
    
    CGSize yongjinSize = [_commission sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    UILabel *yongjingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(yongjinLabel.right+3, 5, yongjinSize.width, 20)];
    yongjingTitleLabel.textAlignment = NSTextAlignmentLeft;
    yongjingTitleLabel.text = _commission;
    yongjingTitleLabel.textColor = BLUEBTBCOLOR;
    yongjingTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_yongJinView addSubview:yongjingTitleLabel];
    _yongJinView.width = yongjingTitleLabel.right;
    
    NSString *feature = _featureTag;
    CGFloat featureX;
    if ([self isBlankString:_commission]) {
        featureX = 10;
        _yongJinView.hidden = YES;
    }else{
        featureX = _yongJinView.right+10;
        _yongJinView.hidden = NO;
    }
    
    UILabel *featureTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(featureX, _loupNameL.bottom+7.5, 45, 15)];
    featureTagLabel.textColor = [UIColor colorWithHexString:@"888888"];
    featureTagLabel.font = FONT(11);
    featureTagLabel.textAlignment = NSTextAlignmentCenter;
    [featureTagLabel.layer setBorderColor:[UIColor colorWithHexString:@"888888"].CGColor];
    featureTagLabel.layer.cornerRadius = 3;
    featureTagLabel.layer.masksToBounds = YES;
    [featureTagLabel.layer setBorderWidth:0.8];
    [bottomView addSubview: featureTagLabel];
    //特色标签
    if (![self isBlankString:feature])
    {
        //不为空
        if ([feature rangeOfString:@","].location!=NSNotFound)
        {  //有分号,
            NSArray *array = [feature componentsSeparatedByString:@","];
            feature = [array objectForIndex:0];
        }
        featureTagLabel.text = feature;
        CGSize featureSize = [feature sizeWithAttributes:@{NSFontAttributeName:FONT(11)}];
        featureTagLabel.width = featureSize.width+10;
        featureTagLabel.hidden = NO;
    }else
    {
        featureTagLabel.hidden = YES;
    }
    if ([self isBlankString:_buildDistance])
    {
        buildDistanceL.hidden = YES;;
    }else
    {
        buildDistanceL.hidden = NO;
    }
    
    bottomView.height = _yongJinView.bottom+10;
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, CGRectGetMaxY(bottomView.frame));
}

- (void)createCustomerVisitView
{
    visitInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, secondView.bottom+10, kMainScreenWidth, 0)];
    visitInfoView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:visitInfoView];
    
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, visitInfoView.width, 68)];
    dateView.backgroundColor = [UIColor whiteColor];
    [visitInfoView addSubview:dateView];
    
    [dateView addSubview:[self createLineView:0 withX:0]];
    
    NSString *str = @"预计到访时间";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [str sizeWithAttributes:attributes];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 19, size.width, 30)];
    label.text = str;
    label.font = FONT(16);
    label.textColor = NAVIGATIONTITLE;
    [dateView addSubview:label];
    
    UIView *datebgView = [[UIView alloc] initWithFrame:CGRectMake(label.right+10, 12, visitInfoView.width-label.right-20, 44)];
    datebgView.layer.cornerRadius = 4.f;
    datebgView.layer.masksToBounds = YES;
    [datebgView.layer setBorderWidth:0.5];
    datebgView.layer.borderColor = buttonBorderColor.CGColor;
    [dateView addSubview:datebgView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(datebgView.width/2-0.25, 9, 0.5, 26)];
    lineLabel.backgroundColor = buttonBorderColor;
    [datebgView addSubview:lineLabel];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lineLabel.left, 22)];
    startLabel.text = @"开始时间";
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.textColor = LABELCOLOR;
    startLabel.font = FONT(12);
    startLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:startLabel];
    
    _dateStartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startLabel.bottom, startLabel.width, 22)];
    _dateStartLabel.text = @"选择时间";
    _dateStartLabel.textAlignment = NSTextAlignmentCenter;
    _dateStartLabel.textColor = BLUEBTBCOLOR;
    _dateStartLabel.font = FONT(10);
    _dateStartLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:_dateStartLabel];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, datebgView.width/2, datebgView.height)];
    [startBtn setBackgroundColor:[UIColor clearColor]];
    [startBtn addTarget:self action:@selector(toggleStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [datebgView addSubview:startBtn];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineLabel.left, 0, lineLabel.left, 22)];
    endLabel.text = @"结束时间";
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.textColor = LABELCOLOR;
    endLabel.font = FONT(12);
    endLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:endLabel];
    
    _dateEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(endLabel.left, endLabel.bottom, endLabel.width, 22)];
    _dateEndLabel.text = @"—";
    _dateEndLabel.textAlignment = NSTextAlignmentCenter;
    _dateEndLabel.textColor = LABELCOLOR;
    _dateEndLabel.font = FONT(10);
    _dateEndLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:_dateEndLabel];
    
    UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(datebgView.width/2, 0, datebgView.width/2, datebgView.height)];
    [endBtn setBackgroundColor:[UIColor clearColor]];
    [endBtn addTarget:self action:@selector(toggleEndButton:) forControlEvents:UIControlEventTouchUpInside];
    [datebgView addSubview:endBtn];
    
    [dateView addSubview:[self createLineView:dateView.height-0.5 withX:0]];
    
    [self createDateSelectView];
    
    countView = [[UIView alloc] initWithFrame:CGRectMake(0, dateView.bottom+10, visitInfoView.width, 59)];
    countView.backgroundColor = [UIColor whiteColor];
    [visitInfoView addSubview:countView];
    
    [countView addSubview:[self createLineView:0 withX:0]];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, size.width, 30)];
    label2.text = @"预计到访人数";
    label2.font = FONT(16);
    label2.textColor = NAVIGATIONTITLE;
    [countView addSubview:label2];
    
    _countVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(countView.width/2, label2.top, 50, 30)];
    _countVisitLabel.text = @"1人";
    _countVisitLabel.font = FONT(15);
    _countVisitLabel.textColor = NAVIGATIONTITLE;
    [countView addSubview:_countVisitLabel];
    
    UIView *countbgView = [[UIView alloc] initWithFrame:CGRectMake(_countVisitLabel.right, 12, scrollView.width-_countVisitLabel.right-10, 34)];
    countbgView.layer.cornerRadius = 4.f;
    countbgView.layer.masksToBounds = YES;
    [countbgView.layer setBorderWidth:0.5];
    countbgView.layer.borderColor = buttonBorderColor.CGColor;
    [countView addSubview:countbgView];
    
    UILabel *cpountlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(countbgView.width/2-0.25, 5, 0.5, 24)];
    cpountlineLabel.backgroundColor = buttonBorderColor;
    [countbgView addSubview:cpountlineLabel];
    
    subBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, countbgView.width/2, countbgView.height)];
    subBtn.enabled = NO;
    [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_hui"] forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(toggleSubButton:) forControlEvents:UIControlEventTouchUpInside];
    [countbgView addSubview:subBtn];
    
    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(countbgView.width/2, 0, countbgView.width/2, countbgView.height)];
    [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_lan"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(toggleAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [countbgView addSubview:addBtn];
    
    [countView addSubview:[self createLineView:countView.height - 0.5 withX:0]];
    
    transfView = [[UIView alloc] initWithFrame:CGRectMake(0, countView.bottom+10, visitInfoView.width, 90)];
    transfView.backgroundColor = [UIColor whiteColor];
    [visitInfoView addSubview:transfView];
    
    [transfView addSubview:[self createLineView:0 withX:0]];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, size.width, 30)];
    label3.text = @"到访交通方式";
    label3.font = FONT(16);
    label3.textColor = NAVIGATIONTITLE;
    [transfView addSubview:label3];
    
    
    _itemArray = [[NSMutableArray alloc] init];
    CGFloat btnWidth = (scrollView.width-(15+15+2*20))/3;
    for (int i = 0; i < dataSource.count; i ++) {
        NSString *str = dataSource[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = FONT(12);
        button.layer.cornerRadius = 4.f;
        button.layer.masksToBounds = YES;
        [button.layer setBorderWidth:0.5];
        if (!button.enabled) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:BLUEBTBCOLOR];
            button.layer.borderColor = BLUEBTBCOLOR.CGColor;
            
        }else
        {
            [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.layer.borderColor = buttonBorderColor.CGColor;
        }
        
        button.tag = i+100;
        button.frame = CGRectMake(15+20*i+btnWidth*i, label3.bottom+7, btnWidth, BUTTON_HEIGHT);
        
        _allWidth += (button.width + 20);
        
        [transfView addSubview:button];
        [_itemArray appendObject:button];
        
    }
    
    [transfView addSubview:[self createLineView:transfView.height - 0.5 withX:0]];
    
    visitInfoView.height = transfView.bottom+10;
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, visitInfoView.bottom);
}

- (void)createConfirmUserViewWithY:(CGFloat)y
{
    confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, y, scrollView.width, 44)];
    confirmView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:confirmView];
    
    [confirmView addSubview:[self createLineView:0 withX:0]];
    
    NSString *str = @"选择确客专员";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [str sizeWithAttributes:attributes];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, size.width, 30)];
    label4.text = @"选择确客专员";
    label4.font = FONT(15);
    label4.textColor = NAVIGATIONTITLE;
    label4.textAlignment = NSTextAlignmentLeft;
    [confirmView addSubview:label4];
    
    confirmUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(label4.right + 10, label4.top, scrollView.width-label4.right-10-23, 30)];
    confirmUserLabel.font = FONT(14);
    confirmUserLabel.textAlignment = NSTextAlignmentRight;
    confirmUserLabel.textColor = NAVIGATIONTITLE;
    [confirmView addSubview:confirmUserLabel];
    
    UIImageView *btnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(confirmView.width - 18, 15, 8, 14)];
    [btnImgView setImage:[UIImage imageNamed:@"arrow-right"]];
    [confirmView addSubview:btnImgView];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, confirmView.width, confirmView.height)];
    confirmBtn.backgroundColor = [UIColor clearColor];
    [confirmBtn addTarget:self action:@selector(toggleConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [confirmView addSubview:confirmBtn];
    
    [confirmView addSubview:[self createLineView:confirmView.height-0.5 withX:0]];
    
    scrollView.contentSize = CGSizeMake(scrollView.width, confirmView.bottom+10);
}

- (void)createDateSelectView
{
    dateArray = [[NSMutableArray alloc] init];
    hourArray = [[NSMutableArray alloc] init];
    minuteArray = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        NSDate*nowDate = [NSDate date];
        NSDate* theDate;
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
        NSString *str = [dateFormatter stringFromDate:theDate];
        
        //        if ([str hasPrefix:@"0"]) {
        //            dateFormatter.dateFormat = @"M月dd日";
        //            str = [dateFormatter stringFromDate:theDate];
        //        }
        [dateArray appendObject:str];
    }
    for (int i=0; i<24; i++) {
        NSString *str = [NSString stringWithFormat:@"%02d点",i];
        [hourArray appendObject:str];
    }
    for (int i=0; i<6; i++) {
        NSString *str = [NSString stringWithFormat:@"%d0分",i];
        [minuteArray appendObject:str];
    }
    
    dateSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, dateView.bottom, visitInfoView.width, 224)];
    dateSelectView.hidden = YES;
    dateSelectView.backgroundColor = [UIColor clearColor];
    [visitInfoView addSubview:dateSelectView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 80, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:FONT(15)];
    [cancelBtn addTarget:self action:@selector(toggleSelectCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [dateSelectView addSubview:cancelBtn];
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateSelectView.width-80, 7, 80, 30)];
    [queryBtn setTitle:@"确定" forState:UIControlStateNormal];
    [queryBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [queryBtn.titleLabel setFont:FONT(15)];
    [queryBtn addTarget:self action:@selector(toggleSelectQueryButton:) forControlEvents:UIControlEventTouchUpInside];
    [dateSelectView addSubview:queryBtn];
    
    //    if (!datePickerView) {
    datePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, queryBtn.bottom+7, dateSelectView.width, dateSelectView.height-queryBtn.bottom-7-0.5)];
    datePickerView.showsSelectionIndicator = YES;
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.delegate = self;
    datePickerView.dataSource = self;
    [dateSelectView addSubview:datePickerView];
    //    }
    
    [dateSelectView addSubview:[self createLineView:dateSelectView.height - 0.5 withX:0]];
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
#pragma mark - Label  Slider
//- (void) configureLabelSlider
//{
//    rangeSlider.minimumValue = 0;
//    rangeSlider.maximumValue = 100;
//
//    rangeSlider.lowerValue = 0;
//    rangeSlider.upperValue = 100;
//
//    if (customerViewCtrlType == kModifyCustomer) {
//        if (![self isBlankString:customerData.expectData.expectPriceMin]) {
//            rangeSlider.lowerValue = [customerData.expectData.expectPriceMin floatValue]/10;
//        }
//        if (![self isBlankString:customerData.expectData.expectPriceMax]) {
//            if ([customerData.expectData.expectPriceMax floatValue]>1000) {
//                rangeSlider.upperValue = 100.0;
//            }else
//            {
//                rangeSlider.upperValue = [customerData.expectData.expectPriceMax floatValue]/10;
//            }
//        }
//    }
//
//    [rangeSlider addTarget:self action:@selector(labelSliderChanged:) forControlEvents:UIControlEventValueChanged];
//    rangeSlider.minimumRange = 0;
//}
//
//- (void)labelSliderChanged:(CustomerRangeSlider*)sender
//{
//    minimumField.text = [NSString stringWithFormat:@"%d", (int)rangeSlider.lowerValue*10];
//    maximumField.text = [NSString stringWithFormat:@"%d", (int)rangeSlider.upperValue*10];
//}
- (void)toggleConfirmButton:(UIButton*)sender
{
    [self.view endEditing:YES];
    ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, self.view.bounds.size.height)];
    listView.selectedData = _confirmData;
    listView.confirmArray = _confirmArr;
    __weak typeof(self) weakSelf = self;
    [listView concelConfirmUserCellBlock:^{
    }];
    [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
        weakSelf.confirmData = confirmObj;
        weakSelf.confirmUserLabel.text = confirmObj.confirmUserName;
        [listView removeFromSuperview];
    }];
    [self.view addSubview:listView];
}

- (void)toggleGoufBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (!sender.selected) {
        middleView.top = secondView.bottom;
        if (_bIsShowVisitInfo) {
            visitInfoView.top = middleView.bottom+10;
            if (_mechanismType) {
                confirmView.top = visitInfoView.bottom;
                bottomView.top = confirmView.bottom+10;
            }else
            {
                bottomView.top = visitInfoView.bottom;
            }
        }else
        {
            if (_mechanismType) {
                confirmView.top = middleView.bottom+10;
                bottomView.top = confirmView.bottom+10;
            }else
            {
                bottomView.top = middleView.bottom+10;
            }
        }
        middleView.hidden = NO;
        [goufImgView setImage:[UIImage imageNamed:@"arrow_up"]];
        sender.selected = YES;
    }else{
        if (_bIsShowVisitInfo) {
            visitInfoView.top = secondView.bottom+10;
            if (_mechanismType) {
                confirmView.top = visitInfoView.bottom;
                bottomView.top = confirmView.bottom+10;
            }else
            {
                bottomView.top = visitInfoView.bottom;
            }
        }else
        {
            if (_mechanismType) {
                confirmView.top = secondView.bottom+10;
                bottomView.top = confirmView.bottom+10;
            }else
            {
                bottomView.top = secondView.bottom+10;
            }
        }
        sender.selected = NO;
        middleView.hidden = YES;
        [goufImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
}

//进入选择客户页面
- (void)toggleCustomerButton:(UIButton*)sender
{
    [self.view endEditing:YES];
    CustReportSelectViewController *selectVC = [[CustReportSelectViewController alloc] init];
    selectVC.buildingID = _buildingID;
    __weak typeof(self) weakSelf = self;
    [selectVC returnCustoemrResultBlock:^(Customer *cust) {
        weakSelf.customerData = cust;
        weakSelf.nameTextField.text = cust.name;
        weakSelf.identityCardField.text = cust.cardId;
        if (![weakSelf isBlankString:cust.cardId]) {
            weakSelf.identityCardField.enabled = NO;
        }
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
        weakSelf.nameTextField.enabled = NO;
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
        }else
        {
            if (cust.listPhone.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[cust.listPhone substringWithRange:NSMakeRange(0, 3)],[cust.listPhone substringWithRange:NSMakeRange(3, 4)],[cust.listPhone substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
            }else{
                [weakSelf showTips:@"手机号码格式错误"];
                weakSelf.telTextField.text = cust.listPhone;
            }
            weakSelf.telTextField.enabled = NO;
        }
    }];
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)toggleCustomer:(UITapGestureRecognizer*)sender
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

- (void)toggleLocalCustomer:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    LocalContactsViewController *addressContact = [[LocalContactsViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [addressContact returnResultBlock:^(NSInteger index,NSString *text,NSString *detailText){
        weakSelf.customerData = nil;
        weakSelf.nameTextField.text = text;
        weakSelf.nameTextField.enabled = YES;
        weakSelf.manButton.enabled = YES;
        weakSelf.womanButton.enabled = YES;
        weakSelf.manButton.selected = NO;
        weakSelf.womanButton.selected = NO;
        weakSelf.identityCardField.enabled = YES;
        weakSelf.identityCardField.text = @"";
//        weakSelf.custSourceLabel.text = @"";
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
                                self.customerData = cust;
                            }
                        }else
                        {
                            [self showTips:result.message];
                        }
                    });
                }];
            }else{
                [weakSelf showTips:@"手机号码格式错误"];
                weakSelf.telTextField.text = detailText;
            }
            weakSelf.telTextField.enabled = YES;
        }
    }];
    [self.navigationController pushViewController:addressContact animated:YES];
}

- (void)toggleSaveBtn:(UIButton*)sender
{
    [self.view endEditing:YES];
    if ([self isBlankString:nameTextField.text]) {
        [self showTips:@"请输入客户姓名"];
        [nameTextField becomeFirstResponder];
        return;
    }
    if ([self isBlankString:self.sexString]) {
        [self showTips:@"请选择客户性别"];
        return;
    }
    if (![NSString accurateVerifyIDCardNumber:_identityCardField.text] && _identityCardField.text.length>0) {
        [self showTips:@"请输入正确身份证号"];
        return;
    }
    if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
        if (_sourceData == nil || [self isBlankString:_sourceData.code]) {
            [self showTips:@"请选择客户来源"];
            return;
        }
    }
    
    NSString *tel = nil;
    NSString *str = @"";
    if (!bIsHiddenNum) {
        NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
        for (int i=0; i<array.count; i++) {
            str = [str stringByAppendingString:[array objectForIndex:i]];
        }
        tel = str;
    }else
    {
        if (![self isBlankString:firstNum.text] || ![self isBlankString:tailNum.text]) {
            str = [NSString stringWithFormat:@"%@****%@",firstNum.text,tailNum.text];
            tel = str;
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
    
    if ([self isBlankString:minimumField.text]) {
        minimumField.text = @"0";
    }
    if ([self isBlankString:maximumField.text]) {
        maximumField.text = @"1000";
    }
    if ([minimumField.text intValue] > [maximumField.text intValue]) {
        if ([minimumField.text integerValue]<0)
        {
            minimumField.text = @"0";
        }
        if ([maximumField.text integerValue]<0) {
            maximumField.text = @"0";
        }
        NSString *text = minimumField.text;
        minimumField.text = maximumField.text;
        maximumField.text = text;
    }
    NSString *visitInfo = @"";
    NSString *confirmId = @"";
//    if (customerViewCtrlType == kReportNewCustomer) {
        if (_bIsShowVisitInfo) {
            if ([_dateStartLabel.text isEqualToString:@"选择时间"]) {
                [self showTips:@"请设置开始时间"];
                return;
            }
            if ([_dateEndLabel.text isEqualToString:@"选择时间"] || [_dateEndLabel.text isEqualToString:@"—"]) {
                [self showTips:@"请设置结束时间"];
                return;
            }
            if ([self isBlankString:_transfStr]) {
                [self showTips:@"请选择交通方式"];
                return;
            }
            
            NSMutableArray *custArr = [[NSMutableArray alloc] init];
            NSMutableDictionary *custDic = [[NSMutableDictionary alloc] init];
            [custDic setValue:_buildingID forKey:@"id"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *startStr = [dateFormatter stringFromDate:startDate];
            NSString *endStr = [dateFormatter stringFromDate:endDate];
            if (![self isBlankString:startStr]) {
                [custDic setValue:startStr forKey:@"visitTimeBegin"];
            }
            if (![self isBlankString:endStr]) {
                [custDic setValue:endStr forKey:@"visitTimeEnd"];
            }
            [custDic setValue:[NSString stringWithFormat:@"%d",count] forKey:@"numPeople"];
            [custDic setValue:_transfStr forKey:@"trafficMode"];
            [custArr appendObject:custDic];
            NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:custArr,@"customerList", nil];
            visitInfo = [CustomerReportViewController dictionaryToJson:phoneListDic];
        }
        if (_mechanismType) {
            if ([self isBlankString:_confirmData.confirmUserId]) {
                [self showTips:@"请选择确客专员"];
                return;
            }
            confirmId = _confirmData.confirmUserId;
        }
//    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:nameTextField.text forKey:@"name"];
    [dic setValue:self.sexString forKey:@"sex"];
    [dic setValue:tel forKey:@"phone"];
    NSString *typeStr = [typeArray componentsJoinedByString:@","];
    if (![self isBlankString:typeStr]) {
        [dic setValue:typeStr forKey:@"expectType"];
    }
    NSString *layoutStr = [layoutArray componentsJoinedByString:@","];
    if (![self isBlankString:layoutStr]) {
        [dic setValue:layoutStr forKey:@"bedRoomNum"];//expectLayout
    }
    if (![self isBlankString:minimumField.text]) {
        [dic setValue:minimumField.text forKey:@"expectPriceMin"];
    }
    if (![self isBlankString:maximumField.text]) {
        [dic setValue:maximumField.text forKey:@"expectPriceMax"];
    }
    if (![self isBlankString:remarksTextView.text]) {
        [dic setValue:remarksTextView.text forKey:@"remark"];
    }
    if (![self isBlankString:_groupData.itemValue]) {
        [dic setValue:_groupData.itemValue forKey:@"groupId"];
    }
    if (![self isBlankString:visitInfo]) {
        [dic setValue:visitInfo forKey:@"customerVisitInfo"];
    }
    if (![self isBlankString:_identityCardField.text]) {
        [dic setValue:_identityCardField.text forKey:@"cardId"];
    }
    if (![self isBlankString:confirmId]) {
        [dic setValue:confirmId forKey:@"confirmUserId"];
    }
    if (![self isBlankString:_sourceData.code]) {
        [dic setValue:_sourceData.code forKey:@"custSource"];
    }
    
    if (!_bIsTouched) {
        _bIsTouched = YES;
        if (![self isBlankString:self.buildingID]) {
            [dic setValue:self.buildingID forKey:@"buildingId"];
        }
        if (![self isBlankString:customerData.customerId]) {
            [dic setValue:customerData.customerId forKey:@"customerId"];
        }
        [MobClick event:@"lpxq_xzkhbb"];
        UIImageView* loadingView  = [self setRotationAnimationWithView];
        if ([NetworkSingleton sharedNetWork].isNetworkConnection)
        {
            [[DataFactory sharedDataFactory] addNewCustomerReportWithDict:dic withCallBack:^(ActionResult *result, ReportReturnData *returnData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //更新UI
                    [self removeRotationAnimationView:loadingView];
                    _bIsTouched = NO;
                    if (result.success) {
                        [self showTips:result.message];
                        BuildingRecViewController *recVC = [[BuildingRecViewController alloc] init];
                        recVC.type = _type;
                        recVC.buildingId = _buildingID;
                        if (returnData != nil) {
                            recVC.custId = returnData.custProfileId;
                        }else
                        {
                            recVC.custId = customerData.customerId;
                        }
                        [self.navigationController pushViewController:recVC animated:YES];
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
    }
}

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
            if ([self noneSpaseString:textField.text].length + string.length - range.length > 11) {
                [self showTips:@"请输入11位手机号"];
                [textField resignFirstResponder];
                return NO;
            }else if ([self noneSpaseString:textField.text].length + string.length - range.length == 11)
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
                                self.customerData = cust;
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

- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-2*x, 0.5)];
    lineView.backgroundColor = CustomerBorderColor;
    return lineView;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length >= 50)
    {
        //        [self showTips:@"不能超过50个字"];
        textView.text = [textView.text substringToIndex:50];
        [textView resignFirstResponder];
    }
}
#pragma mark - UITextFieldDelegate
- (void)firstNumTextFieldDidChanged
{
//    for (int i=0; i<3; i++) {
//        telTextFieldView = (UIView *)[userInfoView viewWithTag:1100+i];
//        //        telTextField = (UITextField *)[telTextFieldView viewWithTag:1000+i];
//        firstNum = (CustomerTextField *)[telTextFieldView viewWithTag:1010+i];
//        tailNum = (CustomerTextField *)[telTextFieldView viewWithTag:1020+i];
//        if (firstNum.editing) {
            if (firstNum.text.length >= 3) {
                //        [firstNum resignFirstRespon                                                                                                                                                                                                                                                                                                   der];
                firstNum.text = [firstNum.text substringToIndex:3];
                if (tailNum.text.length==4) {
                    [firstNum resignFirstResponder];
                }else{
                    [tailNum becomeFirstResponder];
                }
            }
//            break;
//        }
//    }
}
- (void)tailNumTextFieldDidChanged{
//    for (int i=0; i<3; i++) {
//        telTextFieldView = (UIView *)[userInfoView viewWithTag:1100+i];
//        //        telTextField = (UITextField *)[telTextFieldView viewWithTag:1000+i];
//        firstNum = (CustomerTextField *)[telTextFieldView viewWithTag:1010+i];
//        tailNum = (CustomerTextField *)[telTextFieldView viewWithTag:1020+i];
//        if (tailNum.editing) {
            if (tailNum.text.length >= 4) {
                tailNum.text = [tailNum.text substringToIndex:4];
                if (firstNum.text.length==3) {
                    [tailNum resignFirstResponder];
                }else{
                    [firstNum becomeFirstResponder];
                }
                //        [firstNum becomeFirstResponder];
            }
//            break;
//        }
//    }
}

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

- (void)minimumFieldDidChanged
{
    if (minimumField.text.length > 5) {
        minimumField.text = [minimumField.text substringToIndex:5];
        [minimumField resignFirstResponder];
    }
    //    NSString *tempStr = @"0";
    //    if ([minimumField.text intValue] > 1000) {
    ////        minimumField.text = @"1000";
    //        tempStr = @"1000";
    //    }else
    if ([minimumField.text integerValue] < 0)
    {
        minimumField.text = @"0";
        //        tempStr = @"0";
    }
    //    else
    //    {
    //        tempStr = minimumField.text;
    //    }
    //    if ([minimumField.text intValue] > [maximumField.text intValue]) {
    ////        if ([maximumField.text floatValue]>1000.0) {
    ////            rangeSlider.lowerValue = 1000.0/10;
    ////        }else
    ////        {
    //            rangeSlider.lowerValue = [maximumField.text floatValue]/10;
    ////        }
    //        rangeSlider.upperValue = [tempStr floatValue]/10;
    //    }else{
    //        rangeSlider.lowerValue = [tempStr floatValue]/10;
    //    }
}

- (void)maximumFieldDidChanged
{
    if (maximumField.text.length > 5) {
        maximumField.text = [maximumField.text substringToIndex:5];
        [maximumField resignFirstResponder];
    }
    //    NSString *tempStr = @"0";
    //    if ([maximumField.text intValue] > 1000) {
    //        tempStr = @"1000";
    ////        maximumField.text = @"1000";
    //    }else
    if ([maximumField.text integerValue] < 0)
    {
        maximumField.text = @"0";
        //        tempStr = @"0";
    }
    //    else
    //    {
    //        tempStr = maximumField.text;
    //    }
    //    if ([minimumField.text intValue] > [maximumField.text intValue]) {
    //        rangeSlider.lowerValue = [tempStr floatValue]/10;
    ////        if ([minimumField.text floatValue] > 1000.0) {
    ////            rangeSlider.upperValue = 1000.0/10;
    ////        }else
    ////        {
    //            rangeSlider.upperValue = [minimumField.text floatValue]/10;
    ////        }
    //    }else{
    //        rangeSlider.upperValue = [tempStr floatValue]/10;
    //    }
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if ([self isBlankString:minimumField.text]) {
        minimumField.text = @"0";
    }
    if ([self isBlankString:maximumField.text]) {
        maximumField.text = @"1000";
    }
    if ([minimumField.text intValue] > [maximumField.text intValue]) {
        //        NSString *tempMiniStr = @"0";
        //        NSString *tempMaxiStr = @"1000";
        //        if ([minimumField.text integerValue]>1000) {
        ////            minimumField.text = @"1000";
        //            tempMiniStr = @"1000";
        //        }else
        if ([minimumField.text integerValue]<0)
        {
            minimumField.text = @"0";
            //            tempMiniStr = @"0";
        }
        //        else
        //        {
        //            tempMiniStr = minimumField.text;
        //        }
        if ([maximumField.text integerValue]<0) {
            maximumField.text = @"0";
            //            tempMaxiStr = @"0";
        }
        //        else
        //        {
        //            tempMaxiStr = maximumField.text;
        //        }
        //        else if ([maximumField.text integerValue]>1000)
        //        {
        //            //            maximumField.text = @"1000";
        //            tempMaxiStr = @"1000";
        //        }
        NSString *text = minimumField.text;
        minimumField.text = maximumField.text;
        maximumField.text = text;
        //        rangeSlider.lowerValue = [minimumField.text floatValue]/10;
        //        rangeSlider.upperValue = [maximumField.text floatValue]/10;
        //        rangeSlider.lowerValue = [tempMiniStr floatValue]/10;
        //        rangeSlider.upperValue = [tempMaxiStr floatValue]/10;
    }
}

- (NSAttributedString *)transferLouPanString:(NSString*)number
{
    NSString *string = [NSString stringWithFormat:@"报备楼盘[%@]",number];
    NSRange range = [string  rangeOfString:@"]"];
    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:NAVIGATIONTITLE
                        range:NSMakeRange(0, 4)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:16]
                        range:NSMakeRange(0, 4)];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:BLUEBTBCOLOR
                        range:NSMakeRange(5, range.location-5)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:18]
                        range:NSMakeRange(5, range.location-5)];
    return attriString;
}
#pragma mark - 表情判断
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
#pragma mark - 获取一个随机整数，范围在[from,to），包括from，包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowCount = 0;
    if (component==0) {
        rowCount = dateArray.count;
    }else if (component==1)
    {
        rowCount = hourArray.count;
    }else if (component==2)
    {
        rowCount = minuteArray.count;
    }
    return rowCount;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    UIColor *textColor = NAVIGATIONTITLE;
    NSString *title;
    
    if (component==0) {
        if (row==0) {
            title = @"今天";
        }else{
            //            title = [dateArray objectForIndex:row];
            NSArray *array = [[NSArray alloc] init];
            if (dateArray.count > row) {
                array = [[dateArray objectForIndex:row] componentsSeparatedByString:@"年"];
            }
            NSString *str = array[1];
            if ([str hasPrefix:@"0"]) {
                title = [str substringFromIndex:1];
            }else{
                title = str;
            }
        }
    }
    if (component==1) {
        if (hourArray.count > row) {
            title = [hourArray objectForIndex:row];
        }
    }
    if (component==2) {
        if (minuteArray.count > row) {
            title = [minuteArray objectForIndex:row];
        }
    }
    
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return datePickerView.width/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (datePickerView.height-44)/5;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [pickerView reloadAllComponents];
    NSString *str = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    _dateEndLabel setLayoutMargins:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    if (component==0) {
        dayIndex = row;
    }
    if (component==1) {
        hourIndex = row;
    }
    if (component==2) {
        minuteIndex = row;
    }
    if (dateArray.count > dayIndex) {
        str = [dateArray objectForIndex:dayIndex];
    }
    if (hourArray.count > hourIndex) {
        str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
    }
    if (minuteArray.count > minuteIndex) {
        str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
    }
    
    NSDate *date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
    NSDate *nowDate = [NSDate date];
    if (bIsStartDateButton) {
        if ([date compare:nowDate] == NSOrderedAscending) {
            
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *str = [dateFormatter stringFromDate:nowDate];
            for (int i=0; i<dateArray.count; i++) {
                if ([str isEqualToString:[dateArray objectForIndex:i]]) {
                    dayIndex = i;
                    [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
                }
            }
            
            dateFormatter.dateFormat = @"HH";
            str = [dateFormatter stringFromDate:nowDate];
            [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
            hourIndex = [str integerValue];
            
            dateFormatter.dateFormat = @"mm";
            str = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
            [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
            minuteIndex = [str integerValue];
            
            tempDate = nowDate;
            if (0 < [[[dateFormatter stringFromDate:nowDate] substringFromIndex:1] integerValue]) {
                if (minuteIndex==minuteArray.count-1) {
                    hourIndex += 1;
                    [datePickerView selectRow:hourIndex inComponent:1 animated:YES];
                    minuteIndex = 0;
                    [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
                }else
                {
                    minuteIndex += 1;
                    [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
                }
                if (dateArray.count > dayIndex) {
                    str = [dateArray objectForIndex:dayIndex];
                }
                if (hourArray.count > hourIndex) {
                    str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
                }
                if (minuteArray.count > minuteIndex) {
                    str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
                }
                startDate = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
                tempDate = startDate;
            }
        }else if ([date compare:nowDate] == NSOrderedDescending){
            tempDate = date;
        }
    }else
    {
        if ([date compare:startDate] == NSOrderedAscending) {
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *str = [dateFormatter stringFromDate:startDate];
            for (int i=0; i<dateArray.count; i++) {
                if ([str isEqualToString:[dateArray objectForIndex:i]]) {
                    dayIndex = i;
                    [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
                }
            }
            
            dateFormatter.dateFormat = @"HH";
            str = [dateFormatter stringFromDate:startDate];
            [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
            hourIndex = [str integerValue];
            
            dateFormatter.dateFormat = @"mm";
            str = [[dateFormatter stringFromDate:startDate] substringToIndex:1];
            [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
            minuteIndex = [str integerValue];
            
            tempDate = startDate;
        }else if ([date compare:startDate] == NSOrderedDescending){
            tempDate = date;
        }
    }
}
#pragma mark-------------button响应事件 到访交通方式选择
- (void)buttonAction:(UIButton *)sender {
    for (UIButton *item in _itemArray) {
        item.selected = NO;
        [item setTitleColor:LABELCOLOR forState:UIControlStateNormal];
        [item setBackgroundColor:[UIColor whiteColor]];
        item.layer.borderColor = buttonBorderColor.CGColor;
        
        if (item == sender) {
            sender.selected = YES;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundColor:BLUEBTBCOLOR];
            sender.layer.borderColor = BLUEBTBCOLOR.CGColor;
        }
    }
    if (dataSource.count > sender.tag - 100) {
        _transfStr = [dataSource objectForIndex:sender.tag - 100];
    }
    sender.selected = !sender.selected;
}
//选择开始日期
- (void)toggleStartButton:(UIButton*)sender
{
    dateSelectView.hidden = NO;
    visitInfoView.height = dateView.height+10+224+10+countView.height+10+transfView.height;
    countView.top = dateSelectView.bottom+10;
    transfView.top = countView.bottom+10;
    if (_mechanismType) {
        confirmView.top = visitInfoView.bottom;
        bottomView.top = confirmView.bottom+10;
    }else
    {
        bottomView.top = visitInfoView.bottom;
    }
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
    bIsStartDateButton = YES;
    
    NSDate *nowDate;
    if (startDate == nil) {
        nowDate = [NSDate date];
        tempDate = nowDate;
    }else
    {
        nowDate = startDate;
        tempDate = nowDate;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *str = [dateFormatter stringFromDate:nowDate];
    for (int i=0; i<dateArray.count; i++) {
        if ([str isEqualToString:[dateArray objectForIndex:i]]) {
            dayIndex = i;
            [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
        }
    }
    
    dateFormatter.dateFormat = @"HH";
    str = [dateFormatter stringFromDate:nowDate];
    [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
    hourIndex = [str integerValue];
    
    dateFormatter.dateFormat = @"mm";
    str = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
    [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
    minuteIndex = [str integerValue];
    if (0 < [[[dateFormatter stringFromDate:nowDate] substringFromIndex:1] integerValue]) {
        if (minuteIndex==minuteArray.count-1) {
            hourIndex += 1;
            [datePickerView selectRow:hourIndex inComponent:1 animated:YES];
            minuteIndex = 0;
            [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
        }else
        {
            minuteIndex += 1;
            [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
        }
    }
    if (startDate == nil) {
        if (dateArray.count > dayIndex) {
            str = [dateArray objectForIndex:dayIndex];
        }
        if (hourArray.count > hourIndex) {
            str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
        }
        if (minuteArray.count > minuteIndex) {
            str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
        }
        
        startDate = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
        tempDate = startDate;
    }
}
//选择结束日期
- (void)toggleEndButton:(UIButton*)sedner
{
    if ([_dateStartLabel.text isEqualToString:@"选择时间"]) {
        //提示语：请先设置开始时间
        [self showTips:@"请先设置开始时间"];
    }else
    {
        dateSelectView.hidden = NO;
        bIsStartDateButton = NO;
        visitInfoView.height = dateView.height+10+224+10+countView.height+10+transfView.height;
        countView.top = dateSelectView.bottom+10;
        transfView.top = countView.bottom+10;
        if (_mechanismType) {
            confirmView.top = visitInfoView.bottom;
            bottomView.top = confirmView.bottom+10;
        }else
        {
            bottomView.top = visitInfoView.bottom;
        }
        scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
        
        NSDate *nowDate;
        if (endDate == nil) {
            nowDate = startDate;
            tempDate = nowDate;
        }else
        {
            if ([endDate compare:startDate] == NSOrderedAscending) {
                nowDate = startDate;
            }else {
                nowDate = endDate;
            }
            tempDate = nowDate;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
        NSString *str = [dateFormatter stringFromDate:nowDate];
        for (int i=0; i<dateArray.count; i++) {
            if ([str isEqualToString:[dateArray objectForIndex:i]]) {
                dayIndex = i;
                [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
            }
        }
        
        dateFormatter.dateFormat = @"HH";
        str = [dateFormatter stringFromDate:nowDate];
        [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
        hourIndex = [str integerValue];
        
        dateFormatter.dateFormat = @"mm";
        str = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
        [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
        minuteIndex = [str integerValue];
        if (endDate == nil) {
            if (dateArray.count > dayIndex) {
                str = [dateArray objectForIndex:dayIndex];
            }
            if (hourArray.count > hourIndex) {
                str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
            }
            if (minuteArray.count > minuteIndex) {
                str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
            }
            
            endDate = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
        }
    }
}

- (void)toggleSubButton:(UIButton*)sender
{
    if (count > 1 && count <= 10) {
        count--;
        [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_lan"] forState:UIControlStateNormal];
        addBtn.enabled = YES;
        if (count == 1)
        {
            [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_hui"] forState:UIControlStateNormal];
            subBtn.enabled = NO;
        }
    }
    _countVisitLabel.text = [NSString stringWithFormat:@"%d人",count];
}

- (void)toggleAddButton:(UIButton*)sender
{
    if (count < 10) {
        count++;
        [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_lan"] forState:UIControlStateNormal];
        subBtn.enabled = YES;
        if (count == 10)
        {
            [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_hui"] forState:UIControlStateNormal];
            addBtn.enabled = NO;
        }
    }
    _countVisitLabel.text = [NSString stringWithFormat:@"%d人",count];
}

- (void)toggleSelectCancleButton:(UIButton*)sender
{
    dateSelectView.hidden = YES;
    visitInfoView.height = dateView.height+10+countView.height+10+transfView.height+10;
    countView.top = dateView.bottom+10;
    transfView.top = countView.bottom+10;
    if (_mechanismType) {
        confirmView.top = visitInfoView.bottom;
        bottomView.top = confirmView.bottom+10;
    }else
    {
        bottomView.top = visitInfoView.bottom;
    }
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
}

- (void)toggleSelectQueryButton:(UIButton*)sender
{
    if (bIsStartDateButton) {
        bIsStartDateButton = NO;
        startDate = tempDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM月dd日 HH:mm";
        NSString *str = [dateFormatter stringFromDate:startDate];
        if ([str hasPrefix:@"0"]) {
            str = [str substringFromIndex:1];
            str = [str substringToIndex:10];
            str = [str stringByAppendingString:@"0"];
        }else
        {
            str = [str substringToIndex:11];
            str = [str stringByAppendingString:@"0"];
        }
        _dateStartLabel.text = str;
        //        _dateStartLabel.textColor = LABELCOLOR;
        
        _dateEndLabel.text = @"选择时间";
        _dateEndLabel.textColor = BLUEBTBCOLOR;
        
        [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
        [datePickerView selectRow:hourIndex inComponent:1 animated:YES];
        [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
        
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM月dd日 HH:mm";
        endDate = tempDate;
        if (endDate == nil) {
            endDate = startDate;
        }
        NSString *str = [dateFormatter stringFromDate:endDate];
        if ([str hasPrefix:@"0"]) {
            str = [str substringFromIndex:1];
            str = [str substringToIndex:10];
            str = [str stringByAppendingString:@"0"];
        }else
        {
            str = [str substringToIndex:11];
            str = [str stringByAppendingString:@"0"];
        }
        _dateEndLabel.text = str;
        //        _dateEndLabel.textColor = BLUEBTBCOLOR;
        
        //        _dateStartLabel.textColor = BLUEBTBCOLOR;
        
        dateSelectView.hidden = YES;
        visitInfoView.height = dateView.height+10+countView.height+10+transfView.height+10;
        countView.top = dateView.bottom+10;
        transfView.top = countView.bottom+10;
        if (_mechanismType) {
            confirmView.top = visitInfoView.bottom;
            bottomView.top = confirmView.bottom+10;
        }else
        {
            bottomView.top = visitInfoView.bottom;
        }
        scrollView.contentSize = CGSizeMake(kMainScreenWidth, bottomView.bottom);
    }
}

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
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

/*
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIView          *topView;
@property (nonatomic, strong) UITextField     *searchBarTextField;
@property (nonatomic, strong) UIButton        *rightBarItem;
@property (nonatomic, strong) UIView          *bottomView;//底部布局
@property (nonatomic, strong) UILabel         *selectedLabel;//显示已选择几个报备客户
@property (nonatomic, strong) NSMutableArray  *statusArray;//客户是否被选中的状态记录数组，初始状态均为0
//@property (nonatomic, strong) NSMutableArray  *lastStatusArray;//客户是否被选中的状态记录数组，初始状态均为0
@property (nonatomic, strong) NSMutableArray  *totalSeletedArray;

@property (nonatomic, strong) CustomerTableView *tableView;

@property (nonatomic, strong) NSMutableArray *addressBookTemp;//通讯录获取到的联系人集合
@property (nonatomic, strong) UILabel *firstLetterLabel;

@property (nonatomic, strong) CustomerSelectButton *btnView;

@property (nonatomic, assign) int            currentIndex;
@property (nonatomic, assign) BOOL           bIsScrollTop;
@property (nonatomic, assign) BOOL           bIsTouched;//互斥锁，防止保存添加组成员过程中多次点击

@property (nonatomic, assign) BOOL           bIsFirst;
@property (nonatomic, assign) BOOL           bIsScroll;
@property (nonatomic, strong) NSMutableArray *visitStatusArr;//是否展示客户到访信息
@property (nonatomic, strong) NSMutableDictionary  *visitInfoDic;//客户到访信息

@property (nonatomic, strong) NSMutableArray *confirmStatusArr;//是否展示确客信息
@property (nonatomic, strong) NSMutableDictionary  *confirmInfoDic;//确客信息
@property (nonatomic, strong) NSMutableArray *confirmDataArr;

@end

@implementation CustomerReportViewController
@synthesize topView;
@synthesize bottomView,selectedLabel,statusArray;
//@synthesize lastStatusArray;
@synthesize totalSeletedArray;
@synthesize searchBarTextField;

@synthesize titleArray;

@synthesize addressBookTemp;
@synthesize firstLetterLabel;
@synthesize btnView;

@synthesize tableView;

@synthesize currentIndex;
@synthesize bIsScrollTop;

@synthesize bIsShowVisitInfo;
@synthesize visitStatusArr;
@synthesize visitInfoDic;

@synthesize confirmStatusArr;
@synthesize confirmInfoDic;
@synthesize confirmDataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.titleLabel.text = @"报备客户";
    self.navigationBar.barBackgroundImageView.backgroundColor = BACKGROUNDCOLOR;
//    self.customerTelType = @"1";
    _rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-49, 20, 44, 44)];
    [_rightBarItem setImage:[UIImage imageNamed:@"button_add_report_up"] forState:UIControlStateNormal];
    [_rightBarItem setImage:[UIImage imageNamed:@"button_add_report_down"] forState:UIControlStateHighlighted];
    [_rightBarItem addTarget:self action:@selector(toggleRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:_rightBarItem];
    
    _bIsFirst = YES;
    
    statusArray = [[NSMutableArray alloc] init];
    //    lastStatusArray = [[NSMutableArray alloc] init];
    totalSeletedArray = [[NSMutableArray alloc] init];
    addressBookTemp = [[NSMutableArray alloc] init];

    visitStatusArr = [[NSMutableArray alloc] init];
    visitInfoDic = [[NSMutableDictionary alloc] init];
    
    confirmStatusArr = [[NSMutableArray alloc] init];
    confirmInfoDic = [[NSMutableDictionary alloc] init];
    confirmDataArr = [[NSMutableArray alloc] init];
//    bIsShowVisitInfo = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomerReportViewData:) name:@"reloadCustomerReportView" object:nil];//添加刷新客户列表页的通知
    
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (!_bIsFirst) {
        if (tableView.top==viewTopY) {
            tableView.top = viewTopY-20;
            tableView.height = self.view.bounds.size.height-viewTopY-44+20;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (_bIsScroll) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            _bIsFirst = NO;
        }
    }
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-44);
    }
    if (bottomView.superview) {
        bottomView.frame =CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    }
}

- (void)hasNetwork
{
    __weak CustomerReportViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
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
    
    [self createTableView];
    [self createHeaderViewOfTable:viewTopY];
    [self createBottomView];
    [self initTableviewHeader];
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:firstLetterLabel];
    [self.view addSubview:firstLetterLabel];
    
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerReportViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:_buildingID AndKeyword:@"" WithCallBack:^(ActionResult *result,NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!result.success) {
                [self showTips:result.message];
            }
            [addressBookTemp addObjectsFromArray:array];
            bIsScrollTop = YES;
            if (self.mechanismType) {
                [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingID WithCallBack:^(ActionResult *result, NSArray *array) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [confirmDataArr addObjectsFromArray:array];
                    });
                }];
            }
            if (self.addressBookTemp.count>0) {
                self.tableView.bIsShowVisitInfo = self.bIsShowVisitInfo;
                self.tableView.bIsShowConfirmInfo = self.mechanismType;
//                weakSelf.tableView.visitStatusArray = weakSelf.visitStatusArr;
                [self.tableView refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:0 withStore:NO];
            }else
            {
                [self.tableView refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
            }
            [self.tableView bringSubviewToFront:self.tableView.tableHeaderView];
        });
    }];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomerReportView" object:nil];
}

- (void)reloadCustomerReportViewData:(NSNotification*)notification
{
    [self requestCustomerListByKeyword:searchBarTextField.text];
}

- (void)createTableView
{
    tableView = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY-44) tableType:2 withHasShop:YES];
    tableView.cellDelegate = self;
    __weak CustomerReportViewController *weakSelf = self;
    tableView.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [self.view addSubview:tableView];
}

- (void)initTableviewHeader
{
//    NSString *str = @"";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 44+5, kMainScreenWidth-30, 0)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = BLUEBTBCOLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = FONT(12);
    label.adjustsFontSizeToFitWidth = YES;
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
 
    label.text = _mechanismText;
    CGSize size = [self textSize:_mechanismText withConstraintWidth:kMainScreenWidth-40];
    label.height = size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kMainScreenWidth, size.height+10)];
    view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:view];
    [headerView addSubview:label];
    headerView.height = view.bottom;
    if (![self isBlankString:_mechanismText]) {
        self.tableView.tableHeaderView = headerView;
    }
}

- (void)requestCustomerListByKeyword:(NSString*)keyword
{
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
//    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerReportViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:_buildingID AndKeyword:keyword WithCallBack:^(ActionResult *result,NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (![weakSelf removeRotationAnimationView:loadingView]) {
//                return ;
//            }
//            if (!result.success) {
//                [weakSelf showTips:result.message];
//            }
            if (self.addressBookTemp.count != 0) {
                [self.addressBookTemp removeAllObjects];
            }
            [self.addressBookTemp addObjectsFromArray:array];
            self.bIsScrollTop = YES;
            if (self.addressBookTemp.count>0) {
                self.tableView.bIsShowVisitInfo = self.bIsShowVisitInfo;
                self.tableView.visitStatusArray = self.visitStatusArr;
                
                self.tableView.bIsShowConfirmInfo = self.mechanismType;
                self.tableView.confirmStatusArray = self.confirmStatusArr;
                
                [self.tableView refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:0 LastSelectedArray:self.totalSeletedArray];
            }else
            {
                [self.tableView refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex LastSelectedArray:self.totalSeletedArray];
            }
            [self.tableView bringSubviewToFront:self.tableView.tableHeaderView];
        });
    }];
}

- (void)createBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, kMainScreenWidth, 44)];
    bottomView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = CustomerBorderColor;
    [bottomView addSubview:lineView];
    
//    selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kMainScreenWidth - 8 - 80, 30)];
//    [selectedLabel setAttributedText:[self transferLouPanString:@"0"]];
//    [bottomView addSubview:selectedLabel];
    if ([self isBlankString:_customerTelType]) {
        _customerTelType = @"0";
    }
//    if ([_customerTelType boolValue]) {
//        //仅全号
//        selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainScreenWidth - 8 - 80, 30)];
//        [selectedLabel setAttributedText:[self transferLouPanString:@"0"]];
//        [bottomView addSubview:selectedLabel];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 100, 14)];
//        label.text = @"仅支持全号客户";
//        label.textColor = redBgColor;
//        label.textAlignment = NSTextAlignmentLeft;
//        label.font = FONT(11);
//        [bottomView addSubview:label];
//    }else
//    {
        selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, kMainScreenWidth - 8 - 80, 30)];
        [selectedLabel setAttributedText:[self transferLouPanString:@"0"]];
        [bottomView addSubview:selectedLabel];
//    }
    
    UIButton *sendMsgsBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.width - 80, 0, 80, bottomView.height)];
    [sendMsgsBtn setBackgroundColor:BLUEBTBCOLOR];
    [sendMsgsBtn setTitle:@"报备" forState:UIControlStateNormal];
    [sendMsgsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMsgsBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [sendMsgsBtn addTarget:self action:@selector(touchReportCustomersBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendMsgsBtn];
}

- (void)createHeaderViewOfTable:(CGFloat)theY
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, theY, kMainScreenWidth-15, 44)];
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
}

- (void)toggleRightBarButton
{
    if (_bIsScroll) {
        _bIsFirst = NO;
    }
    CustomerOperationViewController *operationVC = [[CustomerOperationViewController alloc] init];
    operationVC.buildingID = self.buildingID;
    operationVC.customerTelType = self.customerTelType;
    operationVC.pageType = self.type;
    operationVC.customerViewCtrlType = kReportNewCustomer;
    operationVC.bIsShowVisitInfo = bIsShowVisitInfo;
    operationVC.bIsShowConfirm = _mechanismType;
    operationVC.confirmArr = confirmDataArr;
//    BuildingRecViewController *recVC = [[BuildingRecViewController alloc] init];
//    recVC.type = self.type;
    [self.navigationController pushViewController:operationVC animated:YES];
//    ReportTipViewController *reportTipVC = [[ReportTipViewController alloc] init];
//    reportTipVC.reportFailType = kfailCustomer;
//    reportTipVC.type = self.type;
////    reportTipVC.reportData = data;
//    reportTipVC.dataArray = self.addressBookTemp;
//    //防止多次pop发生崩溃闪退
//    [self.navigationController pushViewController:reportTipVC animated:YES];
}

- (void)touchReportCustomersBtn:(UIButton*)sender
{
    if (!_bIsTouched) {
        _bIsTouched = YES;
        if (totalSeletedArray.count>1) {
            [MobClick event:@"lpxq_plxzkh"];//楼盘详情页-批量选择客户
        }
        NSString *visitInfo = @"";
        NSString *confirmInfo = @"";
        if (totalSeletedArray.count>0) {
            NSString *custIds = nil;
            NSMutableArray *custArr = [[NSMutableArray alloc] init];
            NSMutableArray *confirmArr = [[NSMutableArray alloc] init];
            for (int i=0; i<totalSeletedArray.count; i++) {
                if (i==0) {
                    custIds = [totalSeletedArray objectForIndex:i];
                }else {
                    custIds = [NSString stringWithFormat:@"%@,%@",custIds,[totalSeletedArray objectForIndex:i]];
                }
                CustomerVisitInfoData *visitData = (CustomerVisitInfoData*)[visitInfoDic valueForKey:[totalSeletedArray objectForIndex:i]];
                
                if (bIsShowVisitInfo) {
                    NSMutableDictionary *custDic = [[NSMutableDictionary alloc] init];
                    [custDic setValue:[totalSeletedArray objectForIndex:i] forKey:@"id"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *startStr = [dateFormatter stringFromDate:visitData.startDate];
                    NSString *endStr = [dateFormatter stringFromDate:visitData.endDate];
                    if (![self isBlankString:startStr]) {
                        [custDic setValue:startStr forKey:@"visitTimeBegin"];
                    }
                    if (![self isBlankString:endStr]) {
                        [custDic setValue:endStr forKey:@"visitTimeEnd"];
                    }
                    [custDic setValue:[visitData.visitCount substringToIndex:visitData.visitCount.length-1] forKey:@"numPeople"];
                    [custDic setValue:visitData.transfFunc forKey:@"trafficMode"];
                    [custArr appendObject:custDic];
                }
                if (custArr.count > 0) {
                    NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:custArr,@"customerList", nil];
                    visitInfo = [CustomerReportViewController dictionaryToJson:phoneListDic];
                }
                
                ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[confirmInfoDic valueForKey:[totalSeletedArray objectForIndex:i]];
                if (_mechanismType) {
                    NSMutableDictionary *confirmDic = [[NSMutableDictionary alloc] init];
                    [confirmDic setValue:[totalSeletedArray objectForIndex:i] forKey:@"customerId"];
                    [confirmDic setValue:confirmData.confirmUserId forKey:@"confirmUserId"];
                    [confirmArr appendObject:confirmDic];
                }
                if (confirmArr.count > 0) {
                    NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:confirmArr,@"confirmUsers", nil];
                    confirmInfo = [CustomerReportViewController dictionaryToJson:phoneListDic];
                }
            }
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            if (![self isBlankString:_buildingID]) {
                [dic setValue:_buildingID forKey:@"buildingId"];
            }
            if (![self isBlankString:custIds]) {
                [dic setValue:custIds forKey:@"customerIds"];
            }
            if (![self isBlankString:visitInfo]) {
                [dic setValue:visitInfo forKey:@"cusftomerVisitInfo"];
            }
            if (![self isBlankString:confirmInfo]) {
                [dic setValue:confirmInfo forKey:@"confirmUsers"];
            }
            //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
            UIImageView * loadingView = [self setRotationAnimationWithView];
//            __weak CustomerReportViewController *weakSelf = self;
            [[DataFactory sharedDataFactory] batchAddCustomers:dic withCallBack:^(ActionResult *result,ReportReturnData *data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![self removeRotationAnimationView:loadingView]) {
                        return ;
                    }
                    self.bIsTouched = NO;
                    if (result.success) {
                        if (data.failCustomerList.count>0) {
//                            for (int i=0; i<data.failCustomerList.count; i++) {
//                                OptionData *option = [data.failCustomerList objectForIndex:i];
//                                for (Customer *cust in addressBookTemp) {
//                                    if ([cust.customerId isEqualToString:option.itemValue]) {
//                                        option.itemValue = cust.name;
//                                        [data.failCustomerList replaceObjectForIndex:i withObject:option];
//                                        break;
//                                    }
//                                }
//                            }
                            ReportTipViewController *reportTipVC = [[ReportTipViewController alloc] init];
                            reportTipVC.reportFailType = kfailCustomer;
                            reportTipVC.type = self.type;
                            reportTipVC.reportData = data;
                            reportTipVC.dataArray = self.addressBookTemp;
                            reportTipVC.buildingId = self.buildingID;
                            if (self.bIsShowVisitInfo) {
                                reportTipVC.custVisitDic = self.visitInfoDic;
                            }
                            if (self.mechanismType) {
                                reportTipVC.confirmDic = self.confirmInfoDic;
                            }
                            //防止多次pop发生崩溃闪退
                            if ([self.view superview]) {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBuildingDetail" object:nil];
                                [self.navigationController pushViewController:reportTipVC animated:YES];
                            }
                        }else{
                            [self showTips:result.message];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomer" object:nil];
                                //防止多次pop发生崩溃闪退
                                if ([self.view superview]) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBuildingDetail" object:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            });
                        }
                    }else
                    {
                        [self showTips:result.message];
                    }
                });
            }];
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
    if (bIsSelected) {
        if (totalSeletedArray.count>=10) {
            [self showTips:[NSString stringWithFormat:@"最多可选择%d个客户",(int)totalSeletedArray.count]];
            return;
        }else{
            if ([[visitInfoDic allKeys] containsObject:custId] || !bIsShowVisitInfo) {
                if (_mechanismType) {
                    if ([[confirmInfoDic allKeys] containsObject:custId]) {
                        [totalSeletedArray appendObject:custId];
                    }else
                    {
                        ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                        //                        listView.selectedData = _selectedConfirm;
                        if ([confirmInfoDic valueForKey:custId] != nil) {
                            listView.selectedData = [confirmInfoDic valueForKey:custId];
                        }
                        if (listView.confirmArray != nil) {
                            listView.confirmArray = nil;
                        }
                        listView.confirmArray = confirmDataArr;
                        
                        __weak CustomerReportViewController *weakSelf = self;
                        [listView concelConfirmUserCellBlock:^{
                            if (weakSelf.tableView.statusArray.count > indexPath.section && ((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]).count > indexPath.row) {
                                [((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]) replaceObjectForIndex:indexPath.row withObject:@"0"];
                            }
                            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                            [weakSelf.tableView refreshRowInSection:tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                        }];
                        [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
                            for (id key in [weakSelf.confirmInfoDic allKeys])
                            {
                                if ([key isEqualToString:custId]) {
                                    [weakSelf.confirmInfoDic removeObjectForKey:custId];
                                    break;
                                }
                            }
                            for (NSString *str in weakSelf.confirmStatusArr) {
                                if ([str isEqualToString:custId]) {
                                    [weakSelf.confirmStatusArr removeObject:custId];
                                    break;
                                }
                            }
                            if (confirmObj != nil) {
                                [weakSelf.confirmInfoDic setValue:confirmObj forKey:custId];
                            }
//                            [weakSelf.confirmInfoDic setValue:confirmObj forKey:custId];
                            [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                            [listView removeFromSuperview];
                            
                            [weakSelf.confirmStatusArr appendObject:custId];
                            [weakSelf.totalSeletedArray appendObject:custId];
                            [weakSelf.selectedLabel setAttributedText:[weakSelf transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)weakSelf.totalSeletedArray.count]]];
                        }];
                        [self.view addSubview:listView];
                    }
                }else
                {
                    [totalSeletedArray appendObject:custId];
                }
            }else
            {
                CustomerVisitInfoView *visitInfoView = [[CustomerVisitInfoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                visitInfoView.bIsShowConfirm = _mechanismType;
                visitInfoView.confirmMutArr = confirmDataArr;
                if ([visitInfoDic valueForKey:custId] != nil) {
                    visitInfoView.visitInfoData = [visitInfoDic valueForKey:custId];
                }
                if ([confirmInfoDic valueForKey:custId] != nil) {
                    visitInfoView.confirmInfoData = [confirmInfoDic valueForKey:custId];
                }
                __weak CustomerReportViewController *weakSelf = self;
                [visitInfoView seleteEndDateBlock:^{
                    [TipsView showTips:@"请先设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                }];
                [visitInfoView seleteCancelButtonBlock:^{
                    if (weakSelf.tableView.statusArray.count > indexPath.section && ((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]).count > indexPath.row) {
                        [((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]) replaceObjectForIndex:indexPath.row withObject:@"0"];
                    }
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [visitInfoView seleteSaveButtonBlock:^(CustomerVisitInfoData *visitInfo,ConfirmUserInfoObject *confirmInfo) {
                    if ([visitInfo.startDateStr isEqualToString:@"选择时间"]) {
                        [TipsView showTips:@"请设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    if ([visitInfo.endDateStr isEqualToString:@"选择时间"] || [visitInfo.endDateStr isEqualToString:@"—"]) {
                        [TipsView showTips:@"请设置结束时间" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    if ([weakSelf isBlankString:visitInfo.transfFunc]) {
                        [TipsView showTips:@"请选择交通方式" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    if (weakSelf.mechanismType && confirmInfo == nil) {
                        [TipsView showTips:@"请选择确客专员" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    for (id key in [weakSelf.visitInfoDic allKeys])
                    {
                        if ([key isEqualToString:custId]) {
                            [weakSelf.visitInfoDic removeObjectForKey:custId];
                            break;
                        }
                    }
                    for (id key in [weakSelf.confirmInfoDic allKeys])
                    {
                        if ([key isEqualToString:custId]) {
                            [weakSelf.confirmInfoDic removeObjectForKey:custId];
                            break;
                        }
                    }
                    for (NSString *str in weakSelf.visitStatusArr) {
                        if ([str isEqualToString:custId]) {
                            [weakSelf.visitStatusArr removeObject:custId];
                            break;
                        }
                    }
                    for (NSString *str in weakSelf.confirmStatusArr) {
                        if ([str isEqualToString:custId]) {
                            [weakSelf.confirmStatusArr removeObject:custId];
                            break;
                        }
                    }
                    if (confirmInfo != nil) {
                        [weakSelf.confirmInfoDic setValue:confirmInfo forKey:custId];
                    }
                    
                    [weakSelf.visitInfoDic setValue:visitInfo forKey:custId];
                    
                    [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithVisitData:weakSelf.visitInfoDic];
                    [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                    [visitInfoView removeFromSuperview];
                    
                    [weakSelf.visitStatusArr appendObject:custId];
                    [weakSelf.confirmStatusArr appendObject:custId];
                    [weakSelf.totalSeletedArray appendObject:custId];
                    [weakSelf.selectedLabel setAttributedText:[weakSelf transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)weakSelf.totalSeletedArray.count]]];
                }];
                [self.view addSubview:visitInfoView];
            }
        }
    }else
    {
        [totalSeletedArray removeObject:custId];
    }
    
    [selectedLabel setAttributedText:[self transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)totalSeletedArray.count]]];
    
}
#pragma mark - tableviewcell点击事件
- (void)CustomerDidSelectedCell:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath Customer:(Customer*)cust
{
    __weak CustomerReportViewController *weakSelf = self;
    if (bIsShowVisitInfo) {
        if ([[visitInfoDic allKeys] containsObject:cust.customerId]) {
            //        [totalSeletedArray appendObject:cust.customerId];
            CustomerVisitInfoView *visitInfoView = [[CustomerVisitInfoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
            if ([visitInfoDic valueForKey:cust.customerId] != nil) {
                visitInfoView.visitInfoData = [visitInfoDic valueForKey:cust.customerId];
            }
            if (_mechanismType) {
                visitInfoView.bIsShowConfirm = _mechanismType;
                visitInfoView.confirmMutArr = confirmDataArr;
                if ([confirmInfoDic valueForKey:cust.customerId] != nil) {
                    visitInfoView.confirmInfoData = [confirmInfoDic valueForKey:cust.customerId];
                }
            }
            
            [visitInfoView seleteEndDateBlock:^{
                [TipsView showTips:@"请先设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
            }];
            [visitInfoView seleteCancelButtonBlock:^{
            }];
            [visitInfoView seleteSaveButtonBlock:^(CustomerVisitInfoData *visitInfo,ConfirmUserInfoObject *confirmInfo) {
                if ([visitInfo.startDateStr isEqualToString:@"选择时间"]) {
                    [TipsView showTips:@"请设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([visitInfo.endDateStr isEqualToString:@"选择时间"] || [visitInfo.endDateStr isEqualToString:@"—"]) {
                    [TipsView showTips:@"请设置结束时间" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([weakSelf isBlankString:visitInfo.transfFunc]) {
                    [TipsView showTips:@"请选择交通方式" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if (_mechanismType && confirmInfo == nil) {
                    [TipsView showTips:@"请选择确客专员" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                for (id key in [weakSelf.visitInfoDic allKeys])
                {
                    if ([key isEqualToString:cust.customerId]) {
                        [weakSelf.visitInfoDic removeObjectForKey:cust.customerId];
                        break;
                    }
                }
                for (id key in [weakSelf.confirmInfoDic allKeys])
                {
                    if ([key isEqualToString:cust.customerId]) {
                        [weakSelf.confirmInfoDic removeObjectForKey:cust.customerId];
                        break;
                    }
                }
                for (NSString *str in weakSelf.visitStatusArr) {
                    if ([str isEqualToString:cust.customerId]) {
                        [weakSelf.confirmStatusArr removeObject:cust.customerId];
                        break;
                    }
                }
                for (NSString *str in weakSelf.confirmStatusArr) {
                    if ([str isEqualToString:cust.customerId]) {
                        [weakSelf.confirmStatusArr removeObject:cust.customerId];
                        break;
                    }
                }
                if (confirmInfo != nil) {
                    [weakSelf.confirmInfoDic setValue:confirmInfo forKey:cust.customerId];
                }
                [weakSelf.visitInfoDic setValue:visitInfo forKey:cust.customerId];
//                [weakSelf.confirmInfoDic setValue:confirmInfo forKey:cust.customerId];
                [weakSelf.visitStatusArr appendObject:cust.customerId];
                [weakSelf.confirmStatusArr appendObject:cust.customerId];
                [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithVisitData:weakSelf.visitInfoDic];
                [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                [visitInfoView removeFromSuperview];
            }];
            [self.view addSubview:visitInfoView];
        }else
        {
            if (totalSeletedArray.count>=10) {
                [self showTips:[NSString stringWithFormat:@"最多可选择%d个客户",(int)totalSeletedArray.count]];
                return;
            }
            CustomerVisitInfoView *visitInfoView = [[CustomerVisitInfoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
            
            if ([visitInfoDic valueForKey:cust.customerId] != nil) {
                visitInfoView.visitInfoData = [visitInfoDic valueForKey:cust.customerId];
            }
            visitInfoView.bIsShowConfirm = _mechanismType;
            visitInfoView.confirmMutArr = confirmDataArr;
            if ([confirmInfoDic valueForKey:cust.customerId] != nil) {
                visitInfoView.confirmInfoData = [confirmInfoDic valueForKey:cust.customerId];
            }
            //        __weak CustomerReportViewController *weakSelf = self;
            [visitInfoView seleteEndDateBlock:^{
                [TipsView showTips:@"请先设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
            }];
            [visitInfoView seleteCancelButtonBlock:^{
            }];
            [visitInfoView seleteSaveButtonBlock:^(CustomerVisitInfoData *visitInfo, ConfirmUserInfoObject *confirmInfo) {
                if ([visitInfo.startDateStr isEqualToString:@"选择时间"]) {
                    [TipsView showTips:@"请设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([visitInfo.endDateStr isEqualToString:@"选择时间"] || [visitInfo.endDateStr isEqualToString:@"—"]) {
                    [TipsView showTips:@"请设置结束时间" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([weakSelf isBlankString:visitInfo.transfFunc]) {
                    [TipsView showTips:@"请选择交通方式" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if (_mechanismType && confirmInfo == nil) {
                    [TipsView showTips:@"请选择确客专员" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                for (id key in [weakSelf.visitInfoDic allKeys])
                {
                    if ([key isEqualToString:cust.customerId]) {
                        [weakSelf.visitInfoDic removeObjectForKey:cust.customerId];
                        break;
                    }
                }
                for (id key in [weakSelf.confirmInfoDic allKeys])
                {
                    if ([key isEqualToString:cust.customerId]) {
                        [weakSelf.confirmInfoDic removeObjectForKey:cust.customerId];
                        break;
                    }
                }
                for (NSString *str in weakSelf.visitStatusArr) {
                    if ([str isEqualToString:cust.customerId]) {
                        [weakSelf.confirmStatusArr removeObject:cust.customerId];
                        break;
                    }
                }
                for (NSString *str in weakSelf.confirmStatusArr) {
                    if ([str isEqualToString:cust.customerId]) {
                        [weakSelf.confirmStatusArr removeObject:cust.customerId];
                        break;
                    }
                }
                if (confirmInfo != nil) {
                    [weakSelf.confirmInfoDic setValue:confirmInfo forKey:cust.customerId];
                }
                [weakSelf.visitInfoDic setValue:visitInfo forKey:cust.customerId];
//                [weakSelf.confirmInfoDic setValue:confirmInfo forKey:cust.customerId];
                [weakSelf.confirmStatusArr appendObject:cust.customerId];
                [weakSelf.visitStatusArr appendObject:cust.customerId];
                [weakSelf.totalSeletedArray appendObject:cust.customerId];
                if (weakSelf.tableView.statusArray.count > indexPath.section && ((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]).count > indexPath.row) {
                    [((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]) replaceObjectForIndex:indexPath.row withObject:@"1"];
                }
                [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithVisitData:weakSelf.visitInfoDic];
                [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                [visitInfoView removeFromSuperview];
                
                [weakSelf.selectedLabel setAttributedText:[weakSelf transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)weakSelf.totalSeletedArray.count]]];
            }];
            [self.view addSubview:visitInfoView];
        }
    }else
    {
        if (_mechanismType) {
            if ([[confirmInfoDic allKeys] containsObject:cust.customerId]) {
                ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                //                        listView.selectedData = _selectedConfirm;
                if ([confirmInfoDic valueForKey:cust.customerId] != nil) {
                    listView.selectedData = [confirmInfoDic valueForKey:cust.customerId];
                }
                listView.confirmArray = confirmDataArr;
                
                __weak CustomerReportViewController *weakSelf = self;
                [listView concelConfirmUserCellBlock:^{
                }];
                [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
                    for (id key in [weakSelf.confirmInfoDic allKeys])
                    {
                        if ([key isEqualToString:cust.customerId]) {
                            [weakSelf.confirmInfoDic removeObjectForKey:cust.customerId];
                            break;
                        }
                    }
                    for (NSString *str in weakSelf.confirmStatusArr) {
                        if ([str isEqualToString:cust.customerId]) {
                            [weakSelf.confirmStatusArr removeObject:cust.customerId];
                            break;
                        }
                    }
                    if (confirmObj != nil) {
                        [weakSelf.confirmInfoDic setValue:confirmObj forKey:cust.customerId];
                    }
//                    [weakSelf.confirmInfoDic setValue:confirmObj forKey:cust.customerId];
                    [weakSelf.confirmStatusArr appendObject:cust.customerId];
                    [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                    [listView removeFromSuperview];
                    
                    
//                    [weakSelf.totalSeletedArray appendObject:cust.customerId];
//                    [weakSelf.selectedLabel setAttributedText:[weakSelf transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)weakSelf.totalSeletedArray.count]]];
                }];
                [self.view addSubview:listView];
            }else
            {
                if (totalSeletedArray.count>=10) {
                    [self showTips:[NSString stringWithFormat:@"最多可选择%d个客户",(int)totalSeletedArray.count]];
                    return;
                }
                ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                //                        listView.selectedData = _selectedConfirm;
                if ([confirmInfoDic valueForKey:cust.customerId] != nil) {
                    listView.selectedData = [confirmInfoDic valueForKey:cust.customerId];
                }
                listView.confirmArray = confirmDataArr;
                
                __weak CustomerReportViewController *weakSelf = self;
                [listView concelConfirmUserCellBlock:^{
                }];
                [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
                    for (id key in [weakSelf.confirmInfoDic allKeys])
                    {
                        if ([key isEqualToString:cust.customerId]) {
                            [weakSelf.confirmInfoDic removeObjectForKey:cust.customerId];
                            break;
                        }
                    }
                    for (NSString *str in weakSelf.confirmStatusArr) {
                        if ([str isEqualToString:cust.customerId]) {
                            [weakSelf.confirmStatusArr removeObject:cust.customerId];
                            break;
                        }
                    }
                    if (confirmObj != nil) {
                        [weakSelf.confirmInfoDic setValue:confirmObj forKey:cust.customerId];
                    }
                    if (weakSelf.tableView.statusArray.count > indexPath.section && ((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]).count > indexPath.row) {
                        [((NSMutableArray*)[weakSelf.tableView.statusArray objectForIndex:indexPath.section]) replaceObjectForIndex:indexPath.row withObject:@"1"];
                    }
//                    [weakSelf.confirmInfoDic setValue:confirmObj forKey:cust.customerId];
                    [weakSelf.tableView refreshRowInSection:weakSelf.tableView AndIndexPath:indexPath WithConfirmData:weakSelf.confirmInfoDic];
                    [listView removeFromSuperview];
                    
                    [weakSelf.confirmStatusArr appendObject:cust.customerId];
                    [weakSelf.totalSeletedArray appendObject:cust.customerId];
                    [weakSelf.selectedLabel setAttributedText:[weakSelf transferLouPanString:[NSString stringWithFormat:@"%ld",(unsigned long)weakSelf.totalSeletedArray.count]]];
                }];
                [self.view addSubview:listView];
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
#pragma mark - tableview上下滑动
-(void)scrollTableView:(UIScrollView *)scrollView{
    searchContent = searchBarTextField.text;
    [searchBarTextField resignFirstResponder];
    CGFloat height = tableView.height;
    if (scrollView.contentOffset.y > _oldOffset && scrollView.contentOffset.y > 44) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
        if (bIsScrollTop) {
            bIsScrollTop = NO;
            _bIsScroll = YES;
            NSLog(@"向上滑动！");
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.8];
            CGRect rect = [topView frame];
            
            rect.origin.x = 0;
            rect.origin.y = -24;
            [topView setFrame:rect];
            
            if (_bIsFirst) {
                tableView.top = viewTopY;
            }else
            {
                tableView.top = viewTopY-20;
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
            _bIsScroll = YES;
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
                _bIsScroll = YES;
                bIsScrollTop = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.8];
                CGRect rect = [topView frame];
                rect.origin.x = 0;
                rect.origin.y = viewTopY;
                
                [topView setFrame:rect];
                
                if (_bIsFirst) {
                    tableView.top = viewTopY;
                }else
                {
                    tableView.top = viewTopY-20;
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
    [CustomerReportViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
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
    __weak CustomerReportViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer requestCustomerListByKeyword:customer.searchBarTextField.text];}]) {
        [self requestCustomerListByKeyword:customer.searchBarTextField.text];
    }
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = FONT(12);
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
}*/

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
