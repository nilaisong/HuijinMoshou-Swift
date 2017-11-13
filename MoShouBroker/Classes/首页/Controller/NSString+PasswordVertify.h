//
//  NSString+PasswordVertify.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//  校验密码

#import <Foundation/Foundation.h>

@interface NSString (PasswordVertify)


/**
 校验密码是否坚强
 */
- (BOOL)isLegal;

@end
