//
//  XTCustomerInfoHeaderView.h
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//
//报备记录，客户详情header view 客户名，添加提醒

#import <UIKit/UIKit.h>
#import "CustomerReportedDetailModel.h"
typedef NS_ENUM(NSInteger,CustomerInfoHeaderEvent) {
    CustomerInfoHeaderEventClock
};

typedef void(^CustomerInfoHeaderActionResult)(CustomerInfoHeaderEvent event);

@interface XTCustomerInfoHeaderView : UITableViewHeaderFooterView

@property (nonatomic,weak)CustomerReportedDetailModel* detailModel;

+ (instancetype)customerInfoHeaderViewWithTableView:(UITableView*)tableView;

+ (instancetype)customerInfoHeaderViewWithTableView:(UITableView*)tableView eventCallBack:(CustomerInfoHeaderActionResult)callBack;

- (instancetype)initWithCallBack:(CustomerInfoHeaderActionResult)callBack;

@end
