//
//  RegisterViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//
#import "RegisterViewController.h"
#import "HMTool.h"
#import "DataFactory+User.h"
#import "UserAgreementViewController.h"
#import "NSString+PasswordVertify.h"
#import "NSString+Extension.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController{
    BlueLineView *_mimablv;
    NSTimer *_timer;
    int count;
    BlueLineView *phoneblv;
    BlueLineView *yanzhengblv;
    
    UILabel* _tipsLabel;
    BOOL isclick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
-(void)createUI{
    count = 60;
    isclick  = NO;
    self.navigationBar.titleLabel.text = @"注册";
    UIView *backview =[[UIView alloc]init];
    [backview setBackgroundColor:[UIColor whiteColor]];
    [backview setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 150)];
    backview.userInteractionEnabled =YES;
    [self.view addSubview:backview];

    phoneblv = [[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50) andIconImage:[UIImage imageNamed:@"iconfont-shouji-3"]  andPlaceholder:@"请输入手机号" andTextFieldStyle:BLVPHONE andLineSyle:BLVSPACEVIEW];
    phoneblv.userInteractionEnabled =YES;
    [phoneblv.textfield setTag:3000];
    [phoneblv.textfield becomeFirstResponder];
    [phoneblv setDelegate:self];
    [backview addSubview:phoneblv];
    
     yanzhengblv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_Height(phoneblv), kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-yanzhengma-3"]  andPlaceholder:@"验证码" andTextFieldStyle:BLVVCODE andLineSyle:BLVSPACEVIEW];
    [yanzhengblv.textfield setTag:3001];

    yanzhengblv.userInteractionEnabled =YES;
    [yanzhengblv setDelegate:self];
    [backview addSubview:yanzhengblv];
    
    UIButton *yanzhengBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-25-88,kFrame_Y(yanzhengblv)+(25-38/2), 88, 38)];
    [yanzhengBtn setBackgroundColor:[UIColor colorWithHexString:@"#5cc7ff"]];
    [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    yanzhengBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    yanzhengBtn.layer.cornerRadius = 4;
    [yanzhengBtn setTag:VCODEBTN];
    yanzhengBtn.layer.masksToBounds = YES;
    [backview addSubview:yanzhengBtn];
    

    
    
    _mimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(yanzhengblv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请设置密码（6到20个数字或字母）" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _mimablv.userInteractionEnabled =YES;
    [_mimablv.textfield setTag:3002];
    if (iPhone4) {
        [_mimablv.textfield setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];

    }

    [_mimablv setDelegate:self];
    [backview addSubview:_mimablv];

    
    UIButton *eyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_mimablv)+(25-11), 22, 22)];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_mimablv.textfield setSecureTextEntry:YES];
    [eyeBtn setTag:EYEBTN];
    [eyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:eyeBtn];

    UIButton *bigBtn =[[UIButton alloc]init];
    bigBtn.frame = CGRectMake(kMainScreenWidth/2-(kMainScreenWidth-20)/2, kFrame_YHeight(backview)+40,kMainScreenWidth-20, 50);
    [bigBtn setBackgroundColor:BLUEBTBCOLOR];
    [bigBtn setTitle:@"注册" forState:UIControlStateNormal];
    [bigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bigBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    bigBtn.layer.cornerRadius = 4.0;
    bigBtn.layer.masksToBounds = YES;
    [bigBtn setTag:REGISTERBTN];
    [self.view addSubview:bigBtn];
    UILabel *tipLabel  =[[UILabel alloc]init];
    [tipLabel setTextColor:TFPLEASEHOLDERCOLOR];
    [tipLabel setFont:[UIFont systemFontOfSize:15]];
    [tipLabel setText:@"注册即视为同意"];
    CGSize size = [HMTool getTextSizeWithText:tipLabel.text andFontSize:15];
    [tipLabel setFrame:CGRectMake(10, kFrame_YHeight(bigBtn)+20, size.width, size.height)];
    [self.view addSubview:tipLabel];
    
    UILabel *agreemrnt = [[UILabel alloc]init];
    [agreemrnt setTextColor:BLUEBTBCOLOR];
    [agreemrnt setFont:[UIFont systemFontOfSize:15]];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"用户协议"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    agreemrnt.attributedText = content;
    CGSize agreemrntSize = [HMTool getTextSizeWithText:@"用户协议" andFontSize:15];
    [agreemrnt setFrame:CGRectMake(kFrame_XWidth(tipLabel)+1, kFrame_Y(tipLabel), agreemrntSize.width, agreemrntSize.height+2)];
    [self.view addSubview:agreemrnt];
    agreemrnt.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreementLabelTap)];
    [agreemrnt addGestureRecognizer:tap];

    [yanzhengBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
     [eyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
     [bigBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    
    //温馨提示
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.text = @"温馨提示：建议使用数字、字母和符号两种及以上的组合，6-20个字符";
    _tipsLabel.font = [UIFont systemFontOfSize:16];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textColor = [UIColor colorWithHexString:@"888888"];
    CGSize tipSize = [_tipsLabel.text sizeWithfont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(kMainScreenWidth - 20, MAXFLOAT)];
    _tipsLabel.frame = CGRectMake(10, CGRectGetMaxY(agreemrnt.frame) + 10 * SCALE6, kMainScreenWidth - 20, tipSize.height);
    [self.view addSubview:_tipsLabel];
    
}
-(void)agreementLabelTap{
    
    UserAgreementViewController *us =[[UserAgreementViewController alloc]init];
    [self.navigationController pushViewController:us animated:YES];
    
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
    }
    
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

//按钮点击事件
-(void)allBtnClickActions:(UIButton *)btn{
    isclick = YES;
    if (btn.tag == EYEBTN) {
        if(btn.selected){
            [_mimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
            
        }else{
            [btn setSelected:YES];
            [_mimablv.textfield setSecureTextEntry:NO];
        }

    }else if (btn.tag == VCODEBTN){
        btn.userInteractionEnabled = NO;
        if (phoneblv.textfield.text.length<=0){
            [TipsView showTips:@"请输入手机号" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else if (phoneblv.textfield.text.length>0&&phoneblv.textfield.text.length<13){
            [TipsView showTips:@"请输入正确手机号" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else{
            [[DataFactory sharedDataFactory]getVcodeWithMobile:[phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] andCallback:^(ActionResult *result) {
                if (result.success) {
                    [btn setBackgroundColor:LINECOLOR];
                    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:btn repeats:YES];
                }else{
                    btn.userInteractionEnabled = YES;
                    [TipsView showTips:result.message inView:self.view];
                }
            }];

        }
    }else if(btn.tag == REGISTERBTN){
        btn.userInteractionEnabled = NO;

        if (phoneblv.textfield.text.length<=0){
            
            [TipsView showTipsCantClick:@"请输入手机号" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else if (yanzhengblv.textfield.text.length<=0){
            
            [TipsView showTipsCantClick:@"请输入验证码" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else if(![_mimablv.textfield.text isLegal]){
//            [TipsView showTipsCantClick:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];
            [TipsView showTips:@"密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符" inView:self.view];

            btn.userInteractionEnabled = YES;
        }else{
            if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                UIImageView *loading = [self setRotationAnimationWithView];
            [[DataFactory sharedDataFactory]registerWtihMobile:[phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] password:_mimablv.textfield.text andVcode:yanzhengblv.textfield.text andCallback:^(ActionResult *result) {
                if (result.success) {
                    [self removeRotationAnimationView:loading];
                    [TipsView showTipsCantClick:@"注册成功" inView:self.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SELECTEDHOMEPAGE" object:self];//tabbar显示为首页
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popView) userInfo:nil repeats:NO];
                }else{
                    [self removeRotationAnimationView:loading];

                    [TipsView showTipsCantClick:result.message inView:self.view];
                    btn.userInteractionEnabled = YES;

                }
                
            }];
            }

        
        }

        
    
    }
    

}
-(void)popView{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//倒计时
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
