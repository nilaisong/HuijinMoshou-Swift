//
//  RecommendationRecordListView.h
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+AllowPanGestureEventPass.h"

@class XTCustomerRecordCell;
typedef NS_ENUM(NSInteger,RecommendationRecordListViewEvent) {
    RecommendationRecordListViewEventSwitchListView,
    RecommendationRecordListViewEventSelectCell,
    RecommendationRecordListViewEventNoNetWorkConnection,
    RecommendationRecordListViewEventRequestStart,
    RecommendationRecordListViewEventRequestEnd
};

@class RecommendationRecordListView;

typedef void(^RecommendationRecordListBlock)(NSInteger index);

//客户信息列表，列表事件，选中了某个cell，或者是位移到了某个某一个位置
typedef void(^RecommendationRecordListViewEventCallBack)(RecommendationRecordListViewEvent event,NSInteger listViewIndex,XTCustomerRecordCell* cell,BOOL touchQRBtn);

@interface RecommendationRecordListView : UIScrollView

- (instancetype)initWithEventCallBack:(RecommendationRecordListViewEventCallBack)callBack;

+ (instancetype)recommendRecordListViewWithEventCallBack:(RecommendationRecordListViewEventCallBack)callBack;

/**
 *  当前标签索引
 */
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,copy)RecommendationRecordListBlock block;

@property (nonatomic,copy)RecommendationRecordListViewEventCallBack callBack;

/**
 *  搜索关键字
 */
@property (nonatomic,copy)NSString* keyword;
@end
