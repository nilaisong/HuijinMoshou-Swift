//
//  CutomersResult.h
//  MoShouBroker
//  客户主页数据结果
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomersResult : NSObject

@property (nonatomic,strong) NSArray *groups;//购房状态数组，元素OptionData

@property (nonatomic,strong) NSArray *customerList;//用户数据列表，元素Customer
@property (nonatomic,assign) BOOL morePage; //是否有下页数据

@end
