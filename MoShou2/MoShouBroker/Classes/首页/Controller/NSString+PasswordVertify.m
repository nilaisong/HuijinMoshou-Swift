//
//  NSString+PasswordVertify.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "NSString+PasswordVertify.h"

@implementation NSString (PasswordVertify)

- (BOOL)isLegal{
    //密码过于简单，建议使用数字、字母和符号两种及以上的组合，6-20个字符
//    //纯字母
//    NSString* reguler1 = @"^[a-zA-Z]*$";
//    //纯数字
//    NSString* reguler2 = @"^[0-9]*$";
    //符号
//    Pattern pattern4 = Pattern.compile("^[^a-z0-9A-Z]*$");
    NSString *pattern = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    
    
    return isMatch;
}

@end
