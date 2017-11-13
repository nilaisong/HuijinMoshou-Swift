//
//  XTCustomerProgressStatusImageView.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//根据状态展示不同图像视图

#import <UIKit/UIKit.h>

//报备进度的进度，用于状态标识
typedef NS_ENUM(NSInteger,XTCustomerProgressStatus){
    XTCustomerProgressStatusComplete,//完成
    XTCustomerProgressStatusPrepare,//准备
    XTCustomerProgressStatusDisable//不可用
};

@interface XTCustomerProgressStatusImageView : UIImageView

- (instancetype)initWithStatus:(XTCustomerProgressStatus)status;
//进度状态，设置后可以显示不同的图标
@property (nonatomic,assign)XTCustomerProgressStatus status;

@end
