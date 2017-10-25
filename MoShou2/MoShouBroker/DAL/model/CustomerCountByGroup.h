//
//  CustomerCountByGroup.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
// 用户状态分组中的数量

#import <Foundation/Foundation.h>

@interface CustomerCountByGroup : NSObject

//状态分组id
@property (nonatomic,assign)NSInteger groupId;

//数量
@property (nonatomic,assign)NSInteger count;

@end
