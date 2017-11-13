//
//  CityFirstResult.h
//  MoShou2
//
//  Created by strongcoder on 16/4/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//
#import "Standard.h"
#import "DistrictModel.h"
#import "PlatList.h"
#import <Foundation/Foundation.h>

@interface CityFirstResult : NSObject


@property (nonatomic,strong)NSArray * districts ;  // 商圈  数组元素DistrictModel  //区域

@property (nonatomic,strong)Standard * feature;    //特色标签

@property (nonatomic,strong)Standard * acreage ;  // 区域面积

@property (nonatomic,strong)NSArray *priceTypes ;    // 价格排序  OptionData

@property (nonatomic,strong)NSArray *trystCarLists ;    // 可约车的筛选项 OptionData



@property (nonatomic,strong)Standard * decoration;  //装修标准

@property (nonatomic,strong)Standard * property;    //物业类型

@property (nonatomic,strong)NSArray *bedroomList ;    // -居室 OptionData


@property (nonatomic,strong)Standard *vicinity ;    // 距离



@property (nonatomic,strong)NSArray *banners ;    // 数组元素  BannerInfo

@property (nonatomic,strong)NSArray *ads ;    // 数组元素  Ad


@end
