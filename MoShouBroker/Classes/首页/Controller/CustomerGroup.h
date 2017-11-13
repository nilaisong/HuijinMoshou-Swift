//
//  CustomerGroup.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//客户报备分组

#import <Foundation/Foundation.h>

@interface CustomerGroup : NSObject
/**
 *  groupId为类型id,查询时使用
 */
@property (nonatomic,assign)NSInteger groupId;
/**
 *  分组名字
 */
@property (nonatomic,copy)NSString* groupName;
@end
