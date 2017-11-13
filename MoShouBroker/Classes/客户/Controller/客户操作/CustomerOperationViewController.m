//
//  CustomerOperationViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerOperationViewController.h"
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
#import "CustomerSelGroupViewController.h"
#import "BuildingDetailViewController.h"
#import "MyBuildingViewController.h"

#import "ConfirmUserListView.h"
#import "ConfirmUserInfoObject.h"
#import "CustomerSourceViewController.h"

#import "UserData.h"

#define heightScale 1110.0/1333
#define BUTTON_HEIGHT                  30               //按钮高

@interface CustomerOperationViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
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
@property (nonatomic, strong) UIButton *telOperationBtn;

@property (nonatomic, strong) UIButton *saveBtn;//保存按钮

@property (nonatomic, strong) NSMutableArray *intentionTypeArray;//意向类型name数组
@property (nonatomic, strong) NSMutableArray *intentionHouseArray;//意向户型name数组
//@property (nonatomic, strong) NSMutableArray *intentionAreaArray;//意向面积name数组
//@property (nonatomic, strong) NSArray *totalArray;
//@property (nonatomic, strong) NSArray *lookAtWayArray;//带看方式

@property (nonatomic, strong) CustomerTextView *remarksTextView;//备注

@property (nonatomic, strong) NSMutableArray *typeArray;//保存的意向类型
@property (nonatomic, strong) NSMutableArray *layoutArray;//保存的意向户型
//@property (nonatomic, strong) NSMutableArray *areaArray;//保存的意向面积

@property (nonatomic, strong) NSMutableArray *typeDataArray;//意向类型option对象数组
@property (nonatomic, strong) NSMutableArray *layoutDataArray;//意向户型。。。
//@property (nonatomic, strong) NSMutableArray *areaDataArray;//意向面积。。。

@property (nonatomic, strong) NSMutableArray *purchaseArray;//修改界面的购房意向
@property (nonatomic, assign) BOOL           bIsTouched;//互斥锁，防止保存报备过程中多次点击
//@property (nonatomic, assign) BOOL           bIsHiddenLoup;
@property (nonatomic, assign) BOOL           bIsHiddenNum;//手机号是否全部显示 （0全部显示，1部分显示）
@property (nonatomic, strong) CustomerTextField    *firstNum;
@property (nonatomic, strong) CustomerTextField    *tailNum;
@property (nonatomic, strong) UILabel        *middleNum;

//@property (nonatomic, strong) UILabel        *reportLoupLabel;
@property (nonatomic, strong) UILabel        *groupLabel;
//@property (nonatomic, strong) CustomerRangeSlider *rangeSlider;
@property (nonatomic, strong) UITextField *minimumField;//最低总价
@property (nonatomic, strong) UITextField *maximumField;//最高总价

@property (nonatomic, assign) NSInteger    telCount;//手机号个数
//@property (nonatomic, strong) UIButton    *mobileBtn;
//@property (nonatomic, strong) UIView      *mobileView;
//@property (nonatomic, assign) NSInteger   viewTag;
//@property (nonatomic, strong) NSMutableArray *totalTelArray;

@property (nonatomic, strong) UITextField    *identityCardField;//客户身份证号
@property (nonatomic, strong) UILabel        *custSourceLabel;//客户来源回显使用
@property (nonatomic, strong) CustomerSourceData *sourceData;

@end

@implementation CustomerOperationViewController
@synthesize customerViewCtrlType;
@synthesize headerView;
@synthesize userInfoView;
@synthesize secondView;
@synthesize middleView;
@synthesize bottomView;
@synthesize telTextFieldView;
@synthesize nameTextField,telTextField;
@synthesize manButton;
@synthesize womanButton;
@synthesize telOperationBtn;
@synthesize saveBtn;
@synthesize scrollView;
@synthesize intentionHouseArray,intentionTypeArray;
//@synthesize lookAtWayArray;//totalArray,
@synthesize remarksTextView;

@synthesize bIsHiddenNum;
@synthesize firstNum;
@synthesize tailNum;
@synthesize middleNum;
//@synthesize reportLoupLabel;
@synthesize groupLabel;
//@synthesize rangeSlider;
@synthesize minimumField;
@synthesize maximumField;

@synthesize typeArray;
@synthesize layoutArray;
//@synthesize areaArray;

@synthesize typeDataArray;
@synthesize layoutDataArray;
//@synthesize areaDataArray;

//@synthesize building;
@synthesize customerData;
@synthesize purchaseArray;

//@synthesize mobileBtn;
//@synthesize mobileView;
//@synthesize totalTelArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.popGestureRecognizerEnable = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *navTitle = nil;
    //数组初始化
    intentionTypeArray = [[NSMutableArray alloc] init];
    intentionHouseArray = [[NSMutableArray alloc] init];

    typeDataArray = [[NSMutableArray alloc] init];
    layoutDataArray = [[NSMutableArray alloc] init];
//    areaDataArray = [[NSMutableArray alloc] init];
    
    typeArray = [[NSMutableArray alloc] init];
    layoutArray = [[NSMutableArray alloc] init];
//    totalTelArray = [[NSMutableArray alloc] init];
//    areaArray = [[NSMutableArray alloc] init];
//    lookAtWayArray = @[@"自己带看",@"委托带看"];
    _sourceData = [[CustomerSourceData alloc] init];
//    dataSource = @[@"公交",@"自驾",@"班车"];
//    count = 1;
    
//    _bIsHiddenLoup = NO;
    //根据传过来的枚举类型，构建界面布局
    switch (customerViewCtrlType) {
        case kAddNewCustomer:
        {
            navTitle = @"新增客户";
        }
            break;
//        case kReportNewCustomer:
//        {
//            navTitle = @"新增报备客户";
//        }
//            break;
        case kModifyCustomer:
        {
            navTitle = @"编辑客户";
        }
            break;
            
        default:
            break;
    }
    self.navigationBar.titleLabel.text = navTitle;
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
    __weak CustomerOperationViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    //手机号是否全部显示 （0全部显示，1部分显示）
    BOOL mobile = [UserData sharedUserData].userInfo.mobileVisable;
