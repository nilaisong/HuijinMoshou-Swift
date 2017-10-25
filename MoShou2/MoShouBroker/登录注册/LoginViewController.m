//
//  LoginViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "LoginViewController.h"
#import "HMTool.h"
#import "RegisterViewController.h"
#import "BlueLineView.h"
#import "NSString+Extension.h"
#import "FindViewController.h"
@interface LoginViewController (){
    UIView *whiteBg;
    UITextField *passTF;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text= @"登录";
    self.navigationBar.leftBarButton.hidden = YES;
    [self setIQKeyboardEnable:YES];
    [self createUI];

}
-(void)createUI{
    
    whiteBg =[[UIView alloc]init];
    [whiteBg setBackgroundColor:[UIColor whiteColor]];
    [whiteBg setFrame:CGRectMake(0, kFrame_Height(self.navigationBar)+0.5, kMainScreenWidth, 100)];
    [self.view addSubview:whiteBg];
    
    UIImageView *phonicon= [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 22, 22)];
    [phonicon setImage:[UIImage imageNamed:@"iconfont-shouji-3"]];
    [whiteBg addSubview:phonicon];
    
    
    UITextField *phoneTF =[[UITextField alloc]init];
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.keyboardType =UIKeyboardTypePhonePad;
    [phoneTF setFrame:CGRectMake(kFrame_XWidth(phonicon)+20, 0.5, kMainScreenWidth-77,48)];
    phoneTF.placeholder = @"请输入手机号";
    [phoneTF setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    [phoneTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    phoneTF.textColor = NAVIGATIONTITLE;
    phoneTF.font = [UIFont systemFontOfSize:15];
    [phoneTF setTag:3000];

    [phoneTF setDelegate:self];

    
    [phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [whiteBg addSubview:phoneTF];
    
    UIView *line2 = [HMTool creareLineWithFrame:CGRectMake(5, kFrame_YHeight(phoneTF), kFrame_Width(whiteBg)-10, 0.5) andColor:LINECOLOR];
    [line2 setTag:2000];
    [whiteBg addSubview:line2];
    
    UIImageView *passicon= [[UIImageView alloc]initWithFrame:CGRectMake(25, kFrame_YHeight(line2)+15, 22, 22)];
    [passicon setImage:[UIImage imageNamed:@"iconfont-mima"]];
    [whiteBg addSubview:passicon];
    
    passTF =[[UITextField alloc]init];
    [passTF setFrame:CGRectMake(kFrame_XWidth(passicon)+20,kFrame_Y(line2)+0.5, kFrame_Width(whiteBg)-25-22-77,48)];
    passTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTF.placeholder = @"请输入密码";
    [passTF setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    [passTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    passTF.textColor = NAVIGATIONTITLE;
    passTF.font = [UIFont systemFontOfSize:15];
    [passTF setTag:3001];
    [passTF setDelegate:self];
    [passTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [whiteBg addSubview:passTF];

    UIButton *eyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(whiteBg)-25-22, kFrame_Y(line2)+(25-11), 22, 22)];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [passTF setSecureTextEntry:YES];
    [eyeBtn setTag:1003];
    [whiteBg addSubview:eyeBtn];
    
    
    UIView *line3 = [HMTool creareLineWithFrame:CGRectMake(0, kFrame_Height(whiteBg)+0.5, kFrame_Width(whiteBg), 0.5) andColor:LINECOLOR];
    [line3 setTag:2001];
    [whiteBg addSubview:line3];
    
    UIButton *loginBtn =[[UIButton alloc]init];
    loginBtn.frame = CGRectMake(kMainScreenWidth/2-(kMainScreenWidth-20)/2, kFrame_YHeight(whiteBg)+40,kMainScreenWidth-20, 50);
//    loginBtn.center = CGPointMake(kMainScreenWidth/2, kFrame_YHeight(whiteBg)-20+100-40);
    [loginBtn setBackgroundColor:BLUEBTBCOLOR];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    loginBtn.layer.cornerRadius = 4.0;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTag:1000];
    [self.view addSubview:loginBtn];
    
    UIButton *regeristBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [regeristBtn setFrame:CGRectMake(kFrame_X(loginBtn)+5, kFrame_YHeight(loginBtn)+30, [HMTool getTextSizeWithText:@"快速注册" andFontSize:14].width, [HMTool getTextSizeWithText:@"快速注册" andFontSize:14].height)];
    [regeristBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    regeristBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regeristBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [regeristBtn setTag:1001];
    [self.view addSubview:regeristBtn];
    
    UIButton *forgetBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setFrame:CGRectMake(kFrame_XWidth(loginBtn)-[HMTool getTextSizeWithText:@"忘记密码" andFontSize:14].width-5, kFrame_YHeight(loginBtn)+30, [HMTool getTextSizeWithText:@"忘记密码" andFontSize:14].width, [HMTool getTextSizeWithText:@"忘记密码" andFontSize:14].height)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [forgetBtn setTag:1002];
    [self.view addSubview:forgetBtn];
    [loginBtn addTarget:self action:@selector(allBtnClickedActions:) forControlEvents:UIControlEventTouchUpInside];
     [regeristBtn addTarget:self action:@selector(allBtnClickedActions:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn addTarget:self action:@selector(allBtnClickedActions:) forControlEvents:UIControlEventTouchUpInside];
    [eyeBtn addTarget:self action:@selector(allBtnClickedActions:) forControlEvents:UIControlEventTouchUpInside];
    
    

}

-(void)allBtnClickedActions:(UIButton *)btn {
    if (btn.tag == 1000) {//登录
        
    }else if (btn.tag == 1001){//注册
        RegisterViewController *regist=[[RegisterViewController alloc]init];
//        [self presentViewController:regist animated:YES completion:^{
//            
//        }];
        [self.navigationController pushViewController:regist animated:YES];
        
    }else if(btn.tag == 1002){//忘记密码
        FindViewController *fin =[[FindViewController alloc]init];
//        [self presentViewController:fin animated:YES completion:^{
//            
//        }];
        [self.navigationController pushViewController:fin animated:YES];

    
    }else if(btn.tag == 1003){//眼睛
        if(btn.selected){
            [passTF setSecureTextEntry:YES];
            [btn setSelected:NO];
            
        }else{
            [btn setSelected:YES];
            [passTF setSecureTextEntry:NO];

        
        }
    }


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *view in [whiteBg subviews]) {
        if (view.tag == 3000) {
            [view resignFirstResponder];
        }
        if (view.tag == 3001) {
            [view resignFirstResponder];

        }
        if (view.tag == 2000) {
            
            [(UIView *)view setBackgroundColor:LINECOLOR];

        }
        if (view.tag == 2001) {
            [(UIView *)view setBackgroundColor:LINECOLOR];

        }
    }


}
-(void)textFieldDidChange:(UITextField *)textField{
    NSLog(@"jsjsjsjsjsjsjsjsj");

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    return [textField resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 3000) {
        for (UIView *view in [whiteBg subviews]) {
            if (view.tag == 2000) {
                [view setBackgroundColor:BLUEBTBCOLOR];
            }
            if (view.tag == 2001) {
                [view setBackgroundColor:LINECOLOR];
            }
        }
        
        
    }
    if (textField.tag == 3001){
        for (UIView *view in [whiteBg subviews]) {
            if (view.tag == 2001) {
                [view setBackgroundColor:BLUEBTBCOLOR];
            }
            if (view.tag == 2000) {
                [view setBackgroundColor:LINECOLOR];
            }
        }
        
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.keyboardType ==UIKeyboardTypePhonePad) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
