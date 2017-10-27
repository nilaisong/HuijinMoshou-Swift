//
//  AppDelegate.m
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/27.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//


#define  kBDMapKey [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.5i5j.moshou.broker"]?@"03LVUnDW04EAZSv6I7GNzMiI":@"6dXLh7CgPHFtlxXOjpXT45qS"//企业版:商店版

#define  kJPushKey [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.5i5j.moshou.broker"]?@"9f44899c74d926d568e0f3cd":@"859d6501aaf11efa2f7e9256"//企业版:商店版
#define  kJPushChannel [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.5i5j.moshou.broker"]?@"ftp":@"store"//企业版:商店版

#import "AppDelegate.h"
#import <UMMobClick/MobClick.h>
#import "JPUSHService.h"
#import "ShareService.h"
#import "UserData.h"
#import "MyAlertView.h"
#import "NetworkSingleton.h"
#import "DataFactory+User.h"
#import "DataFactory+Main.h"
#import "CustomTabBarController.h"
#import "DataFactory+Customer.h"
//#import "FMDBSource+Broker.h"
#import "DownloaderManager.h"
#import "InstructionView.h"
#import "BaseNavigationController.h"
#import "MoShouTopWindow.h"
//#import "LoginViewController.h"
//create by dingpuyu 2016-1-15 //3d touch事件相关控制器
#import "XTWorkReportingController.h"
#import "XTUserScheduleViewController.h"
#include "MortgageCalculatorViewController.h"
#import "MyBuildingViewController.h"

#import "SplashImageView.h"

#import "CustomerListViewController.h"
#import "MessageDetailViewController.h"
#import "MessageNoticeDetailViewController.h"
#import "ChatUIHelper.h"
#import "ChatViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "XTCrashManager.h"

#import "XTLogInController.h"
#import "BuildingDetailViewController.h"
//#import "ServiceUpdatingController.h"
#import "XTServiceUpdatingView.h"//服务器正在升级提示
#import "ShareActionSheet.h"
#import "MyUncaughtExceptionHandler.h"
#import "MyEvaluationViewController.h"
@interface AppDelegate ()<BMKGeneralDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic,strong)BMKMapManager *mapmanager;
@property (nonatomic,strong) InstructionView* instructionView;
@property (nonatomic,strong)NSDictionary* userInfo;

@property (nonatomic,weak)XTServiceUpdatingView* updatingView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSLog(@"%@",kMainBundlePath);

    
#ifdef DEVELOP
    Class overlay = NSClassFromString(@"UIDebuggingInformationOverlay");
    [[overlay class] performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    //    UIWindow *overlayWindow =  (UIWindow *)[[overlay class] performSelector:NSSelectorFromString(@"overlay")];
    //    [overlayWindow performSelector:NSSelectorFromString(@"toggleVisibility")];
#else
#endif
    
    [self initializeHuanXinSDK]; //初始化环信
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //监听热点连接状态栏变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    //创建3D touch快捷菜单
    [self createShortcutItems];
    //  注册友盟统计
    [self registerUmeng];
    //注册shareSDK分享
    [[ShareService sharedService] registerSharedApp];

    //极光推送
    BOOL apsForProduction = YES;
//    #ifdef DEVELOP
//        apsForProduction = NO;
//    #else
//        apsForProduction = YES;
//    #endif
    [JPUSHService setupWithOption:launchOptions appKey:kJPushKey channel:kJPushChannel apsForProduction:apsForProduction];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode,NSString *registrationID){
        if (resCode==0)
        {
            
        }
    }];
//    //通知角标个数清零
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
//#endif
    //百度地图初始化
    _mapmanager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapmanager start:kBDMapKey generalDelegate:self];
    if (!ret)
    {
        AlertShow(@"manager start failed!");
    }
    //初始化和加载程序根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CustomTabBarController *tabBarController=[[CustomTabBarController alloc]init];
    BaseNavigationController *navigationController=[[BaseNavigationController alloc]initWithRootViewController:tabBarController];
    self.window.rootViewController = navigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

//     添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到最顶部
    [MoShouTopWindow show];
    //检测版本更新
    [self checkVersionUpdate];
    //添加开机引导画面
    self.instructionView = [InstructionView showHelpImagesWithCount:3 andInView:self.window];
    
