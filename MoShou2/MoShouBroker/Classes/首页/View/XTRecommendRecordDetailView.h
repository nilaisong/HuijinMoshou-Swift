//
//  XTRecommendRecordDetailView.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/27.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerReportedRecord.h"
#import "TradeRecord.h"

@class XTRecommendRecordDetailView;
@class CustomerReportedDetailModel;
@class ReportDetailBuilding;
@protocol CustomerRecommendRecordDetailDelegate <NSObject>

@required  //点击了跟进按钮
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView*)detailView didSelectedAddTrackAction:(CustomerReportedDetailModel*)detailModel;

- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedDeleteTrackAction:(NSString*)trackId;

- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedClockAction:(CustomerReportedDetailModel*)model;

- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedTelAction:(NSString*)phoneNumber;

- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedQRAction:(NSString*)url;

- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedBuilding:(TradeRecord *)trade;


@end



@interface XTRecommendRecordDetailView : UIView

@property (nonatomic,strong)CustomerReportedRecord* customerReportedRecord;
//报备详情
@property (nonatomic,strong)CustomerReportedDetailModel* detailModel;

@property (nonatomic,weak)id <CustomerRecommendRecordDetailDelegate> delegate;
@end
