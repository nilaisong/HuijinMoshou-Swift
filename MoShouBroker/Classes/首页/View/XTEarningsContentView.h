//
//  XTEarningsContentView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/17.
//  Copyright © 2015年 5i5j. All rights reserved.
//  我的财富顶部视图

#import <UIKit/UIKit.h>

#import "XTIncomeAllModel.h"

typedef NS_ENUM(NSUInteger,XTEarningsContentViewEventType){
    XTEarningsContentViewEventTypeQuestion,
    XTEarningsContentViewEventTypeViewRecord,
};

@class XTEarningsContentView;

typedef void(^XTEarningsContentViewEventCallBack)(XTEarningsContentView* view,XTEarningsContentViewEventType type);

@interface XTEarningsContentView : UIView

+ (instancetype)earningsContentView;

+ (instancetype)earningsContentViewWithEventCallBack:(XTEarningsContentViewEventCallBack)callBack;

@property (nonatomic,copy)XTEarningsContentViewEventCallBack callBack;

/**
 *  全部收益
 */
@property (nonatomic,strong)XTIncomeAllModel* incomeModel;

@end
