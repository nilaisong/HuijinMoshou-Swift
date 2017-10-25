//
//  XTCustomerDetailTelCell.h
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileVisible.h"

typedef NS_ENUM(NSInteger,CustomerDetailTelCellEvent) {
    CustomerDetailTelCellEventCall //打电话
};

typedef void(^CustomerDetailTelCellActionResult)(CustomerDetailTelCellEvent event,NSString* telString);

@interface XTCustomerDetailTelCell : UITableViewCell

+ (instancetype)customerDetailTelCellWithTableView:(UITableView*)tableView;

+ (instancetype)customerDetailTelCellWithTableView:(UITableView *)tableView eventCallBack:(CustomerDetailTelCellActionResult)callBack;


@property (nonatomic,weak)MobileVisible* mobileModel;

@end