//    //缓存闪屏用数据
//    [[DataFactory sharedDataFactory] performSelectorInBackground:@selector(downloadSplashsData) withObject:nil];
    //添加闪屏画面
    if(!self.instructionView)
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray* fileNames = [fileManager contentsOfDirectoryAtPath:SplashImageFolder error:nil];
        BOOL shouleSplash = [fileManager fileExistsAtPath:SplashImageFolder] && fileNames.count > 0;
        /*
        NSDate* startTime = [NSDate new];
        double timeIntervale = 0;//三秒之内没有闪屏的图就一直检测
        //找到了闪屏的图或则超过了3秒，则退出检测
        while (timeIntervale<3) {
             NSDate* curTime = [NSDate new];
             timeIntervale = [curTime timeIntervalSinceDate:startTime];
             shouleSplash = [fileManager fileExistsAtPath:SplashImageFolder] && fileNames.count > 0;;
        }
         */
        if (shouleSplash) {
            self.window.rootViewController.view.alpha = 1.0;
            //            __weak typeof(self) weakSelf = self;
            SplashImageView* splashImageView = [[SplashImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) callBack:^(SplashImageView *view) {
                //        [splashImageView removeFromSuperview];
                //            weakSelf.window.rootViewController.view.alpha = 1.0;
                
            }];
            [self.window addSubview:splashImageView];
        }
    }
    
    //添加服务器状态校验通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vertifyServiceState:) name:kAFHTTPRequestFailure object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeServiceUpdatingView:) name:kAFHTTPRequestSuccess object:nil];
    
//    [self executeXTCrashManager];
 
    [self applicationWillEnterForeground:application];
    
    return YES;
}

/**
 执行崩溃监测
// */
//- (void)executeXTCrashManager{
//
//#ifdef DEVELOP
//    
//    [MyUncaughtExceptionHandler setDefaultHandler];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
//    if (data != nil) {
//        NSString *string = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
//        AlertShow(string);
//        //日志展示成功后把本地文件删除掉
//        NSFileManager *fileManger = [NSFileManager defaultManager];
//        [fileManger removeItemAtPath:dataPath error:nil];
//
//    }
//
////    NSString* phone = [UserData sharedUserData].mobile;
////    NSString* city =  [UserData sharedUserData].cityName;
////    NSString* version = [LocalFileSystem sharedManager].versionName;
////    NSString* domain = [LocalFileSystem sharedManager].baseURL;
////    [[XTCrashManager shareManager] initAppInfoWithPhone:phone city:city version:version domain:domain reportCallBack:^(NSString *reportPath) {
////        DLog(@"----------%@------",reportPath);
////        if (reportPath.length > 0 ) {
////            NSString *string = [NSString stringWithContentsOfFile:reportPath encoding:NSUTF8StringEncoding error:nil];
////                    AlertShow(string);
//////            [[DataFactory sharedDataFactory] uploadFileWithContetnFile:reportPath callBack:^(ActionResult *result) {
////            
//////            }];
////        }
////    }];
//
//#else
//    [MyUncaughtExceptionHandler setDefaultHandler];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
//    if (data != nil) {
//  
//    [[DataFactory sharedDataFactory] uploadFileWithContetnFile:dataPath callBack:^(ActionResult *result) {
//                    }];
//        
//    }
//
////    NSString* phone = [UserData sharedUserData].mobile;
////    NSString* city =  [UserData sharedUserData].cityName;
////    NSString* version = [LocalFileSystem sharedManager].versionName;
////    NSString* domain = [LocalFileSystem sharedManager].baseURL;
////    [[XTCrashManager shareManager] initAppInfoWithPhone:phone city:city version:version domain:domain reportCallBack:^(NSString *reportPath) {
////        NSString *string = [NSString stringWithContentsOfFile:reportPath encoding:NSUTF8StringEncoding error:nil];
////        AlertShow(string);
//////        DLog(@"----------%@------",reportPath);
//////        if (reportPath.length > 0 ) {
//////            [[DataFactory sharedDataFactory] uploadFileWithContetnFile:reportPath callBack:^(ActionResult *result) {
//////                
//////            }];
//////        }
////    }];
//#endif
//}

