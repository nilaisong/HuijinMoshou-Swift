//
//  XTAppointmentRecordView.h
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//  约车记录

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,XTAppointmentRecordViewEvent) {
    /**
     *  发生滚动
     */
   XTAppointmentRecordViewEventScroll,
    /**
     *  选中
     */
    XTAppointmentRecordViewEventSelected,
    /**
     *  开始动画
     */
    XTAppointmentRecordViewEventBegainAnimation,
    /**
     *  结束动画
     */
    XTAppointmentRecordViewEventEndAnimation,
};

@class XTAppointmentRecordView;
@class CarRecordListModel;

typedef void(^XTAppointmentRecordViewCallBack)(XTAppointmentRecordView* view,XTAppointmentRecordViewEvent event,CarRecordListModel* model);

@interface XTAppointmentRecordView : UIView


@property (nonatomic,copy)NSString* keyword;

- (instancetype)initWithCallBack:(XTAppointmentRecordViewCallBack)callBack;

@end
