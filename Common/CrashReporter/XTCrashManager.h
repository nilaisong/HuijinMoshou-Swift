//
//  XTCrashManager.h
//  PLCrashReporterDemo
//
//  Created by xiaotei's MacBookPro on 16/11/23.
//  Copyright © 2016年 xiaotei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CrashManagerReportCallBack)(NSString* reportPath);

@interface XTCrashManager : NSObject

+ (instancetype)shareManager;

/**
 *phone 用户手机号
 *city  城市
 *device 手机型号
 *version app版本
 *domain 当前域名
 */
- (void)initAppInfoWithPhone:(NSString*)phone city:(NSString*)city  version:(NSString*)version domain:(NSString*)domain reportCallBack:(CrashManagerReportCallBack)callBack;

//- (void)crashReportCallBack:(CrashManagerReportCallBack)callBack;
@end
