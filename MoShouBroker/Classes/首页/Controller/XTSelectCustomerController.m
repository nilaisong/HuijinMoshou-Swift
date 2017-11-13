//
//  XTSelectCustomerController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTSelectCustomerController.h"
#import "XTEditCustomerView.h"
#import "CustomerTextField.h"
#import "CustomerSelectViewController.h"
#import "LocalContactsViewController.h"
#import "NSString+Extension.h"
#import "Customer.h"
#import "UserData.h"

@interface XTSelectCustomerController ()<UITextFieldDelegate>

//@property (nonatomic,weak)UISegmentedControl* segmentedControl;

@property (nonatomic,weak)XTEditCustomerView* customerView;

@property (nonatomic,weak)UIButton* saveButton;

@property (nonatomic,weak)UIView* headerView;

@property (nonatomic,weak)UITextField* nameTextField;

@property (nonatomic,weak)UIButton* womanButton;

@property (nonatomic,weak)UIButton* manButton;

@property (nonatomic,copy)NSString* sexString;

@property (nonatomic,weak)UITextField* telTextField;

@property (nonatomic, assign) BOOL        bIsHiddenNum;

@property (nonatomic,weak)CustomerTextField* firstNum;

@property (nonatomic,weak)UILabel* middleNum;

@property (nonatomic,weak)CustomerTextField* tailNum;

@property (nonatomic,strong)Customer* selectedCustomer;
//add by wangzz 160415
//@property (nonatomic, strong) UIButton    *mobileBtn;
//@property (nonatomic, strong) UIView      *mobileView;
@property (nonatomic, strong) UIView      *userInfoView;

@property (nonatomic,assign)BOOL isCustomerList;
//end
@end

@implementation XTSelectCustomerController
//@synthesize mobileBtn;
//@synthesize mobileView;
@synthesize userInfoView;

- (instancetype)initWithCallBack:(SelectCustomerControllerResult)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //手机号是否全部显示 （0全部显示，1部分显示）
    _bIsHiddenNum = [UserData sharedUserData].userInfo.mobileVisable;
    _isCustomerList = NO;
    // Do any additional setup after loading the view.
//    [self commonInit];
    [self initView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];    
}

- (void)initView{ 
    UIView* headerView = nil;
    UITextField* nameTextField = nil;
    UIButton* womanButton = nil;
    UIButton* manButton = nil;
    UITextField* telTextField = nil;
    CustomerTextField* firstNum = nil;
    UILabel* middleNum = nil;
    CustomerTextField* tailNum = nil;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, 0)];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    headerView.userInteractionEnabled = YES;
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
    
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, mailListBtn.bottom+10, kMainScreenWidth, 89)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:userInfoView];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth - 15 -10 - 120, 30)];
    nameTextField.tag = 1031;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.placeholder = @"请输入客户姓名";
    nameTextField.font = [UIFont systemFontOfSize:16.0f];
    nameTextField.textColor = NAVIGATIONTITLE;
    nameTextField.delegate = self;
