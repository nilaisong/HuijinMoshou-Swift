//
//  AFHttpRequestManager.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/9/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "NetWork.h"
#import "LocalFileSystem.h"
#import <CommonCrypto/CommonDigest.h>
#import "Tool.h"


static NetWork* afNetworkManager;

@implementation NetWork

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* baseUrl = [LocalFileSystem sharedManager].baseURL;
        afNetworkManager = [self requestWithBaseUrl:baseUrl];
    });
    [afNetworkManager addRequestHeader];

    return afNetworkManager;
}

+(instancetype)managerWithBaseKey:(NSString*)key
{
    NSString* baseUrl = [[LocalFileSystem sharedManager] getBaseUrlWithKey:key];
    NetWork* afRequestManager = [self requestWithBaseUrl:baseUrl];
    [afRequestManager addRequestHeader];
    return afRequestManager;
}

+(instancetype)requestWithBaseUrl:(NSString*)baseUrl
{
    NetWork* afRequestManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    afRequestManager.operationQueue.maxConcurrentOperationCount=4;
    
    //重新初始化requestSerializer
    AFHTTPRequestSerializer* requestSerializer = afRequestManager.requestSerializer;
    [requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [requestSerializer setTimeoutInterval:30];
    [requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [requestSerializer setHTTPShouldHandleCookies:YES];
    //--设置header
    NSString *deviceId = [Tool getDeviceId];
    if (deviceId) {
        //设备UDID
        [requestSerializer setValue:deviceId forHTTPHeaderField:@"deviceId"];
        
    }
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    //系统版本号
    [requestSerializer setValue:iosVersion forHTTPHeaderField:@"osVersion"];
    
    NSString *deviceType = [Tool getDeviceName];
    //手机设备型号
    [requestSerializer setValue:deviceType forHTTPHeaderField:@"deviceName"];
    
    //代表是安卓还是ios的标识，其实用数字标识  2   IOS ，1   Android
    [requestSerializer setValue:@"2" forHTTPHeaderField:@"deviceSource"];
    //程序版本号
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [requestSerializer setValue:appVersion forHTTPHeaderField:@"appVersion"];
    
    //程序名称
    NSString*productName = [LocalFileSystem sharedManager].productName;
    [requestSerializer setValue:productName forHTTPHeaderField:@"appName"];
    
    if([productName isEqualToString:@"moshou"])
        [requestSerializer setValue:@"1" forHTTPHeaderField:@"loginEntry"];
    else if([productName isEqualToString:@"moqueke"])
        [requestSerializer setValue:@"2" forHTTPHeaderField:@"loginEntry"];
    else if([productName isEqualToString:@"mozhanggui"])
        [requestSerializer setValue:@"3" forHTTPHeaderField:@"loginEntry"];
    
    //--重新初始化responseSerializer
    AFJSONResponseSerializer* responseSerializer = (AFJSONResponseSerializer*)afRequestManager.responseSerializer;
    responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // 网络请求空字符 NULL 过滤
    responseSerializer.removesKeysWithNullValues = YES;
    
    return afRequestManager;
}

//重写POST方法
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPRequestSuccess theSuccess = ^(NSURLSessionDataTask *task, id responseObject)
    {
        success(task,responseObject);
        //数据接口请求成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFHTTPRequestSuccess object:nil];
    };
    AFHTTPRequestFailure theFailure = ^(NSURLSessionDataTask *task, NSError *error)
    {
        failure(task,error);
        //数据接口请求失败通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFHTTPRequestFailure object:error];
    };
    return [self POST:URLString parameters:parameters progress:nil success:theSuccess failure:theFailure];
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
    AFHTTPRequestFailure theFailure = ^(NSURLSessionDataTask *task, NSError *error)
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


- (void)addRequestHeader
{
    @synchronized (self)
    {
        //城市名称，6
        NSString* cityNameKey = [NSString stringWithFormat:@"userCityName%@",[Tool getCache:@"newUserId"]];
        NSString* cityName = [Tool getCache:cityNameKey];
        if (!cityName) {
            NSString* newChooseCityNameKay = [NSString stringWithFormat:@"chooseCityName%@",[Tool getCache:@"newUserId"]];
            cityName = [Tool getCache:newChooseCityNameKay];
        }
        if (!cityName) {
            cityName = [Tool getCache:@"locationCityName"];
        }
        if (cityName) {
            cityName = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.requestSerializer setValue:cityName forHTTPHeaderField:@"city"];
        }
        
        //    NSInteger screenScale = [UIScreen mainScreen].scale;
        //    int mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
        //    int mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
        //    [self.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)mainScreenWidth] forHTTPHeaderField:@"SCREENWIDTH"];
        //    [self.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)mainScreenHeight] forHTTPHeaderField:@"SCREENHEIGHT"];
        //    [self.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)screenScale] forHTTPHeaderField:@"SCREENSCALE"];
        
        //    NSString* md5Token = [NSString stringWithFormat:@"%@", getMd5_32Bit_String([NSString stringWithFormat:@"%@|%@|%@|%@|%ld|%ld|%ld|%@", deviceId, iosVersion, deviceType, appVersion, (long)mainScreenWidth, (long)mainScreenHeight, (long)screenScale, moshouEncryptKey])];
        //    //安全校验码，服务器端用来校验比对
        //    [self addRequestHeader:@"MD5TOKEN" value:md5Token];
        //    [self.requestSerializer setValue:md5Token forHTTPHeaderField:@"MD5TOKEN"];
        //用户登录成功后回传过来的token，用以标记用户身份
        NSString*userToken = [Tool getCache:@"user_token"];
        if (userToken) {
            [self.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];
        }else{
            //每次重置请求头之后就不需要这个空token了
            //        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
        }

    }
}

@end
