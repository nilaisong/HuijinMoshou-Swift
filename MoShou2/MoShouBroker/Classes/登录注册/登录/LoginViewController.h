//
//  LoginViewController.h
//  MoShou2
//
//  Created by Aminly on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "BlueLineView.h"
#import "PhoneTextField.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate,BlueLineViewDelegate>
//手机号字符串格式化
- (NSString*)parseString:(NSString*)string;
//按钮点击事件
-(void)allBtnClickedActions:(UIButton *)btn;
//设置手机号码的格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
