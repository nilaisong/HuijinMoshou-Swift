//
//  XTCustomerStatusGroupTagModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//获取客户状态分组

#import <Foundation/Foundation.h>

@interface XTCustomerStatusGroupTagModel : NSObject

///api/estateCustomer/customer/customerStatusGroupTag
//客户状态列表
@property (nonatomic,strong)NSArray* groupList;

@property (nonatomic,copy)NSString *message;

@end
