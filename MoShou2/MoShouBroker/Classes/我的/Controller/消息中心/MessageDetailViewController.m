//
//  MessageDetailViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "HMTool.h"
#import "UILabel+StringFrame.h"
#import "UserData.h"
#import "BaseNavigationController.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
-(void)initUI{
     self.navigationBar.titleLabel.text = @"消息详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *title = [[UILabel alloc]init];
    [title setText:self.data.title];
    [title setFont:[UIFont systemFontOfSize:16]];
    [title setTextColor:NAVIGATIONTITLE];
    CGSize titleSize =[HMTool getTextSizeWithText:title.text andFontSize:16];
    [title setFrame:CGRectMake(16, kFrame_Height(self.navigationBar)+15, titleSize.width, titleSize.height)];
    [self.view addSubview:title];
    
    UILabel *date = [[UILabel alloc]init];
    [date setTextColor:LABELCOLOR];
    [date setFont:[UIFont systemFontOfSize:12]];
    [date setText:self.data.datetime];
    CGSize dataSize =[HMTool getTextSizeWithText:date.text andFontSize:12];
    [date setFrame:CGRectMake(kMainScreenWidth-16-dataSize.width, kFrame_Height(self.navigationBar)+15, dataSize.width, dataSize.height)];
    [self.view addSubview:date];
    UILabel *content =[[UILabel alloc]init];
    [content setText:self.data.content];
    [content autoWithFrame:CGRectMake(kFrame_X(title),kFrame_YHeight(title)+13, kMainScreenWidth-32, 97-(15+titleSize.height+13)) andFontSize:14];
    [content setTextColor:LABELCOLOR];
    [self.view addSubview:content];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)leftBarButtonItemClick{
    [[NSNotificationCenter defaultCenter]postNotificationName:UserUnreadMessageCountNotification object:self];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTableView" object:self];

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)baseNavigationController:(BaseNavigationController*)controller didReturn:(NSString*)className{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UserUnreadMessageCountNotification object:self];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTableView" object:self];
    
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
