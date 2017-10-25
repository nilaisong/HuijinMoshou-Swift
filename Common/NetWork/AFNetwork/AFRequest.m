//
//  AFHttpRequestManager.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/9/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "AFRequest.h"
#import "LocalFileSystem.h"
#import <CommonCrypto/CommonDigest.h>
#import "Tool.h"
#import "SSKeychain.h"
#import "sys/utsname.h"

@implementation AFRequest

+ (instancetype)manager
{
    NSString* baseUrl = [LocalFileSystem sharedManager].baseURL;
    AFRequest* afRequestManager = [self requestWithBaseUrl:baseUrl];
    return afRequestManager;
}

+(instancetype)managerWithBaseKey:(NSString*)key
{
    NSString* baseUrl = [[LocalFileSystem sharedManager] getBaseUrlWithKey:key];
    return [self requestWithBaseUrl:baseUrl];
}

+(instancetype)requestWithBaseUrl:(NSString*)baseUrl
{
    AFRequest* afRequestManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    afRequestManager.operationQueue.maxConcurrentOperationCount=4;
    afRequestManager.responseSerializer.acceptableContentTypes = [afRequestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [afRequestManager.requestSerializer setTimeoutInterval:30];
    [afRequestManager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [afRequestManager.requestSerializer setHTTPShouldHandleCookies:YES];
    [afRequestManager addDeviceHeader];
    return afRequestManager;
}
//
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [super POST:URLString parameters:parameters success:success failure:failure];
}

//同步请求
- (NSURLSessionDataTask *)syncPost:(NSString *)url  parameters:(id)parameters
                                                success:(AFHTTPRequestSuccess)success
                                                failure:(AFHTTPRequestFailure)failure
{
    
    __block BOOL syncComplete = NO;
    AFHTTPRequestSuccess theSuccess = ^(NSURLSessionDataTask *task, id responseObject)
    {
        success(task,responseObject);
        syncComplete  = YES;
    };
    AFHTTPRequestSuccess theFailure = ^(NSURLSessionDataTask *task, NSError *error)
    {
        failure(task,error);
        syncComplete  = YES;
    };
    
    NSURLSessionDataTask *task = [self POST:url parameters:parameters
       success:theSuccess
       failure:theFailure];
    //如果没返回结果就一直执行下去，模拟同步执行
    while (!syncComplete) {
//        NSLog(@"runloop…");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        NSLog(@"runloop end.");
    }
    return task;
}

-(NSString *)getDeviceId
{
    NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *keychainservice = bundleId;
    NSString *keychainaccount = [bundleId stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *deviceId = [SSKeychain passwordForService:keychainservice account:keychainaccount];
    if(deviceId == nil)
    {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString *deviceIdCache = [setting objectForKey:@"DeviceIdCache"];
        if (deviceIdCache.length==0) {
            
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            deviceId = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
            
            [setting setObject:deviceId forKey:@"DeviceIdCache"];
            [setting synchronize];
        }else{
            deviceId = deviceIdCache;
        }
        
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", deviceId]
                     forService:keychainservice account:keychainaccount];
        
    }
    return deviceId;
}


-(NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceType = [NSString stringWithFormat:@"%@",[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    
    return deviceType;
}

-(NSString *)deviceModelName
{
    NSString* machineType = [self getDeviceType];
    
    if ([machineType isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([machineType isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([machineType isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([machineType isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([machineType isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([machineType isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([machineType isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([machineType isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([machineType isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([machineType isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([machineType isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([machineType isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([machineType isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([machineType isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([machineType isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([machineType isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";
    if ([machineType isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";
    if ([machineType isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
    if ([machineType isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
    if ([machineType isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
    
    if ([machineType isEqualToString:@"iPad1,1"])   return @"iPad 1";
    
    if ([machineType isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([machineType isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([machineType isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([machineType isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([machineType isEqualToString:@"iPad2,5"])   return @"iPad Mini 1";
    if ([machineType isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";
    if ([machineType isEqualToString:@"iPad2,7"])   return @"iPad Mini 1";
    
    if ([machineType isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([machineType isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([machineType isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([machineType isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([machineType isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([machineType isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([machineType isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([machineType isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([machineType isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([machineType isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";
    if ([machineType isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";
    if ([machineType isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";
    
    if ([machineType isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([machineType isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return machineType;
}

////和md5Hash一样
//NSString *getMd5_32Bit_String( NSString * srcString)
//{
//    
//    const char *cStr = [srcString UTF8String ];
//    
//    unsigned char digest[ CC_MD5_DIGEST_LENGTH ];
//    
//    CC_MD5 ( cStr, (CC_LONG)strlen (cStr), digest );
//    
//    NSMutableString *result = [ NSMutableString stringWithCapacity : CC_MD5_DIGEST_LENGTH * 2 ];
//    
//    for ( int i = 0 ; i < CC_MD5_DIGEST_LENGTH ; i++)
//        
//        [result appendFormat : @"%02x" , digest[i]];
//    
//    return result;
//}

- (void)addDeviceHeader
{
    NSString *deviceId = [self getDeviceId];
    //设备UDID
    [self.requestSerializer setValue:deviceId forHTTPHeaderField:@"DEVICEID"];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    //系统版本号
    [self.requestSerializer setValue:iosVersion forHTTPHeaderField:@"OSVERSION"];
    NSString *deviceType = [self getDeviceType];
    //手机设备类型
    [self.requestSerializer setValue:deviceType forHTTPHeaderField:@"DEVICETYPE"];
    //代表是安卓还是ios的标识，其实用数字标识  2   IOS ，1   Android
    [self.requestSerializer setValue:@"2" forHTTPHeaderField:@"deviceSource"];
    //城市名称
    NSString* cityNameKey = [NSString stringWithFormat:@"userCityName%@",[Tool getCache:@"userId"]];
    NSString* cityName = [Tool getCache:cityNameKey];
    if (cityName.length==0) {
        cityName = [Tool getCache:@"locationCityName"];
    }
    if (cityName.length>0) {
        [self.requestSerializer setValue:cityName forHTTPHeaderField:@"city"];
    }
    //程序版本号
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self.requestSerializer setValue:appVersion forHTTPHeaderField:@"APPVERSION"];
    
    //程序名称
    NSString*productName = [LocalFileSystem sharedManager].productName;
    [self.requestSerializer setValue:@"APPNAME" forHTTPHeaderField:productName];
    
    
    NSInteger screenScale = [UIScreen mainScreen].scale;
    int mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    int mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)mainScreenWidth] forHTTPHeaderField:@"SCREENWIDTH"];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)mainScreenHeight] forHTTPHeaderField:@"SCREENHEIGHT"];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)screenScale] forHTTPHeaderField:@"SCREENSCALE"];
    //    NSString* md5Token = [NSString stringWithFormat:@"%@", getMd5_32Bit_String([NSString stringWithFormat:@"%@|%@|%@|%@|%ld|%ld|%ld|%@", deviceId, iosVersion, deviceType, appVersion, (long)mainScreenWidth, (long)mainScreenHeight, (long)screenScale, moshouEncryptKey])];
    //    //安全校验码，服务器端用来校验比对
    //    [self addRequestHeader:@"MD5TOKEN" value:md5Token];
//    [self.requestSerializer setValue:md5Token forHTTPHeaderField:@"MD5TOKEN"];
    //用户登录成功后回传过来的token，用以标记用户身份
    NSString*userToken = [Tool getCache:@"user_token"];
    if (userToken) {
        [self.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];

    }
}

@end
