//
//  ChangeMobileViewController.m
//  MoShouQueke
//
//  Created by Aminly on 15/11/2.
//  Copyright © 2015年  5i5j. All rights reserved.
//

#import "ChangeMobileViewController.h"
//#import "MyLabelView.h"
#import "NSString+Extension.h"
#import "DataFactory+User.h"
#import "HMTool.h"
#import "LoginViewController.h"
#import "UserData.h"

@interface ChangeMobileViewController (){

    BlueLineView *_mimablv;
    BlueLineView *_phoneblv;
    BlueLineView *_yanzhengblv;
    NSTimer *_timer;
    int count;
}

@end

@implementation ChangeMobileViewController

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
    self.navigationBar.titleLabel.text = @"手机修改";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *tip = [[UILabel alloc]init];
    [tip setText:[NSString stringWithFormat:@"您当前手机号为：%@",[UserData sharedUserData].mobile]];
    CGSize tipsize = [HMTool getTextSizeWithText:tip.text andFontSize:14];
    [tip setFrame: CGRectMake(kMainScreenWidth/2- tipsize.width/2,kFrame_YHeight(self.navigationBar)+15, tipsize.width, tipsize.height)];
    [tip setFont:[UIFont systemFontOfSize:14]];
    tip.textColor = TFPLEASEHOLDERCOLOR;
    [self.view addSubview:tip];
    
    UIView *backview =[[UIView alloc]init];
    [backview setBackgroundColor:[UIColor whiteColor]];
    [backview setFrame:CGRectMake(0, kFrame_YHeight(tip)+13, kMainScreenWidth, 100)];
    backview.userInteractionEnabled =YES;
    [self.view addSubview:backview];
    
    _phoneblv =[[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50) andIconImage:[UIImage imageNamed:@"iconfont-shouji-3"]  andPlaceholder:@"请输入新手机号" andTextFieldStyle:BLVPHONE andLineSyle:BLVSPACEVIEW];
    [_phoneblv.textfield setTag:3000];
 
//    [[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50) andIconImage:[UIImage imageNamed:@"iconfont-shouji-3"]  andPlaceholder:@"请输入手机号" andTextFieldStyle:BLVPHONE andLineSyle:BLVSPACEVIEW];
    _phoneblv.userInteractionEnabled =YES;
    [_phoneblv setTag:3000];
    [_phoneblv setDelegate:self];
//    _phoneblv.textfield.placeholder = [self getPhoneString:[UserData sharedUserData].mobile];
    [backview addSubview:_phoneblv];
    
    UIView *linet =[HMTool getLineWithFrame:CGRectMake(0, kFrame_Y(_phoneblv), kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [backview addSubview:linet];
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
    [yanzhengBtn setTag:CVCODEBTN];
    [backview addSubview:yanzhengBtn];
    
    UIButton *bigBtn =[[UIButton alloc]init];
    bigBtn.frame = CGRectMake(kMainScreenWidth/2-(kMainScreenWidth-20)/2, kFrame_YHeight(backview)+40,kMainScreenWidth-20, 50);
    [bigBtn setBackgroundColor:BLUEBTBCOLOR];
    [bigBtn setTitle:@"保存" forState:UIControlStateNormal];
    [bigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bigBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    bigBtn.layer.cornerRadius = 4.0;
    bigBtn.layer.masksToBounds = YES;
    [bigBtn setTag:CRESETBTN];
    [self.view addSubview:bigBtn];
    [yanzhengBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
//    [eyeBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
    [bigBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
}
-(NSString *)getPhoneString:(NSString *)phone{
    NSString *string = [phone substringWithRange:NSMakeRange(0,3)];
    NSString *string1 = [phone substringWithRange:NSMakeRange(3,4)];
    NSString *string2 = [phone substringWithRange:NSMakeRange(7,4)];
    
    NSString *phoneStr =[NSString stringWithFormat:@"%@ %@ %@",string,string1,string2];
    return phoneStr;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    NSLog(@"ziziziziz%@---%zd",textField.text,textField.tag);
//    if (textField.tag == 3000) {
//        if (textField.text.length<=0) {
//            [TipsView showTips:@"请输入手机号" inView:self.view];
//        }else if (textField.text.length<13){
//            [TipsView showTips:@"请输入正确格式手机号" inView:self.view];
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
//    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if(textField.tag == 3001){
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            [textField resignFirstResponder];
        }
    }
    
}
-(void)allBtnClickActions:(UIButton *)btn{
    
    if (btn.tag == CEYEBTN) {
        if(btn.selected){
            [_mimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
            
        }else{
            [btn setSelected:YES];
            [_mimablv.textfield setSecureTextEntry:NO];
            
            
        }
        
    }else if (btn.tag == CVCODEBTN){
        btn.userInteractionEnabled = NO;
        if (_phoneblv.textfield.text.length>=13) {
            [[DataFactory sharedDataFactory]getVcodeWithMobile:[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] andCallback:^(ActionResult *result) {
                if (result.success) {
                    [btn setBackgroundColor:LINECOLOR];

                    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:btn repeats:YES];
                    
                }else{
                    btn.userInteractionEnabled = YES;
                    [btn setBackgroundColor:BLUEBTBCOLOR];
                    [TipsView showTipsCantClick:result.message inView:self.view];
                }
            }];

        }else{
            btn.userInteractionEnabled = YES;

            [TipsView showTipsCantClick:@"请输入手机号" inView:self.view];

        }
        
    }else if(btn.tag == CRESETBTN){
            if (_phoneblv.textfield.text.length<=0) {
                [TipsView showTipsCantClick:@"请输入手机号" inView:self.view];
            }else if (_phoneblv.textfield.text.length<13){
                [TipsView showTipsCantClick:@"请输入正确手机号" inView:self.view];
                
            }else if (_yanzhengblv.textfield.text.length<=0) {
                [TipsView showTipsCantClick:@"请输入验证码" inView:self.view];
            }else if (_yanzhengblv.textfield.text.length<6){
                [TipsView showTipsCantClick:@"请输入正确验证码" inView:self.view];
                
            }else{
                if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                    UIImageView *loading =[self setRotationAnimationWithView];
                    [[DataFactory sharedDataFactory]changMobileWithMobile:[_phoneblv.textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""] andVcode:_yanzhengblv.textfield.text andCallback:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(),^{

                        if (result.success) {
                            [self removeRotationAnimationView:loading];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONINFO" object:self];
                            [TipsView showTipsCantClick:@"修改成功" inView:self.view];
                            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(backAction) userInfo:nil repeats:NO];
                        }else{
                            [self removeRotationAnimationView:loading];

                            [TipsView showTipsCantClick:result.message inView:self.view];
                        }
                        });
                    }];

                }
            }
    }
}
-(void)backAction{

    [self.navigationController popViewControllerAnimated:YES];

}
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
