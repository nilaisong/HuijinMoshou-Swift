//
//  ReportReturnData.h
//  MoShou2
//
//  Created by wangzz on 16/1/5.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportReturnData : NSObject

@property(nonatomic,copy) NSString* count;//最多还可报备多少个楼盘
@property(nonatomic,copy) NSString* successCount;//报备成功的有多少
@property(nonatomic,copy) NSArray* failCustomerList;//报备失败的有多少failListData
@property(nonatomic,copy) NSArray* failBuildingList;//报备失败的有多少failListData
@property(nonatomic,copy) NSString* custProfileId;//客户id

@end
