//
//  XTMonthCommission.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//月份佣金收益

#import <Foundation/Foundation.h>

@interface XTMonthCommission : NSObject
@property (nonatomic,copy)NSString* month;
@property (nonatomic,assign)CGFloat commission;
@end
