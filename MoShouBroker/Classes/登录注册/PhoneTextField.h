//
//  PhoneTextField.h
//  MoShou2
//
//  Created by Aminly on 16/2/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneTextField : UITextField<UITextFieldDelegate>
@property(nonatomic,weak)id<UITextFieldDelegate>delegate;
@property(nonatomic,assign)BOOL needBlank;
//-(instancetype)init;

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
//- (void)textFieldDidBeginEditing:(UITextField *)textField;
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//-(void)textFieldDidEndEditing:(UITextField *)textField;

@end
