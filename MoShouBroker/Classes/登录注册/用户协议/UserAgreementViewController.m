//
//  UserAgreementViewController.m
//  MoShouBroker
//
//  Created by Aminly on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "UserAgreementViewController.h"
#import "MyWebView.h"
@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"用户协议";
    MyWebView *areementWebview =[[MyWebView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20, kMainScreenWidth, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-20)];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"魔售平台经纪人用户协议" ofType:@"docx"];
        NSURLRequest* contentRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:filePath]];
        areementWebview.scalesPageToFit = YES;
        [areementWebview loadRequest:contentRequest];
    [self.view addSubview:areementWebview];
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
