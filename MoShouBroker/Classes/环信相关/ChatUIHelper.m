/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatUIHelper.h"

#import "AppDelegate.h"
//#import "ApplyViewController.h"
#import "MBProgressHUD.h"
#import "UserCacheManager.h"



//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


@interface ChatUIHelper()
{
    NSTimer *_callTimer;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

static ChatUIHelper *helper = nil;

@implementation ChatUIHelper





+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatUIHelper alloc] init];
    });
    return helper;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [ChatUIHelper shareHelper].currentChatConversationId = @"";


}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{
    
    self.currentChatConversationId = @"";
    
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}


- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:NO];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.conversationListVC) {
                [weakself.conversationListVC refreshDataSource];
            }
            
                NOTIFY_POST(kSetupUnreadMessageCount);
        });
    });
}

#pragma mark - EMClientDelegate  网络状态  自动登录处理相关  从其他设备登录

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    NOTIFY_POST(kConnectionStateChanged);
}

- (void)didAutoLoginWithError:(EMError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
    }
//    else if([[EMClient sharedClient] isConnected]){
//        UIView *view = self.mainVC.view;
//        [MBProgressHUD showHUDAddedTo:view animated:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            BOOL flag = [[EMClient sharedClient] dataMigrationTo3];
//            if (flag) {
//                [self asyncGroupFromServer];
//                [self asyncConversationFromDB];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:view animated:YES];
//            });
//        });
//    }
}

//被其他设备踢掉


- (void)didLoginFromOtherDevice
{
    [self _clearHelper];
    
    AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDeleage  performSelector:@selector(logout:) withObject:@"账号已在其它设备登录" afterDelay:0.1];
    
    
    
    
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didRemovedFromServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

//- (void)didServersChanged
//{
//    [self _clearHelper];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//}
//
//- (void)didAppkeyChanged
//{
//    [self _clearHelper];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//}

#pragma mark - EMChatManagerDelegate  更新回话列表  收到消息的时候

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    
#warning 这里要处理 更新绘画列表的时候的通知处理事情

    NOTIFY_POST(kSetupUnreadMessageCount);
    
    if (self.conversationListVC) {
        [_conversationListVC refreshDataSource];
    }
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    NOTIFY_POST(kSetupUnreadMessageCount);

    
//    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){
        
        [UserCacheManager saveInfo:message.ext];
        
        NSString *userid = [message.ext objectForKey:kChatUserId];
        UserCacheInfo *test = [UserCacheManager getById:userid];
        NSLog(@"%@", test.NickName);
        
        BOOL needShowNotification = [self _needShowNotification:message.conversationId];
        
        
        
        
        
        if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            switch (state) {
                case UIApplicationStateActive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        }
        
//        if (_chatVC == nil) {
//            _chatVC = [self _getCurrentChatView];
//        }
//        BOOL isChatting = NO;
//        if (_chatVC) {
//            isChatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
//        }
//        if (_chatVC == nil || !isChatting) {
//            if (self.conversationListVC) {
//                [_conversationListVC refresh];
//            }
//            
////            if (self.mainVC) {
////                 NOTIFY_POST(kSetupUnreadMessageCount);
////            }
//            return;
//        }
//        
//        if (isChatting) {
//            isRefreshCons = NO;
//        }
//    }
//    
//    if (isRefreshCons) {
//        if (self.conversationListVC) {
//            [_conversationListVC refresh];
//        }
//        
////        if (self.mainVC) {
////             NOTIFY_POST(kSetupUnreadMessageCount);
////        }
    }
}


#pragma mark - EMCallManagerDelegate


#pragma mark - public 


#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    if ([fromChatter isEqualToString:self.currentChatConversationId]) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                return NO;
                break;
            case UIApplicationStateInactive:
                return NO;
                break;
            case UIApplicationStateBackground:
               
                return YES;
                break;
            default:
                break;
        };
        
        
    }else{
        
        return YES;
        
    }
    
    
//    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
//    for (NSString *str in igGroupIds) {
//        if ([str isEqualToString:fromChatter]) {
//            ret = NO;
//            break;
//        }
//    }
}

- (ChatViewController*)_getCurrentChatView
{
    AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;

    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDeleage.window.rootViewController.navigationController.viewControllers
];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}

- (void)_clearHelper
{
//    self.mainVC = nil;
    self.conversationListVC = nil;
    self.chatVC = nil;
//    self.contactViewVC = nil;
    [ChatUIHelper shareHelper].currentChatConversationId = @"";

    [[EMClient sharedClient] logout:YES];
    

}

- (void)playSoundAndVibration{
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMError *error = nil;
    EMPushOptions *options = [[EMClient sharedClient]  getPushOptionsFromServerWithError:&error];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = [UserCacheManager getNickById:message.from];
//        if (message.chatType == EMChatTypeGroupChat) {
//            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:message.conversationId]) {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
//                    break;
//                }
//            }
//        }
//        else if (message.chatType == EMChatTypeChatRoom)
//        {
//            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
//            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//            NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
//            if (chatroomName)
//            {
//                title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
//            }
//        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
//#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    
#ifdef DEBUG
//    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地测试]%@", notification.alertBody];
#endif
    
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    [[ChatUIHelper shareHelper] playSoundAndVibration];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}
@end
