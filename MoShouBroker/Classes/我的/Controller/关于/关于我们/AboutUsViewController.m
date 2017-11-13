//
//  AboutUsViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UILabel+StringFrame.h"
#import "HMTool.h"
#import "UserAgreementViewController.h"
#import "UsingHelpViewController.h"
#import "DataFactory+User.h"
@interface AboutUsViewController (){

    UILabel *desc;
}

@end

@implementation AboutUsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{

    self.navigationBar.titleLabel.text = @"关于";
    UIImageView *logo = [[UIImageView alloc]init];
    [logo setImage:[UIImage imageNamed:@"logo-no"]];
    [logo setFrame:CGRectMake(kMainScreenWidth/2,kFrame_YHeight(self.navigationBar)+80, 82.5, 94)];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.centerX = kMainScreenWidth/2;
    [self.view addSubview:logo];
    UILabel *banben = [[UILabel alloc]initWithPoint:CGPointMake(kMainScreenWidth/2, kFrame_YHeight(logo)+50) andText:[NSString stringWithFormat:@"汇金魔售v%@",kAppVersion ] andFontSize:15];
    [banben setCenter:CGPointMake(kMainScreenWidth/2, kFrame_YHeight(logo)+20)];
    [banben setTextColor:TFPLEASEHOLDERCOLOR];
    [self.view addSubview:banben];
    desc = [[UILabel alloc]initWithPoint:CGPointMake(kMainScreenWidth/2, kFrame_YHeight(banben)+10) andText:@"经纪人的魔法工具" andFontSize:15];
    [desc setCenter:CGPointMake(kMainScreenWidth/2, kFrame_YHeight(banben)+20)];
    [desc setTextColor:TFPLEASEHOLDERCOLOR];
    [self.view addSubview:desc];

    if (self.isNew) {
        
        UIView *line =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(desc)+50, kMainScreenWidth, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line];
        UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(desc)+51, kMainScreenWidth, 50)];
        [btn1 setTag:1000];
        [btn1 addTarget:self action:@selector(aboutAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
        UILabel *title  =[[UILabel alloc]initWithPoint:CGPointMake(16, 16) andText:@"使用帮助" andFontSize:16];
        [title setTextColor:LABELCOLOR];
        [btn1 addSubview:title];
        UIImageView *arr = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-8, 25-6.5, 8, 13)];
        [arr setImage:[UIImage imageNamed:@"arrow-right"]];
        [btn1 addSubview:arr];
        UIView *line2 =[HMTool getLineWithFrame:CGRectMake(16, kFrame_YHeight(btn1), kMainScreenWidth-16, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line2];
        UIButton *btn2 =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(line2)+1, kMainScreenWidth, 50)];
        [self.view addSubview:btn2];
        UILabel *title2  =[[UILabel alloc]initWithPoint:CGPointMake(16, 16) andText:@"用户协议" andFontSize:16];
        [title2 setTextColor:LABELCOLOR];
        [btn2 setTag:1001];
        [btn2 addTarget:self action:@selector(aboutAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addSubview:title2];
        UIImageView *arr1 = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-8, 25-6.5, 8, 13)];
        [arr1 setImage:[UIImage imageNamed:@"arrow-right"]];
        [btn2 addSubview:arr1];
        UIView *line4 =[HMTool getLineWithFrame:CGRectMake(16, kFrame_YHeight(btn2), kMainScreenWidth-16, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line4];
        UIButton *btn3 =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(line4)+1, kMainScreenWidth, 50)];
        [self.view addSubview:btn3];
        UILabel *title3  =[[UILabel alloc]initWithPoint:CGPointMake(16, 16) andText:@"新版本检测" andFontSize:16];
        [title3 setTextColor:LABELCOLOR];
        [btn3 setTag:1002];
        [btn3 addTarget:self action:@selector(aboutAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addSubview:title3];
        UIImageView *arr3 = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-8, 25-6.5, 8, 13)];
        [arr3 setImage:[UIImage imageNamed:@"arrow-right"]];
        [btn3 addSubview:arr3];
        UIView *line3 =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(btn3), kMainScreenWidth, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line3];
    }else{
        UIView *line =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(desc)+50, kMainScreenWidth, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line];
        UIButton *btn2 =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(line)+1, kMainScreenWidth, 50)];
        [self.view addSubview:btn2];
        UILabel *title2  =[[UILabel alloc]initWithPoint:CGPointMake(16, 16) andText:@"使用帮助" andFontSize:16];
        [title2 setTextColor:LABELCOLOR];
        [btn2 setTag:1000];
        [btn2 addTarget:self action:@selector(aboutAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addSubview:title2];
        UIImageView *arr1 = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-8, 25-6.5, 8, 13)];
        [arr1 setImage:[UIImage imageNamed:@"arrow-right"]];
        [btn2 addSubview:arr1];
        UIView *line4 =[HMTool getLineWithFrame:CGRectMake(16, kFrame_YHeight(btn2), kMainScreenWidth-16, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line4];
        UIButton *btn3 =[[UIButton alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(line4)+1, kMainScreenWidth, 50)];
        [self.view addSubview:btn3];
        UILabel *title3  =[[UILabel alloc]initWithPoint:CGPointMake(16, 16) andText:@"用户协议" andFontSize:16];
        [title3 setTextColor:LABELCOLOR];
        [btn3 setTag:1001];
        [btn3 addTarget:self action:@selector(aboutAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addSubview:title3];
        UIImageView *arr3 = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-8, 25-6.5, 8, 13)];
        [arr3 setImage:[UIImage imageNamed:@"arrow-right"]];
        [btn3 addSubview:arr3];
        UIView *line3 =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(btn3), kMainScreenWidth, 0.5) andColor:LINECOLOR];
        [self.view addSubview:line3];
    }

    }

//按钮点击事件
-(void)aboutAllBtnClickedAction:(UIButton *)btn{

    if (btn.tag == 1000 ) {
        [MobClick event:@"wode_sybz"];

        UsingHelpViewController *use = [[UsingHelpViewController alloc]init];
        [self.navigationController pushViewController:use animated:YES];
    
    }else if(btn.tag == 1001){
        
        UserAgreementViewController *u  =[[UserAgreementViewController alloc]init];
        [self.navigationController pushViewController:u animated:YES];
    
    }else if (btn.tag == 1002){
      
        if (self.isNew) {
            [[DataFactory sharedDataFactory] updateVersionWithMessage:self.updateMsg mustUpdate:self.needUpdate newVersion:self.version];
            
        }

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
