//
//  AdShowViewController.m
//  MoShouBroker
//
//  Created by yuanqi on 15/8/4.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "AdShowViewController.h"
#import "PLNavigationBar.h"
#import "MyWebView.h"
#import "ShareActionSheet.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ShareActionSheet.h"

@interface AdShowViewController ()<UIWebViewDelegate>
@property(strong, nonatomic)UIWebView *webView;

@property (nonatomic,weak)ShareActionSheet* shareView;

@end

@implementation AdShowViewController
@synthesize webView = _webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseView];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)createBaseView
{
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255 green:231.0/255 blue:233.0/255 alpha:1];
    //导航条
    PLNavigationBar *nav = [[PLNavigationBar alloc]initWithDelegate:self];
    nav.titleLabel.text = self.name;
    [self.view addSubview:nav];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20+44, kMainScreenWidth, self.view.bounds.size.height-20-44)];
    _webView.scalesPageToFit = YES;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview: _webView];
}

-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (_webView.superview) {
        _webView.frame =CGRectMake(0, 20+44, self.view.bounds.size.width, self.view.bounds.size.height-20-44);
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    __weak typeof(self) weakSelf = self;
    context[@"luanchNativeShare"] = ^() {
        NSArray *args = [JSContext currentArguments];
        ShareModel* model = [[ShareModel alloc] init];
        model.content = @"  ";
        if (args.count == 1) {
            JSValue* value = args.firstObject;
            model.linkUrl = value.toString;
        }else if(args.count == 2){
            JSValue* value1 = args.firstObject;
            JSValue* value2 = args.lastObject;
            model.linkUrl = value1.toString;
            model.title = value2.toString;
        }else if (args.count == 3){
            JSValue* value1 = args.firstObject;
            JSValue* value2 = [args objectForIndex:1];
            JSValue* value3 = args.lastObject;
            model.linkUrl = value1.toString;
            model.title = value2.toString;
            model.content = value3.toString;
        }else if (args.count == 4){
            JSValue* value1 = args.firstObject;
            JSValue* value2 = [args objectForIndex:1];
            JSValue* value3 = [args objectForIndex:2];
            JSValue* value4 = args.lastObject;
            model.linkUrl = value1.toString;
            model.title = value2.toString;
            model.content = value3.toString;
            
            model.img = value4.toString;
        }else{
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf shareWithModel:model];
        });
        
    };
}

- (void)shareWithModel:(ShareModel*)model{
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
    ShareActionSheet* shareView = [[ShareActionSheet alloc]initContentOperateWithShareType:WEBOPERATE andModel:model andParent:self.view];
    _shareView = shareView;
}



#pragma ----btn触发事件
- (void)leftBarButtonItemClick{
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