-(void)initializeHuanXinSDK
{

#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
    NSString *emAppKey = nil;
    
    #ifdef DEBUG//线下环境
        #ifdef TIYAN //体验
            emAppKey = @"moshou2016#tiyan51moshouapp";
        #elif FANGZHEN//仿真
            emAppKey = @"moshou2016#51moshouapp";
        #elif ALIYUN//阿里云
        emAppKey = @"5i5j#moshoutest";
//            emAppKey = @"moshou2016#aliyun51moshouapp";
        #elif  INHOUSE//测试
            emAppKey = @"moshou2016#51moshouapp";//      @"5i5j#moshoutest";
        #else //调试
            emAppKey = @"moshou2016#51moshouapp";    //   @"5i5j#moshoutest";         //@"moshou2016#com5i5jmoshoubroker";
        #endif
        
        #ifdef DEVELOP
            apnsCertName = @"moshoubroker_enterprise_aps_development";
        #else
            apnsCertName = @"moshoubroker_enterprise_aps_distribution";
        #endif
    #else//发布上线环境
        emAppKey = @"5i5j#moshou";
        #ifdef APPSTORE//商店版
            apnsCertName = @"moshoubroker_aps_distribution";
        #else
            apnsCertName = @"moshoubroker_enterprise_aps_distribution";
        #endif
    #endif
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:emAppKey];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];

    [ChatUIHelper shareHelper];

    [ChatUIHelper shareHelper].currentChatConversationId = @"";

}



-(void)createShortcutItems
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0){
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"calculator" localizedTitle:@"房贷计算器" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"icon-qian-touch"] userInfo:nil];
        
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"building" localizedTitle:@"我的楼盘" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"icon-loupan-touch"] userInfo:nil];
        
        UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"schedule" localizedTitle:@"我的日程" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"iconfont-richeng-2-拷贝"] userInfo:nil];
        
        // 这里是可以自定义的效果  可以自己设置  Icon
        
        UIApplicationShortcutItem * item4 = [[UIApplicationShortcutItem alloc]initWithType:@"workReport" localizedTitle:@"工作报表" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"icon-baobiao-touch"] userInfo:nil];
        
        [[UIApplication sharedApplication] setShortcutItems: @[ item4, item3, item2, item1 ]];
    }
}

-(void)registerAllLocalNotifications
{
    [[DataFactory sharedDataFactory] getAllScheduledRemindList:^(NSArray* array){
        if(array)
        {
            [self removeAllNotification];
            for (NSDictionary* remind in array)
            {
                long remindId =(long)[remind valueForKey:@"remindId"];
                NSString* content = [remind valueForKey:@"content"];
                NSString* name = [remind valueForKey:@"name"];
                NSArray* phoneList = [remind valueForKey:@"phoneList"];
                NSString *phone = @"";
                if (phoneList.count > 0) {
                    NSDictionary *mobile = [phoneList objectForIndex:0];
                    if ([self isBlankString:[mobile valueForKey:@"hidingPhone"]]) {
                        phone = [mobile valueForKey:@"totalPhone"];
                    }else
                    {
                        phone = [mobile valueForKey:@"hidingPhone"];
                    }
                }
                NSString* alertBody = [NSString stringWithFormat:@"%@(%@)\r\n%@",name,phone,content];
                NSString* datetime = [remind valueForKey:@"datetime"];
                datetime = [datetime stringByAppendingString:@":00"];
                NSDate *date = getNSDateWithDateTimeString(datetime);
                
//                [JPUSHService setLocalNotification:date alertBody:alertBody badge:-1 alertAction:nil identifierKey:[NSString stringWithFormat:@"%ld",remindId] userInfo:nil soundName:nil];
                
                
                [self setLoacationNotification:date alertBody:alertBody badge:@(-1) identifierKey:[NSString stringWithFormat:@"%ld",remindId]];
                
            }
        }
    }];
}

