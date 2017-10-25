//
//  XTCustomerReportBuildingDetailView.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerReportedDetailModel.h"
@class XTCustomerReportBuildingDetailView;

typedef void(^BuildingDetailViewActionResult)(XTCustomerReportBuildingDetailView* detailVC,ReportDetailBuilding* building);

@interface XTCustomerReportBuildingDetailView : UIView

//报备详情
//@property (nonatomic,strong)CustomerReportedDetailModel* detailModel;

@property (nonatomic,strong)ReportDetailBuilding* building;

@property (nonatomic,assign)CGFloat trackViewHeight;

@property (nonatomic,copy)BuildingDetailViewActionResult callBack;

- (instancetype)initWithCallBack:(BuildingDetailViewActionResult)callBack;

@end
