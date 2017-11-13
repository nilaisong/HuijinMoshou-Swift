//
//  MyWebView.m
//  AuctionCatalog
//
//  Created by Laison on 12-4-9.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "MyWebView.h"

@implementation MyWebView
@synthesize  showIndicator=_showIndicator;

//
//-(void)dealloc
//{
//    [HUDIndicator release];
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        super.delegate=self;
        if (HUDIndicator)
        {
            [HUDIndicator removeFromSuperview];
//            [HUDIndicator release];
        }
        HUDIndicator = [[MBProgressHUD alloc] initWithView:self];
        HUDIndicator.frame = CGRectMake(0, 0, 200, 160);
        HUDIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        // Set determinate mode
        HUDIndicator.mode = MBProgressHUDModeIndeterminate;
        //HUDIndicator.delegate = self;
        HUDIndicator.hidden=YES;
        [self addSubview:HUDIndicator];
    }
    return self;
}

//定义一个新的变量指向外部的代理
-(void)setDelegate:(id<UIWebViewDelegate>)delegate
{
    theDelegate = delegate;
}

-(void)setFrame:(CGRect)frame
{
    super.frame=frame;
    HUDIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void)singleTouch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchDown" object:self userInfo:nil];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView * hitView = [super hitTest:point withEvent:event];
//    [hitView setBackgroundColor:[UIColor clearColor]];
//    UITapGestureRecognizer * tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTouch)] autorelease];
//    
//    [tapRecognizer setNumberOfTapsRequired:1];
//    [hitView addGestureRecognizer:tapRecognizer];
//    
//    return hitView;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (_showIndicator) 
    {
        HUDIndicator.hidden=NO;
        [HUDIndicator show:NO];
        HUDIndicator.labelText=@"正在加载...";
    }
    if (theDelegate && [theDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [theDelegate performSelector:@selector(webViewDidStartLoad:) withObject:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_showIndicator) 
    {
        HUDIndicator.hidden=YES;
        [HUDIndicator hide:NO];
    }

    float width = webView.frame.size.width *0.8;
    NSString* script = [NSString stringWithFormat:@"javascript:var oimgs = document.getElementsByTagName('img');for (var i = 0; i < oimgs.length; i++) {if(oimgs[i].width > %f){var h=%f / oimgs[i].width * oimgs[i].height; oimgs[i].width='%f'; oimgs[i].height=h;}}",width,width,width];
//        NSLog(@"script:%@",script);
    CGFloat webHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGFloat contentHeight = [webView.scrollView contentSize].height;
    [webView stringByEvaluatingJavaScriptFromString:script];
    webHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    contentHeight = [webView.scrollView contentSize].height;
    if (theDelegate && [theDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [theDelegate performSelector:@selector(webViewDidFinishLoad:) withObject:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_showIndicator) 
    {
        HUDIndicator.labelText=@"加载失败!";
    }
    if (theDelegate && [theDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [theDelegate performSelector:@selector(webView:didFailLoadWithError:) withObject:webView withObject:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (theDelegate && [theDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
      return  [theDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}


@end