//    if (customerViewCtrlType == kReportNewCustomer) {
//        if (mobile && ![_customerTelType boolValue]) {
//            bIsHiddenNum = YES;
//        }
//    }else
//    {
        bIsHiddenNum = mobile;
//    }
    
    //根据传过来的枚举类型，构建界面布局
    switch (customerViewCtrlType) {
        case kAddNewCustomer:
        {
            _groupData = [[OptionData alloc] init];
            _groupData.itemValue = @"0";
            _groupData.itemName = @"全部";
        }
            break;
        case kModifyCustomer:
        {
            NSString *puchaseIntention = customerData.expect;
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
            }
        }
            break;
            
        default:
            break;
    }
//    if (![self isBlankString:_phone] && _phone.length==11) {
//        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[_phone substringWithRange:NSMakeRange(0, 3)],[_phone substringWithRange:NSMakeRange(3, 4)],[_phone substringWithRange:NSMakeRange(7, 4)]];
//        _phone = str;
//    }
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY-54)];
    scrollView.delegate = self;
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:scrollView];
    
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-54, kMainScreenWidth-20, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BLUEBTBCOLOR];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [saveBtn.layer setCornerRadius:4.0];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn addTarget:self action:@selector(toggleSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    [self initHeaderView];
    [self initSecondView];
//    if (customerViewCtrlType == kReportNewCustomer) {
//        if (_bIsShowVisitInfo) {
//            [self createCustomerVisitView];
//            if (_bIsShowConfirm) {
//                [self createConfirmUserViewWithY:visitInfoView.bottom];
//            }
//        }else
//        {
//            if (_bIsShowConfirm) {
//                [self createConfirmUserViewWithY:secondView.bottom+10];
//            }
//        }
//    }else
//    {
        [self initBottomView];
//    }
    [self initMiddleView];
    middleView.hidden = YES;
    
    //获取购房意向
    UIImageView* loadingView = [self setRotationAnimationWithView];
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
                
                //                for (int i=0; i<data.areas.count; i++) {
                //                    OptionData *option = (OptionData*)[data.areas objectForIndex:i];
                //                    if (![self isBlankString:option.itemName]) {
                //                        [intentionAreaArray appendObject:option.itemName];
                //                        [areaDataArray appendObject:option];
                //                    }
                //                }
                
                if (customerViewCtrlType == kModifyCustomer) {
                    for (int i=0; i<purchaseArray.count; i++) {
                        for (int j=0; j<intentionTypeArray.count; j++) {
                            
                            if ([purchaseArray[i] isEqualToString:intentionTypeArray[j]]) {
                                [typeArray appendObject:((OptionData*)[typeDataArray objectForIndex:j]).itemValue];
                                break;
                            }
                        }
                        for (int j=0; j<intentionHouseArray.count; j++) {
                            
                            if ([purchaseArray[i] isEqualToString:intentionHouseArray[j]]) {
                                [layoutArray appendObject:((OptionData*)[layoutDataArray objectForIndex:j]).itemValue];
                                break;
                            }
                        }
                        //                        for (int j=0; j<intentionAreaArray.count; j++) {
                        //
                        //                            if ([purchaseArray[i] isEqualToString:intentionAreaArray[j]]) {
                        //                                [areaArray appendObject:((OptionData*)[areaDataArray objectForIndex:j]).itemValue];
                        //                                break;
                        //                            }
                        //                        }
                    }
                }
                [scrollView removeAllSubviews];
                [self initHeaderView];
                [self initSecondView];
//                if (customerViewCtrlType == kReportNewCustomer) {
//                    if (_bIsShowVisitInfo) {
//                        [self createCustomerVisitView];
//                        if (_bIsShowConfirm) {
//                            [self createConfirmUserViewWithY:visitInfoView.bottom];
//                        }
//                    }else
//                    {
//                        if (_bIsShowConfirm) {
//                            [self createConfirmUserViewWithY:secondView.bottom+10];
//                        }
//                    }
//                }else
//                {
                    [self initBottomView];
//                }
                [self initMiddleView];
                middleView.hidden = YES;
            });
        }];
    }else
    {
        [self removeRotationAnimationView:loadingView];
        [self showTips:@"网络连接失败"];
    }
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - initHeaderView
- (void)initHeaderView
{
    CustomerBaseBuildView *addCustView = nil;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    if (customerViewCtrlType != kModifyCustomer) {
        [headerView addSubview:[self createLineView:0 withX:0]];
        addCustView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, 0.5, kMainScreenWidth, 44) Title:@"从通讯录添加" AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:4];
        addCustView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:addCustView];
        
        [headerView addSubview:[self createLineView:addCustView.bottom withX:0]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLocalCustomer:)];
        [addCustView addGestureRecognizer:tapGesture];
    }
    CGFloat labelY = 0;
    if (addCustView != nil) {
        labelY = 54;
    }
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, labelY, kMainScreenWidth, 89)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:userInfoView];

    [userInfoView addSubview:[self createLineView:0 withX:0]];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth - 15 -10 - 120, 30)];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.placeholder = @"请输入客户姓名";
    nameTextField.font = [UIFont systemFontOfSize:16.0f];
