//
//  XTLoginInputView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTLoginInputView.h"
#import "XTButton.h"
#import "NSString+Extension.h"
#import "Tool.h"

@interface XTLoginInputView()<UITextFieldDelegate>

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UITextField* inputField;

@property (nonatomic,weak)XTButton* eyeButton;

@property (nonatomic,copy)NSString* titleStr;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,copy)LoginInputViewCallBack callBack;

@end

@implementation XTLoginInputView

- (instancetype)initWithFrame:(CGRect)frame Type:(LoginInputViewType)type titleStr:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self setType:type];
        _titleStr = title;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Type:(LoginInputViewType)type titleStr:(NSString *)title callBack:(LoginInputViewCallBack)callBack{
    if (self =  [self initWithFrame:frame Type:type titleStr:title]) {
        _callBack = callBack;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (_titleStr.length > 0) {
        self.titleLabel.text = _titleStr;
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (_callBack) {
        _callBack(self,_inputField.text);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize titleSize = [@"手机号" sizeWithfont:self.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.titleLabel.frame = CGRectMake(0, (self.height - 16)/2.0, titleSize.width, titleSize.height);
    
    self.eyeButton.frame = CGRectMake(self.width - 25, 0, 25, self.height);
    
    switch (_type) {
        case LoginInputViewPhone:{
            self.inputField.frame = CGRectMake(_titleLabel.width + 30 * SCALE6, _titleLabel.frame.origin.y - 10, self.width - (_titleLabel.width + 30 * SCALE6), 38);
        }
            break;
        case LoginInputViewPasswd:{
            self.inputField.frame = CGRectMake(_titleLabel.width + 30 * SCALE6, _titleLabel.frame.origin.y - 10, self.width - (_titleLabel.width + 30 * SCALE6) - 25, 38);
        }
            break;
        default:
            break;
    }
    
    self.lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UITextField *)inputField{
    if (!_inputField) {
        UITextField* field = [[UITextField alloc]init];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textColor = [UIColor colorWithHexString:@"333333"];
        field.font = [UIFont systemFontOfSize:16];
        [self addSubview:field];
        field.delegate = self;
        [field addTarget:self action:@selector(fieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _inputField = field;
    }
    return _inputField;
}

- (void)fieldDidChange:(UITextField*)field{
    if (_callBack) {
        if (_type == LoginInputViewPasswd) {
            if (field.text.length > 20) {
                field.text = [field.text substringToIndex:20];
                [field resignFirstResponder];
            }
        }
        _callBack(self,[field.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }
}

//#pragma mark -设置手机号码的格式
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (_type == LoginInputViewPhone) {
//        //删除
//        if([string isEqualToString:@""]){
//            return YES;
//         }
//        else if(string.length >0){
//            //限制输入字符个数
//            if ((textField.text.length + string.length > 11) ) {
//                if (_showTipsCallBack) {
//                    _showTipsCallBack(self,@"请输入11位手机号");
//                }
//                return NO;
//            }
//            //            判断是否是纯数字
//            if(![self validateNumber:string]){
//                return NO;
//            }
//        }
//        return YES;
//    }
//    
//    return YES;
//    
//}

#pragma mark -设置手机号码的格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_type == LoginInputViewPhone) {
        NSString* text = textField.text;
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
                
                if (_showTipsCallBack) {
                    _showTipsCallBack(self,@"请输入11位手机号");
                }
                return NO;
            }
            //            判断是否是纯数字
            if(![self validateNumber:string]){
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
    }
    
    return YES;
    
}

//手机号字符串格式化
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

-(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


- (XTButton *)eyeButton{
    if (!_eyeButton) {
        XTButton* btn = [[XTButton alloc]initWithNormalImage:@"" selectedImage:@"" imageFrame:CGRectMake(0, (self.height - 15)/2.0, 25, 15)];
        [self addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"login-passwd-normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"login-passwd-selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(eyeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _eyeButton = btn;
    }
    return _eyeButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
        [self addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

- (void)eyeBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    self.inputField.secureTextEntry = !btn.selected;
}

- (void)setType:(LoginInputViewType)type{
    _type = type;
    
    self.inputField.keyboardType = UIKeyboardTypeDefault;
    self.inputField.returnKeyType = UIReturnKeyDone;
    self.inputField.secureTextEntry = NO;
    self.eyeButton.hidden = YES;
    
    switch (type) { 
        case LoginInputViewPhone:
        {
            if (![self isBlankString:[Tool getCache:@"user_account"] ]) {
                
                self.inputField.text = [self getPhoneString:[Tool getCache:@"user_account"]];
            }
            self.inputField.attributedPlaceholder = [self placeWith:@"请输入手机号"];
            self.inputField.keyboardType = UIKeyboardTypePhonePad;
        }
            break;
        case LoginInputViewPasswd:{
            self.inputField.attributedPlaceholder = [self placeWith:@"请输入密码"];
            self.inputField.secureTextEntry = YES;
            self.eyeButton.hidden = NO;
        }
            break;
        default:{
            self.inputField.attributedPlaceholder = [self placeWith:@""];
        }
            break;
    }
    
    
    
}

- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (NSAttributedString*)placeWith:(NSString*)string{
    NSAttributedString* plactAttr = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"bfbfbf"]}];
    return plactAttr;
}

- (void)setEndEditing:(BOOL)end{
    if (end) {
        [_inputField endEditing:YES];
        [self.inputField resignFirstResponder];
    }else{
        [_inputField endEditing:NO];
        [self.inputField becomeFirstResponder];
    }
}

-(NSString *)getPhoneString:(NSString *)phone{
    NSString *string = [phone substringWithRange:NSMakeRange(0,3)];
    NSString *string1 = [phone substringWithRange:NSMakeRange(3,4)];
    NSString *string2 = [phone substringWithRange:NSMakeRange(7,4)];
    
    NSString *phoneStr =[NSString stringWithFormat:@"%@ %@ %@",string,string1,string2];
    return phoneStr;
}

- (void)clearText{
    _inputField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

@end
