//
//  XTReportedRecordListModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//报备记录列表模型

#import <Foundation/Foundation.h>

@interface XTReportedRecordListModel : NSObject

@property (nonatomic,assign)NSInteger count;//客户数量

@property (nonatomic,assign)BOOL morePage;

@property (nonatomic,assign)NSInteger totalCount;

@property (nonatomic,strong)NSArray* customerList;//客户的列表

@end
