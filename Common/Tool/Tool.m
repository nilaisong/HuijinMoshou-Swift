//
//  Tool.m
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tool.h"
#import "TipsView.h"
@implementation Tool

+(NSString *) getDeviceId
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

+(NSString*) getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceType = [NSString stringWithFormat:@"%@",[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    
    return deviceType;
}

+(NSString*)getDeviceName
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

+ (void)showTextHUD:(NSString *)text andView:(UIView *)view
{
    [TipsView showTips:text inView:view];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = text;
//    hud.margin = 30.f;
//    hud.yOffset = -50.f;
//    hud.removeFromSuperViewOnHide = YES;
//
//    [hud hide:YES afterDelay:1];
}
+ (void)showImageHUD:(NSString *)imgName andView:(UIView *)view

{
    [TipsView showTipImage:imgName inView:view];
}
+ (void)setCache:(NSString *)key value:(id)value{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (value==nil) {
        [setting removeObjectForKey:key];
    }
    else
    {
        [setting setObject:value forKey:key];
    }
    [setting synchronize];
}

+ (id)getCache:(NSString *)key{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    id value = [setting objectForKey:key];
    return value;
}

+ (void)removeCache:(NSString *)key
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:key];
    if (value) {
        [setting removeObjectForKey:key];
        [setting synchronize];
    }
}

+ (int)getCnCharNum:(NSString *)text{
    
    //NSString *temp = nil;
    int num = 0;
    for(int i =0; i < [text length]; i++)
    {
        //temp = [text substringWithRange:NSMakeRange(i, 1)];
        unichar a = [text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            num += 1;
        }
        //NSLog(@"第%d个字是:%@",i,temp);
    }
    return num;
    
}

+ (BOOL)validateMobile:(NSString *)mobile{
    
    NSString *phoneRegex = @"^(1[3456789]{1})\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


+(int)getRandomNumber:(int)from to:(int)to

{
//    NSLog(@"from:%d",from);
//    NSLog(@"to:%d",to);
    if (from < to) {
        return (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
    }else{
        return (int)(to + (arc4random() % (from - to + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
    }
}

//计算输入本文的长度
+ (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}


+(CGSize )getTextSizeWithText:(NSString *)text andFontSize:(float)size{
    CGSize fsize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    return  fsize;
}

+ (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font width:(float)width;
{
//    NSLog(@"string == %@",string);
    CGRect rect = CGRectZero;
    if (string ) {
        NSCharacterSet *charact = [NSCharacterSet whitespaceCharacterSet];
        NSString *searchStr = [string stringByTrimmingCharactersInSet:charact];
        if (![searchStr isEqual:@""]) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string
                                                                                 attributes:attributes];
            rect = [attributedText
                    boundingRectWithSize:CGSizeMake(width, 50000.0f)
                    options:NSStringDrawingUsesLineFragmentOrigin
                    context:nil];
        }
        
        
    }
    return rect.size;
    
}

+(BOOL)archiveObject:(id)object withKey:(NSString*)key ToPath:(NSString*)path
{
    NSMutableData *buildingData= [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver= [[NSKeyedArchiver alloc]initForWritingWithMutableData:buildingData];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    return [buildingData writeToFile:path atomically:YES];
}

+(id)unarchiveObjectWithKey:(NSString*)key fromPath:(NSString*)path
{
    NSData *data= [[NSMutableData alloc]initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object= [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return object;
}

@end












