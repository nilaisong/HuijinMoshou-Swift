//
//  XTIncomeModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//
//收入明细模型

#import <Foundation/Foundation.h>

@interface XTIncomeModel : NSObject
/*业绩数*/
@property (nonatomic,assign)CGFloat commission;
/*"业绩"业绩来源*/
@property (nonatomic,copy)NSString* commissionOpt;
/*//"2015-11-28 00:00",//时间*/
@property (nonatomic,copy)NSString* createTime;
/*"刘海洋",//客户名称*/
@property (nonatomic,copy)NSString* customerName;
/*"北京周边",//地区*/
@property (nonatomic,copy)NSString* estateDistrict;
/*"永清国瑞生态城"//楼盘名称*/
@property (nonatomic,copy)NSString* estateName;
@end
