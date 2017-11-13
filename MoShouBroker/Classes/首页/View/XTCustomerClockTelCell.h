//
//  XTCustomerClockTelCell.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/27.
//  Copyright © 2015年 5i5j. All rights reserved.
// 用户报备详情，闹钟电话cell

#import <UIKit/UIKit.h>
#import "CustomerReportedDetailModel.h"

typedef NS_ENUM(NSInteger,CustomerClockTelCellEvent) {
    CustomerClockTelCellEventClock,
    CustomerClockTelCellEventTel
};

typedef void(^CustomerClockTelActionResult)(CustomerClockTelCellEvent event,CustomerReportedDetailModel* detailModel);

@interface XTCustomerClockTelCell : UITableViewCell

@property (nonatomic,copy)CustomerClockTelActionResult callBack;

@property (nonatomic,strong)CustomerReportedDetailModel* customerReportedDetailModel;

+ (instancetype)customerClockTelCellWithTableView:(UITableView*)tableView;

+ (instancetype)customerClockTelCellWithTableView:(UITableView *)tableView callBack:(CustomerClockTelActionResult)callBack;


@end
