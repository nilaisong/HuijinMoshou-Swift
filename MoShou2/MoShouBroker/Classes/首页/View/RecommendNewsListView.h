//
//  RecommendNewsListView.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/27.
//  Copyright © 2016年 5i5j. All rights reserved.
//  相关推荐视图

#import <UIKit/UIKit.h>

@class XTOperationModelItem;
@class RecommendNewsListView;

typedef NS_ENUM(NSInteger,RecommendNewsListViewEventType) {
    RecommendNewsListViewEventMore,//点击了更多
    RecommendNewsListViewEventClick//点击了item
};

typedef void(^RecommendNewsListViewCallBack)(RecommendNewsListView* view,RecommendNewsListViewEventType event,XTOperationModelItem* model);
@interface RecommendNewsListView : UIView

@property (nonatomic,strong)NSArray* relateRecdArray;

- (instancetype)initWithCallBack:(RecommendNewsListViewCallBack)callBack;

+ (CGFloat)heightWithRelateArray:(NSArray*)modelArray;
@end
