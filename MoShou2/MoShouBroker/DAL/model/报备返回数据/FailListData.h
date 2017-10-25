//
//  FailListData.h
//  MoShou2
//
//  Created by wangzz on 16/5/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailListData : NSObject

@property(nonatomic,copy) NSString* customerId;//客户id
@property(nonatomic,copy) NSString* buildingId;//楼盘id
@property(nonatomic,copy) NSString* reason;//楼盘仅支持全号报备
@property(nonatomic,copy) NSString* reasonCode;//状态为7时楼盘只支持报备全号,客户需要补全手机号
@property(nonatomic,copy) NSString* name;//客户名
@property(nonatomic,copy) NSArray * phoneList;//手机号数组，数组元素MobileVisible

@end
