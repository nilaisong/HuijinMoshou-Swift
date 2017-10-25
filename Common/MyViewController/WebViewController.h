//
//  WebViewController.h
//  Common
//
//  Created by Ni Laisong on 12-7-18.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyWebView.h"

@interface WebViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,copy) NSString* logoUrl;
@property(nonatomic,copy) NSString* logoPath;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* content;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,retain) MyWebView* webView;
@property(nonatomic,retain) UIViewController* supperViewController;

-(void)unloadData;
- (void)loadData;

@end
