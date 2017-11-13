//
//  MyCustomersTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

typedef void(^callMyCustomerBlock)(NSString*);
typedef void(^revertReportMyCustomerBlock)(NSString*);

@interface MyCustomersTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *telLabel;//手机号码显示label
@property (nonatomic, strong) UILabel       *customerNameLabel;//客户姓名
@property (nonatomic, strong) UILabel       *statusLabel;//客户状态
@property (nonatomic, strong) UIButton      *callBtn;//打电话按钮(仅限客户列表、我的报备页面使用)
@property (nonatomic, strong) UIButton      *revertReportBtn;//撤销报备按钮(仅限客户列表、我的报备页面使用)

@property (nonatomic, strong) UILabel       *QueKeTelLabel;//确客手机号码显示label
@property (nonatomic, strong) UILabel       *QueKeNameLabel;//确客姓名

@property (nonatomic, strong) Customer  *customerList;

@property (nonatomic, copy) callMyCustomerBlock didSelectCallCustomer;
@property (nonatomic, copy) revertReportMyCustomerBlock didSelectReportCustomer;

-(void)callMyCustomerCellBlock:(callMyCustomerBlock)ablock;
-(void)revertReportCellBlock:(revertReportMyCustomerBlock)ablock;

@end
