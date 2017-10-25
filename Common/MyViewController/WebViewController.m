//
//  WebViewController.m
//  Common
//
//  Created by Ni Laisong on 12-7-18.
//  Copyright (c) 2012年 . All rights reserved.
//



#import "WebViewController.h"
#import "MyImageView.h"
//#import "Constant.h"

#define TOPMARGIN   44
#define LEFTMARGIN (isIpad?50:10)

@interface WebViewController ()
{
    BOOL isLoaded;
}
@property(nonatomic,retain) MyImageView* logoView;
@property(nonatomic,retain) UIScrollView* contentView;
@end

@implementation WebViewController
@synthesize logoUrl;
@synthesize logoPath;
@synthesize logoView;
@synthesize title;
@synthesize content;
@synthesize url;
@synthesize webView=_webView;
@synthesize contentView=_contentView;
@synthesize supperViewController;

-(void)dealloc
{
    [_contentView release];
    [logoView release];
    [logoUrl release];
    [logoPath release];
    [title release];
    [content release];
    [url release];
    [_webView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)createWebView
{
    if (self.webView) 
    {
        [self.webView removeFromSuperview];
    }
    
    self.webView=[[[MyWebView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
    _webView.showIndicator=YES;
    _webView.delegate=self;
//    _webView.scalesPageToFit = YES;
    //关于实现uiwebview禁止长按复制的功能
    UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil] autorelease];
    longPress.delegate = self;   //记得在.h文件里加上<UIGestureRecognizerDelegate>委托
    longPress.minimumPressDuration = 0.4;  //这里为什么要设置0.4，因为只要大于0.5就无效，我像大概是因为默认的跳出放大镜的手势的长按时间是0.5秒，
    //如果我们自定义的手势大于或小于0.5秒的话就来不及替换他的默认手势了，这是只是我的猜测。但是最好大于0.2
    //秒，因为有的pdf有一些书签跳转功能，这个值太小的话可能会使这些功能失效。
    [_webView addGestureRecognizer:longPress];

    _webView.dataDetectorTypes=UIDataDetectorTypeNone;
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:NO];
    UIScrollView * webScrollView = [_webView.subviews objectAtIndex:0];
    [webScrollView setBackgroundColor:[UIColor clearColor]];
    [webScrollView setOpaque:NO];       
    webScrollView.bounces=YES;
    webScrollView.showsVerticalScrollIndicator=NO;
    webScrollView.showsHorizontalScrollIndicator=NO;
    [self.contentView addSubview:_webView];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;  //这里一定要return NO,至于为什么大家去看看这个方法的文档吧。
    //还有就是这个委托在你长按的时候会被多次调用，大家可以用nslog输出gestureRecognizer和otherGestureRecognizer
    //看看都是些什么东西。
}

-(void)unloadData
{
    isLoaded=FALSE;
    [self.webView loadHTMLString:@"" baseURL:nil];
}

- (void)loadData
{
//    NSLog(@"url:%@",url);
    isLoaded=TRUE;
    if ([url hasPrefix:@"http"] && url.length>0)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    else
    {
        [self.webView loadHTMLString:content baseURL:nil];
    }
    
//    [logoView removeFromSuperview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"test");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, self.supperViewController.view.frame.size.width, self.supperViewController.view.frame.size.height);

    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

//    self.logoView  = [[[MyImageView alloc] initWithFrame:frame] autorelease];
//    logoView.contentMode=UIViewContentModeScaleAspectFit;
//    [self.view addSubview:logoView];
//    if (![logoView setImageWithPath:logoPath]) {
//        [logoView setImageWithURL:[NSURL URLWithString:logoUrl]];
//    }

    self.contentView = [[[UIScrollView alloc] initWithFrame: CGRectMake(LEFTMARGIN, TOPMARGIN, frame.size.width-LEFTMARGIN*2, frame.size.height-TOPMARGIN)] autorelease];
    
//    NSLog(@"self.contentView.frame : %@",NSStringFromCGRect(self.contentView.frame));
    [self.view addSubview:_contentView];

//    self.contentView.showsVerticalScrollIndicator=NO;
//    self.contentView.showsHorizontalScrollIndicator=NO;
//    self.contentView.bounces=NO;
    
    [self createWebView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(NSNotification*)notification
{
    if (![self.view.superview isKindOfClass:[UIScrollView class]]) 
    {
        self.view.frame = CGRectMake(0, 0, self.supperViewController.view.frame.size.width, self.supperViewController.view.frame.size.height);
    }
//    self.logoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.contentView.frame = CGRectMake(LEFTMARGIN, TOPMARGIN, self.view.frame.size.width-LEFTMARGIN*2, self.view.frame.size.height-TOPMARGIN*2);
    
    if (!isLoaded)
    {
        self.webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width,self.contentView.frame.size.height);
    }
}

-(void)didRotateToInterfaceOrientation:(NSNotification*)notification
{
    if (isLoaded) 
    {
        [self createWebView];
        [self loadData];
    }
}

@end