//    if (![self isBlankString:_customerName]) {
//        nameTextField.text = _customerName;
//    }
    nameTextField.textColor = NAVIGATIONTITLE;
    if (customerViewCtrlType == kModifyCustomer) {
        nameTextField.text = customerData.name;
    }
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
    if (customerViewCtrlType == kModifyCustomer) {
        if ([customerData.sex isEqualToString:@"男"]) {
            manButton.selected = YES;
            womanButton.selected = NO;
            self.sexString = @"male";
        }else if ([customerData.sex isEqualToString:@"女"])
        {
            manButton.selected = NO;
            womanButton.selected = YES;
            self.sexString = @"female";
        }
    }
    
    [manButton addTarget:self action:@selector(toggleSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userInfoView addSubview:manButton];
    
//    int x = 1;//;1+arc4random() % 3;
//    _telCount = x;
//    _viewTag = 0;
//    [self initTelTExtFieldViewWithY:nameTextField.bottom+7 AndBtnType:0 IsNew:NO];
//    if (x==2) {
//        _viewTag = 1;
//        [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:1 IsNew:NO];
//    }else if (x==3)
//    {
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100];
//        telOperationBtn = (UIButton*)[telOperationBtn viewWithTag:1030];
//        telOperationBtn.hidden = YES;
//        _viewTag = 2;
//        [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:1 IsNew:NO];
//        [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:2 IsNew:NO];
//    }
    MobileVisible *mobile = nil;
    if (customerData.phoneList.count > 0) {
        mobile = (MobileVisible*)[customerData.phoneList objectForIndex:0];
    }
    if (![self isBlankString:mobile.hidingPhone] && ![self isBlankString:mobile.totalPhone]) {
        _telCount = 2;
        [self initTelTExtFieldViewWithY:nameTextField.bottom+7 AndBtnType:0 withPhone:mobile.hidingPhone];
        [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:1 withPhone:mobile.totalPhone];
    }else
    {
        _telCount = 1;
        [self initTelTExtFieldViewWithY:nameTextField.bottom+7 AndBtnType:0 withPhone:mobile.hidingPhone];
    }
    CGFloat identityY = userInfoView.height;
    
    [userInfoView addSubview:[self createLineView:identityY withX:10]];
    
    _identityCardField = [[UITextField alloc] initWithFrame:CGRectMake(15, identityY+7, kMainScreenWidth-40, 30)];
    _identityCardField.textColor = NAVIGATIONTITLE;
    _identityCardField.placeholder = @"请输入客户身份证号";
    _identityCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _identityCardField.font = [UIFont systemFontOfSize:18.0f];
    [_identityCardField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    if (customerViewCtrlType == kModifyCustomer) {
        _identityCardField.text = customerData.cardId;
    }
    [_identityCardField addTarget:self action:@selector(identityTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [userInfoView addSubview:_identityCardField];
    userInfoView.height = _identityCardField.bottom+7;
    headerView.height = userInfoView.bottom;
    [scrollView addSubview:headerView];
}

- (void)initTelTExtFieldViewWithY:(CGFloat)viewY AndBtnType:(NSInteger)type withPhone:(NSString*)phone
{
    telTextFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, kMainScreenWidth, 44)];
    telTextFieldView.backgroundColor = [UIColor whiteColor];
    telTextFieldView.tag = 1100+type;
    [userInfoView addSubview:telTextFieldView];
    [telTextFieldView addSubview:[self createLineView:0 withX:10]];
    
    if (customerViewCtrlType == kModifyCustomer) {
        telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth - 40, 30)];
        telTextField.enabled = NO;
        telTextField.tag = 1000+type;
        telTextField.font = [UIFont systemFontOfSize:18.0f];
        NSString *str = @"";
        if (![self isBlankString:phone] && phone.length==11) {
            str = [NSString stringWithFormat:@"%@ %@ %@",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(3, 4)],[phone substringWithRange:NSMakeRange(7, 4)]];
        }else
        {
            [telTextField becomeFirstResponder];
            str = phone;
        }
        telTextField.text = str;//customerList.phone;
        telTextField.textColor = [UIColor colorWithHexString:@"d2d1d1"];
        [telTextFieldView addSubview:telTextField];
        
        if (_bCanModify) {
            if (!bIsHiddenNum) {
                telTextField.placeholder = @"请输入手机号";
                telTextField.delegate = self;
                telTextField.enabled = YES;
                telTextField.textColor = NAVIGATIONTITLE;
                telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
                telTextField.keyboardType = UIKeyboardTypePhonePad;
            }else
            {
                telTextField.hidden = YES;
                firstNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(15, 7, 60, 30)];
                firstNum.keyboardType = UIKeyboardTypePhonePad;
                firstNum.delegate = self;
                firstNum.tag = 1010+type;
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
                middleNum.tag = 1040+type;
                middleNum.textColor = NAVIGATIONTITLE;
                middleNum.font = [UIFont systemFontOfSize:18];
                middleNum.textAlignment = NSTextAlignmentCenter;
                
                tailNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(middleNum.right, firstNum.top, 80, 30)];
                tailNum.keyboardType = UIKeyboardTypePhonePad;
                tailNum.delegate = self;
                tailNum.tag = 1020+type;
                tailNum.textColor = NAVIGATIONTITLE;
                tailNum.placeholder = @"后四";
                tailNum.textAlignment = NSTextAlignmentCenter;
                tailNum.font = [UIFont systemFontOfSize:18];
                [tailNum.layer setCornerRadius:4.0];
                [tailNum.layer setMasksToBounds:YES];
                [tailNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
                [tailNum.layer setBorderWidth:0.5];
                [tailNum addTarget:self action:@selector(tailNumTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
                
                if (![self isBlankString:str])  {
                    if (str.length==13) {
                        firstNum.text = [str substringWithRange:NSMakeRange(0, 3)];
                        tailNum.text = [str substringWithRange:NSMakeRange(9, 4)];
                    }else
                    {
                        [firstNum becomeFirstResponder];
                        firstNum.text = @"";
                        tailNum.text = @"";
                    }
                }else
                {
                    [firstNum becomeFirstResponder];
                    firstNum.text = @"";
                    tailNum.text = @"";
                }
                [telTextFieldView addSubview:firstNum];
                [telTextFieldView addSubview:middleNum];
                [telTextFieldView addSubview:tailNum];
            }
        }
    }
    else{
        if (!bIsHiddenNum) {
            telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth - 40, 30)];
            telTextField.placeholder = @"请输入手机号";
            telTextField.delegate = self;
            telTextField.tag = 1000+type;
            telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            telTextField.font = [UIFont systemFontOfSize:18.0f];
            [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
            telTextField.keyboardType = UIKeyboardTypePhonePad;
            telTextField.textColor = NAVIGATIONTITLE;
            [telTextFieldView addSubview:telTextField];
        }else
        {
            firstNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(15, 7, 60, 30)];
            firstNum.keyboardType = UIKeyboardTypePhonePad;
            firstNum.delegate = self;
            firstNum.tag = 1010+type;
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
            middleNum.tag = 1040+type;
            middleNum.textColor = NAVIGATIONTITLE;
            middleNum.font = [UIFont systemFontOfSize:18];
            middleNum.textAlignment = NSTextAlignmentCenter;
            
            tailNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(middleNum.right, firstNum.top, 80, 30)];
            tailNum.keyboardType = UIKeyboardTypePhonePad;
            tailNum.delegate = self;
            tailNum.tag = 1020+type;
            tailNum.textColor = NAVIGATIONTITLE;
            tailNum.placeholder = @"后四";
            tailNum.textAlignment = NSTextAlignmentCenter;
            tailNum.font = [UIFont systemFontOfSize:18];
            [tailNum.layer setCornerRadius:4.0];
            [tailNum.layer setMasksToBounds:YES];
            [tailNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
            [tailNum.layer setBorderWidth:0.5];
            [tailNum addTarget:self action:@selector(tailNumTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];

            [telTextFieldView addSubview:firstNum];
            [telTextFieldView addSubview:middleNum];
            [telTextFieldView addSubview:tailNum];
            
//            mobileBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40-50, firstNum.top, 50, 30)];//16
//            [mobileBtn.layer setMasksToBounds:YES];
//            [mobileBtn.layer setCornerRadius:5.0];
//            [mobileBtn.layer setBorderWidth:0.5];
//            [mobileBtn.layer setBorderColor:BLUEBTBCOLOR.CGColor];
//            [mobileBtn setBackgroundColor:[UIColor whiteColor]];
//            [mobileBtn setTitle:@"隐号" forState:UIControlStateNormal];
//            [mobileBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//            //报备客户支持全号的楼盘需要提示仅报备全号客户；报备楼盘隐号的客户提示仅报备隐号楼盘   否则均不显示
//            mobileBtn.titleLabel.font = FONT(13);
//            mobileBtn.tag = 1050+type;
//            [mobileBtn addTarget:self action:@selector(toggleMobileButton:) forControlEvents:UIControlEventTouchUpInside];
//            [telTextFieldView addSubview:mobileBtn];
//            
//            mobileView = [[UIView alloc] initWithFrame:CGRectMake(0, firstNum.top - 2, mobileBtn.left, 35)];
//            mobileView.backgroundColor = [UIColor whiteColor];
//            mobileView.tag = 1060+type;
//            telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 2, mobileView.width - 30, 30)];
//            telTextField.placeholder = @"请输入手机号";
//            telTextField.delegate = self;
//            telTextField.tag = 1000+type;
//            telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            telTextField.font = [UIFont systemFontOfSize:18.0f];
//            [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
//            telTextField.keyboardType = UIKeyboardTypePhonePad;
//            telTextField.textColor = NAVIGATIONTITLE;
//            if (![self isBlankString:_phone]) {
//                if (!bIsNewAdd) {
//                    telTextField.text = _phone;
//                }
//            }
//            [mobileView addSubview:telTextField];
//            mobileView.hidden = YES;
//            [telTextFieldView addSubview:mobileView];
//            if ([[totalTelArray lastObject] boolValue]) {
//                [totalTelArray appendObject:@"1"];
//                [mobileBtn setTitle:@"全号" forState:UIControlStateNormal];
//                [mobileBtn setBackgroundColor:BLUEBTBCOLOR];
//                [mobileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                mobileView.hidden = NO;
//            }else
//            {
//                [totalTelArray appendObject:@"0"];
//            }
        }
    }
