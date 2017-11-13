//
//  Constant.h
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/28.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "Functions.h"
#import "LocalFileSystem.h"
#import "NetworkSingleton.h"
#import "UIColor+Hex.h"
#define EMPTYSTRING @""

#define moshouEncryptKey @"m【oshoubroker" //与后台通信加密的秘钥

//add by wangzz 150710
#import "UIViewExt.h"
#import "ShareModel.h"


#define PAGESIZE @"20"
#define UserUnreadMessageCountNotification @"UserUnreadMessageCountUpdate"
#define BACKGROUNDCOLOR [UIColor colorWithHexString:@"f7f7f7"]
#define LABELCOLOR [UIColor colorWithHexString:@"777777"]
#define VIEWBGCOLOR [UIColor colorWithHexString:@"efeff4"]
#define NAVIGATIONTITLE [UIColor colorWithHexString:@"333333"]
#define LINECOLOR [UIColor colorWithHexString:@"d9d9db"]
#define TFPLEASEHOLDERCOLOR [UIColor colorWithHexString:@"aeaeae"]

#define BLUEBTBCOLOR [UIColor colorWithHexString:@"37aeff"]
#define POINTMALLGRAYLABELCOLOR [UIColor colorWithHexString:@"8f8e93"]
#define ORIGCOLOR   [UIColor colorWithHexString:@"ff6600"]
#define bgViewColor [UIColor colorWithHexString:@"ececec"]
#define stringColor [UIColor colorWithHexString:@"b2b2b2"]
#define redBgColor  [UIColor colorWithHexString:@"f4595b"]

#define buttonBorderColor  [UIColor colorWithHexString:@"d1d1d1"]

#define CustomerBorderColor [UIColor colorWithHexString:@"e5e4e0"]
//闪屏数据的缓存路径
#define SplashDownloadFolder [NSString stringWithFormat:@"splash%@",[UserData sharedUserData].cityName]

//闪屏用图片缓存的位置
#define SplashImageFolder documentFilePathWithFileName(@"image",SplashDownloadFolder)

#define DataCacheFolder [NSString stringWithFormat:@"data%@",[UserData sharedUserData].userInfo.userId]

//#define NSUD    [NSUserDefaults standardUserDefaults]
#define CUSTOMER_LABEL_FONT_SIZE            14.0f
#define nullPageWidth                       ((198/320.0)*kMainScreenWidth)
#define nullPageScale                       (272/396.0)//(396/272.0)
#define viewTopY                            self.navigationBar.bottom
//end

#define kReadJPushMessage @"ReadJPushMessageAfterLogin"
#define kRefreshCustomerDetailWithMsg @"RefreshCustomerDetailWithMsg"

// 环信聊天用的昵称和头像（发送聊天消息时，要附带这3个属性）
#define kChatUserId @"ChatUserName"// 环信账号
#define kChatUserNick @"ChatUserNick"
#define kChatUserPic @"ChatUserPic"


#ifndef ChatUIDefine_h
#define ChatUIDefine_h

// 消息通知
#define kSetupUntreatedApplyCount @"setupUntreatedApplyCount"// 未处理的好友申请
#define kSetupUnreadMessageCount @"setupUnreadMessageCount"// 未读聊天消息数
#define kConnectionStateChanged @"ChatConnectionStateChanged"// 环信服务器连接状态改变

// 注册通知
#define NOTIFY_ADD(_noParamsFunc, _notifyName)  [[NSNotificationCenter defaultCenter] \
addObserver:self \
selector:@selector(_noParamsFunc) \
name:_notifyName \
object:nil];

// 发送通知
#define NOTIFY_POST(_notifyName)   [[NSNotificationCenter defaultCenter] postNotificationName:_notifyName object:nil];

// 移除通知
#define NOTIFY_REMOVE(_notifyName) [[NSNotificationCenter defaultCenter] removeObserver:self name:_notifyName object:nil];

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#endif /* GlobalDefine_h */