- (void)setLoacationNotification:(NSDate*)date alertBody:(NSString*)alertBody badge:(NSNumber*)badge identifierKey:(NSString*)identifier{
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
    content.body = alertBody;
    content.badge = badge;
    content.categoryIdentifier = identifier;
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max) {
        trigger.fireDate = date;
    }else{
        NSTimeInterval time = [date timeIntervalSinceNow];
        trigger.timeInterval = time;
    }
    trigger.repeat = NO;
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.requestIdentifier = identifier;
    request.content = content;
    request.trigger = trigger;//trigger2;//trigger3;//trigger4;//trigger5;
    request.completionHandler = ^(id result) {
        NSLog(@"结果返回：%@", result);
    };
    [JPUSHService addNotification:request];
}

#pragma mark - 移除所有本地推送
- (void)removeAllNotification {
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max) {
        // 代码块
        [JPUSHService removeNotification:nil];  // iOS10以下移除所有推送；iOS10以上移除所有在通知中心显示推送和待推送请求
        
    } else {
        // 代码块
      JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
      identifier.identifiers = nil;
      identifier.delivered = NO;  //等于YES则移除所有在通知中心显示的，等于NO则为移除所有待推送的
      [JPUSHService removeNotification:identifier];
    }

    
    //  //iOS10以上支持
    //  JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
    //  identifier.identifiers = nil;
    //  identifier.delivered = YES;  //等于YES则移除所有在通知中心显示的，等于NO则为移除所有待推送的
    //  [JPUSHService removeNotification:identifier];
}

#pragma mark - 判断字符串是否为空
- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


//接收和处理热点连接状态栏的变化消息事件
- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
    if (_instructionView.superview) {
        _instructionView.frame = self.window.bounds;
        [_instructionView adjustFrameForHotSpotChange];
    }
}

//退出登录，用户登录之后被踢出用 
-(void)logout:(NSString*)message
{
    [[UserData sharedUserData] cleareUserData];
    [[EMClient sharedClient] logout:YES];

    
//    LoginViewController *logVC =[[LoginViewController alloc]init];
    XTLogInController* logVC = [[XTLogInController alloc]init];
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    [navigationController.topViewController.view.layer removeAllAnimations];
    
    //add by wangzz 2016-01-27
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TouchExit"];
    for (UIViewController *temp in navigationController.viewControllers) {
        if ([temp isKindOfClass:[CustomTabBarController class]]) {
            UITabBarController *tabBarViewController = (UITabBarController*)temp;
            if ([tabBarViewController.selectedViewController isKindOfClass:[CustomerListViewController class]]) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TouchExit"];
                break;
            }
        }   
    }
    //end
    [navigationController pushViewController:logVC animated:NO];
//    [navigationController presentViewController:logVC animated:NO completion:nil];
    [TipsView showTips:message inView:logVC.view];
}

//  注册友盟统计
-(void)registerUmeng
{
    NSString*channelId = nil;
    NSString*  mobAppKey = @"557e66df67e58ee13c0016e7";
    #ifdef DEBUG
        {
            channelId = @"test";
        }
    #else
        {
            NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
            if ([bundleId isEqualToString:@"com.5i5j.moshou.broker"]) {
                channelId = @"enterprise";
            }
        }
    #endif
    
//    [MobClick startWithAppkey:mobAppKey reportPolicy:BATCH   channelId:channelId];
    [UMAnalyticsConfig sharedInstance].appKey = mobAppKey;
    [UMAnalyticsConfig sharedInstance].channelId =channelId;
    [MobClick setCrashReportEnabled:YES];
    [MobClick startWithConfigure: [UMAnalyticsConfig sharedInstance]];
    [MobClick setAppVersion:kAppVersion];
}

