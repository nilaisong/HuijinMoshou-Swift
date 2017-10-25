//
//  ChangeEmplyeeNoViewController.m
//  MoShou2
//
//  Created by wangzz on 16/8/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ChangeEmplyeeNoViewController.h"
#import "DataFactory+User.h"
#import "HMTool.h"
#import "UserData.h"

@interface ChangeEmplyeeNoViewController ()<UITextFieldDelegate>
{
    UITextField *nameTF;
    UIButton *saveBtn;
}
@end

@implementation ChangeEmplyeeNoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"修改员工编号";
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}

-(void)createUI{
    UIView *textbg = [[UIView alloc]initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, 40)];
    [self.view addSubview:textbg];
    [textbg setBackgroundColor:[UIColor whiteColor]];
    
    nameTF =[[UITextField alloc]initWithFrame:CGRectMake(16, 0, kMainScreenWidth-16, 40)];
    [textbg addSubview:nameTF];
    nameTF.placeholder = @"请输入你的员工编号";
    nameTF.delegate = self;
    nameTF.font =[UIFont systemFontOfSize:16];
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.textColor=NAVIGATIONTITLE;
    [nameTF setBackgroundColor:[UIColor whiteColor]];
    if (![self isBlankString:[UserData sharedUserData].employeeNo]) {
//        nameTF.placeholder = @"请输入你的员工编号";
//    }else{
//        nameTF.placeholder = [UserData sharedUserData].userName;
        nameTF.text = [UserData sharedUserData].employeeNo;
    }
    
    [nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *line2 =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(textbg)+1, kMainScreenWidth,0.5) andColor:LINECOLOR];
    [self.view addSubview:line2];
    
    saveBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-40, kFrame_Y(self.navigationBar.leftBarButton)+10,50,30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//    [saveBtn setTitleColor:LINECOLOR forState:UIControlStateHighlighted];
    
//    if ([UserData sharedUserData].limitEmployeeNo) {
//        saveBtn.highlighted = YES;
//        saveBtn.enabled = NO;
//    }
    
    saveBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [saveBtn addTarget:self action:@selector(saveName) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:saveBtn];
}
-(void)saveName{
    if (saveBtn.enabled == NO) {
        return;
    }
    
    saveBtn.userInteractionEnabled = NO;
    NSString *employee = [UserData sharedUserData].employeeNo;
    if (![self isBlankString:employee] && [nameTF.text isEqualToString:employee]) {
        [TipsView showTips:@"你没有进行任何修改。" inView:self.view];
        saveBtn.userInteractionEnabled = YES;
        
    }else{
        
        if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
            UIImageView *loading =[self setRotationAnimationWithView];
            [[DataFactory sharedDataFactory]changEmpoyeeNo:nameTF.text andCallback:^(ActionResult *result) {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    if (result.success ) {
                        [self removeRotationAnimationView:loading];
                        [TipsView showTips:result.message inView:self.view];
                        [saveBtn setEnabled:NO];
                        nameTF.enabled = NO;
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONSHOP" object:self];
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINETABLEVIEW" object:self];
                        
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackAction) userInfo:nil repeats:NO];
                        
                    }else{
                        [self removeRotationAnimationView:loading];
                        
                        [TipsView showTips:result.message inView:self.view];
                    }
                });
                
            }];
            saveBtn.userInteractionEnabled = YES;
        }
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

-(void)textFieldDidChange:(UITextField *)textField{
//    if ([UserData sharedUserData].limitEmployeeNo) {
//        if (textField.text.length>0) {
//            saveBtn.highlighted = NO;
//            saveBtn.enabled = YES;
//        }else{
//            saveBtn.highlighted = YES;
//            saveBtn.enabled = NO;
//        }
//    }else
//    {
//        saveBtn.highlighted = NO;
//        saveBtn.enabled = YES;
//    }
    if (textField.text.length >= 18) {
        textField.text = [textField.text substringToIndex:18];
        [textField resignFirstResponder];
    }
    
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
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
