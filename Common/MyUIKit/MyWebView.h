//
//  MyWebView.h
//  AuctionCatalog
//
//  Created by Laison on 12-4-9.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyWebView : UIWebView<UIWebViewDelegate>
{
    MBProgressHUD* HUDIndicator;
    id<UIWebViewDelegate> theDelegate;
}

@property  BOOL showIndicator;

-(void)singleTouch;

@end