//    if (type == 0) {
//        telOperationBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 2, 40, 40)];
//        telOperationBtn.tag = 1030;
//        [telOperationBtn setImage:[UIImage imageNamed:@"image_add_blue"] forState:UIControlStateNormal];
//        [telOperationBtn addTarget:self action:@selector(toggleTelAddButton:) forControlEvents:UIControlEventTouchUpInside];
//        [telTextFieldView addSubview:telOperationBtn];
//    }else
//    {
//        if (customerViewCtrlType == kModifyCustomer) {
//            if (_bCanModify || bIsNewAdd) {
//                telOperationBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 2, 40, 40)];
//                telOperationBtn.tag = 1030+type;
//                [telOperationBtn setImage:[UIImage imageNamed:@"image_delete_red"] forState:UIControlStateNormal];
//                [telOperationBtn addTarget:self action:@selector(toggleTelDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
//                [telTextFieldView addSubview:telOperationBtn];
//            }
//        }else
//        {
//            telOperationBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40, 2, 40, 40)];
//            telOperationBtn.tag = 1030+type;
//            [telOperationBtn setImage:[UIImage imageNamed:@"image_delete_red"] forState:UIControlStateNormal];
//            [telOperationBtn addTarget:self action:@selector(toggleTelDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
//            [telTextFieldView addSubview:telOperationBtn];
//        }
//    }
    userInfoView.height = telTextFieldView.bottom;
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
    
    remarksTextView = [[CustomerTextView alloc] initWithFrame:CGRectMake(15, remarksBgView.top+7, remarksBgView.width-30, remarksBgView.height-14)];
    remarksTextView.placeHolder = @"请输入备注";
    remarksTextView.font = [UIFont systemFontOfSize:15];
    remarksTextView.delegate = self;
    if (customerViewCtrlType == kModifyCustomer) {
        remarksTextView.text = customerData.remark;
    }
    remarksTextView.textColor = NAVIGATIONTITLE;
    [secondView addSubview:remarksTextView];
    
    [secondView addSubview:[self createLineView:remarksBgView.bottom+9.5 withX:0]];
    CGFloat kHeight = remarksBgView.bottom;
    if ([[UserData sharedUserData].userInfo.customerSource boolValue]) {
        //客户来源
        CustomerBaseBuildView *custView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, remarksBgView.bottom+10, kMainScreenWidth, 44) Title:@"客户来源" AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:4];
        custView.backgroundColor = [UIColor whiteColor];
        [secondView addSubview:custView];
        
        _custSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7, kMainScreenWidth-150-33, 30)];
        _custSourceLabel.textColor = TFPLEASEHOLDERCOLOR;
        _custSourceLabel.textAlignment = NSTextAlignmentRight;
        _custSourceLabel.font = FONT(13);
        
        if (customerViewCtrlType == kModifyCustomer && ![self isBlankString:customerData.custSource])
        {
            _sourceData.code = customerData.custSource;
            _sourceData.label = customerData.custSourceLabel;
            _custSourceLabel.text = [NSString stringWithFormat:@"%@.%@",_sourceData.code,_sourceData.label];
        }
        [custView addSubview:_custSourceLabel];
        
        [secondView addSubview:[self createLineView:custView.bottom withX:0]];
        [secondView addSubview:[self createLineView:custView.bottom+9.5 withX:0]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCustomer:)];
        [custView addGestureRecognizer:tapGesture];
        
        kHeight = custView.bottom;
    }
    
    //购房意向
    UIView *goufangView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight+10, kMainScreenWidth, 44)];
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
    
    UIButton *goufBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, goufangView.top, kMainScreenWidth, 44)];
    [goufBtn setBackgroundColor:[UIColor clearColor]];
    [goufBtn addTarget:self action:@selector(toggleGoufBtn:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:goufBtn];
    secondView.height = goufangView.bottom;
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
    if (customerViewCtrlType == kModifyCustomer) {
        if (![self isBlankString:customerData.expectData.expectPriceMin]) {
            minimumField.text = customerData.expectData.expectPriceMin;
        }
    }
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
    if (customerViewCtrlType == kModifyCustomer) {
        if (![self isBlankString:customerData.expectData.expectPriceMax]) {
            maximumField.text = customerData.expectData.expectPriceMax;
        }
    }
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
        if (customerViewCtrlType == kModifyCustomer) {
            tagView.purchseArray = purchaseArray;
        }
        tagView.dataSource = intentionTypeArray;
        __weak CustomerOperationViewController *customer = self;
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
        if (customerViewCtrlType == kModifyCustomer) {
            houseTagView.purchseArray = purchaseArray;
        }
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
        
        //    [middleView addSubview:[self createLineView:CGRectGetMaxY(houseTagView.frame)+5]];
        //
        //    UILabel *intentionAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(houseTagView.frame)+10, 100, 30)];
        //    intentionAreaLabel.textColor = TFPLEASEHOLDERCOLOR;
        //    intentionAreaLabel.text = @"意向面积";
        //    intentionAreaLabel.font = [UIFont systemFontOfSize:12];
        //    [middleView addSubview:intentionAreaLabel];
        //
        //    ExpectSelectButton *areaTagView = [[ExpectSelectButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(intentionAreaLabel.frame)+5, kMainScreenWidth, 0)];
        //    areaTagView.backgroundColor = [UIColor whiteColor];
        //    areaTagView.padding = UIEdgeInsetsMake(0, 15, 10, 15); //上,左,下,右,的边距
        //    areaTagView.horizontalSpace = 10;                       //横向间隔
        //    areaTagView.verticalSpace = 10;                         //纵向间隔
        //    areaTagView.tagValue = 1241;
        //    areaTagView.btnEnabled = YES;
        //    if (customerViewCtrlType == kModifyCustomer) {
        //        areaTagView.purchseArray = purchaseArray;
        //    }
        //    areaTagView.dataSource = intentionAreaArray;                        //数据源
        //    [areaTagView excptButtonSeleteBlock:^(int index,BOOL isSeleted){
        //        if (isSeleted) {
        //            //            [customer.areaArray appendObject:((OptionData*)[customer.areaDataArray objectForIndex:index]).itemValue];
        //        }else
        //        {
        //            //            [customer.areaArray removeObject:((OptionData*)[customer.areaDataArray objectForIndex:index]).itemValue];
        //        }
        //        
        //    }];
        //    [middleView addSubview:areaTagView];
        
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
    bottomView.backgroundColor = BACKGROUNDCOLOR;
    [scrollView addSubview:bottomView];
    
    CGFloat currentY = 0;
//    if (!_bIsHiddenLoup) {
//        UIView *reportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
//        reportView.backgroundColor = [UIColor whiteColor];
//        [bottomView addSubview:reportView];
//        
//        reportLoupLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 150, 30)];
//        [reportLoupLabel setAttributedText:[self transferLouPanString:@"5"]];
//        [reportView addSubview:reportLoupLabel];
//        
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8, 15, 8, 14)];
//        [imgView setImage:[UIImage imageNamed:@"arrow-right"]];
//        [reportView addSubview:imgView];
//        
//        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        reportBtn.frame = CGRectMake(0, 0, reportView.width, reportView.height);
//        reportBtn.backgroundColor = [UIColor clearColor];
//        [reportBtn addTarget:self action:@selector(toggleReportButton) forControlEvents:UIControlEventTouchUpInside];
//        [reportView addSubview:reportBtn];
//        
//        currentY = 54;
//    }
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, kMainScreenWidth, 44)];
    groupView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:groupView];
    
    [groupView addSubview:[self createLineView:0 withX:0]];
    
    [groupView addSubview:[self createLineView:groupView.height-0.5 withX:0]];
    
    UILabel *moveLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 80, 30)];
    moveLabel.font = [UIFont systemFontOfSize:16];
    moveLabel.text = @"移动至";
    moveLabel.textColor = NAVIGATIONTITLE;
    [groupView addSubview:moveLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8, 15, 8, 14)];
    [imgView setImage:[UIImage imageNamed:@"arrow-right"]];
    [groupView addSubview:imgView];
    
    groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(moveLabel.right+20, moveLabel.top, kMainScreenWidth - moveLabel.right - 20 - 15-12, 30)];
    groupLabel.font = [UIFont systemFontOfSize:15];
    groupLabel.text = _groupData.itemName;
    groupLabel.textAlignment = NSTextAlignmentRight;
    groupLabel.textColor = TFPLEASEHOLDERCOLOR;
    [groupView addSubview:groupLabel];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(0, 0, groupView.width, groupView.height);
    reportBtn.backgroundColor = [UIColor clearColor];
    [reportBtn addTarget:self action:@selector(toggleGroupButton) forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:reportBtn];
    
    bottomView.height = groupView.bottom+10;
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, CGRectGetMaxY(bottomView.frame));
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

