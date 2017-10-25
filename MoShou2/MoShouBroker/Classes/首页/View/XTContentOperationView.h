//
//  XTContentOperationView.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/8.
//  Copyright © 2016年 5i5j. All rights reserved.
// 内容运营视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(int,ContentOperationType) {
    ContentOperationTypeNews,//最新资讯
    ContentOperationTypeNewFunction,//魔售新功能
    ContentOperationTypeProjecRecommendation,//项目推荐
    ContentOperationTypeHeadlines,//头条经纪人
};

@class XTOperationModel;
@class XTContentOperationView;
/**
 *  运营视图时间返回
 *
 *  @param view 视图
 *  @param type 事件类型
 */
typedef void(^ContentOperationViewCallBack)(XTContentOperationView* view,ContentOperationType type);

@interface XTContentOperationView : UIView

- (instancetype)initWithCallBack:(ContentOperationViewCallBack)callBack;

@property (nonatomic,strong)XTOperationModel* operationModel;

@end
