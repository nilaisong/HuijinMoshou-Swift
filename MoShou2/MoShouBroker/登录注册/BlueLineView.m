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
        self.textfield = [[UITextField alloc]init];
        self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.isPhoneTextField = isPhoneTextField;
        if (isPhoneTextField) {
            self.textfield.keyboardType =UIKeyboardTypePhonePad;

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
        if ([[[NSString stringWithFormat:@"%@%@",textField.text,string] trimSpace] isValidNumber]) {
            if (textField.text.length == 3||textField.text.length == 8) {
                if (string.length>0) {
                    textField.text =[NSString stringWithFormat:@"%@ %@",textField.text,string];
                    return NO;
                }
            }else if (textField.text.length == 5||textField.text.length == 10){
                if (string.length==0) {
                    textField.text =[textField.text substringToIndex:textField.text.length-2];
                    return NO;
                }
            }else if (textField.text.length == 13&&string.length>0){
                return NO;
            }
        }else{
            if (textField.text.length == 14&& string.length>0) {
                return  NO;
            }
        }
       
    }
    return  YES;
}
-(instancetype)initWithFrame:(CGRect)frame andIconImage:(UIImage *)icon andPlaceholder:(NSString *)placeholder andTextFieldStyle:(BLVTextFieldStyle)tfStyle andLineSyle:(BLVLINEStyle)lineStyle;
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 22, 22)];
        self.icon.image = icon;
        [self addSubview:self.icon];
        self.textfield = [[UITextField alloc]init];
        self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.style= tfStyle;
        if (self.style == BLVPHONE) {
            
            [self.textfield setFrame:CGRectMake(kFrame_XWidth(self.icon)+20, 0.5, kMainScreenWidth-77,48)];
            self.textfield.keyboardType = UIKeyboardTypePhonePad;

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
    return self;

}


@end
