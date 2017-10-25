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
#import "Tool.h"
#import "IQKeyboardManager.h"
#import "DataFactory+User.h"
#import "JPUSHService.h"

@interface LoginViewController (){
    UIView *whiteBg;
    PhoneTextField *phoneTF;
    UITextField *passTF;
    BOOL isClick;
    int _currentTag;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text= @"登录";
    self.navigationBar.leftBarButton.hidden = YES;
    self.popGestureRecognizerEnable = NO;
    
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    
    [self createUI];

}

- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

-(void)createUI{

    whiteBg =[[UIView alloc]init];
    [whiteBg setBackgroundColor:[UIColor whiteColor]];
    [whiteBg setFrame:CGRectMake(0, kFrame_Height(self.navigationBar)+0.5, kMainScreenWidth, 100)];
    [self.view addSubview:whiteBg];
    
    UIImageView *phonicon= [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 22, 22)];
    [phonicon setImage:[UIImage imageNamed:@"iconfont-shouji-3"]];
    [whiteBg addSubview:phonicon];
    
    
    phoneTF =[[PhoneTextField alloc]init];
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.keyboardType =UIKeyboardTypePhonePad;
    phoneTF.needBlank = YES;
    [phoneTF setFrame:CGRectMake(kFrame_XWidth(phonicon)+20, 0.5, kMainScreenWidth-77,48)];
    phoneTF.placeholder = @"请输入手机号";
    [phoneTF setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    [phoneTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    phoneTF.textColor = NAVIGATIONTITLE;
    phoneTF.font = [UIFont systemFontOfSize:15];
    [phoneTF setTag:3000];
    [phoneTF setDelegate:self];
    [phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (![self isBlankString:[Tool getCache:@"user_account"] ]) {
        
        phoneTF.text = [self getPhoneString:[Tool getCache:@"user_account"]];
    }

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
    [self canBecomeFirstResponder];
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
    [loginBtn setBackgroundColor:BLUEBTBCOLOR];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    loginBtn.layer.cornerRadius = 4.0;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTag:1000];
    [loginBtn addTarget:self action:@selector(allBtnClickedActions:) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark -按钮点击事件
-(void)allBtnClickedActions:(UIButton *)btn {
    [phoneTF resignFirstResponder];
    [passTF resignFirstResponder];
    btn.userInteractionEnabled = NO;
    isClick = YES;
    if (btn.tag == 1000) {//登录
        if (phoneTF.text.length<=0) {
//            NSString* regID = [JPUSHService registrationID];
            [TipsView showTips:@"请输入手机号" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else if (phoneTF.text.length<13){
            
            [TipsView showTips:@"请输入正确格式手机号" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else if (passTF.text.length<=0) {
            [TipsView showTips:@"请输入密码" inView:self.view];
            btn.userInteractionEnabled = YES;

        }else if (passTF.text.length<6){
            [TipsView showTips:@"请输入6到20位的密码" inView:self.view];
            btn.userInteractionEnabled = YES;
            
        }else{
            if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
                UIImageView *loading = [self setRotationAnimationWithView];
                [[DataFactory sharedDataFactory] loginWtihMobile:[phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] andPassword:passTF.text andCallback:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{//add by wangzz 160809
                        if (result.success) {
                            
                            if (result.message.length==0) {
                                result.message = @"登录成功";
                            }
                            [TipsView showTipsCantClick:result.message inView:self.view];
                            //检测版本升级
                            [self.appDelegate performSelector:@selector(checkVersionUpdate)];
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"SELECTEDHOMEPAGE" object:self];
//                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];

                            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popView) userInfo:nil repeats:NO];
                            [self removeRotationAnimationView:loading];

                        }else{
                            if(result.code==0)
                                result.message =@"登录失败!";
                            [TipsView showTipsCantClick:result.message inView:self.view];
                            [self removeRotationAnimationView:loading];
                        }
                    });
                }];

            }
            btn.userInteractionEnabled = YES;

        }
        
    }else if (btn.tag == 1001){//注册
        RegisterViewController *regist=[[RegisterViewController alloc]init];
        [self.navigationController pushViewController:regist animated:YES];
        btn.userInteractionEnabled = YES;

    }else if(btn.tag == 1002){//忘记密码
        FindViewController *fin =[[FindViewController alloc]init];
        [self.navigationController pushViewController:fin animated:YES];
        btn.userInteractionEnabled = YES;

    }else if(btn.tag == 1003){//眼睛
        if(btn.selected){
            [passTF setSecureTextEntry:YES];
            [btn setSelected:NO];
            btn.userInteractionEnabled = YES;

        }else{
            [btn setSelected:YES];
            [passTF setSecureTextEntry:NO];
            btn.userInteractionEnabled = YES;

        
        }
    }


}
-(NSString *)getPhoneString:(NSString *)phone{

    NSString *phoneStr =[[NSString alloc]init];
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < phone.length; i ++) {
        NSRange range;
        range.location = i;
        range.length = 1;
        NSString *tempString = [phone substringWithRange:range];
        [stringArray appendObject:tempString];
        switch (i) {
            case 2:
                [stringArray appendObject:@" "];
                break;
            case 6:
                [stringArray appendObject:@" "];

                break;
            
            default:
                break;
        }
    }
    phoneStr = [stringArray componentsJoinedByString:@""];
    return phoneStr;
}
-(void)popView{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    if (textField.tag ==3000 ) {
       
    }else if(textField.tag == 3001){
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    return [textField resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (!isClick) {
//        if (textField.tag == 3000) {
//            
//            if (textField.text.length<=0) {
//                
//                [TipsView showTips:@"请输入手机号" inView:self.view];
//            }else if (textField.text.length<13){
//                
//                [TipsView showTips:@"请输入正确格式手机号" inView:self.view];
//                
//            }
//        }else if (textField.tag == 3001){
//            if (textField.text.length<=0) {
//                [TipsView showTips:@"请输入密码" inView:self.view];
//            }else if (textField.text.length<6){
//                [TipsView showTips:@"请输入6到20位的密码" inView:self.view];
//                
//            }
//            
//        }
//
//    }
   }

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 3000) {
        _currentTag = 3000;
    }else{
        _currentTag = 3001;
    }

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
}
#pragma mark -设置手机号码的格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag ==3000) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                return NO;
            }
            else{
                return YES;
            }
        }
        else if(string.length >0){
           //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
                
                 [self showTips:@"请输入11位手机号"];
                return NO;
            }
//            判断是否是纯数字
            if(![self validateNumber:string]){
                return NO;
            }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
    }
   
    return YES;

}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

-(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
//手机号字符串格式化
- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >2) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 7) {
        [mStr insertString:@" " atIndex:8];
        
    }
    
    return  mStr;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
        IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
        mage.enable = NO;
        mage.shouldResignOnTouchOutside = NO;
        mage.shouldToolbarUsesTextFieldTintColor = NO;
        mage.enableAutoToolbar = NO;
        
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
