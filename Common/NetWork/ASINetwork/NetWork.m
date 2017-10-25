//
//  NetWork.m
//  Council
//
//  Created by lwq on 14-8-19.
//  Copyright (c) 2014年 LJS. All rights reserved.
//

#import "NetWork.h"
#import "SSKeychain.h"
#import "sys/utsname.h"
#import "Tool.h"
// Need to import for CC_MD5 access
#import <CommonCrypto/CommonDigest.h>

@implementation NetWork

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

//和md5Hash一样
NSString *getMd5_32Bit_String( NSString * srcString)
{
    
    const char *cStr = [srcString UTF8String ];
    
    unsigned char digest[ CC_MD5_DIGEST_LENGTH ];
    
    CC_MD5 ( cStr, (CC_LONG)strlen (cStr), digest );
    
    NSMutableString *result = [ NSMutableString stringWithCapacity : CC_MD5_DIGEST_LENGTH * 2 ];
    
    for ( int i = 0 ; i < CC_MD5_DIGEST_LENGTH ; i++)
        
        [result appendFormat : @"%02x" , digest[i]];
    
    return result;
}

- (void)addDeviceHeader
{
    //设备标示
    NSString *deviceId = [self getDeviceId];
    [self addRequestHeader:@"DEVICEID" value:deviceId];
    //系统版本号
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    [self addRequestHeader:@"OSVERSION" value:iosVersion];
    //设备型号
    NSString *deviceType = [self getDeviceType];
    [self addRequestHeader:@"DEVICETYPE" value:deviceType];
    //代表是安卓还是ios的标识，其实用数字标识  2  IOS ，1   Android
    [self addRequestHeader:@"deviceSource" value:@"2"];
    //城市名称
    NSString* cityNameKey = [NSString stringWithFormat:@"userCityName%@",[Tool getCache:@"newUserId"]];
    NSString* cityName = [Tool getCache:cityNameKey];
    if (cityName.length==0) {
        cityName = [Tool getCache:@"locationCityName"];
    }
    if (cityName.length>0) {
        [self addRequestHeader:@"city" value:cityName];
    }
    //程序版本号
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self addRequestHeader:@"APPVERSION" value:appVersion];
    //程序名称
    NSString*productName = [LocalFileSystem sharedManager].productName;
    [self addRequestHeader:@"APPNAME" value:productName];
    //程序类别
    if([productName isEqualToString:@"moshou"])
         [self addRequestHeader:@"loginEntry" value:@"1"];
    else if([productName isEqualToString:@"moqueke"])
        [self addRequestHeader:@"loginEntry" value:@"2"];
    else if([productName isEqualToString:@"mozhanggui"])
        [self addRequestHeader:@"loginEntry" value:@"3"];
    
    NSInteger screenScale = [UIScreen mainScreen].scale;
    int mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    int mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    [self addRequestHeader:@"SCREENWIDTH" value:[NSString stringWithFormat:@"%ld",(long)mainScreenWidth]];
    [self addRequestHeader:@"SCREENHEIGHT" value:[NSString stringWithFormat:@"%ld",(long)mainScreenHeight]];
    [self addRequestHeader:@"SCREENSCALE" value:[NSString stringWithFormat:@"%ld",(long)screenScale]];

//    NSString* md5Token = [NSString stringWithFormat:@"%@", getMd5_32Bit_String([NSString stringWithFormat:@"%@|%@|%@|%@|%ld|%ld|%ld|%@", deviceId, iosVersion, deviceType, appVersion, (long)mainScreenWidth, (long)mainScreenHeight, (long)screenScale, moshouEncryptKey])];
//    //安全校验码，服务器端用来校验比对
//    [self addRequestHeader:@"MD5TOKEN" value:md5Token];
    //用户登录成功后回传过来的token，用以标记用户身份
    NSString*userToken = [Tool getCache:@"user_token"];
    if (userToken) {
        [self addRequestHeader:@"token" value:userToken];
    }

}

- (id)initWithUrlString:(NSString *)urlString{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self initWithURL:[NSURL URLWithString:urlString]])
    {
        [self setTimeOutSeconds:30];//请求多长时间没反应，算是超时
        self.useSessionPersistence = NO;
        self.useCookiePersistence = NO;
        self.defaultResponseEncoding = NSUTF8StringEncoding;
//        [self setValidatesSecureCertificate:NO];
        [self addDeviceHeader];
    };
    return self;
}


+ (id)requestWithUrlString:(NSString *)urlString
{
	return [[self alloc] initWithUrlString:urlString];
}

@end
