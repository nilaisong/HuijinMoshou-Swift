//
//  XTMapDistricPointAnnotation.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "XTMapDistricInfoModel.h"
#import "XTMapDistricAnnotationModel.h"

@interface XTMapDistricPointAnnotation : BMKPointAnnotation

/**
 *  区域数据简化版模型
 **/
@property (nonatomic,strong)XTMapDistricAnnotationModel* districModel;

/**
 *  区域数据后台多层次版模型
 **/
@property (nonatomic,strong)XTMapDistricInfoModel* mapDistricInfoModel;

@end