//    [nameTextField addTarget:self action:@selector(nameTextFieldEndChanged) forControlEvents:UIControlEventEditingDidEnd];
    [nameTextField addTarget:self action:@selector(nameTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    nameTextField.returnKeyType = UIReturnKeyDone;
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
//    self.sexString = @"MALE";
    
    [manButton addTarget:self action:@selector(toggleSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userInfoView addSubview:manButton];
    
//    [userInfoView addSubview:[self createLineView:nameTextField.bottom+7]];
    
    if (!_bIsHiddenNum) {
        telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, nameTextField.bottom+15, kMainScreenWidth - 30, 30)];
        telTextField.placeholder = @"请输入手机号";
        telTextField.delegate = self;
        telTextField.tag = 1030;
        telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        telTextField.font = [UIFont systemFontOfSize:18.0f];
        [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        telTextField.keyboardType = UIKeyboardTypePhonePad;
        telTextField.textColor = NAVIGATIONTITLE;
//        [telTextField addTarget:self action:@selector(telTextFieldEndChanged) forControlEvents:UIControlEventEditingDidEnd];
        [userInfoView addSubview:telTextField];
    }else
    {
        firstNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(15, nameTextField.bottom+15, 60, 30)];
        firstNum.keyboardType = UIKeyboardTypePhonePad;
        firstNum.delegate = self;
        firstNum.tag = 1031;
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
//        firstNum.enabled = NO;
        middleNum = [[UILabel alloc] initWithFrame:CGRectMake(firstNum.right, firstNum.top, 45, 30)];
        middleNum.text = @"****";
        middleNum.textColor = NAVIGATIONTITLE;
        middleNum.font = [UIFont systemFontOfSize:18];
        middleNum.textAlignment = NSTextAlignmentCenter;
        
        tailNum = [[CustomerTextField alloc] initWithFrame:CGRectMake(middleNum.right, firstNum.top, 80, 30)];
        tailNum.keyboardType = UIKeyboardTypePhonePad;
        tailNum.delegate = self;
        tailNum.tag = 1032;
        tailNum.textColor = NAVIGATIONTITLE;
        tailNum.placeholder = @"后四";
        tailNum.textAlignment = NSTextAlignmentCenter;
        tailNum.font = [UIFont systemFontOfSize:18];
        [tailNum.layer setCornerRadius:4.0];
        [tailNum.layer setMasksToBounds:YES];
        [tailNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
        [tailNum.layer setBorderWidth:0.5];
        [tailNum addTarget:self action:@selector(tailNumTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
//        tailNum.enabled = NO;
        [userInfoView addSubview:firstNum];
        [userInfoView addSubview:middleNum];
        [userInfoView addSubview:tailNum];
        
        
        telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, nameTextField.bottom+15, kMainScreenWidth - 30, 30)];
        telTextField.placeholder = @"请输入手机号";
        telTextField.delegate = self;
        telTextField.tag = 1030;
        telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        telTextField.font = [UIFont systemFontOfSize:18.0f];
        [telTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        telTextField.keyboardType = UIKeyboardTypePhonePad;
        telTextField.textColor = NAVIGATIONTITLE;
        //        [telTextField addTarget:self action:@selector(telTextFieldEndChanged) forControlEvents:UIControlEventEditingDidEnd];
        [userInfoView addSubview:telTextField];
        
        telTextField.hidden = YES;
        //add by wangzz 160421
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
//        mobileVi  ew.backgroundColor = [UIColor whiteColor];
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
        //end
    }

    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    lineView.frame = CGRectMake(16, userInfoView.frame.size.height / 2.0 - 1, kMainScreenWidth - 16, 1);
    [userInfoView addSubview:lineView];
    
    
    headerView.frame = CGRectMake(0, 74, self.view.frame.size.width,userInfoView.frame.size.height + 50);
    _headerView = headerView;
    _nameTextField = nameTextField;
    _womanButton = womanButton;
    _manButton = manButton;
    _telTextField = telTextField;
    _firstNum = firstNum;
    _middleNum = middleNum;
    _tailNum = tailNum;
    [self.view addSubview:_headerView];
    
    
    self.navigationBar.titleLabel.text = @"选择客户";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.97f blue:0.97f alpha:1.00f];
    
    self.saveButton.frame = CGRectMake(8, CGRectGetMaxY(_headerView.frame) + 30, self.view.frame.size.width - 16, 50);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    if (textField.tag == 1030) {
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
    }else if (textField.tag == 1031)
    {
        return YES;
    }
    else
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

- (void)commonInit{

    
//    [self segmentedControl];
    
//    self.customerView.frame = CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame) + 10, self.view.frame.size.width, 88);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (XTEditCustomerView *)customerView{
    if (!_customerView) {
        XTEditCustomerView* view = [XTEditCustomerView editCustomerViewWithCallBack:^(XTEditCustomerView *view, XTEditCustomerViewSex sex) {
            switch (sex) {
                case XTEditCustomerViewSexWoMan:
                    NSLog(@"女");
                    break;
                case XTEditCustomerViewSexMan:
                    
                default:
                    NSLog(@"男");
                    break;
            }
        }];
        [self.view addSubview:view];
        _customerView =  view;
    }
    return _customerView;
}

- (void)toggleMailListButton:(UIButton*)sender
{
    LocalContactsViewController *addressContact = [[LocalContactsViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    _selectedCustomer = nil;
    [addressContact returnResultBlock:^(NSInteger index,NSString *text,NSString *detailText){
        weakSelf.nameTextField.text = text;
        if (_bIsHiddenNum) {
            if (detailText.length>=11) {
                [weakSelf.tailNum becomeFirstResponder];
                weakSelf.firstNum.text = [detailText substringWithRange:NSMakeRange(0, 3)];
                weakSelf.tailNum.text = [detailText substringWithRange:NSMakeRange(7, 4)];
                //add by wangzz 160421
//                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[detailText substringWithRange:NSMakeRange(0, 3)],[detailText substringWithRange:NSMakeRange(3, 4)],[detailText substringWithRange:NSMakeRange(7, 4)]];
//                weakSelf.telTextField.text = str;
                //end
            }else{
                [weakSelf.firstNum becomeFirstResponder];
                weakSelf.firstNum.text = @"";
                weakSelf.tailNum.text = @"";
                weakSelf.firstNum.enabled = YES;
                weakSelf.tailNum.enabled = YES;
                [weakSelf showTips:@"请输入客户手机号"];
            }
            weakSelf.tailNum.hidden = NO;
            weakSelf.firstNum.hidden = NO;
            weakSelf.middleNum.hidden = NO;
            weakSelf.telTextField.hidden = YES;
        }else
        {
            [weakSelf.telTextField becomeFirstResponder];
            if (detailText.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[detailText substringWithRange:NSMakeRange(0, 3)],[detailText substringWithRange:NSMakeRange(3, 4)],[detailText substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
                //add by wangzz 160421
//                if (!mobileView.hidden) {
//                    weakSelf.firstNum.text = [detailText substringWithRange:NSMakeRange(0, 3)];
//                    weakSelf.tailNum.text = [detailText substringWithRange:NSMakeRange(7, 4)];
//                }
                //end
            }else{
                weakSelf.telTextField.text = detailText;
            }
        }
        
        weakSelf.telTextField.userInteractionEnabled = YES;
        weakSelf.nameTextField.userInteractionEnabled = YES;
        weakSelf.manButton.userInteractionEnabled = YES;
        weakSelf.womanButton.userInteractionEnabled = YES;
        weakSelf.firstNum.userInteractionEnabled = YES;
        weakSelf.tailNum.userInteractionEnabled = YES;
        
        
        
    }];
    _isCustomerList = NO;
    [self.navigationController pushViewController:addressContact animated:YES];
}


- (UIButton *)saveButton{
    if (!_saveButton) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(saveButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 5;
        _saveButton = button;
    }
    return _saveButton;
}

- (void)saveButtonTouch:(UIButton*)btn{
    NSMutableString* mobileStr = nil;
    if (!_bIsHiddenNum) {
        //add by wangzz 160421
//        if ([_telTextField.text rangeOfString:@"****"].location != NSNotFound) {
//            [self showTips:@"手机号为全数字,请重新输入"];
//            return;
//        }
        //end
        mobileStr = [NSMutableString stringWithString:[_telTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//        mobileStr = [NSMutableString stringWithString:<#(nonnull NSString *)#>]
    }else
    if (_isCustomerList) {
        mobileStr = [NSMutableString stringWithFormat:@"%@",_telTextField.text];
    }else{
        mobileStr = [NSMutableString stringWithFormat:@"%@%@%@",_firstNum.text,_middleNum.text,_tailNum.text];
        
        mobileStr = [NSMutableString stringWithString:[mobileStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }

    if (!_manButton.selected && !_womanButton.selected) {
        [self showTips:@"请选择性别"];
        return;
    }
    if (_nameTextField.text.length > 0 && mobileStr.length == 11 && _callBack) {
        if (!_selectedCustomer) {
            Customer* _customer = [[Customer alloc]init];
            
            _selectedCustomer = _customer;
        }
        
        NSString* name = [NSMutableString stringWithFormat:@"%@",_nameTextField.text];
        _selectedCustomer.name = name;
        _selectedCustomer.listPhone = mobileStr;
        _selectedCustomer.sex = _sexString;
        _callBack(_selectedCustomer);
        [self.navigationController popViewControllerAnimated:YES];
    }else if(_nameTextField.text.length <= 0)[self showTips:@"请输入姓名"];
    else if(mobileStr.length != 11)[self showTips:@"请输入11位手机号"];
}

- (void)toggleCustomerButton:(UIButton*)sender
{
    CustomerSelectViewController *selectVC = [[CustomerSelectViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    _selectedCustomer = nil;
    [selectVC returnCustoemrResultBlock:^(Customer*cust) {
        weakSelf.nameTextField.text = cust.name;
        weakSelf.selectedCustomer = cust;
        if (weakSelf.bIsHiddenNum) {
            if (cust.listPhone.length>=11) {
//                [weakSelf.tailNum becomeFirstResponder];
//                weakSelf.firstNum.text = [cust.listPhone substringWithRange:NSMakeRange(0, 3)];
//                weakSelf.tailNum.text = [cust.listPhone substringWithRange:NSMakeRange(7, 4)];
                weakSelf.telTextField.text = cust.listPhone;
//                weakSelf.firstNum.enabled = NO;
//                weakSelf.tailNum.enabled = NO;
                //add by wangzz 160415
//                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[cust.phone substringWithRange:NSMakeRange(0, 3)],[cust.phone substringWithRange:NSMakeRange(3, 4)],[cust.phone substringWithRange:NSMakeRange(7, 4)]];
//                weakSelf.telTextField.text = str;
                //end
            }else
            {
//                [weakSelf.firstNum becomeFirstResponder];
            }
            
            weakSelf.tailNum.hidden = YES;
            weakSelf.firstNum.hidden = YES;
            weakSelf.middleNum.hidden = YES;
            weakSelf.telTextField.hidden = NO;
        }else
        {
//            [weakSelf.telTextField becomeFirstResponder];
            if (cust.listPhone.length == 11) {
                NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[cust.listPhone substringWithRange:NSMakeRange(0, 3)],[cust.listPhone substringWithRange:NSMakeRange(3, 4)],[cust.listPhone substringWithRange:NSMakeRange(7, 4)]];
                weakSelf.telTextField.text = str;
                //add by wangzz 160421
//                if (!mobileView.hidden) {
//                    weakSelf.firstNum.text = [cust.phone substringWithRange:NSMakeRange(0, 3)];
//                    weakSelf.tailNum.text = [cust.phone substringWithRange:NSMakeRange(7, 4)];
//                }
                //end
            }else{
                weakSelf.telTextField.text = cust.listPhone;
            }
        }
        if ([cust.sex isEqualToString:@"男"]) {
            [weakSelf toggleSexBtn:weakSelf.manButton];
        }else [weakSelf toggleSexBtn:weakSelf.womanButton];
        weakSelf.telTextField.userInteractionEnabled = NO;
        weakSelf.nameTextField.userInteractionEnabled = NO;
        weakSelf.manButton.userInteractionEnabled = NO;
        weakSelf.womanButton.userInteractionEnabled = NO;
        weakSelf.firstNum.userInteractionEnabled = NO;
        weakSelf.tailNum.userInteractionEnabled = NO;
    }];
    _isCustomerList = YES;
    [self.navigationController pushViewController:selectVC animated:YES];
}

//- (void)toggleMobileButton:(UIButton*)sender
//{
//    if (!sender.selected) {
//        [mobileBtn setTitle:@"全号" forState:UIControlStateNormal];
//        [mobileBtn setBackgroundColor:BLUEBTBCOLOR];
//        [mobileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        mobileView.hidden = NO;
//        _bIsHiddenNum = NO;
//        sender.selected = YES;
//    }else{
//        [mobileBtn setTitle:@"隐号" forState:UIControlStateNormal];
//        [mobileBtn setBackgroundColor:[UIColor whiteColor]];
//        [mobileBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//        mobileView.hidden = YES;
//        _bIsHiddenNum = YES;
//        sender.selected = NO;
//    }
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

//- (void)nameTextFieldEndChanged
//{
//    if ([self isBlankString:_nameTextField.text]) {
//        [self showTips:@"请输入客户姓名"];
//    }
//}

- (void)nameTextFieldDidChanged
{
    if (_nameTextField.text.length >= 15) {
        _nameTextField.text = [_nameTextField.text substringToIndex:15];
        [_nameTextField resignFirstResponder];
    }
}

//- (void)telTextFieldEndChanged
//{
//    NSArray *array = [_telTextField.text componentsSeparatedByString:@" "];
//    NSString *str = @"";
//    for (int i=0; i<array.count; i++) {
//        str = [str stringByAppendingString:[array objectForIndex:i]];
//    }
//    if (![NSString isValidateMobile:str] || [self isBlankString:_telTextField.text]) {
//        [self showTips:@"请输入11位手机号"];
//    }
//}

- (void)firstNumTextFieldDidChanged
{
    if (_firstNum.text.length >= 3) {
        //        [firstNum resignFirstResponder];
        _firstNum.text = [_firstNum.text substringToIndex:3];
        if (_tailNum.text.length==4) {
            [_firstNum resignFirstResponder];
        }else{
            [_tailNum becomeFirstResponder];
        }
    }
}

- (void)toggleSexBtn:(UIButton*)sender
{
    if (sender.tag == 1131) {
        if(!sender.selected) {
            sender.selected = NO;
            
            _manButton.selected = YES;
            sender.selected = !sender.selected;
            _manButton.selected = !_manButton.selected;
            self.sexString = @"0";
        }
        
    }else if (sender.tag == 1132)
    {
        if(!sender.selected) {
            sender.selected = NO;
            _womanButton.selected = YES;
            sender.selected = !sender.selected;
            _womanButton.selected = !_womanButton.selected;
            self.sexString = @"1";
        }
    }
}


- (void)tailNumTextFieldDidChanged{
    if (_tailNum.text.length >= 4) {
        _tailNum.text = [_tailNum.text substringToIndex:4];
        if (_firstNum.text.length==3) {
            [_tailNum resignFirstResponder];
        }else{
            [_firstNum becomeFirstResponder];
        }
        //        [firstNum becomeFirstResponder];
    }
}

@end
