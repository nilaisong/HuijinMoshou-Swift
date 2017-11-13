//
//  RecommendationRecordTableView.h
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCustomerRecordCell.h"

@class RecommendRecordOptionModel;

/**
 *  动画方向
 */
typedef NS_ENUM(NSInteger,TableViewAnimationDirection) {
    /**
     *  没有
     */
    TableViewAnimationDirectionNone,
    /**
     *  向左动画
     */
    TableViewAnimationDirectionLeft,
    /**
     *  向右动画
     */
    TableViewAnimationDirectionRight
};

//cell事件回调，点击了二维码，或者点击了cell
typedef void(^RecommendationRecordTableViewEventCallBack)(XTCustomerRecordCell* cell,BOOL touchQRBtn);

@interface RecommendationRecordTableView : UITableView

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style eventCallBack:(RecommendationRecordTableViewEventCallBack)callBack;

+ (instancetype)recommendRecordTableViewWithTableViewStyle:(UITableViewStyle)style eventCallBack:(RecommendationRecordTableViewEventCallBack)callBack;



//动画方向
@property (nonatomic,assign)TableViewAnimationDirection direction;

@property (nonatomic,strong)RecommendRecordOptionModel* optionModel;
#warning 测试
@property (nonatomic,weak)NSArray* customerModelArray;

@property (nonatomic,copy)RecommendationRecordTableViewEventCallBack callBack;
@end
