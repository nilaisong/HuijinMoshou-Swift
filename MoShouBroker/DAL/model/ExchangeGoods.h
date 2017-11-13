//
//  ExchangeGoods.h
//  MoShouBroker
//  积分兑换的商品数据模型
//  Created by NiLaisong on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeGoods : NSObject

@property(nonatomic,copy) NSString* goodsId;//商品编号
@property(nonatomic,copy) NSString* goodsName;//商品名称
@property(nonatomic,copy) NSString* convertPoints;//兑换积分
@property(nonatomic,copy) NSString* availableNum ;//剩余份额
@property(nonatomic,copy) NSString* availableStatus;//兑换状态
@property(nonatomic,copy) NSString* thmUrl;//缩略图
@property(nonatomic,copy) NSString* imgUrl;//大图

@property(nonatomic,copy) NSString* goodsDescription;//商品描述
@property(nonatomic,copy) NSString* goodsInfo;//商品描述

@property(nonatomic,copy) NSString* activityTime;//活动时间
@property(nonatomic,copy) NSString* convertFlow;//兑换流程
@property(nonatomic,copy) NSString* remarks;//重要说明
@property(nonatomic,copy) NSString* endTime;//重要说明

@end
