//
//  Tool.h
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SSKeychain.h"
#import "sys/utsname.h"

#import "MBProgressHUD.h"

@interface Tool : NSObject

+ (NSString *) getDeviceId;
+ (NSString *)getDeviceName;

+ (void)showTextHUD:(NSString *)text andView:(UIView *)view;
+ (void)showImageHUD:(NSString *)imgName andView:(UIView *)view;

+ (void)setCache:(NSString *)key value:(id)value;
+ (id)getCache:(NSString *)key;
+ (void)removeCache:(NSString *)key;

+ (int)getCnCharNum:(NSString *)value;

+ (BOOL)validateMobile:(NSString *)mobile;

+ (int)getRandomNumber:(int)from to:(int)to;

+ (int)textLength:(NSString *)text;


+(CGSize )getTextSizeWithText:(NSString *)text andFontSize:(float)size;

+ (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font width:(float)width;

+(BOOL)archiveObject:(id)object withKey:(NSString*)key ToPath:(NSString*)path;
+(id)unarchiveObjectWithKey:(NSString*)key fromPath:(NSString*)path;

@end
