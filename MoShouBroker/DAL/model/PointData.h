//
//  PointData.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointData : NSObject

@property(nonatomic,copy) NSString* ruleName;//积分规则名称
@property(nonatomic,copy) NSString* point;//积分
@property(nonatomic,copy) NSString* ruleOpt;//符号 + 为增加了积分 -为减少了积分
@property(nonatomic,copy) NSString* title;//标题名称
@property(nonatomic,copy) NSString* operationTime;//积分时间

@end
