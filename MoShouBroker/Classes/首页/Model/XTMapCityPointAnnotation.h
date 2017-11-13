//
//  XTMapCityAnnotation.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "XTMapCityAnnotationModel.h"
#import "XTMapCityInfoModel.h"

@interface XTMapCityPointAnnotation : BMKPointAnnotation

/**
 *  简化版城市模型
 **/
@property (nonatomic,strong)XTMapCityAnnotationModel* cityModel;

/**
 *  后台多层次城市信息模型
 **/
@property (nonatomic,strong)XTMapCityInfoModel* mapCityInfoModel;

@end
