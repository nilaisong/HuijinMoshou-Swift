//
//  Standard.h
//  MoShou2
//  装修标准
//  Created by strongcoder on 16/4/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Standard : NSObject


@property (nonatomic,copy)NSString *standardId;   //需要映射id
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *orgId;
@property (nonatomic,copy)NSString *creator;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *updater;
@property (nonatomic,copy)NSString *updateTime;
@property (nonatomic,copy)NSString *delFlag;
@property (nonatomic,strong)NSArray *sysDics;   //装修标准列表  元素 SysDic



@end





