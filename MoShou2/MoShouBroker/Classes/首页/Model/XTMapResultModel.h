//
//  XTMapResultModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//  这是地图找房数据回调模型

#import <Foundation/Foundation.h>
#import "XTMapCityGroupModel.h"
#import "XTMapDistricGroupModel.h"
#import "XTMapBuildGroupModel.h"

@interface XTMapResultModel : NSObject

//城市组模型
@property (nonatomic,strong)XTMapCityGroupModel* cityGroupModel;

//区域组模型
@property (nonatomic,strong)XTMapDistricGroupModel* districtGroupModel;

//楼盘组模型
@property (nonatomic,strong)XTMapBuildGroupModel* buildGroupModel;

@property (nonatomic,assign)NSInteger modelType;

@end
