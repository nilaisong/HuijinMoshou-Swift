//
//  ExpectData.h
//  MoShouBroker
//  客户购房意向数据模型
//  Created by NiLaisong on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpectData : NSObject

//最低总价（万元）
@property(nonatomic,copy) NSString *expectPriceMin;
//最高总价（万元）
@property(nonatomic,copy) NSString *expectPriceMax;

@property(nonatomic,copy) NSArray* expectType;//意向类型，数组元素OptionData
@property(nonatomic,copy) NSArray* expectLayout;//意向户型，数组元素OptionData
//@property(nonatomic,copy) NSArray* areaList;//意向面积，数组元素OptionData
//@property(nonatomic,copy) NSArray* prices;//意向价格，数组元素OptionData

@end
