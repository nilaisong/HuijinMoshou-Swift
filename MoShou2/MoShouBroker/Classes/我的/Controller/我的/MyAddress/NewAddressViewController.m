//
//  NewAddressViewController.m
//  MoShou2
//
//  Created by wangzz on 2017/2/22.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "NewAddressViewController.h"
#import "NSString+Extension.h"
#import "CMInputView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "DataFactory+Customer.h"
@interface NewAddressViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField    *nameTextField;
@property (nonatomic, strong) UITextField    *telTextField;
@property (nonatomic, strong) CMInputView    *addressTextView;
@property (nonatomic, assign) BOOL           bIsTouched;

@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"新增地址";
    self.view.backgroundColor = VIEWBGCOLOR;
    [self layoutUI];
    
    // Do any additional setup after loading the view.
}

- (void)layoutUI
{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, kMainScreenHeight-viewTopY)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    
    CGSize nameSize = [@"收货地址" sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, nameSize.width, nameSize.height)];
    nameLabel.text = @"收货人";
    nameLabel.textColor = NAVIGATIONTITLE;
    nameLabel.font = FONT(15);
    [bgView addSubview:nameLabel];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.right+30, nameLabel.top, kMainScreenWidth-nameLabel.right-30-10, nameLabel.height)];
    _nameTextField.font = FONT(15);
    _nameTextField.placeholder = @"请填写收件人";
    [_nameTextField setValue:[UIColor colorWithHexString:@"888888"] forKeyPath:@"_placeholderLabel.textColor"];
    _nameTextField.textColor = NAVIGATIONTITLE;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:_nameTextField];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, _nameTextField.bottom+15, kMainScreenWidth-10, 0.5)];
    line1.backgroundColor = VIEWBGCOLOR;
    [bgView addSubview:line1];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line1.bottom+15, nameLabel.width, nameLabel.height)];
    telLabel.text = @"手机号码";
    telLabel.textColor = NAVIGATIONTITLE;
    telLabel.font = FONT(15);
    [bgView addSubview:telLabel];
    
    _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(telLabel.right+30, telLabel.top, kMainScreenWidth-telLabel.right-30-10, telLabel.height)];
    _telTextField.font = FONT(15);
    _telTextField.placeholder = @"11位手机号";
    [_telTextField setValue:[UIColor colorWithHexString:@"888888"] forKeyPath:@"_placeholderLabel.textColor"];
    _telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telTextField.textColor = NAVIGATIONTITLE;
    _telTextField.delegate = self;
    [bgView addSubview:_telTextField];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, _telTextField.bottom+15, kMainScreenWidth-10, 0.5)];
    line2.backgroundColor = VIEWBGCOLOR;
    [bgView addSubview:line2];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.bottom+15, nameLabel.width, nameLabel.height)];
    addressLabel.text = @"收货地址";
    addressLabel.textColor = NAVIGATIONTITLE;
    addressLabel.font = FONT(15);
    [bgView addSubview:addressLabel];
    
    _addressTextView = [[CMInputView alloc] initWithFrame:CGRectMake(addressLabel.right+30, addressLabel.top, kMainScreenWidth-addressLabel.right-30-10, addressLabel.height)];
    _addressTextView.font = FONT(15);
    _addressTextView.textColor = NAVIGATIONTITLE;
    _addressTextView.maxNumberOfLines = 4;
    _addressTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
    _addressTextView.placeholder = @"请填写详细地址";
    _addressTextView.placeholderFont = FONT(15);
    _addressTextView.placeholderColor = [UIColor colorWithHexString:@"888888"];
    [bgView addSubview:_addressTextView];
    if (_addressType == kEditAddress && _addressData != nil) {
        _nameTextField.text = _addressData.receiverUser;
        NSString *phone = _addressData.receiverMobile;
        NSString *str = @"";
        if (![self isBlankString:phone] && phone.length==11) {
            str = [NSString stringWithFormat:@"%@ %@ %@",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(3, 4)],[phone substringWithRange:NSMakeRange(7, 4)]];
        }else
        {
//            [_telTextField becomeFirstResponder];
            str = phone;
        }
        _telTextField.text = str;
        _addressTextView.text = _addressData.receiverAddress;
        if (_addressTextView.text.length>0) {
            _addressTextView.placeholderView.hidden = YES;
            float maxTextH = ceilf(_addressTextView.font.lineHeight * 4 + _addressTextView.textContainerInset.top + _addressTextView.textContainerInset.bottom);
            float textH = ceilf([_addressTextView sizeThatFits:CGSizeMake(_addressTextView.width, MAXFLOAT)].height);
            _addressTextView.height = textH;
            if (textH>maxTextH) {
                BOOL isChange = !_addressTextView.scrollEnabled;
                _addressTextView.scrollEnabled = textH > maxTextH && maxTextH > 0;
                if (_addressTextView.scrollEnabled && isChange) {
                    _addressTextView.contentOffset = CGPointMake(0,1);
                }
                _addressTextView.height = maxTextH;
            }
        }
    }
    bgView.height = _addressTextView.bottom+15;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, bgView.bottom + 25, kMainScreenWidth-20, 45)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BLUEBTBCOLOR];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:4];
    [saveBtn addTarget:self action:@selector(toggleSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:saveBtn];
    
    __weak NewAddressViewController *weakSelf = self;
    // 设置文本框最大行数
    [_addressTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = weakSelf.addressTextView.frame;
        frame.size.height = textHeight;
        weakSelf.addressTextView.frame = frame;
        
        bgView.height = weakSelf.addressTextView.bottom + 15;
        saveBtn.top = bgView.bottom+25;
    }];
    
}

