//
//  XTMapCityView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "XTMapCityAnnotationModel.h"
#import "XTMapCityInfoModel.h"
@class XTMapCityView;

@protocol XTMapCityViewDelegate <NSObject>

- (void)mapCityView:(XTMapCityView*)areaView didSelected:(XTMapCityAnnotationModel*)cityModel;

@end


@interface XTMapCityView : BMKAnnotationView

/**
 *  简化版城市信息模型
 **/
@property (nonatomic,strong)XTMapCityAnnotationModel* cityModel;

/**
 *  后台传来的多层次城市信息
 **/
@property (nonatomic,strong)XTMapCityInfoModel* mapCityInfoModel;

@property (nonatomic,weak)id<XTMapCityViewDelegate> delegate;

@end
