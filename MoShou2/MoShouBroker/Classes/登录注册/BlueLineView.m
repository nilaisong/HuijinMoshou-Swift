//
//  BlueLineView.m
//  MoShou2
//
//  Created by Aminly on 15/11/23.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BlueLineView.h"
#import "HMTool.h"
#import "NSString+Extension.h"

@implementation BlueLineView

-(instancetype)initWithFrame:(CGRect)frame andIconImage:(UIImage *)icon andPlaceholder:(NSString *)placeholder andIsPhoneTF:(BOOL)isPhoneTextField
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 22, 22)];
        self.icon.image = icon;
        [self addSubview:self.icon];
        self.textfield = [[PhoneTextField alloc]init];
        self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.isPhoneTextField = isPhoneTextField;
        if (isPhoneTextField) {
            self.textfield.keyboardType =UIKeyboardTypePhonePad;
            self.textfield.needBlank = YES;

        }
        [self.textfield setFrame:CGRectMake(kFrame_XWidth(self.icon)+20, 0.5, kMainScreenWidth-77,48)];
        self.textfield.placeholder = placeholder;
        [self.textfield setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
        [self.textfield setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        self.textfield.textColor = NAVIGATIONTITLE;
        self.textfield.font = [UIFont systemFontOfSize:15];
        
        [self.textfield setDelegate:self];
        [self addSubview:self.textfield];
         [self.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.line = [HMTool getLineWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-0.5, self.frame.size.width, 0.5) andColor:LINECOLOR];
        [self addSubview:self.line];

    }
    return self;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
 
    [self.line setBackgroundColor:BLUEBTBCOLOR];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.line setBackgroundColor:LINECOLOR];
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:self.textfield];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [self.delegate textFieldDidChange:self.textfield];
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.style == BLVPHONE||self.isPhoneTextField) {
        if (textField.tag ==3000) {
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
                    
                    [TipsView showTipsCantClick:@"请输入11位手机号" inView:[UIApplication sharedApplication].keyWindow ];

                    return NO;
                }
                //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
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
    }
    return  YES;
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
-(instancetype)initWithFrame:(CGRect)frame andIconImage:(UIImage *)icon andPlaceholder:(NSString *)placeholder andTextFieldStyle:(BLVTextFieldStyle)tfStyle andLineSyle:(BLVLINEStyle)lineStyle;
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 22, 22)];
        self.icon.image = icon;
        [self addSubview:self.icon];
        self.textfield = [[PhoneTextField alloc]init];
        self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.style= tfStyle;
        if (self.style == BLVPHONE) {
            self.isPhoneTextField = YES;
            [self.textfield setFrame:CGRectMake(kFrame_XWidth(self.icon)+20, 0.5, kMainScreenWidth-77,48)];
            self.textfield.keyboardType = UIKeyboardTypePhonePad;
            self.textfield.needBlank = YES;

        }else if (self.style == BLVVCODE){
            self.textfield.keyboardType = UIKeyboardTypeNumberPad;
            [self.textfield setFrame:CGRectMake(kFrame_XWidth(self.icon)+20, 0.5, kMainScreenWidth-25-88-77, 50)];
        }else if (self.style == BLVPASSWORD){
            self.textfield.keyboardType = UIKeyboardTypeDefault;
            [self.textfield setFrame:CGRectMake(kFrame_XWidth(self.icon)+20,0.5, kMainScreenWidth-25-22-77, 50)];

        }
        self.textfield.placeholder = placeholder;
        [self.textfield setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
        [self.textfield setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        self.textfield.textColor = NAVIGATIONTITLE;
        self.textfield.font = [UIFont systemFontOfSize:15];
        [self.textfield setDelegate:self];
        [self addSubview:self.textfield];
        [self.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        if (lineStyle == BLVALLVIEW) {
            self.line = [HMTool getLineWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-0.5, self.frame.size.width, 0.5) andColor:LINECOLOR];

        }else{
         
            self.line = [HMTool getLineWithFrame:CGRectMake(self.frame.origin.x+10, self.frame.size.height-0.5, self.frame.size.width-20, 0.5) andColor:LINECOLOR];
        }
        [self addSubview:self.line];
        
    }
    self.userInteractionEnabled = YES;
    return self;

}
-(void)setPhoneText:(NSString*)phone{
    
    self.textfield.text = phone;

}


@end
