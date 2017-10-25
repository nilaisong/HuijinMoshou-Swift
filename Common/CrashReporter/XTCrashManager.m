//
//  XTCrashManager.m
//  PLCrashReporterDemo
//
//  Created by xiaotei's MacBookPro on 16/11/23.
//  Copyright © 2016年 xiaotei. All rights reserved.
//

#import "XTCrashManager.h"
#import <CrashReporter/CrashReporter.h>

@interface XTCrashManager()

@property (nonatomic,strong)NSMutableDictionary* userInfoDict;

@property (nonatomic,strong)NSMutableArray* userInfoArray;

@property (nonatomic,copy)CrashManagerReportCallBack callBack;

@end

@implementation XTCrashManager

static XTCrashManager *_manager;


+ (instancetype)shareManager{
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[XTCrashManager alloc]init];
        });
    }
    return _manager;
}

- (void)initAppInfoWithPhone:(NSString *)phone city:(NSString *)city version:(NSString *)version domain:(NSString *)domain reportCallBack:(CrashManagerReportCallBack)callBack{
    [self.userInfoArray removeAllObjects];
    if (phone.length > 0) {
        [self.userInfoDict setObject:phone forKey:@"手机号"];
        [self.userInfoArray addObject:[NSString stringWithFormat:@"手机号:%@",phone]];
    }
    if (city.length > 0) {
        [self.userInfoDict setObject:city forKey:@"城市"];
        [self.userInfoArray addObject:[NSString stringWithFormat:@"城市:%@",city]];
    }
    if (version.length > 0) {
        [self.userInfoDict setObject:version forKey:@"APP版本"];
        [self.userInfoArray addObject:[NSString stringWithFormat:@"APP版本:%@",version]];
    }
    if (domain.length > 0) {
        [self.userInfoDict setObject:domain forKey:@"域名"];
        [self.userInfoArray addObject:[NSString stringWithFormat:@"域名:%@",domain]];
    }
    _callBack = callBack;
    [self crashReportInit];
}

- (void)crashReportCallBack:(CrashManagerReportCallBack)callBack{
    _callBack = callBack;
}

- (void)crashReportInit{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    if ([crashReporter hasPendingCrashReport]) {
        [self myHandleCrashReport];
    }
    
    if (![crashReporter enableCrashReporterAndReturnError:&error]) {
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }
}