#pragma mark -   消息推送JPush  本地推送

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    DLog(@"本地推送消息userInfo ==%@",notification.userInfo);
//    本地推送消息userInfo =={
//        ConversationChatter = 13693211326;
//        MessageType = 0;
//    }
    
    NSDictionary *notificationUserInfoDic = notification.userInfo;
    
    for (NSString * string in notificationUserInfoDic.allKeys) {
        
        if ([string isEqualToString:@"MessageType"]) {
            //环信本地推送
            
            NSString *conversationChatter  =[notificationUserInfoDic valueForKey:@"ConversationChatter"];
            [self PushToChatVCWithconversationChatter:conversationChatter];
            
            break;
            
        }else{ //其他推送处理
            
            UIApplicationState state = application.applicationState;
            if (state == UIApplicationStateActive)
            {
                if (notification.alertBody.length>0)
                {
                    MyAlertView* alertView = [[MyAlertView alloc] initWithTitle:@"日程提醒" message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    //            [alertView.parameters setValue:custId forKey:@"custId"];
                    alertView.tag=2;//本地消息推送处理
                    [alertView show];
                }
            }
        }
    }
//    self.userInfo = notification.userInfo;//如果未登录先缓存起来
//    if (![UserData sharedUserData].isUserLogined)
//    {
//        return;
//    }
//    self.userInfo = nil;//对于已登录用户该属性没有用
//    NSString* custId = [notification.userInfo valueForKey:@"custId"];
    
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:@"123456"];
}


-(void)jumpToCustomerInfoWithId:(NSString*)custId
{
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
 ///环信的SDKdeviceToken注册
    [[EMClient sharedClient] bindDeviceToken:deviceToken];

  //极光的deviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *dt = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UserData sharedUserData].deviceToken = dt;
    //如果用户登录以后开启消息推送
    [[UserData sharedUserData] setJPushAlias];
    //测试推送
    /*[JPUSHService setTags:[NSSet setWithObject:@"moshou"]
                    alias:@"test123" callbackSelector:@selector(tagsAliasCallback:tags:                                                               alias:)  object:self];*/
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \nalias: %@\n", iResCode,alias];
    NSLog(@"tagsAlias回调1:%@", callbackString);
}

#pragma mark - 远程推送消息


//点击通知进入的方法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {

    if ([userInfo valueForKey:@"f"]) {
        
        
        if (![UserData sharedUserData].isUserLogined){
            
            return;
        }

        [self PushToChatVCWithconversationChatter:[userInfo valueForKey:@"f"]];
        
        return;
    }
    
//    NSString *string = [NSString stringWithFormat:@" 点击通知栏的推送消息   %@",userInfo];
//    AlertShow(string);
    
    [self handleRemoteNotification:userInfo withApplication:application];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    
//    NSString *string = [NSString stringWithFormat:@" 在前台收到推送   %@",userInfo];
//    AlertShow(string);
    
    
    [self handleRemoteNotification:userInfo withApplication:application];
}


////IOS10之后 推送消息接收
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//    
//    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {// 程序在运行过程中受到推送通知
//        // TODO
//        
//        
//        
//        if ([userInfo valueForKey:@"f"]) {
//            
//            [self PushToChatVCWithconversationChatter:[userInfo valueForKey:@"f"]];
//            
//            return;
//        }
//        
////        [self handleRemoteNotification:userInfo withApplication:application];
//        
//        
//        
//    } else { //在background状态受到推送通知
//        // TODO
//        if ([userInfo valueForKey:@"f"]) {
//            
//            [self PushToChatVCWithconversationChatter:[userInfo valueForKey:@"f"]];
//            
//            return;
//        }
//        
////        [self handleRemoteNotification:userInfo withApplication:application];
//        
//        
//    }
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//


#pragma mark - 跳转到聊天页面
-(void)PushToChatVCWithconversationChatter:(NSString *)conversationChatter
{
    if ([conversationChatter isEqualToString:[ChatUIHelper shareHelper].currentChatConversationId]) {
        
        return;
    }
    
    
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:conversationChatter conversationType:EMConversationTypeChat];
    

    UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
    [navigationController pushViewController:chatVC animated:YES];

}


