//
//  BuildingsResult.h
//  MoShouBroker
//  楼盘主页数据结果
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingsResult : NSObject

@property (nonatomic,strong) NSArray *bannerInfos;//顶部热门楼盘数组，元素BannerInfo
@property (nonatomic,strong) NSArray *areas;//楼盘区域数组，元素OptionData
@property (nonatomic,strong) NSArray *featureTags;//楼盘特色数组，元素OptionData

@property (nonatomic,strong)NSArray *acreageTypes;  //楼盘面积区间 元素OptionData
@property (nonatomic,strong) NSArray *priceTypes;//楼盘价格区间数组，


@property (nonatomic,strong) NSArray *buildings;//楼盘数据列表，元素BuildingListData
@property (nonatomic,assign) BOOL morePage; //是否有下页数据

@end