-(void)myHandleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
     crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    
    
    
    PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    [self.userInfoArray addObject:[NSString stringWithFormat:@"应用名称:%@",app_Name]];
    [self.userInfoArray addObject:[NSString stringWithFormat:@"操作系统版本:%@",report.systemInfo.operatingSystemVersion]];
    [self.userInfoArray addObject:[NSString stringWithFormat:@"手机型号:%@\n",[self deviceStylsWithmodelName:report.machineInfo.modelName]]];
    [self.userInfoArray addObject:[NSString stringWithFormat:@"应用程序ID:%@\n",report.applicationInfo.applicationIdentifier]];
    [self.userInfoArray addObject:[NSString stringWithFormat:@"异常名字:%@\n",report.exceptionInfo.exceptionName]];
    NSString *address = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1llx",report.signalInfo.address]];
    [self.userInfoArray addObject:[NSString stringWithFormat:@"异常信息:%@ %@\n",report.exceptionInfo.exceptionReason,address]];

    if (report.images.count > 0) {
        PLCrashReportBinaryImageInfo* imgInfo = [report.images firstObject];
        if (imgInfo.imageUUID.length > 0) {
            [self.userInfoArray addObject:[NSString stringWithFormat:@"imageUUID:%@\n",imgInfo.imageUUID]];
        }
    }
    NSString* crashName = report.exceptionInfo.exceptionName;
    if (crashName.length <= 0 || [crashName isKindOfClass:[NSNull class]] || crashName == nil) {
        return;
    }
    
    NSString* exceptionText = [self getExcStringWith:report];
    [self.userInfoArray addObject:exceptionText];
    
    NSMutableString* crashTxt = [NSMutableString string];
    for (NSString* string in self.userInfoArray) {
        if ([string isKindOfClass:[NSString class]]) {
            if (string.length > 0) {
                [crashTxt appendFormat:@"%@\n",string];
            }
        }
    }
    
    NSData* myCrashData = [crashTxt dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取document路径
    NSArray *docPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPathArray firstObject];
    NSString *path = [docPath stringByAppendingString:@"/crashdata.txt"];
    BOOL success = [myCrashData writeToFile:path atomically:YES];
    if (success && _callBack) {
        _callBack(path);
        [crashReporter purgePendingCrashReport];
    }
    
    if (report == nil) {
        NSLog(@"Could not parse crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    
    /* CrashData 还需要用 PLCrashReporter 的工具 crashutil 解析，也可以直接保存成字符串*/

//    NSLog(@"Report: %@", humanReadable);
    
}

- (NSMutableArray *)userInfoArray{
    if (!_userInfoArray) {
        NSMutableArray* arrayM = [NSMutableArray array];
        _userInfoArray = arrayM;
    }
    return _userInfoArray;
}

- (NSMutableDictionary *)userInfoDict{
    if (!_userInfoDict) {
        NSMutableDictionary* dicM = [NSMutableDictionary dictionary];
        _userInfoDict = dicM;
    }
    return _userInfoDict;
}

//获取手机型号
- (NSString*)deviceStylsWithmodelName:(NSString*)platform{
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
    
    if ([platform isEqualToString:@"i386"])return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";

    return @"";
}

/**
 * Format a stack frame for display in a thread backtrace.
 *
 * @param frameInfo The stack frame to format
 * @param frameIndex The frame's index
 * @param report The report from which this frame was acquired.
 * @param lp64 If YES, the report was generated by an LP64 system.
 *
 * @return Returns a formatted frame line.
 */
- (NSString *) formatStackFrame: (PLCrashReportStackFrameInfo *) frameInfo
                     frameIndex: (NSUInteger) frameIndex
                         report: (PLCrashReport *) report
                           lp64: (BOOL) lp64
{
    /* Base image address containing instrumention pointer, offset of the IP from that base
     * address, and the associated image name */
    uint64_t baseAddress = 0x0;
    uint64_t pcOffset = 0x0;
    NSString *imageName = @"\?\?\?";
    NSString *symbolString = nil;
    
    PLCrashReportBinaryImageInfo *imageInfo = [report imageForAddress: frameInfo.instructionPointer];
    if (imageInfo != nil) {
        imageName = [imageInfo.imageName lastPathComponent];
        baseAddress = imageInfo.imageBaseAddress;
        pcOffset = frameInfo.instructionPointer - imageInfo.imageBaseAddress;
    }
    
    /* If symbol info is available, the format used in Apple's reports is Sym + OffsetFromSym. Otherwise,
     * the format used is imageBaseAddress + offsetToIP */
    if (frameInfo.symbolInfo != nil) {
        NSString *symbolName = frameInfo.symbolInfo.symbolName;
        
        /* Apple strips the _ symbol prefix in their reports. Only OS X makes use of an
         * underscore symbol prefix by default. */
        if ([symbolName rangeOfString: @"_"].location == 0 && [symbolName length] > 1) {
            switch (report.systemInfo.operatingSystem) {
                case PLCrashReportOperatingSystemMacOSX:
                case PLCrashReportOperatingSystemiPhoneOS:
                case PLCrashReportOperatingSystemiPhoneSimulator:
                    symbolName = [symbolName substringFromIndex: 1];
                    break;
                    
                default:
                    NSLog(@"Symbol prefix rules are unknown for this OS!");
                    break;
            }
        }
        
        
        uint64_t symOffset = frameInfo.instructionPointer - frameInfo.symbolInfo.startAddress;
        symbolString = [NSString stringWithFormat: @"%@ + %" PRId64, symbolName, symOffset];
    } else {
        symbolString = [NSString stringWithFormat: @"0x%" PRIx64 " + %" PRId64, baseAddress, pcOffset];
    }
    
    /* Note that width specifiers are ignored for %@, but work for C strings.
     * UTF-8 is not correctly handled with %s (it depends on the system encoding), but
     * UTF-16 is supported via %S, so we use it here */
    return [NSString stringWithFormat: @"%-4ld%-35S 0x%0*" PRIx64 " %@\n",
            (long) frameIndex,
            (const uint16_t *)[imageName cStringUsingEncoding: NSUTF16StringEncoding],
            lp64 ? 16 : 8, frameInfo.instructionPointer,
            symbolString];
}

//解析崩溃地址
- (NSString*)getExcStringWith:(PLCrashReport*)report{
    boolean_t lp64 = true; // quiesce GCC uninitialized value warning
    
    /* Header */
    
    /* Map to apple style OS nane */
    NSString *osName;
    switch (report.systemInfo.operatingSystem) {
        case PLCrashReportOperatingSystemMacOSX:
            osName = @"Mac OS X";
            break;
        case PLCrashReportOperatingSystemiPhoneOS:
            osName = @"iPhone OS";
            break;
        case PLCrashReportOperatingSystemiPhoneSimulator:
            osName = @"Mac OS X";
            break;
        default:
            osName = [NSString stringWithFormat: @"Unknown (%d)", report.systemInfo.operatingSystem];
            break;
    }
    
    /* Map to Apple-style code type, and mark whether architecture is LP64 (64-bit) */
    NSString *codeType = nil;
    {
        /* Attempt to derive the code type from the binary images */
        for (PLCrashReportBinaryImageInfo *image in report.images) {
            /* Skip images with no specified type */
            if (image.codeType == nil)
                continue;
            
            /* Skip unknown encodings */
            if (image.codeType.typeEncoding != PLCrashReportProcessorTypeEncodingMach)
                continue;
            
            switch (image.codeType.type) {
                case CPU_TYPE_ARM:
                    codeType = @"ARM";
                    lp64 = false;
                    break;
                    
                case CPU_TYPE_X86:
                    codeType = @"X86";
                    lp64 = false;
                    break;
                    
                case CPU_TYPE_X86_64:
                    codeType = @"X86-64";
                    lp64 = true;
                    break;
                    
                case CPU_TYPE_POWERPC:
                    codeType = @"PPC";
                    lp64 = false;
                    break;
                    
                default:
                    // Do nothing, handled below.
                    break;
            }
            
            /* Stop immediately if code type was discovered */
            if (codeType != nil)
                break;
        }
        
        /* If we were unable to determine the code type, fall back on the legacy architecture value. */
        if (codeType == nil) {
            switch (report.systemInfo.architecture) {
                case PLCrashReportArchitectureARMv6:
                case PLCrashReportArchitectureARMv7:
                    codeType = @"ARM";
                    lp64 = false;
                    break;
                case PLCrashReportArchitectureX86_32:
                    codeType = @"X86";
                    lp64 = false;
                    break;
                case PLCrashReportArchitectureX86_64:
                    codeType = @"X86-64";
                    lp64 = true;
                    break;
                case PLCrashReportArchitecturePPC:
                    codeType = @"PPC";
                    lp64 = false;
                    break;
                default:
                    codeType = [NSString stringWithFormat: @"Unknown (%d)", report.systemInfo.architecture];
                    lp64 = true;
                    break;
            }
        }
    }
    
    NSMutableString* text = [NSMutableString string];
    if (report.exceptionInfo != nil && report.exceptionInfo.stackFrames != nil && [report.exceptionInfo.stackFrames count] > 0) {
        PLCrashReportExceptionInfo *exception = report.exceptionInfo;
        
        /* Create the header. */
        [text appendString: @"Last Exception Backtrace:\n"];
        
        /* Write out the frames. In raw reports, Apple writes this out as a simple list of PCs. In the minimally
         * post-processed report, Apple writes this out as full frame entries. We use the latter format. */
        
        for (NSUInteger frame_idx = 0; frame_idx < [exception.stackFrames count]; frame_idx++) {
            PLCrashReportStackFrameInfo *frameInfo = [exception.stackFrames objectAtIndex: frame_idx];
            [text appendString: [self formatStackFrame: frameInfo frameIndex: frame_idx report: report lp64: lp64]];
        }
    }
    
    return text;
}

@end
