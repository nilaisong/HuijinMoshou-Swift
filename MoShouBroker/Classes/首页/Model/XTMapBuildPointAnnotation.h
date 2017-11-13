//
//  XTMapBuildPointAnnotation.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotation.h>
#import "XTMapBuildInfoModel.h"

@interface XTMapBuildPointAnnotation : BMKPointAnnotation


/**
 *  楼盘信息模型
 **/
@property (nonatomic,strong)XTMapBuildInfoModel* infoModel;

@end