- (void)toggleGoufBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    CGFloat height = 0;
    if (!sender.selected) {
        middleView.top = secondView.bottom;
        if (bottomView != nil) {
            bottomView.top = middleView.bottom+10;
            height = CGRectGetMaxY(bottomView.frame);
        }
        middleView.hidden = NO;
        [goufImgView setImage:[UIImage imageNamed:@"arrow_up"]];
        sender.selected = YES;
    }else{
        if (bottomView != nil) {
            bottomView.top = secondView.bottom+10;
            height = CGRectGetMaxY(bottomView.frame);
        }
        sender.selected = NO;
        middleView.hidden = YES;
        [goufImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, height);
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
//    telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+_viewTag];
//    firstNum = (CustomerTextField*)[telTextFieldView viewWithTag:1010+_viewTag];
//    tailNum = (CustomerTextField*)[telTextFieldView viewWithTag:1020+_viewTag];
    [self.view endEditing:YES];
    LocalContactsViewController *addressContact = [[LocalContactsViewController alloc] init];
    __weak CustomerOperationViewController *weakSelf = self;
    [addressContact returnResultBlock:^(NSInteger index,NSString *text,NSString *detailText){
        weakSelf.nameTextField.text = text;
//        weakSelf.mobileView = (UIView*)[weakSelf.telTextFieldView viewWithTag:1060+weakSelf.viewTag];
//        weakSelf.telTextField = (UITextField*)[weakSelf.mobileView viewWithTag:1000+weakSelf.viewTag];
        if (weakSelf.bIsHiddenNum) {
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
//            weakSelf.telTextField = (UITextField*)[weakSelf.telTextFieldView viewWithTag:1000+weakSelf.viewTag];
            [weakSelf.telTextField becomeFirstResponder];
            if (detailText.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[detailText substringWithRange:NSMakeRange(0, 3)],[detailText substringWithRange:NSMakeRange(3, 4)],[detailText substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
                [[DataFactory sharedDataFactory] validationMobileWithPhone:detailText withCallBack:^(ActionResult *result, Customer *cust) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.success) {
                            if ([cust.exist boolValue]) {
//                                if (self.customerViewCtrlType == kReportNewCustomer) {
//                                    self.customerData = cust;
//                                }else {
                                    [self showTips:result.message];
//                                }
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
//    for (int i=0; i<_telCount; i++) {
//        if (_telCount == 2 && i == 1) {
//            telTextFieldView = (UIView *)[userInfoView viewWithTag:1100+_viewTag];
//            telTextField = (UITextField *)[telTextFieldView viewWithTag:1000+_viewTag];
//            firstNum = (CustomerTextField *)[telTextFieldView viewWithTag:1010+_viewTag];
//            tailNum = (CustomerTextField *)[telTextFieldView viewWithTag:1020+_viewTag];
//        }else
//        {
//            telTextFieldView = (UIView *)[userInfoView viewWithTag:1100+i];
//            telTextField = (UITextField *)[telTextFieldView viewWithTag:1000+i];
//            firstNum = (CustomerTextField *)[telTextFieldView viewWithTag:1010+i];
//            tailNum = (CustomerTextField *)[telTextFieldView viewWithTag:1020+i];
//        }
        NSString *str = @"";
        if (customerViewCtrlType == kModifyCustomer) {
            if (_telCount == 2) {
                telTextFieldView = (UIView *)[userInfoView viewWithTag:1100];
                telTextField = (UITextField *)[telTextFieldView viewWithTag:1000];
            }
            NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
            for (int i=0; i<array.count; i++) {
                str = [str stringByAppendingString:[array objectForIndex:i]];
            }
//            if (i==0) {
                tel = str;
//            }else
//            {
//                tel = [tel stringByAppendingFormat:@",%@/",str];
//            }
            if (_bCanModify && bIsHiddenNum) {
                if (![self isBlankString:firstNum.text] && ![self isBlankString:tailNum.text]) {
                    str = [NSString stringWithFormat:@"%@****%@",firstNum.text,tailNum.text];
                    tel = str;//[tel stringByAppendingFormat:@",%@",str];
                }
            }
        }else {
            if (!bIsHiddenNum) {
                NSArray *array = [telTextField.text componentsSeparatedByString:@" "];
                for (int i=0; i<array.count; i++) {
                    str = [str stringByAppendingString:[array objectForIndex:i]];
                }
//                if (i==0) {
                    tel = str;
//                }else
//                {
//                    tel = [tel stringByAppendingFormat:@",%@",str];
//                }
            }else
            {
                if (![self isBlankString:firstNum.text] || ![self isBlankString:tailNum.text]) {
                    str = [NSString stringWithFormat:@"%@****%@",firstNum.text,tailNum.text];
//                    if (i==0) {
                        tel = str;
//                    }else
//                    {
//                        tel = [tel stringByAppendingFormat:@",%@",str];
//                    }
                }
            }
        }
//        if (i==0) {
            if ([self isBlankString:tel] || tel.length != 11) {
                [self showTips:@"请输入11位手机号"];
                if (customerViewCtrlType == kAddNewCustomer) {
                    if (bIsHiddenNum) {
                        [firstNum becomeFirstResponder];
                    }else{
                        [telTextField becomeFirstResponder];
                    }
                }
                return;
            }
//        }
//        else
//        {
//            if (![self isBlankString:str] && str.length != 11) {
//                [self showTips:@"请输入11位手机号"];
//                if (customerViewCtrlType == kAddNewCustomer) {
//                    if (bIsHiddenNum) {
//                        [firstNum becomeFirstResponder];
//                    }else{
//                        [telTextField becomeFirstResponder];
//                    }
//                }
//                return;
//            }
//        }
//    }
    
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
//    NSString*name = nameTextField.text;
//    if ([self stringContainsEmoji:nameTextField.text]) {
//        [self showTips:@"添加失败，请不要输入特殊字符"];
//        return;
//    }
    NSString *visitInfo = @"";
    NSString *confirmId = @"";
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:nameTextField.text forKey:@"name"];
//    if (customerViewCtrlType == kModifyCustomer) {
//        if ([self.sexString isEqualToString:@"male"]) {
//            [dic setValue:@"男" forKey:@"sex"];
//        }else
//        {
//            [dic setValue:@"女" forKey:@"sex"];
//        }
//        
//    }else
//    {
        [dic setValue:self.sexString forKey:@"sex"];
//    }
    
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
        [saveBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];
        switch (customerViewCtrlType) {
            case kAddNewCustomer:
            {
                UIImageView* loadingView  = [self setRotationAnimationWithView];
                if ([NetworkSingleton sharedNetWork].isNetworkConnection)
                {
                    [[DataFactory sharedDataFactory] addNewCustomerWithDict:dic withCallBack:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //更新UI
                            [self removeRotationAnimationView:loadingView];
                            if (result.success) {
                                [self showTips:@"添加客户成功！"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                    if (_bIsCustomerList) {
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
//                                        [self.navigationController popToRootViewControllerAnimated:YES];
//                                    }else
//                                    {
                                        //防止多次pop发生崩溃闪退
                                        if ([self.view superview]) {
                                            _bIsTouched = NO;
                                            [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerReportView" object:nil];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
//                                    }
                                });
                            }else
                            {
                                [self showTips:result.message];
                                _bIsTouched = NO;
                                [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                            }
                        });
                    }];
                }else
                {
                    _bIsTouched = NO;
                    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                    [self removeRotationAnimationView:loadingView];
                }
            }
                break;
            case kModifyCustomer:
            {
                [dic setValue:customerData.customerId forKey:@"customerId"];
                UIImageView* loadingView  = [self setRotationAnimationWithView];
                if ([NetworkSingleton sharedNetWork].isNetworkConnection)
                {
                    [[DataFactory sharedDataFactory] editCustomerWithDict:dic withCallBack:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //更新UI
                            [self showTips:result.message];
                            [self removeRotationAnimationView:loadingView];
                            if (result.success) {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailHeader" object:nil];
                                    //防止多次pop发生崩溃闪退
                                    if ([self.view superview]) {
                                        _bIsTouched = NO;
                                        [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                });
                            }else
                            {
                                _bIsTouched = NO;
                                [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                            }
                        });
                    }];
                }else
                {
                    _bIsTouched = NO;
                    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                    [self removeRotationAnimationView:loadingView];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)toggleGroupButton
{
    [self.view endEditing:YES];
    CustomerSelGroupViewController *groupVC = [[CustomerSelGroupViewController alloc] init];
    __weak CustomerOperationViewController *weakSelf = self;
    [groupVC setData:_groupData andGroupBlock:^(OptionData *groupData) {
        weakSelf.groupData = groupData;
        weakSelf.groupLabel.text = weakSelf.groupData.itemName;
    }];
    [self.navigationController pushViewController:groupVC animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    if (textField.tag == 1000 || textField.tag == 1001 || textField.tag == 1002) {
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
                                
                                    [self showTips:result.message];
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
    for (int i=0; i<3; i++) {
        telTextFieldView = (UIView *)[userInfoView viewWithTag:1100+i];
//        telTextField = (UITextField *)[telTextFieldView viewWithTag:1000+i];
        firstNum = (CustomerTextField *)[telTextFieldView viewWithTag:1010+i];
        tailNum = (CustomerTextField *)[telTextFieldView viewWithTag:1020+i];
        if (firstNum.editing) {
            if (firstNum.text.length >= 3) {
                //        [firstNum resignFirstRespon                                                                                                                                                                                                                                                                                                   der];
                firstNum.text = [firstNum.text substringToIndex:3];
                if (tailNum.text.length==4) {
                    [firstNum resignFirstResponder];
                }else{
                    [tailNum becomeFirstResponder];
                }
            }
            break;
        }
    }
}
- (void)tailNumTextFieldDidChanged{
    for (int i=0; i<3; i++) {
        telTextFieldView = (UIView *)[userInfoView viewWithTag:1100+i];
        //        telTextField = (UITextField *)[telTextFieldView viewWithTag:1000+i];
        firstNum = (CustomerTextField *)[telTextFieldView viewWithTag:1010+i];
        tailNum = (CustomerTextField *)[telTextFieldView viewWithTag:1020+i];
        if (tailNum.editing) {
            if (tailNum.text.length >= 4) {
                tailNum.text = [tailNum.text substringToIndex:4];
                if (firstNum.text.length==3) {
                    [tailNum resignFirstResponder];
                }else{
                    [firstNum becomeFirstResponder];
                }
                //        [firstNum becomeFirstResponder];
            }
            break;
        }
    }
}

//- (void)nameTextFieldEndChanged
//{
//    if ([self isBlankString:nameTextField.text]) {
//        [nameTextField becomeFirstResponder];
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
//        [telTextField becomeFirstResponder];
//        [self showTips:@"请输入11位手机号"];
//    }
//}

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

//- (void)toggleTelAddButton:(UIButton*)sender
//{
//    if (_telCount == 1) {
//        _viewTag = 1;
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100];
//        [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:1 IsNew:YES];
//    }else if (_telCount == 2)
//    {
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100];
//        telOperationBtn = (UIButton*)[telTextFieldView viewWithTag:1030];
//        telOperationBtn.hidden = YES;
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+1];
//        if (telTextFieldView == nil) {
//            _viewTag = 1;
//            telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+2];
//            [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:1 IsNew:YES];
//        }else
//        {
//            _viewTag = 2;
//            [self initTelTExtFieldViewWithY:telTextFieldView.bottom AndBtnType:2 IsNew:YES];
//        }
//    }
//    headerView.height = userInfoView.bottom;
//    secondView.top = headerView.bottom;
//    if (middleView.hidden) {
//        bottomView.top = secondView.bottom+10;
//    }else
//    {
//        middleView.top = secondView.bottom;
//        bottomView.top = middleView.bottom+10;
//    }
//    _telCount++;
//    scrollView.contentSize = CGSizeMake(kMainScreenWidth, CGRectGetMaxY(bottomView.frame));
//}
//
//- (void)toggleTelDeleteButton:(UIButton*)sender
//{
//    NSInteger tag = sender.tag-1030;
//    if (_telCount == 3) {
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100];
//        CGFloat height = telTextFieldView.bottom;
//        telOperationBtn = (UIButton*)[telTextFieldView viewWithTag:1030];
//        telOperationBtn.hidden = NO;
//        if (tag == 1) {
//            _viewTag = 2;
//            telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+tag];
//            CGFloat height1 = telTextFieldView.top;
//            [telTextFieldView removeAllSubviews];
//            [telTextFieldView removeFromSuperview];
//            telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+2];
//            if (telTextFieldView.top > height1) {
//                telTextFieldView.top = height1;
////                if (bIsHiddenNum) {
////                    [totalTelArray removeObjectForIndex:1];
////                }
//            }else if (telTextFieldView.top < height1)
//            {
//                telTextFieldView.top = height;
////                if (bIsHiddenNum) {
////                    [totalTelArray removeObjectForIndex:2];
////                }
//            }
//            
////            userInfoView.height = telTextFieldView.bottom;
//        }else
//        {
//            _viewTag = 1;
//            telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+tag];
//            CGFloat height1 = telTextFieldView.top;
//            [telTextFieldView removeAllSubviews];
//            [telTextFieldView removeFromSuperview];
//            telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+1];
//            if (telTextFieldView.top > height1) {
//                telTextFieldView.top = height1;
////                if (bIsHiddenNum) {
////                    [totalTelArray removeObjectForIndex:1];
////                }
//            }else if (telTextFieldView.top < height1)
//            {
//                telTextFieldView.top = height;
////                if (bIsHiddenNum) {
////                    [totalTelArray removeObjectForIndex:2];
////                }
//            }
//        }
//    }else if (_telCount == 2)
//    {
////        if (bIsHiddenNum) {
////            [totalTelArray removeObjectForIndex:1];
////        }
//        _viewTag = 0;
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+tag];
//        [telTextFieldView removeAllSubviews];
//        [telTextFieldView removeFromSuperview];
//        telTextFieldView = (UIView*)[userInfoView viewWithTag:1100];
////        userInfoView.height = telTextFieldView.bottom;
//    }
//    userInfoView.height = telTextFieldView.bottom;
//    headerView.height = userInfoView.bottom;
//    secondView.top = headerView.bottom;
//    if (middleView.hidden) {
//        bottomView.top = secondView.bottom+10;
//    }else
//    {
//        middleView.top = secondView.bottom;
//        bottomView.top = middleView.bottom+10;
//    }
//    _telCount--;
//    scrollView.contentSize = CGSizeMake(kMainScreenWidth, CGRectGetMaxY(bottomView.frame));
//}
//
//- (void)toggleMobileButton:(UIButton*)sender
//{
//    NSInteger tag = sender.tag-1050;
//    telTextFieldView = (UIView*)[userInfoView viewWithTag:1100+tag];
//    mobileView = (UIView*)[telTextFieldView viewWithTag:1060+tag];
//    mobileBtn = (UIButton*)[telTextFieldView viewWithTag:sender.tag];
//    if (!sender.selected) {
//        [mobileBtn setTitle:@"全号" forState:UIControlStateNormal];
//        [mobileBtn setBackgroundColor:BLUEBTBCOLOR];
//        [mobileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        mobileView.hidden = NO;
////        bIsTotalTel = YES;
//        [totalTelArray replaceObjectForIndex:tag withObject:@"1"];
//        sender.selected = YES;
//    }else{
//        [mobileBtn setTitle:@"隐号" forState:UIControlStateNormal];
//        [mobileBtn setBackgroundColor:[UIColor whiteColor]];
//        [mobileBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//        mobileView.hidden = YES;
////        bIsTotalTel = NO;
//        [totalTelArray replaceObjectForIndex:tag withObject:@"0"];
//        sender.selected = NO;
//    }
//}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
