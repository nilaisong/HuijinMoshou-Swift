//
//  XTAppointmentCarView.h
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//预约专车容器视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XTAppointmentCarViewEvent) {
    /**
     *  发生滚动
     */
    XTAppointmentCarViewEventScroll,
    /**
     *  去约车
     */
    XTAppointmentCarViewEventTrystCar,
    /**
     *  选中
     */
    XTAppointmentCarViewEventSelected,
    /**
     *  开始动画
     */
    XTAppointmentCarViewBegainAnimation,
    /**
     *  结束动画
     */
    XTAppointmentCarViewEndAnimation,
};

@class XTAppointmentCarView;
@class CarReportedRecordModel;

typedef void(^XTAppointmentCarViewCallBack)(XTAppointmentCarView* view,XTAppointmentCarViewEvent event,CarReportedRecordModel* model);

@interface XTAppointmentCarView : UIView


@property (nonatomic,copy)NSString* keyword;

- (instancetype)initWithCallBack:(XTAppointmentCarViewCallBack)callBack;

@end
