//
//  XTSelectCustomerController.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
@class Customer;
typedef void(^SelectCustomerControllerResult)(Customer* customer);

@interface XTSelectCustomerController : BaseViewController


- (instancetype)initWithCallBack:(SelectCustomerControllerResult)callBack;

@property (nonatomic,copy)SelectCustomerControllerResult callBack;

@end
