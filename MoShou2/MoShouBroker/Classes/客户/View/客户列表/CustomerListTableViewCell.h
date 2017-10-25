//
//  CustomerListTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
#import "CustomerShowVisitInfoView.h"

@class CustomerListTableViewCell;

typedef void(^callCustomerBlock)(CustomerListTableViewCell*);
//delete by wangzz 161020
//typedef void(^reportCustomerBlock)(CustomerListTableViewCell*);
typedef void(^selecteCustomerBlock)(CustomerListTableViewCell*,BOOL);

@interface CustomerListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *telLabel;//手机号码显示label
//@property (nonatomic, strong) UIImageView   *headImageView;//客户头像
@property (nonatomic, strong) UILabel       *customerNameLabel;//客户姓名
//@property (nonatomic, strong) UILabel       *reportNumberLabel;//还可报备楼盘数
//@property (nonatomic, strong) UILabel   *purchaseIntentionLabel;//购房意向
@property (nonatomic, strong) UIButton  *callBtn;//打电话按钮(仅限客户列表、我的报备页面使用)
//delete by wangzz 161020
//@property (nonatomic, strong) UIButton  *reportBtn;//报备按钮(仅限客户列表、我的报备页面使用)

@property (nonatomic, strong) UIButton  *selectedBtn;//多选按钮(仅限客户涉及多选操作页面使用)

@property (nonatomic, strong) Customer  *customerList;

@property (nonatomic, strong) CustomerShowVisitInfoView  *showVisitInfoView;
@property (nonatomic, assign) BOOL      bIsShowVisitInfo;
@property (nonatomic, assign) BOOL      bIsShowConfirmInfo;

- (id)initWithShop:(BOOL)bIsShop CallHidden:(BOOL)bIsCallHidden AndSelectedHidden:(BOOL)bIsSelHidden PurchaseHidden:(BOOL)bIsPurHidden;

@property (nonatomic, copy) callCustomerBlock didSelectCallCustomer;
//delete by wangzz 161020
//@property (nonatomic, copy) reportCustomerBlock didSelectReportCustomer;
@property (nonatomic, copy) selecteCustomerBlock didSelectCustomer;

-(void)selectCallBlock:(callCustomerBlock)ablock;
//delete by wangzz 161020
//-(void)selectReportBlock:(reportCustomerBlock)ablock;
-(void)selectCustomerBlock:(selecteCustomerBlock)ablock;

@end
