//
//  ChangeSexViewController.m
//  MoShouQueke
//
//  Created by Aminly on 15/11/2.
//  Copyright © 2015年  5i5j. All rights reserved.
//

#import "ChangeSexViewController.h"
#import "DataFactory+User.h"
#import "HMTool.h"
#import "UserData.h"
@interface ChangeSexViewController ()

@end

@implementation ChangeSexViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"选择性别";

    [self createUI];
}
-(void)createUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *manBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+30, kMainScreenWidth, 40)];
    [self.view addSubview:manBtn];
    
    [manBtn setBackgroundColor: [UIColor whiteColor]];
    UILabel *manLB= [[UILabel alloc]init];
    [manLB setText:@"男"];
    [manLB setFont:[UIFont systemFontOfSize:18]];
    [manLB setFrame:CGRectMake(20, 0, 100, 40)];
    [manLB setTextColor:LABELCOLOR];
    [manBtn setTag:1000];
    
    [manBtn addSubview:manLB];
    UIButton *womanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, manBtn.frame.origin.y+manBtn.frame.size.height, kMainScreenWidth, 40)];
    [self.view addSubview:womanBtn];
    [womanBtn setBackgroundColor: [UIColor whiteColor]];
    [womanBtn setTag:1001];
    UILabel *womanLB=[[UILabel alloc]init];
    [womanLB setText:@"女"];
    [womanLB setTextColor:LABELCOLOR];
    
      [womanLB setFont:[UIFont systemFontOfSize:18]];
    [womanLB setFrame:CGRectMake(20, 0, 100, 40)];
    [womanBtn addSubview:womanLB];
    
    UIImageView *manGoubg =[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-30, 10, 17, 17)];
    manGoubg.image =[UIImage imageNamed:@"mine椭圆-2"];
    [manGoubg setTag:1001];
    [manBtn addSubview:manGoubg];
    
    UIImageView *manGou =[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-30, 10, 17, 17)];
    manGou.image =[UIImage imageNamed:@"iconfont-duihao"];
    [manGou setTag:1000];
    [manBtn addSubview:manGou];
    
    
    
    UIImageView *womanGoubg =[[UIImageView alloc ]init];
    [womanGoubg setFrame:CGRectMake(kMainScreenWidth-30, 10, 17, 17)];
    [womanGoubg setTag:1001];
    womanGoubg.image =[UIImage imageNamed:@"mine椭圆-2"];
    
    UIImageView *womanGou =[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-30, 10,17, 17)];
    womanGou.image =[UIImage imageNamed:@"iconfont-duihao"];
    [womanGou setTag:1000];
    
    [womanBtn addSubview:womanGoubg];
    [womanBtn addSubview:womanGou];
    [womanGou setHidden:YES];
    [manGou setHidden:YES];

   
        if ([UserData sharedUserData].userInfo.gender.intValue == 1) {
            _pointBtn = manBtn;
            _userSex = @"1";
            [womanGou setHidden:YES];
            [manGou setHidden:NO];

        }else if([UserData sharedUserData].userInfo.gender.intValue == 0){
            [manGou setHidden:YES];
            [womanGou setHidden:NO];

            _userSex = @"0";
            _pointBtn = womanBtn;
            
        }
        
        
    

    [manBtn addTarget:self action:@selector(sexBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [womanBtn addTarget:self action:@selector(sexBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
   

    UIView *line2 = [HMTool getLineWithFrame:CGRectMake(16, manBtn.frame.origin.y+manBtn.frame.size.height, kMainScreenWidth-32, 0.5) andColor:LINECOLOR];
    [self.view addSubview:line2];
    UIView *line3 = [HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(womanBtn), kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [self.view addSubview:line3];
    
    UIButton *saveBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-40, kFrame_Y(self.navigationBar.leftBarButton)+10,50,30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    saveBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [saveBtn addTarget:self action:@selector(saveSex) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:saveBtn];
}

-(void)saveSex{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView *loading =[self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]changeSexWithSex:_userSex andCallback:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(),^{

            if (result.success) {
                [self removeRotationAnimationView:loading];
                [TipsView showTips:@"保存成功！" inView:self.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONINFO" object:self];
                
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popback) userInfo:nil repeats:NO];
                
            }else{
                [self removeRotationAnimationView:loading];

                [TipsView showTips:result.message inView:self.view];
            }
            });
        }];

    }
    
}
-(void)popback{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)sexBtnClickedAction:(UIButton*)btn{//修改性别
    
    if (_pointBtn) {
        for (UIImageView *label in [_pointBtn subviews]) {
            if (label.tag == 1000) {
                [label setHidden:YES];
            }
        }
        for (UIImageView *label in [btn subviews]) {
            if (label.tag == 1000) {
                [label setHidden:NO];
            }
        }
        
    }else{
        
        for (UIImageView *label in [btn subviews]) {
            if (label.tag == 1000) {
                [label setHidden:NO];
            }
        }
        
    }
    if (btn.tag == 1000) {
        _userSex = @"1";
    }else{
        
        _userSex = @"0";
    }
    _pointBtn = btn;
    
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
