//
//  CustomerEditViewController.h
//  MoShouBroker
//
//  Created by wangzz on 15/10/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "Customer.h"

typedef void (^CustomerDetailMsgEdit) ();

/*typedef enum {
    kAddRemarksMsg,  //添加备注信息
//    kEditRemarksMsg,  //编辑备注信息
    kAddCustomerFollowMsg,//添加客户跟进信息
//    kEditCustomerFollowMsg,//编辑客户跟进信息
    kAddFolloMsg,  //添加跟进信息
//    kEditFolloMsg,  //编辑跟进信息
}customerDetailMsgType;*/

@interface CustomerEditViewController : BaseViewController

@property (copy, nonatomic)  CustomerDetailMsgEdit customerEditBlock;
//@property (nonatomic, assign) customerDetailMsgType  customerMsgType;
@property (nonatomic, copy) NSString               *editString;
@property (nonatomic, copy) NSString               *customerMsdId;

-(void)returnCustomerEditResultBlock:(CustomerDetailMsgEdit)ablock;

@end
