//
//  BonusData.h
//  MoShouBroker
//  经纪人佣金数据模型
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommisionData : NSObject
@property(nonatomic,copy) NSString* commission;//佣金数额，标题
@property(nonatomic,copy) NSString* district;//所在区域
@property(nonatomic,copy) NSString* buildingName;//楼盘名称
@property(nonatomic,copy) NSString* customerName;//客户名称
@property(nonatomic,copy) NSString* commissionOpt;//客户名称
@property(nonatomic,copy) NSString* datetime;//日期时间
@property(nonatomic,copy) NSString* commissionStr;//佣金数额，标题


@end
