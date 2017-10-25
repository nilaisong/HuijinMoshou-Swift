//
//  DataListResult.h
//  MoShouBroker
//  通用数据列表结果
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataListResult : NSObject

@property (nonatomic,strong) NSArray *dataArray;//数据列表 
@property (nonatomic,assign) BOOL morePage; //是否有下一页数据
@property (nonatomic,strong) NSNumber* totalCount;//数据条目总数
//@property (nonatomic,strong) NSString *error;//错误描述

@end
