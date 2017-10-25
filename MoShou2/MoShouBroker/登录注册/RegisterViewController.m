//
//  RegisterViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "RegisterViewController.h"
#import "HMTool.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController{
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
    self.navigationBar.titleLabel.text = @"注册";
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
    [yanzhengBtn setTag:VCODEBTN];
    yanzhengBtn.layer.masksToBounds = YES;
    [backview addSubview:yanzhengBtn];
    

    
    
    _mimablv=[[BlueLineView alloc]initWithFrame:CGRectMake(0,kFrame_YHeight(yanzhengblv),kMainScreenWidth, 50)  andIconImage:[UIImage imageNamed:@"iconfont-mima"]  andPlaceholder:@"请设置新密码" andTextFieldStyle:BLVPASSWORD andLineSyle:BLVALLVIEW];
    _mimablv.userInteractionEnabled =YES;
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
    
}
-(void)agreementLabelTap{
    
    NSLog(@"用户协议");
    
}
-(void)textFieldDidChange:(UITextField *)textField{
    
    NSLog(@"jsjsjsjsjsjsjsjsj%@", [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
}
-(void)allBtnClickActions:(UIButton *)btn{
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
        [btn setBackgroundColor:LINECOLOR];
        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:btn repeats:YES];
    }else if(btn.tag == REGISTERBTN){
    
    
    }
    

}
-(void)countDown:(NSTimer *)timer{
    -- count;
    UIButton *btn = (UIButton *)timer.userInfo;
   //           [btn setTitle:[NSString stringWithFormat:@"重新发送\n(%ds)", count] forState:UIControlStateNormal];
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
