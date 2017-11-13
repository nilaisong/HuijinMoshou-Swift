//
//  ShareService.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/15.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "ShareService.h"
#import "Tool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

static ShareService *sharedService;

@implementation ShareService
//创建单例，方便调用
+(ShareService *)sharedService
{
    if(sharedService == nil)
    {
        sharedService = [[ShareService alloc] init];
        
    }
    return sharedService;
}

//初始化
-(id)init
{
    if(self = [super init])
    {
        [self registerSharedApp];
    }
    return  self;
}

- (void)registerSharedApp
{
    
    [ShareSDK registerApp:@"81e81b651434"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
     
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"788869518"
                                                appSecret:@"848bd0cdc0df97552efbd1bf1f98379f"
                                              redirectUri:@"http://www.huijinhang.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx741c154fae1ddf53"
                                            appSecret:@"f23c4433c98880b58330ce71e89fb490"];
                      //                       SSDKSetupPocketByConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                      //                                                redirectUri:@"pocketapp1234"
                      //                                                   authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104642773"
                                           appKey:@"p7WXeUWH1YPauXJB"
                                         authType:@"SSDKAuthTypeSSO"];
                      //
                      break;
                      
                  default:
                      break;
              }
          }];
    
    
    
    
    
    
    
    
    
    //    //注册shareSDK
    //    [ShareSDK registerApp:@"81e81b651434"];
    //    [ShareSDK ssoEnabled:YES];
    //
    //    //注册各个分享平台
    //    /**
    //     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
    //     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
    //     **/
    //    [ShareSDK connectSinaWeiboWithAppKey:@"788869518"
    //                               appSecret:@"848bd0cdc0df97552efbd1bf1f98379f"
    //                             redirectUri:@"http://www.huijinhang.com"];
    //
    ////    /**
    ////     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
    ////     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
    ////
    ////     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
    ////     **/
    ////    [ShareSDK connectTencentWeiboWithAppKey:@"801566927"
    ////                                  appSecret:@"13c893eca42b930c7a4aec10fe784ee3"
    ////                                redirectUri:@"http://www.5i5j.com"//应用网址
    ////                                   wbApiCls:[WeiboApi class]];
    //
    ////    /**
    ////     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
    ////     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
    ////
    ////     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，
    ////     将QQApiInterface和TencentOAuth的类型传入接口
    ////     **/
    ////    [ShareSDK connectQZoneWithAppKey:@"1104642773"
    ////                           appSecret:@"p7WXeUWH1YPauXJB"
    ////                   qqApiInterfaceCls:[QQApiInterface class]
    ////                     tencentOAuthCls:[TencentOAuth class]];
    //
    //    /**
    //     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
    //     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
    //     **/
    //    [ShareSDK connectQQWithQZoneAppKey:@"1104642773"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    //
    //    //连接短信分享
    //    [ShareSDK connectSMS];
    //
    //    /**
    //     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
    //     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
    //     **/
    ////    [ShareSDK connectWeChatWithAppId:@"wx37fa6b9470efc325"
    //////                           appSecret:@"d2e5a739453c99279511a34ecb6756e0"
    ////                           wechatCls:[WXApi class]];
    //    //魔售
    //    [ShareSDK connectWeChatWithAppId:@"wx741c154fae1ddf53"
    //                                appSecret:@"f23c4433c98880b58330ce71e89fb490"
    //                           wechatCls:[WXApi class]];
    
}

-(void)showShareActionSheetWithView:(UIView*)sender andShareModel:(ShareModel*)model
{
    //    self.shareModel = model;
    ////    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //    //定义分享图片
    //    id<ISSCAttachment> publishImage = nil;
    //    if (model.img.length>0) {
    //        if ([model.img.lowercaseString hasPrefix:@"http:"]) {
    //            publishImage = [ShareSDK imageWithUrl:model.img];
    //        }else
    //        {
    //            NSString *imagePath = kPathOfMainBundle(model.img);
    //            publishImage = [ShareSDK imageWithPath:imagePath];
    //        }
    //    }
    //    NSString* content = nil;
    //    if (model.linkUrl.length>0) {
    //        content = [NSString stringWithFormat:@"%@ %@",model.content,model.linkUrl];
    //    }
    //    else{
    //        content =model.content;
    //    }
    //    //构造分享内容
    //    id<ISSContent> publishContent = [ShareSDK content:content
    //                                       defaultContent:@""
    //                                                image:publishImage
    //                                                title:model.title
    //                                                  url:model.linkUrl
    //                                          description:nil
    //                                            mediaType:SSPublishContentMediaTypeNews];
    //    //创建弹出菜单容器
    //    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    //
    //    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
    //                                                         allowCallback:YES
    //                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
    //                                                          viewDelegate:nil
    //                                               authManagerViewDelegate:nil];
    //    //创建自定义分享列表
    //    NSArray *shareList = [ShareSDK customShareListWithType:[NSNumber numberWithInt:ShareTypeQQ],[NSNumber numberWithInt:ShareTypeSMS],[NSNumber numberWithInt:ShareTypeWeixiSession],[NSNumber numberWithInt:ShareTypeWeixiTimeline],nil];
    //    //弹出分享菜单
    //    [ShareSDK showShareActionSheet:container
    //                         shareList:shareList
    //                           content:publishContent
    //                     statusBarTips:YES
    //                       authOptions:authOptions
    //                      shareOptions:nil
    //                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
    //                                NSString *source;
    //                                if (type == ShareTypeSinaWeibo) {
    //                                    source = @"weibo";
    //                                }else if(type == ShareTypeWeixiTimeline){
    //                                    source = @"friendcircle";
    //                                }else if(type == ShareTypeWeixiSession){
    //                                    source = @"weixin";
    //                                }else if(type == ShareTypeQQSpace){
    //                                    source = @"qqzone";
    //                                }
    //                                else if(type == ShareTypeQQ){
    //                                    source = @"qq";
    //                                }
    //                                else if(type == ShareTypeSMS){
    //                                    source = @"sms";
    //                                }
    //                                if (state == SSResponseStateSuccess)
    //                                {
    //                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
    //                                    
    //                                    //记录分享
    //                                    
    //                                }
    //                                else if (state == SSResponseStateFail)
    //                                {
    //                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
    //                                }
    //                            }];
}

@end