#pragma mark - 3D touch 相关
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if (![UserData sharedUserData].isUserLogined)
    {
//        [Tool removeCache:@"releaseBaseURL"];
        
        [[UserData sharedUserData] cleareUserData];
//        LoginViewController *logVC =[[LoginViewController alloc]init];
//        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//        [navigationController.topViewController.view.layer removeAllAnimations];
        XTLogInController* logVC = [[XTLogInController alloc] init];
        UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
        [navigationController.topViewController.view.layer removeAllAnimations];
        
        //add by wangzz 2016-01-27
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TouchExit"];
        for (UIViewController *temp in navigationController.viewControllers) {
            if ([temp isKindOfClass:[CustomTabBarController class]]) {
                UITabBarController *tabBarViewController = (UITabBarController*)temp;
                if ([tabBarViewController.selectedViewController isKindOfClass:[CustomerListViewController class]]) {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TouchExit"];
                    break;
                }
            }
        }
        //end
        [navigationController pushViewController:logVC animated:NO];
        return;
    }
    UIViewController* controller = nil;
    if ([shortcutItem.type isEqualToString:@"calculator"]) {
        controller = [[MortgageCalculatorViewController alloc]init];
                                                              }else if([shortcutItem.type isEqualToString:@"building"]){
        controller = [[MyBuildingViewController alloc]init];
    }else if([shortcutItem.type isEqualToString:@"schedule"]){
        controller = [[XTUserScheduleViewController alloc]init];
    }else if([shortcutItem.type isEqualToString:@"workReport"]){
        controller = [[XTWorkReportingController alloc]init];
    }
    
    if (!controller) return;
    UINavigationController* nav = (UINavigationController*)_window.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:controller animated:NO];
    }
}

//-(void)handleNotificationAfterLogin
//{
//    if(self.userInfo)
//    {
//        NSString* pushCode = [_userInfo valueForKey:@"biz_type"];
//        NSString* msgId =  [_userInfo valueForKey:@"msg_id"];
//        if(msgId)
//        {
//            [self jumpToMessageInfoWithId:msgId andCode:pushCode];
//        }
////        NSString* custId = [_userInfo valueForKey:@"custId"];
////        if (custId) {
////            [self jumpToCustomerInfoWithId:custId];
////        }
//    }
//}

-(void)handleRemoteNotification:(NSDictionary *)userInfo withApplication:(UIApplication *)application
{
//    [JPUSHService setBadge:0];
//    if([UIApplication sharedApplication].applicationIconBadgeNumber>0)
//    {
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    }
    self.userInfo = userInfo;//如果未登录先缓存起来
    if (![UserData sharedUserData].isUserLogined)
    {
        return;
    }
    self.userInfo = nil;//对于已登录用户该属性没有用
    [JPUSHService handleRemoteNotification:userInfo];
    NSDictionary* apsInfo = [userInfo valueForKey:@"aps"];
    NSString* alertMsg = [apsInfo valueForKey:@"alert"];

    
    NSString* pushCode = [userInfo valueForKey:@"biz_type"];
    NSString* msgId =  [userInfo valueForKey:@"msg_id"];
    NSString* custId =  [userInfo valueForKey:@"custId"];
    
    NSString *tmpCode = [userInfo valueForKey:@"tmpCode"];
   
    
    
#pragma mark -   //add by wangzz 161027
    ///   7是楼盘动态   8 是楼盘基本信息修改的推送  4是啥忘记了
    NSString* msgType = [userInfo valueForKey:@"msg_type"];
    NSString* estateId = @"";
    if (([msgType isEqualToString:@"4"] ||[msgType isEqualToString:@"7"] ||[msgType isEqualToString:@"8"])&& [userInfo valueForKey:@"estate_id"])
    {
        estateId = [userInfo valueForKey:@"estate_id"];
    }
    for(UIView *view in self.window.subviews){
        if([view isKindOfClass:[ShareActionSheet class]]){
            [view removeAllSubviews];
            [view removeFromSuperview];
        }
    }
            NSString* title =  [userInfo valueForKey:@"title"];
            //end
            if (custId.length>0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCustomerDetailWithMsg object:custId];
            }
            
            UIApplicationState state = application.applicationState;
            if (state == UIApplicationStateActive)
            {
                if (alertMsg.length>0)
                {
                    NSString *msgContent = msgType?msgType:msgId;
                    MyAlertView* alertView = [[MyAlertView alloc]initWithTitle:[msgType isEqualToString:@"7"]?@"楼盘动态":@"消息" message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:msgContent?@"阅读":nil, nil];
                    if (msgId) {
                        [alertView.parameters setValue:msgId forKey:@"msgId"];
                    }
                    if (msgType) {
                        [alertView.parameters setValue:msgType forKey:@"msgType"];
                    }
                    if (([msgType isEqualToString:@"4"] ||[msgType isEqualToString:@"7"]||[msgType isEqualToString:@"8"] )&& estateId) {
                        [alertView.parameters setValue:estateId forKey:@"estateId"];
                    }
                    if (title) {
                        [alertView.parameters setValue:title forKey:@"title"];
                    }
                    [alertView.parameters setValue:pushCode forKey:@"pushCode"];
                    
                    if (tmpCode) {
                        [alertView.parameters setValue:tmpCode forKey:@"tmpCode"];
                    }
                    
                    alertView.tag=1;//消息推送处理
                    [alertView show];
                }
            }
            else
            {
                if([tmpCode isEqualToString:@"cust_review"]){
                    
                        MyEvaluationViewController *evaVC =[[MyEvaluationViewController alloc]init];
                        UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
                        [navigationController pushViewController:evaVC animated:YES];
                 
                }else if(msgType)
                {
                    [self jumpToMessageInfoWithMsgType:msgType EstateId:estateId AndTitle:title];
                    
                }else if (msgId)
                {
                    [self jumpToMessageInfoWithId:msgId andCode:pushCode];
                }
            }
    
}

