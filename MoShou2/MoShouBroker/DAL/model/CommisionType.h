//
//  BonusType.h
//  MoShouBroker
//  佣金类别数据模型
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommisionType : NSObject

@property(nonatomic,copy) NSString* typeId;//类别编号
@property(nonatomic,copy) NSString* name;//类别名称
@property(nonatomic,copy) NSString* sum;//总额
@property(nonatomic,assign) BOOL isSelect;//是否选中

@end
