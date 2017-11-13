//
//  XTMapBuildingDetailView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/7.
//  Copyright © 2016年 5i5j. All rights reserved.
//  地图找房详情

#import <UIKit/UIKit.h>
#import "XTMapBuildInfoModel.h"

@class XTMapBuildingDetailView;

@protocol XTMapBuildingDetailViewDelegate <NSObject>

- (void)mapBuildingDetailView:(XTMapBuildingDetailView*)detailView didSelectedImageView:(XTMapBuildInfoModel*)infoModel;

@end

//佣金
#define CommissionFont [UIFont systemFontOfSize:16]

@interface XTMapBuildingDetailView : UIView

@property (nonatomic,strong)XTMapBuildInfoModel* infoModel;

+ (CGFloat)heightWith:(XTMapBuildInfoModel*)infoModel;

@property (nonatomic,weak)id<XTMapBuildingDetailViewDelegate> delegate;

@end