-(void)myAlertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //消息推送
    if (alertView.tag==1 && buttonIndex==1)
    {
        NSString*msgId = [alertView.parameters valueForKey:@"msgId"];
        NSString*pushCode = [alertView.parameters valueForKey:@"pushCode"];
#pragma mark -   //add by wangzz 161027
        NSString* msgType = [alertView.parameters valueForKey:@"msgType"];
        NSString* estateId = @"";
        if ([msgType isEqualToString:@"4"] ||[msgType isEqualToString:@"8"]||[msgType isEqualToString:@"7"]) {
            estateId =  [alertView.parameters valueForKey:@"estateId"];
        }
        NSString* title =  [alertView.parameters valueForKey:@"title"];
        NSString *tmpCode = [alertView.parameters valueForKey:@"tmpCode"];
        //end
        if ([tmpCode isEqualToString:@"cust_review"]) {
            
                MyEvaluationViewController *evaVC =[[MyEvaluationViewController alloc]init];
                UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
                [navigationController pushViewController:evaVC animated:YES];

        }else if(msgType)
        {
            [self jumpToMessageInfoWithMsgType:msgType EstateId:estateId AndTitle:title];
        }else if (msgId)
        {
            [self jumpToMessageInfoWithId:msgId andCode:pushCode];
        }
    }
    //add by wangzz 2016-02-22
    else if (alertView.tag==2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshRemindList" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeDot" object:nil];
    }

}

//跳转到消息页
-(void)jumpToMessageInfoWithMsgType:(NSString*)msgType EstateId:(NSString*)estateId AndTitle:(NSString*)title
{
    NSLog(@"消息Type:%@",msgType);
    if ([msgType isEqualToString:@"7"] || [msgType isEqualToString:@"8"]) {
        
        if (estateId.length>0) {
            //楼盘动态推送 跳转到楼盘详情
            BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
            UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
            VC.buildingId = estateId;
            [navigationController pushViewController:VC animated:YES];
        }
        
    }else{
        
        [[DataFactory sharedDataFactory] readMessageByMsgType:msgType AndEstateId:estateId withCallBack:^(ActionResult *result) {
            if (result.success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeDot" object:nil];
                MessageNoticeDetailViewController *msgVC =[[MessageNoticeDetailViewController alloc]init];
                msgVC.msgType = msgType;
                msgVC.eatateId = estateId;
                msgVC.navTitle = title;
                UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
                [navigationController pushViewController:msgVC animated:YES];
            }
        }];

        }
    
}

//跳转到消息页 //delete by wangzz 161027
-(void)jumpToMessageInfoWithId:(NSString*)msgId  andCode:(NSString*)code
{
    NSLog(@"消息Id:%@",msgId);
    MessageData* message = [[MessageData alloc] init];
    message.msgId = msgId;
    message.pushCode = code;
    [[DataFactory sharedDataFactory] readMessage:message withCallback:^(ActionResult *result) {
        if (result.success) {
            MessageDetailViewController *msgVC =[[MessageDetailViewController alloc]init];
            msgVC.data = message;
            UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
            [navigationController pushViewController:msgVC animated:YES];
        }
//            else
//            {
//                [TipsView showTips:result.message inView:self.view];
//            }
        
    }];
}
#pragma -end 消息推送JPush

