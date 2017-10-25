//
//  MyUncaughtExceptionHandler.m
//  MoShou2
//
//  Created by Mac on 2017/4/17.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "MyUncaughtExceptionHandler.h"
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import "UserData.h"
#import <sys/utsname.h>


NSString *iphoneType()
{
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}



static NSUUID *ExecutableUUID(void)
{
    const struct mach_header *executableHeader = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++)
    {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE)
        {
            executableHeader = header;
            break;
        }
    }
    if (!executableHeader)
        return nil;
    
    BOOL is64bit = executableHeader->magic == MH_MAGIC_64 || executableHeader->magic == MH_CIGAM_64;
    uintptr_t cursor = (uintptr_t)executableHeader + (is64bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
    const struct segment_command *segmentCommand = NULL;
    for (uint32_t i = 0; i < executableHeader->ncmds; i++, cursor += segmentCommand->cmdsize)
    {
        segmentCommand = (struct segment_command *)cursor;
        if (segmentCommand->cmd == LC_UUID)
        {
            const struct uuid_command *uuidCommand = (const struct uuid_command *)segmentCommand;
            return [[NSUUID alloc] initWithUUIDBytes:uuidCommand->uuid];
        }
    }
    
    return nil;
}



// 沙盒的地址
NSString * applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// 崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception) {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSMutableArray *infoArr = [NSMutableArray array];
    NSString* phone = [UserData sharedUserData].mobile;
    NSString* city =  [UserData sharedUserData].cityName;
    NSString* version = [LocalFileSystem sharedManager].versionName;
    NSString* domain = [LocalFileSystem sharedManager].baseURL;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *iphoneTypeString = iphoneType();
    NSUUID *uuiddddd =  ExecutableUUID();
    NSString *uuidString = [uuiddddd UUIDString];
    

    
    if (phone.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"手机号:%@",phone]];
    }
    if (city.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"城市:%@",city]];
    }
    if (version.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"APP版本%@",version]];
    }
    if (domain.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"域名:%@",domain]];
    }
    if (app_Name.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"应用名称:%@",app_Name]];
    }
    [infoArr addObject:[NSString stringWithFormat:@"操作系统版本:%@",[[UIDevice currentDevice] systemVersion]]];
    [infoArr addObject:[NSString stringWithFormat:@"手机型号:%@",iphoneTypeString]];
    [infoArr addObject:[NSString stringWithFormat:@"应用程序ID: %@",[[NSBundle mainBundle]bundleIdentifier]]];
    NSString * url = [NSString stringWithFormat:@" %@ \nimageUUID:%@\n 异常名字name:%@\n 异常原因reason:\n%@\n 异常详细信息callStackSymbols:\n%@",[infoArr componentsJoinedByString:@"\n"],uuidString,name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

    
}


@implementation MyUncaughtExceptionHandler


// 沙盒地址
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler {
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSMutableArray *infoArr = [NSMutableArray array];
    NSString* phone = [UserData sharedUserData].mobile;
    NSString* city =  [UserData sharedUserData].cityName;
    NSString* version = [LocalFileSystem sharedManager].versionName;
    NSString* domain = [LocalFileSystem sharedManager].baseURL;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    if (phone.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"手机号:%@",phone]];
    }
    if (city.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"城市:%@",city]];
    }
    if (version.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"APP版本%@",version]];
    }
    if (domain.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"域名:%@",domain]];
    }
    if (app_Name.length>0) {
        [infoArr addObject:[NSString stringWithFormat:@"应用名称:%@",app_Name]];
    }
    
    [infoArr addObject:[NSString stringWithFormat:@"操作系统版本:%f",[[[UIDevice currentDevice] systemVersion] floatValue]]];
    [infoArr addObject:[NSString stringWithFormat:@"手机型号:%@",[UIDevice currentDevice].model]];
    
    [infoArr addObject:[NSString stringWithFormat:@"应用程序ID: %@",[[NSBundle mainBundle]bundleIdentifier]]];
    
    NSString * url = [NSString stringWithFormat:@" %@ \n 异常名字name:%@\n 异常原因reason:\n%@\n 异常详细信息callStackSymbols:\n%@",[infoArr componentsJoinedByString:@"\n"],name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSLog(@"path = %@",path);
    
}





@end
