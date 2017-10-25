//
//  ActionResult.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "ActionResult.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "TipsView.h"

@implementation ActionResult

-(void)setCode:(int)code
{
    if(_code!=code)
    {
        _code = code;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (code==-2001)
        {
            if ([UserData sharedUserData].isUserLogined)
            {
                AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [appDeleage performSelectorOnMainThread:@selector(logout) withObject:nil waitUntilDone:YES];
                [appDeleage  performSelector:@selector(logout:) withObject:self.message afterDelay:0.1];
                //            NSString* error =code ==-1000?@"账号已在其它设备登录":@"用户账号被锁定";
                //            [TipsView showTips:error inView:appDeleage.window.rootViewController.view];
            }
        }
    });
}

-(NSString*)message
{
    if (!_success && _message.length==0) {
        return @"抱歉，发生未知异常";
    }
    else
    {
        return _message;
    }
}
@end
