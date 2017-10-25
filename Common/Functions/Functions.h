//
//  Functions.h
//  Common
//
//  Created by Ni Laisong on 12-6-6.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSStringAdditions.h"

#define kAppBundleId [[NSBundle mainBundle] bundleIdentifier];
//判断是否是iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//判断是否是iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//判断是否是iOS9
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)


//判断是否是ipad
#define isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

//判断是否是iphone6plus (高度)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone6 (高度)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone5 (高度)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphone4 (高度)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


//程序主目录
#define kMainBundlePath [[NSBundle mainBundle] resourcePath]

#define kPathOfMainBundle(x) [[NSBundle mainBundle] pathForResource:x ofType:@""]

#define kPathOfDocument(x) [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),x]

#define kPathOfCaches(x) [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(),x]

#define kFilePathOfTmp(x) [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(),x]

#define kMainScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height


// 颜色值
// 16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// RGB颜色
#define kRGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]

//宏定义调试
#ifdef DEBUG
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define ELog(err) {if(err) DLog(@"%@", err)}
#define STRING(a) [NSString stringWithFormat:@"%@",a] 
#else
#define DLog(...)
#define ELog(err)
#endif

//坐标 位置相关
#define kFrame_X(View) View.frame.origin.x
#define kFrame_Y(View) View.frame.origin.y
#define kFrame_Width(View) View.frame.size.width
#define kFrame_Height(View) View.frame.size.height

#define kFrame_XWidth(View) View.frame.origin.x + View.frame.size.width
#define kFrame_YHeight(View) View.frame.origin.y + View.frame.size.height

#define AlertShow(msg) [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

#define AlertMessage(msg) [[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

#define FONT(s)                  [UIFont systemFontOfSize:s]
#define SCALE                       FULL_WIDTH/320.f//以iPhone5/4为基础的比例
#define SCALE6                       FULL_WIDTH/375.f//以iPhone6基础的比例
#define FULL_WIDTH                  [[UIScreen mainScreen] bounds].size.width

//以iPhone5/4为基础的尺寸换算
CGRect GTRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
//以iPhone6为基础的尺寸换算
CGRect GTRectMake6(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
//以iPhone6为基础的尺寸换算//只有横向
CGRect GTRectMake12(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

double scaleAspectFitRate(CGSize imageSize,CGSize imageViewSize);

NSString* stringWithCString(const char* cString);

NSString* filePathWithUrl(NSString* url,NSString* modifyTime,NSString* subDirectory);
NSString* filePathWithFileName(NSString* fileName,NSString* subDirectory);
NSString* documentFilePathWithUrl(NSString* url,NSString* modifyTime,NSString* subDirectory);
NSString* documentFilePathWithFileName(NSString* fileName,NSString* subDirectory);

BOOL cancelBackupAttributeToItemAtURL(NSURL *URL);
BOOL addBackupAttributeToItemAtURL(NSURL *URL);

NSString* isNil(id object, NSString* defaultValue);

int calculateTextLength (NSString* strtemp);
NSArray* readByLineFromFile(NSString* filePath);
//应用换肤的时候需要用到的方法
NSObject* valueForKeyFromPlistFile(NSString*key, NSString*plistFile);
//获取时间函数
NSDate* getNSDateWithDateTimeString(NSString* dateString);
NSString* getLocationDateTime();
NSString* getLocationDate();
//NSString * deviceIPAdress();
//处理转义字符
NSString * getJSONString(NSString * aString);

UIFont* getFontWithNameAndSize(NSString*name,float size);
//把后台返回的图片地址转换为小图尺寸的地址
NSString* smallImgUrl(NSString* imgUrl);
//把后台返回的图片地址转换为大图尺寸的地址
NSString* bigImgUrl(NSString* imgUrl);
//把后台返回的图片地址转换为iPhone4全屏尺寸的地址
NSString* fullScreen4ImgUrl(NSString* imgUrl);
//把后台返回的图片地址转换为全屏尺寸的地址
NSString* fullScreen6ImgUrl(NSString* imgUrl);
//地图图片尺寸
NSString* mapBuildingSmallUrl(NSString* imgUrl);
//首页广告图切图
NSString* adImgUrl(NSString* imgUrl);