- (void)toggleSaveButton:(UIButton*)sender
{
    if (!_bIsTouched) {
        _bIsTouched = YES;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:_nameTextField.text]) {
            [dic setValue:_nameTextField.text forKey:@"receiverUser"];
        }
        if (![self isBlankString:_telTextField.text]) {
            [dic setValue:_telTextField.text forKey:@"receiverMobile"];
        }
        if (![self isBlankString:_addressTextView.text]) {
            [dic setValue:_addressTextView.text forKey:@"receiverAddress"];
        }
        if (![self isBlankString:_addressData.addressId]) {
            [dic setValue:_addressData.addressId forKey:@"id"];
        }
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] modifyAddressWithDict:dic withCallBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeRotationAnimationView:loadingView];
                if (result.success) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //防止多次pop发生崩溃闪退
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                        if ([self.view superview]) {
                            _bIsTouched = NO;
                            _saveAddressButton();
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }else
                {
                    _bIsTouched = NO;
                }
            });
        }];
    }
}

-(void)saveModifyAddressBlock:(SaveAddressBlock)ablock
{
    _saveAddressButton = ablock;
}

-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
        [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
//    if (textField.tag == 1000 || textField.tag == 1001 || textField.tag == 1002) {
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
            }
//            else if ([self noneSpaseString:textField.text].length + string.length - range.length == 11)
//            {
//                NSArray *array = [_telTextField.text componentsSeparatedByString:@" "];
//                NSString *phone = @"";
//                for (int i=0; i<array.count; i++) {
//                    phone = [phone stringByAppendingString:[array objectForIndex:i]];
//                }
//                phone = [phone stringByAppendingString:string];
//                [[DataFactory sharedDataFactory] validationMobileWithPhone:phone withCallBack:^(ActionResult *result, Customer *cust) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (result.success) {
//                            if ([cust.exist boolValue]) {
//                                if (customerViewCtrlType == kReportNewCustomer) {
//                                    self.customerData = cust;
//                                }else {
//                                    [self showTips:result.message];
//                                }
//                            }
//                        }else
//                        {
//                            [self showTips:result.message];
//                        }
//                    });
//                }];
//            }
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
//    }else
//    {
//        //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
//        if(![string isValidNumber]){
//            return NO;
//        }
//    }
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
