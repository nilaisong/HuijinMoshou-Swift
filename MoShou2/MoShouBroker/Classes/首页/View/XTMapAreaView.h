//
//  XTMapAreaView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "XTMapDistricInfoModel.h"
#import "XTMapDistricAnnotationModel.h"

@class XTMapAreaView;


@protocol XTMapAreaViewDelegate <NSObject>

- (void)mapAreaView:(XTMapAreaView*)areaView didSelected:(XTMapDistricAnnotationModel*)districModel;

@end

@interface XTMapAreaView : BMKAnnotationView

/**
 *  简化版数据模型
 **/
@property (nonatomic,strong)XTMapDistricAnnotationModel* districModel;

/**
 *  后台返回的多层级数据
 **/
@property (nonatomic,strong)XTMapDistricInfoModel* mapDistricInfoModel;

@property (nonatomic,weak)id<XTMapAreaViewDelegate> delegate;

@property (nonatomic,assign)CLLocationCoordinate2D coordinate;

@end
