//
//  Functions.m
//  Common
//
//  Created by Ni Laisong on 12-6-6.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "Functions.h"

#import "sys/utsname.h"

NSString * getDeviceId()
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

NSString * getDeviceType()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceType = [NSString stringWithFormat:@"%@",[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    
    return deviceType;
}

NSString *deviceModelName()
{
    NSString* machineType = getDeviceType();
    
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
    
    if ([machineType isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([machineType isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([machineType isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([machineType isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([machineType isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([machineType isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([machineType isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([machineType isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([machineType isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([machineType isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([machineType isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([machineType isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([machineType isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([machineType isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([machineType isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([machineType isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([machineType isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([machineType isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([machineType isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([machineType isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([machineType isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([machineType isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([machineType isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([machineType isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([machineType isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([machineType isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([machineType isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([machineType isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([machineType isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([machineType isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([machineType isEqualToString:@"i386"])  return @"iPhone Simulator";
    
    if ([machineType isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    
    return machineType;
}
//以iPhone5为基础的尺寸换算
CGRect GTRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
//    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    float scale = [UIScreen mainScreen].bounds.size.width/320;
    CGRect rect;
    rect.origin.x = x*scale; rect.origin.y = y*scale;
    rect.size.width = width*scale; rect.size.height = height*scale;
    return rect;
}

CGRect GTRectMake6(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    //    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    float scale = [UIScreen mainScreen].bounds.size.width/375;
    CGRect rect;
    rect.origin.x = x*scale; rect.origin.y = y*scale;
    rect.size.width = width*scale; rect.size.height = height*scale;
    return rect;
}
CGRect GTRectMake12(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    float scale = [UIScreen mainScreen].bounds.size.width/375;
    CGRect rect;
    rect.origin.x = x*scale;rect.origin.y = y;
    rect.size.width = width*scale;rect.size.height = height;
    return rect;
}

double scaleAspectFitRate(CGSize imageSize,CGSize imageViewSize)
{
    double rate;
    if (imageSize.width>imageViewSize.width || imageSize.height>imageViewSize.height) //图片大于显示区，取最大的比率
    {
        if (imageSize.width/imageViewSize.width>imageSize.height/imageViewSize.height) 
        {
            rate=(double)imageViewSize.width/imageSize.width;
        }
        else
        {
            rate=(double)imageViewSize.height/imageSize.height;
        }
    }
    else//图片小于显示区，取最小的比率
    {
        if (imageViewSize.width/imageSize.width>imageViewSize.height/imageSize.height) 
        {
            rate=(double)imageViewSize.height/imageSize.height;
        }
        else
        {
            rate=(double)imageViewSize.width/imageSize.width;
        }
    }
    return rate;
}

NSString* stringWithCString(const char* cString)
{
    if (cString)
    {
        return [NSString stringWithUTF8String:cString];
    }
    else 
    {
        return nil;
    }
}

NSString* filePathWithUrl(NSString* url,NSString* modifyTime,NSString* subDirectory)
{
    NSString *tempName = [NSString stringWithFormat:@"%@%@",url,modifyTime];
    NSString *fileName = tempName.md5Hash;
    
    NSString* filePath = filePathWithFileName(fileName,subDirectory);
    
    return filePath;
}

NSString* filePathWithFileName(NSString* fileName,NSString* subDirectory)
{

    NSString* subPath = [NSString stringWithFormat:@"%@/%@",subDirectory,fileName];
    NSString* filePath = kPathOfCaches(subPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:kPathOfCaches(subDirectory)])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:kPathOfCaches(subDirectory) withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return filePath;
}

NSString* documentFilePathWithUrl(NSString* url,NSString* modifyTime,NSString* subDirectory)
{
    NSString *tempName = [NSString stringWithFormat:@"%@%@",url,modifyTime];
    NSString *fileName = tempName.md5Hash;
    return documentFilePathWithFileName(fileName,subDirectory);
}

NSString* documentFilePathWithFileName(NSString* fileName,NSString* subDirectory)
{
    NSString* subPath = [NSString stringWithFormat:@"%@/%@",subDirectory,fileName];
    NSString* filePath = kPathOfDocument(subPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:kPathOfDocument(subDirectory)])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:kPathOfDocument(subDirectory) withIntermediateDirectories:NO attributes:nil error:nil];
        //禁止icloud备份
        cancelBackupAttributeToItemAtURL([[NSURL alloc] initFileURLWithPath:kPathOfDocument(subDirectory) isDirectory:YES]);
        
    }
    return filePath;
}

BOOL setBackupAttributeToItemAtURL(NSURL *URL,BOOL isBackup)
{
//    if([[UIDevice currentDevice].systemVersion isEqualToString:@"5.0.1"])
//    {
//        const char* filePath = [[URL path] fileSystemRepresentation];
//        
//        const char* attrName = "com.apple.MobileBackup";
//        u_int8_t attrValue = isBackup?0:1;
//        
//        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//        return result == 0;
//    }
//    else
        if ([[UIDevice currentDevice].systemVersion caseInsensitiveCompare:@"5.0.1"] == NSOrderedDescending)
    {
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool:!isBackup]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    else{
        return YES;
    }
}

BOOL cancelBackupAttributeToItemAtURL(NSURL *URL)
{
    return setBackupAttributeToItemAtURL(URL, NO);
}

BOOL addBackupAttributeToItemAtURL(NSURL *URL)
{
    return setBackupAttributeToItemAtURL(URL, YES);
}

NSString* isNil(id object, NSString* defaultValue)
{
    if(object)
    {
        return object;
    }
    else{
        return defaultValue;
    }
}

int calculateTextLength (NSString* strtemp)
{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}

NSArray* readByLineFromFile(NSString* filePath)
{
    const char *filename = [filePath cStringUsingEncoding:NSUTF8StringEncoding]; //文件名
    FILE *fp;
    char StrLine[1024];             //每行最大读取的字符数
    if((fp = fopen(filename,"r")) == NULL) //判断文件是否存在及可读
    {
        printf("error!");
        return nil;
    }
    NSMutableArray* array = [NSMutableArray array];
    while (!feof(fp))
    {
        fgets(StrLine,1024,fp);  //读取一行
        //printf("%s\n", StrLine); //输出
        [array addObject:[NSString stringWithCString:StrLine encoding:NSUTF8StringEncoding]];
    } 
    fclose(fp); //关闭文件
    return array;
}

NSObject* valueForKeyFromPlistFile(NSString*key, NSString*plistFile)
{
    if (![[plistFile pathExtension] isEqualToString:@"plist"])
    {
        plistFile = [plistFile stringByAppendingPathExtension:@"plist"];
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* theme = [userDefaults objectForKey:@"currentTheme"];
    NSString* themePath = [theme objectForKey:@"themePath"];
    NSString* filePath = [themePath  stringByAppendingPathComponent:plistFile];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        filePath = [[NSBundle mainBundle].resourcePath  stringByAppendingPathComponent:plistFile];
    }
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return [dic objectForKey:key];
}

//获取时间函数
NSDate* getNSDateWithDateTimeString(NSString* dateString)
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:dateString];
//    [formatter release];
    return date;
}

NSString* getLocationDateTime()
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
//    [formatter release];
    return dateTime;
}

NSString* getLocationDate()
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    //    [formatter release];
    return dateTime;
}
//NSString * deviceIPAdress()
//{
//    InitAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}

NSString * getJSONString(NSString * aString)
{
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\'" withString:@"\\\'" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

UIFont* getFontWithNameAndSize(NSString*name,float size)
{
    return [UIFont fontWithName:name size:size] ;
}

NSString* adImgUrl(NSString* imgUrl){
    if (imgUrl.length > 0) {
        return [NSString stringWithFormat:@"%@_750x450.%@",imgUrl,imgUrl.pathExtension];  //_640x272
    }
    return imgUrl;
}

NSString* smallImgUrl(NSString* imgUrl)
{
    if (imgUrl.length>0) {
        return [NSString stringWithFormat:@"%@_240x180.%@",imgUrl,imgUrl.pathExtension];
    }
    return imgUrl;
}

NSString* mapBuildingSmallUrl(NSString* imgUrl){
    if (imgUrl.length>0) {
        return [NSString stringWithFormat:@"%@_750x400.%@",imgUrl,imgUrl.pathExtension];
    }
    return imgUrl;
}

NSString* bigImgUrl(NSString* imgUrl)
{
    if (imgUrl.length>0) {
        return [NSString stringWithFormat:@"%@_1200x900.%@",imgUrl,imgUrl.pathExtension];
    }
    return imgUrl;
}

NSString* fullScreen4ImgUrl(NSString* imgUrl)
{
    if (imgUrl.length>0) {
        return [NSString stringWithFormat:@"%@_640x960.%@",imgUrl,imgUrl.pathExtension];
    }
    return imgUrl;
}

NSString* fullScreen6ImgUrl(NSString* imgUrl)
{
    if (imgUrl.length>0) {
        return [NSString stringWithFormat:@"%@_1080x1920.%@",imgUrl,imgUrl.pathExtension];
    }
    return imgUrl;
}
