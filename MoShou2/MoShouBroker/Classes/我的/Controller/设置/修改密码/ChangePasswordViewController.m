//
//  ChangePasswordViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "BlueLineView.h"
#import "LoginViewController.h"
#import "DataFactory+User.h"
#import "NSString+PasswordVertify.h"
@interface ChangePasswordViewController ()<BlueLineViewDelegate>{
    BlueLineView *_mimablv;
    BlueLineView *_currentMimablv;
//    BlueLineView *_phoneblv;
    BlueLineView *_yanzhengblv;
    BlueLineView *_querenmima;

//    NSTimer *_timer;
    int count;
}

@end

@implementation ChangePasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI{
    count = 60;
    self.navigationBar.titleLabel.text = @"修改密码";
    UIView *backview =[[UIView alloc]init];
    [backview setBackgroundColor:[UIColor whiteColor]];
    [backview setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 150)];
    backview.userInteractionEnabled =YES;
    [self.view addSubview:backview];
    
//    _phoneblv = [[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50) andIconImage:[UIImage imageNamed:@"iconfont-shouji-3"]  andPlaceholder:@"请输入手机号" andTextFieldStyle:BLVPHONE andLineSyle:BLVSPACEVIEW];
//    _phoneblv.userInteractionEnabled =YES;
//    [_phoneblv.textfield setTag:3000];
//    [_phoneblv setDelegate:self];
//    [backview addSubview:_phoneblv];
//     _yanzhengblv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_Height(_phoneblv), kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-yanzhengma-3"]  andPlaceholder:@"验证码" andTextFieldStyle:BLVVCODE andLineSyle:BLVSPACEVIEW];
//    [_yanzhengblv.textfield setTag:3001];

