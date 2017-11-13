//
//  NSString+TKUtilities.h
//  TKContactsMultiPicker
//
//  Created by 종태 안 on 12. 5. 17..
//  Copyright (c) 2012년 Tabko Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TKUtilities)

- (BOOL)containsString:(NSString *)aString;
- (NSString*)telephoneWithReformat;

//add by wangzz 150928  判断楼盘数
- (NSAttributedString *)transferLouPanString;

- (NSString *)trimWhitespace;
- (NSUInteger)numberOfLines;

+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

@end
