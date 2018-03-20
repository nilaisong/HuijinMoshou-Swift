//
//  AppDelegate.h
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/27.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>{


}


@property (strong, nonatomic) UIWindow *window;
//退出登录，用户登录之后被踢出用
-(void)logout:(NSString*)message;
//检测版本更新
-(void)checkVersionUpdate;
//注册日程提醒，添加日程、删除日程、登录时调用
-(void)registerAllLocalNotifications;
@end

