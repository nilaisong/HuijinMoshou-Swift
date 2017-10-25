//
//  CommonProblemViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/17.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CommonProblemViewController.h"

@interface CommonProblemViewController (){
    UIWebView *_webView;
}

@end

@implementation CommonProblemViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    PLNavigationBar *nav = [[PLNavigationBar alloc]initWithDelegate:self];
    nav.titleLabel.text = @"常见问题";
    [self.view addSubview:nav];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20+44, kMainScreenWidth, self.view.bounds.size.height-20-44)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:kFullUrlWithSuffix(@"/admin/module/EstateHtml/qalist.html")]];
    [_webView loadRequest:request];
    [self.view addSubview: _webView];
    self.popGestureRecognizerEnable = NO;

}
-(void)leftBarButtonItemClick{
    if (_webView.canGoBack) {
         [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