//    _yanzhengblv.userInteractionEnabled =YES;
//    [_yanzhengblv setDelegate:self];
//    [backview addSubview:_yanzhengblv];
//    
//    UIButton *yanzhengBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-25-88,kFrame_Y(_yanzhengblv)+(25-38/2), 88, 38)];
//    [yanzhengBtn setBackgroundColor:[UIColor colorWithHexString:@"#5cc7ff"]];
//    [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    yanzhengBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    yanzhengBtn.layer.cornerRadius = 4;
//    yanzhengBtn.layer.masksToBounds = YES;
//    [yanzhengBtn setTag:CFVCODEBTN];
//    [backview addSubview:yanzhengBtn];
    
    _currentMimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请输入当前密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _currentMimablv.userInteractionEnabled =YES;
    [_currentMimablv.textfield setTag:3003];
    [_currentMimablv setDelegate:self];
    [backview addSubview:_currentMimablv];
    UIButton *ceyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_currentMimablv)+(25-11), 22, 22)];
    [ceyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [ceyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_currentMimablv.textfield setSecureTextEntry:YES];
    [ceyeBtn setTag:CFCEYEBTN];
    [backview addSubview:ceyeBtn];
    
    _mimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(_currentMimablv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请输入新密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _mimablv.userInteractionEnabled =YES;
    [_mimablv.textfield setTag:3002];
    [_mimablv setDelegate:self];
    [backview addSubview:_mimablv];
    
    UIButton *eyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_mimablv)+(25-11), 22, 22)];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_mimablv.textfield setSecureTextEntry:YES];
    [eyeBtn setTag:CFEYEBTN];
    [backview addSubview:eyeBtn];
    
    _querenmima=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(_mimablv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请再次输入新密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _querenmima.userInteractionEnabled =YES;
    [_querenmima.textfield setTag:3001];
    [_querenmima setDelegate:self];
    [backview addSubview:_querenmima];
    
    UIButton *qeyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_querenmima)+(25-11), 22, 22)];
    [qeyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [qeyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_querenmima.textfield setSecureTextEntry:YES];
    [qeyeBtn setTag:CFCEYEBTN2];
    [backview addSubview:qeyeBtn];
    
    UIButton *bigBtn =[[UIButton alloc]init];
    bigBtn.frame = CGRectMake(kMainScreenWidth/2-(kMainScreenWidth-20)/2, kFrame_YHeight(backview)+40,kMainScreenWidth-20, 50);
    [bigBtn setBackgroundColor:BLUEBTBCOLOR];
    [bigBtn setTitle:@"保存" forState:UIControlStateNormal];
    [bigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bigBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    bigBtn.layer.cornerRadius = 4.0;
    bigBtn.layer.masksToBounds = YES;
    [bigBtn setTag:CFRESETBTN];
    [self.view addSubview:bigBtn];
    [qeyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    [eyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    [ceyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];

    [bigBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    if (textField.tag == 3000) {
//        if (textField.text.length<=0) {
//            [TipsView showTips:@"请输入手机号" inView:self.view];
//        }else if (textField.text.length<13){
//            [TipsView showTips:@"请输入正确手机号" inView:self.view];
//            
//        }
//    }else if (textField.tag == 3001){
//        if (textField.text.length<=0) {
//            [TipsView showTips:@"请输入验证码" inView:self.view];
//        }else if (textField.text.length<6){
//            [TipsView showTips:@"请输入正确验证码" inView:self.view];
//            
//        }
//        
//    }else if (textField.tag == 3002){
//        if (textField.text.length<=0) {
//            [TipsView showTips:@"请设置密码" inView:self.view];
//        }else if (textField.text.length<6){
//            [TipsView showTips:@"设置6到20个字符密码" inView:self.view];
//            
//        }
//        
//    }else if (textField.tag == 3003){
//        if (textField.text.length<=0) {
//            [TipsView showTips:@"请输入当前密码" inView:self.view];
//        }else if (textField.text.length<6){
//            [TipsView showTips:@"请输入6到20个字符密码" inView:self.view];
//            
//        }
//        
//    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 3001) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }

    }else if (textField.tag == 3002){
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }
    }else if (textField.tag == 3003){
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }
    }
    
}
//按钮点击事件
-(void)allBtnClickActions:(UIButton *)btn{
//     if (btn.tag == CFVCODEBTN){//获取验证码按钮
//        if (_phoneblv.textfield.text.length<=0) {
//            [TipsView showTipsCantClick:@"请输入手机号" inView:self.view];
//        }else if (_phoneblv.textfield.text.length<13){
//            [TipsView showTipsCantClick:@"请输入正确手机号" inView:self.view];
//            
//        }else if(![[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[Tool getCache:@"user_account"]]){
//            [TipsView showTipsCantClick:@"请输入当前手机号" inView:self.view];
//        }else{
//            btn.userInteractionEnabled = NO;
//            [[DataFactory sharedDataFactory]getVcodeWithMobile:[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] andCallback:^(ActionResult *result) {
//                if (result.success) {
//                    [btn setBackgroundColor:LINECOLOR];
//                    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:btn repeats:YES];
//                }else{
//                    [btn setBackgroundColor:BLVALLVIEW];
//                    [TipsView showTipsCantClick:result.message inView:self.view];
//                    btn.userInteractionEnabled = YES;
//                }
//            }];
//        }
//    }else
    if(btn.tag == CFRESETBTN){//保存按钮
//        if (_phoneblv.textfield.text.length<=0) {
//            [TipsView showTipsCantClick:@"请输入手机号" inView:self.view];
//        }else if (_phoneblv.textfield.text.length<13){
//            [TipsView showTipsCantClick:@"请输入正确手机号" inView:self.view];
//        }else if(![[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[Tool getCache:@"user_account"]]){
//            [TipsView showTipsCantClick:@"请输入当前手机号" inView:self.view];
//            
//        }
//            else if(_yanzhengblv.textfield.text.length<=0){
//                [TipsView showTipsCantClick:@"请输入验证码" inView:self.view];
//            }else if (_yanzhengblv.textfield.text.length<6){
//                [TipsView showTipsCantClick:@"请输入正确验证码" inView:self.view];
//                
//            }else
        if (_currentMimablv.textfield.text.length<=0) {
                    [TipsView showTipsCantClick:@"请输入当前密码" inView:self.view];
            }else if(![_querenmima.textfield.text isEqualToString:_mimablv.textfield.text]){
            [TipsView showTipsCantClick:@"密码不一致请重新输入" inView:self.view];
            
            }else if (![_currentMimablv.textfield.text isLegal]){
                [TipsView showTips:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];
                
            }else if (_mimablv.textfield.text.length<=0) {
                [TipsView showTipsCantClick:@"请输入新密码" inView:self.view];
            }else if (![_mimablv.textfield.text isLegal]){
                [TipsView showTips:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];
                
            }else if (_querenmima.textfield.text.length<=0) {
                [TipsView showTipsCantClick:@"请再次输入新密码" inView:self.view];
                
            }else if (![_querenmima.textfield.text isLegal]){
                [TipsView showTips:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];
                
            }else{
                if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                UIImageView *loading =[self setRotationAnimationWithView];
                [[DataFactory sharedDataFactory]changPasswordWithCurrentPassword:_currentMimablv.textfield.text andNewPassword:_mimablv.textfield.text andCallback:^(ActionResult *result) {
                    if ( result.success) {
                        [self removeRotationAnimationView:loading];
                        [TipsView showTipsCantClick:@"修改成功" inView:self.view];
                        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popToLoginVC) userInfo:nil repeats:NO];
                    }else{
                        [self removeRotationAnimationView:loading];
                        btn.userInteractionEnabled = YES;
                        [TipsView showTipsCantClick:result.message inView:self.view];
                    }
                }];
            }
        }
    }else if(btn.tag == CFCEYEBTN){//显示当前输入密码按钮
        if(btn.selected){
            [_currentMimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
        }else{
            [btn setSelected:YES];
            [_currentMimablv.textfield setSecureTextEntry:NO];
        }
    }else if (btn.tag == CFEYEBTN) {//显示输入密码按钮
        if(btn.selected){
            [_mimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
            
        }else{
            [btn setSelected:YES];
            [_mimablv.textfield setSecureTextEntry:NO];
        }
    }else if (btn.tag == CFCEYEBTN2) {//显示输入密码按钮
        if(btn.selected){
            [_querenmima.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
            
        }else{
            [btn setSelected:YES];
            [_querenmima.textfield setSecureTextEntry:NO];
        }
    }

}

-(void)popToLoginVC{
    [self.navigationController popViewControllerAnimated:YES];

}
////验证码倒计时
//-(void)countDown:(NSTimer *)timer{
//    -- count;
//    UIButton *btn = (UIButton *)timer.userInfo;
//    if (count<=0) {
//        btn.titleLabel.numberOfLines =1;
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        [btn setBackgroundColor:[UIColor colorWithHexString:@"#5cc7ff"]];
//        
//        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [_timer invalidate];
//        btn.userInteractionEnabled = YES;
//        count = 60;
//    }else{
//        btn.titleLabel.numberOfLines =0;
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [btn setTitle:[NSString stringWithFormat:@"重新发送\n(%ds)", count] forState:UIControlStateNormal];
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
