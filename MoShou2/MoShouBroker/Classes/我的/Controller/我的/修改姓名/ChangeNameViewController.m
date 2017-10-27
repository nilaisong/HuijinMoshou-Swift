//
//  ChangeNameViewController.m
//  MoShouQueke
//
//  Created by Aminly on 15/10/27.
//  Copyright © 2015年  5i5j. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "DataFactory+User.h"
#import "HMTool.h"
#import "UserData.h"
@interface ChangeNameViewController (){
    UIButton *saveBtn;
}

@end

@implementation ChangeNameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"修改姓名";

    [self createUI];
}
-(void)createUI{
    UIView *textbg = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, kMainScreenWidth, 40)];
    [self.view addSubview:textbg];
    [textbg setBackgroundColor:[UIColor whiteColor]];
    
    nameTF =[[UITextField alloc]initWithFrame:CGRectMake(16, 0, kMainScreenWidth-16, 40)];
    [textbg addSubview:nameTF];
    nameTF.placeholder = @"请输入姓名";
    nameTF.delegate = self;
    nameTF.font =[UIFont systemFontOfSize:16];
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.textColor=NAVIGATIONTITLE;
    [nameTF setBackgroundColor:[UIColor whiteColor]];
    if (![self isBlankString:[UserData sharedUserData].userInfo.userName]) {
//        nameTF.placeholder = @"请输入姓名";
//    }else{
//        nameTF.placeholder = [UserData sharedUserData].userName;
        nameTF.text = [UserData sharedUserData].userInfo.userName;
    }
    
    [nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    UIView *line2 =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(textbg)+1, kMainScreenWidth,0.5) andColor:LINECOLOR];
    [self.view addSubview:line2];
    
    saveBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-40, kFrame_Y(self.navigationBar.leftBarButton)+10,50,30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [saveBtn setTitleColor:LINECOLOR forState:UIControlStateHighlighted];
    
    saveBtn.highlighted = YES;
    saveBtn.enabled = NO;
    
    saveBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [saveBtn addTarget:self action:@selector(saveName) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:saveBtn];
}
-(void)saveName{
    if (saveBtn.enabled == NO) {
        return;
    }
    
    saveBtn.userInteractionEnabled = NO;
//    if ([self adjusStrHasNumber:nameTF.text]||![self isChinese:nameTF.text]) {
//        [TipsView showTips:@"请输入真实姓名" inView:self.view];
//        saveBtn.userInteractionEnabled = YES;
//
//    }else{
    
        if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        
            UIImageView *loading =[self setRotationAnimationWithView];
        
            [[DataFactory sharedDataFactory]changeNameWithName:nameTF.text andCallback:^(ActionResult *result) {
                dispatch_async(dispatch_get_main_queue(),^{
 
            if (result.success) {
                
                [nameTF resignFirstResponder];
                [TipsView showTipsCantClick:@"保存成功" inView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONINFO" object:self];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popPersonView) userInfo:nil repeats:NO];
                [self removeRotationAnimationView:loading];
                
                saveBtn.enabled = NO;
                saveBtn.highlighted = YES;
                saveBtn.userInteractionEnabled = YES;
            }else{
                [TipsView showTipsCantClick:result.message inView:self.view];
                [self removeRotationAnimationView:loading];
                saveBtn.userInteractionEnabled = YES;


            }
                });
        }];

        }
    
//    }
  
}
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length>0) {
        saveBtn.highlighted = NO;
        saveBtn.enabled = YES;
    }else{
        saveBtn.highlighted = YES;
        saveBtn.enabled = NO;
    }
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
            [textField resignFirstResponder];
//            [TipsView showTips:@"姓名不能超过15位" inView:self.view];
        }
    
}
-(void)popPersonView{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)adjusStrHasNumber:(NSString *)str{
    
    if(([str rangeOfString:@"0"].location !=NSNotFound)||([str rangeOfString:@"1"].location !=NSNotFound)||([str rangeOfString:@"2"].location !=NSNotFound)||([str rangeOfString:@"3"].location !=NSNotFound)||([str rangeOfString:@"4"].location !=NSNotFound)||([str rangeOfString:@"5"].location !=NSNotFound)||([str rangeOfString:@"6"].location !=NSNotFound)||([str rangeOfString:@"7"].location !=NSNotFound)||([str rangeOfString:@"8"].location !=NSNotFound)||([str rangeOfString:@"9"].location !=NSNotFound)){
        return true;
        
    }
    return false;
}



////判断字符串是否纯中文
-(BOOL)isChinese:(NSString*)str{

        
        for (int i=0; i<str.length;i++){
             
             NSRange range=NSMakeRange(i,1);
             
             NSString *subString=[str substringWithRange:range];
             
             const char *cString=[subString UTF8String];
             
             if (strlen(cString)==3){

            
            if(str.length<2||str.length>15){

                
                return NO;
                
            }
                 return YES;
    
            
        }/*else if(strlen(cString)==1){
            
            NSLog(@"昵称是字母");
            
            if(nameTF.text.length<4||nameTF.text.length>16){

                return NO;
                
            }
        }*/
        
        }
    
    return NO;

    

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
