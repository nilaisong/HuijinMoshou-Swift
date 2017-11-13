//
//  XTTopFunctionView.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTopFunctionButton.h"

#define TopFunctionCount 7

@class XTTopFunctionView;

/**
 *  这里是首页顶部功能栏的功能类型枚举
 */
typedef NS_ENUM(NSInteger,XTTopFunctionType) {
    /**
     *  快速报备
     */
    XTTopFunctionTypeQuickRecommend,
    /**
     *  添加客户
     */
    XTTopFunctionTypeAddCustomer,
    /**
     *  工作报表
     */
    XTTopFunctionTypeWorkReport,
    /**
     *  报备记录
     */
    XTTopFunctionTypeRecommendRecord,
    /**
     *  地图找房
     */
    XTTopFunctionTypeMapFindRoom,
    /**
     *  临城置业
     */
    XTTopFunctionTypeNeighborPropertie,
    
    /**
     *  海外房产
     */
    XTTopFunctionTypeOverseasEasteBtn,
    /**
     *  约看房车
     */
    XTTopFunctionTypeCar
};

/**
 *  顶部功能视图事件回调
 */
typedef void(^XTTopFunctionViewEventBlock)(XTTopFunctionButton* funcBtn,XTTopFunctionType event);

@interface XTTopFunctionView : UIView

- (instancetype)initWithEventBlock:(XTTopFunctionViewEventBlock)eventBlock;

+ (instancetype)topFunctionViewWith:(XTTopFunctionViewEventBlock)eventBlock;

//
@property (nonatomic,copy)XTTopFunctionViewEventBlock block;

@end
