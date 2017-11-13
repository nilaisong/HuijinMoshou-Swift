//
//  FindViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "FindViewController.h"

@implementation FindViewController{
    BlueLineView *_mimablv;
    NSTimer *_timer;
    int count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
-(void)createUI{
    count = 60;
    self.navigationBar.titleLabel.text = @"忘记密码";
    UIView *backview =[[UIView alloc]init];
    [backview setBackgroundColor:[UIColor whiteColor]];
    [backview setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 150)];
    backview.userInteractionEnabled =YES;
    
    [self.view addSubview:backview];
    
    BlueLineView *phoneblv = [[BlueLineView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, 50) andIconImage:[UIImage imageNamed:@"iconfont-shouji-3"]  andPlaceholder:@"请输入手机号" andTextFieldStyle:BLVPHONE andLineSyle:BLVSPACEVIEW];
    phoneblv.userInteractionEnabled =YES;
    [phoneblv setDelegate:self];
    [backview addSubview:phoneblv];
    BlueLineView *yanzhengblv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_Height(phoneblv), kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-yanzhengma-3"]  andPlaceholder:@"验证码" andTextFieldStyle:BLVVCODE andLineSyle:BLVSPACEVIEW];
    yanzhengblv.userInteractionEnabled =YES;
    [yanzhengblv setDelegate:self];
    [backview addSubview:yanzhengblv];
    
    UIButton *yanzhengBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-25-88,kFrame_Y(yanzhengblv)+(25-38/2), 88, 38)];
    [yanzhengBtn setBackgroundColor:[UIColor colorWithHexString:@"#5cc7ff"]];
    [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    yanzhengBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    yanzhengBtn.layer.cornerRadius = 4;
    yanzhengBtn.layer.masksToBounds = YES;
    [yanzhengBtn setTag:FVCODEBTN];
    [backview addSubview:yanzhengBtn];
    
    
    
    _mimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(yanzhengblv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请设置新密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _mimablv.userInteractionEnabled =YES;
    [_mimablv setDelegate:self];
    [backview addSubview:_mimablv];
    
    
    UIButton *eyeBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_Width(backview)-25-22, kFrame_Y(_mimablv)+(25-11), 22, 22)];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-biyan-2"] forState:UIControlStateNormal];
    [eyeBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-yanjing"] forState:UIControlStateSelected];
    [_mimablv.textfield setSecureTextEntry:YES];
    [eyeBtn setTag:FEYEBTN];
    [backview addSubview:eyeBtn];
    
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
    [bigBtn addTarget:self action:@selector(allBtnClickActions:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)textFieldDidChange:(UITextField *)textField{
    
    NSLog(@"jsjsjsjsjsjsjsjsj%@", [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
}
-(void)allBtnClickActions:(UIButton *)btn{
    
    if (btn.tag == FEYEBTN) {
        if(btn.selected){
            [_mimablv.textfield setSecureTextEntry:YES];
            [btn setSelected:NO];
            
        }else{
            [btn setSelected:YES];
            [_mimablv.textfield setSecureTextEntry:NO];
            
            
        }
        
    }else if (btn.tag == FVCODEBTN){
        btn.userInteractionEnabled = NO;
        [btn setBackgroundColor:LINECOLOR];
        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:btn repeats:YES];
    }else if(btn.tag == FRESETBTN){
        
        
    }
    
    
    
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

@end
