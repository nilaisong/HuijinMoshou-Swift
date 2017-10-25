//
//  ExchangeRecord.h
//  MoShouBroker
//  积分兑换记录
//  Created by NiLaisong on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeRecord : NSObject

@property(nonatomic,copy) NSString* exchangeId;//兑换记录编号
@property(nonatomic,copy) NSString* goodsName;//商品名称
@property(nonatomic,copy) NSString* costPoint;//兑换花费积分
@property(nonatomic,copy) NSString* applyConvertTime ;//兑换日期时间
@property(nonatomic,copy) NSString* convertStatus;//兑换状态
@property(nonatomic,copy) NSString* thmUrl;//商品缩略图

@end
