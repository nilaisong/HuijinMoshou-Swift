//
//  ChineseString.h
//  MoShouBroker
//  按拼音排序后的联系人数据模型
//  Created by wangzz on 15/7/15.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseString : NSObject

@property(copy,nonatomic)NSString *string;//联系人姓名
@property(copy,nonatomic)NSString *pinYin;//临时缓存拼音
@property(copy,nonatomic)NSString *telNumber;//电话号码
@property(copy,nonatomic)NSString *custId;
@property(copy,nonatomic)NSString *purchaseInte;
@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *count;
@property(assign,nonatomic)BOOL   bIsDefine;
@property(copy,nonatomic)NSString *defineText;
@property(copy,nonatomic)NSString *cardId;
@property(copy,nonatomic)NSString *custSource;
@property(copy,nonatomic)NSString *custSourceLabel;
@property(strong,nonatomic)NSArray *phone;

@end
