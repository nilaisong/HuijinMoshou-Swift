//
//  FindViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "FindViewController.h"
#import "DataFactory+User.h"
#import "NSString+PasswordVertify.h"
#import "NSString+Extension.h"

@implementation FindViewController{
    BlueLineView *_mimablv;
    BlueLineView *_phoneblv;
    BlueLineView *_yanzhengblv;
    BlueLineView *_querenMimablv;
    
    UILabel      *_tipsLabel;
    NSTimer *_timer;
    int count;
    BOOL isclick;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI{
    count = 60;
    self.navigationBar.titleLabel.text = @"忘记密码";
    UIView *backview =[[UIView alloc]init];
    [backview setBackgroundColor:[UIColor whiteColor]];
    [backview setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 200)];
    backview.userInteractionEnabled =YES;
    
    [self.view addSubview:backview];
    
   _phoneblv = [[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50) andIconImage:[UIImage imageNamed:@"iconfont-shouji-3"]  andPlaceholder:@"请输入手机号" andTextFieldStyle:BLVPHONE andLineSyle:BLVSPACEVIEW];
    _phoneblv.userInteractionEnabled =YES;
    [_phoneblv.textfield setTag:3000];
    [_phoneblv setDelegate:self];
    [backview addSubview:_phoneblv];
    if (![self isBlankString:[Tool getCache:@"user_account"] ]) {
        
        _phoneblv.textfield.text = [self getPhoneString:[Tool getCache:@"user_account"]];
    }

    _yanzhengblv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_Height(_phoneblv), kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-yanzhengma-3"]  andPlaceholder:@"验证码" andTextFieldStyle:BLVVCODE andLineSyle:BLVSPACEVIEW];
    [_yanzhengblv.textfield setTag:3001];

    _yanzhengblv.userInteractionEnabled =YES;
    [_yanzhengblv setDelegate:self];
    [backview addSubview:_yanzhengblv];
       UIButton *yanzhengBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-25-88,kFrame_Y(_yanzhengblv)+(25-38/2), 88, 38)];
    [yanzhengBtn setBackgroundColor:[UIColor colorWithHexString:@"#5cc7ff"]];
    [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    yanzhengBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    yanzhengBtn.layer.cornerRadius = 4;
    yanzhengBtn.layer.masksToBounds = YES;
    [yanzhengBtn setTag:FVCODEBTN];
    [backview addSubview:yanzhengBtn];
    
    
    _mimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(_yanzhengblv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请输入新密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _mimablv.userInteractionEnabled =YES;
    [_mimablv.textfield setTag:3002];

    [_mimablv setDelegate:self];
    [backview addSubview:_mimablv];
    
    
    UIButton *eyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_mimablv)+(25-11), 22, 22)];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_mimablv.textfield setSecureTextEntry:YES];
    [eyeBtn setTag:FEYEBTN];
    [backview addSubview:eyeBtn];
    
    
    _querenMimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(_mimablv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请再次输入新密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _querenMimablv.userInteractionEnabled =YES;
    [_querenMimablv.textfield setTag:3003];
        [_querenMimablv setDelegate:self];
    [backview addSubview:_querenMimablv];
    
    UIButton *qeyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_querenMimablv)+(25-11), 22, 22)];
    [qeyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [qeyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_querenMimablv.textfield setSecureTextEntry:YES];
    [qeyeBtn setTag:FEYEBTN2];
    [backview addSubview:qeyeBtn];
    
    UIButton *bigBtn =[[UIButton alloc]init];
    bigBtn.frame = CGRectMake(kMainScreenWidth/2-(kMainScreenWidth-20)/2, kFrame_YHeight(backview)+40,kMainScreenWidth-20, 50);
    [bigBtn setBackgroundColor:BLUEBTBCOLOR];
    [bigBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [bigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bigBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    bigBtn.layer.cornerRadius = 4.0;
    bigBtn.layer.masksToBounds = YES;
    [bigBtn setTag:FRESETBTN];
    [self.view addSubview:bigBtn];
    [yanzhengBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    [eyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    
    [qeyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];

    [bigBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    
    //温馨提示
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.text = @"温馨提示：建议使用数字、字母和符号两种及以上的组合，6-20个字符";
    _tipsLabel.font = [UIFont systemFontOfSize:16];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textColor = [UIColor colorWithHexString:@"888888"];
    CGSize tipSize = [_tipsLabel.text sizeWithfont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(kMainScreenWidth - 40, MAXFLOAT)];
    _tipsLabel.frame = CGRectMake(20, CGRectGetMaxY(bigBtn.frame) + 30 * SCALE6, kMainScreenWidth - 40, tipSize.height);
    [self.view addSubview:_tipsLabel];
}
-(NSString *)getPhoneString:(NSString *)phone{
    NSString *string = [phone substringWithRange:NSMakeRange(0,3)];
    NSString *string1 = [phone substringWithRange:NSMakeRange(3,4)];
    NSString *string2 = [phone substringWithRange:NSMakeRange(7,4)];
    NSString *phoneStr =[NSString stringWithFormat:@"%@ %@ %@",string,string1,string2];
    return phoneStr;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    
//    if (!isclick) {
//        if (textField.tag == 3000) {
//            if (textField.text.length<=0) {
//                [TipsView showTips:@"请输入手机号" inView:self.view];
//            }else if (textField.text.length<13){
//                [TipsView showTips:@"请输入正确手机号" inView:self.view];
//                
//            }
//        }else if (textField.tag == 3001){
//            if (textField.text.length<=0) {
//                [TipsView showTips:@"请输入验证码" inView:self.view];
//            }else if (textField.text.length<6){
//                [TipsView showTips:@"请输入正确验证码" inView:self.view];
//                
//            }
//            
//        }else if (textField.tag == 3002){
//            if (textField.text.length<=0) {
//                [TipsView showTips:@"请设置密码" inView:self.view];
//            }else if (textField.text.length<6){
//                [TipsView showTips:@"设置6到20个字符密码" inView:self.view];
//                
//            }
//            
//        }
//
//    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag ==3000 ) {
        
        
    }else if(textField.tag == 3001){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
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
#pragma mark -按钮点击事件
-(void)allBtnClickActions:(UIButton *)btn{
    
    if (btn.tag == FEYEBTN) {//眼睛按钮
        if(btn.selected){
            [_mimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
        }else{
            [btn setSelected:YES];
            [_mimablv.textfield setSecureTextEntry:NO];
        }
    }else if (btn.tag == FEYEBTN2) {//眼睛按钮
        if(btn.selected){
            [_querenMimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
        }else{
            [btn setSelected:YES];
            [_querenMimablv.textfield setSecureTextEntry:NO];
        }
    }else if (btn.tag == FVCODEBTN){//验证码按钮
        if (_phoneblv.textfield.text.length != 13) {
            [TipsView showTips:@"请输入正确格式手机号" inView:self.view];
        }else{
            btn.userInteractionEnabled = NO;
            [btn setBackgroundColor:LINECOLOR];
            [[DataFactory sharedDataFactory]getVcodeWithMobile:[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] andCallback:^(ActionResult *result) {
                if (result.success) {
                    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:btn repeats:YES];
                }else{
                    btn.userInteractionEnabled = YES;
                }
            }];
        }
    }else if(btn.tag == FRESETBTN){//重置密码按钮
            if (_phoneblv.textfield.text.length<=0) {
                [TipsView showTips:@"请输入手机号" inView:self.view];
            }else if (_phoneblv.textfield.text.length<13){
                [TipsView showTips:@"请输入正确手机号" inView:self.view];
            }else if (_yanzhengblv.textfield.text.length<=0) {
                [TipsView showTips:@"请输入验证码" inView:self.view];
            }else if (_yanzhengblv.textfield.text.length<6){
                [TipsView showTips:@"请输入正确验证码" inView:self.view];
            }else if (_mimablv.textfield.text.length<=0) {
                [TipsView showTips:@"请输入新密码" inView:self.view];
            }else if (![_querenMimablv.textfield.text isEqualToString:_mimablv.textfield.text]){
                [TipsView showTips:@"密码不一致请重新输入" inView:self.view];
            }else if (![_mimablv.textfield.text isLegal]){
                [TipsView showTips:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];
            }else if (_querenMimablv.textfield.text.length<=0) {
                [TipsView showTips:@"请再次输入新密码" inView:self.view];
            }else if (![_querenMimablv.textfield.text isLegal]){
                [TipsView showTips:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];
            }else{
                if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                    UIImageView *loading = [self setRotationAnimationWithView];
                    [[DataFactory sharedDataFactory]forgetPasswordWtihMobile:[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] andVcode:_yanzhengblv.textfield.text andNewPassword:_mimablv.textfield.text andCallback:^(ActionResult *result) {
                        if (result.success) {
                            [TipsView showTipsCantClick:@"找回密码成功" inView:self.view];
                            [self removeRotationAnimationView:loading];
                            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findedPopToLoginVC) userInfo:nil repeats:NO];
                        }else{
                            [TipsView showTipsCantClick:result.message inView:self.view];
                            [self removeRotationAnimationView:loading];
                        }
                    }];
                }
            }
    }
}
-(void)findedPopToLoginVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//获取验证码倒计时
-(void)countDown:(NSTimer *)timer{
    -- count;
    UIButton *btn = (UIButton *)timer.userInfo;
    if (count<=0) {
        btn.titleLabel.numberOfLines =1;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#5cc7ff"]];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        btn.userInteractionEnabled = YES;
        count = 60;
    }else{
        btn.titleLabel.numberOfLines =0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:[NSString stringWithFormat:@"重新发送\n(%ds)", count] forState:UIControlStateNormal];
    }
    
}

@end
