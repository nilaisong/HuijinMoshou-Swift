//
//  XTIncomeAllModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//  我的财富，近四个月收益

#import <Foundation/Foundation.h>

@interface XTIncomeAllModel : NSObject

@property (nonatomic,assign)CGFloat allCommission;//总业绩

//总的收益列表
@property (nonatomic,strong)NSArray* allCommissionList;

//当前月业绩
@property (nonatomic,assign)CGFloat currentMonthCommission;

@end