//#pragma -begin 分享shareSDK
//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}

-(void)checkVersionUpdate
{
    [[DataFactory sharedDataFactory] checkVersionUpdateWithCallback:^(BOOL isnew, NSString* message,BOOL mustUpdate,NSString* newVersion){
        if (isnew) {
            [[DataFactory sharedDataFactory] updateVersionWithMessage:message mustUpdate:mustUpdate newVersion:newVersion];
        }
    }];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/hui-jin-mo-shou/id1035508186"]];//
}
#pragma -end 分享shareSDK

- (void)applicationWillResignActive:(UIApplication *)application {
   
//    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];

    NSInteger allNum = [UserData sharedUserData].newUnreadMsgCount+[self getUnreadMessageCount]+[[UserData sharedUserData].userInfo.offlineMsgCount integerValue];
    
    [application setApplicationIconBadgeNumber:allNum];


    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([UserData sharedUserData].isUserLogined) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCustomer" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:@"0"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyBuildingList" object:nil];
    }
    
    [[DataFactory sharedDataFactory] checkVersionUpdateWithCallback:^(BOOL isnew, NSString* message,BOOL mustUpdate,NSString* newVersion){
        if (isnew && mustUpdate) {
            [[DataFactory sharedDataFactory] updateVersionWithMessage:message mustUpdate:mustUpdate newVersion:newVersion];
        }
    }];
    
    //如果在登录、添加日程、删除日程时，获取日程列表失败，则此时重新获取并注册
    NSNumber* remindFlag = [Tool getCache:@"getAllScheduledRemindList"];
    if (remindFlag && ![remindFlag boolValue]) {
        [self registerAllLocalNotifications];
    }
    //检测并更新已下载楼盘数据
    //    [[DownloaderManager sharedManager] checkDownloadItemsUpdate];
    //缓存闪屏用数据
    [[DataFactory sharedDataFactory] performSelectorInBackground:@selector(downloadSplashsData) withObject:nil];
    //create by xiaotei
    [[AccountServiceProvider sharedInstance] getUserInfo:^(ResponseResult *result) {
        if (result.success) {
            [UserData sharedUserData].userInfo = result.data;
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

//如果服务器接口能通，则移除提示视图
- (void)removeServiceUpdatingView:(NSNotification*)noti
{
    if (_updatingView) {
        [_updatingView removeFromSuperview];
        _updatingView = nil;
    }
}
/**
 校验服务器是否停止服务
 */
- (void)vertifyServiceState:(NSNotification*)noti{
    #ifdef DEVELOP
    
    #else
    
    [[DataFactory sharedDataFactory] getServiceState:^(ActionResult *result, ServiceStatusModel *statusModel) {
        if (result.success && statusModel.isServerStop.boolValue) {
            [self serviceUpdatingWithString:statusModel.message];
        }else{
            if (_updatingView) {
                [_updatingView removeFromSuperview];
                _updatingView = nil;
            }
        }
    }];
    
    #endif
}

- (void)serviceUpdatingWithString:(NSString*)tips{
//    ServiceUpdatingController* serviceVC = [[ServiceUpdatingController alloc]init];
//    serviceVC.tipsString = tips.length <= 0?@"尊敬的用户:服务器正在升级，魔兽平台将停止服务，给您带来的不便敬请谅解。":tips;
    if (_updatingView) {
        [_updatingView removeFromSuperview];
        _updatingView = nil;
    }
    XTServiceUpdatingView* updatingView = [[XTServiceUpdatingView alloc]initWithFrame:self.window.bounds];
    updatingView.tipsString = tips.length <= 0?@"尊敬的用户:服务器正在升级，魔售平台将停止服务，给您带来的不便敬请谅解。":tips;
    _updatingView = updatingView;
    [[UIApplication sharedApplication].keyWindow addSubview:updatingView];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(NSInteger)getUnreadMessageCount
{
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    return unreadCount;
    
}

@end
