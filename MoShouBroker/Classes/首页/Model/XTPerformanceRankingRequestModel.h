//
//  XTPerformanceRankingRequestModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//排行榜-业绩-数据

#import <Foundation/Foundation.h>

@class PerformanceRanking;

@interface XTPerformanceRankingRequestModel : NSObject

@property (nonatomic,assign)CGFloat allCnt;//总业绩

//@property (nonatomic,assign)NSUInteger allCnt;//经纪人总数

@property (nonatomic,strong)NSArray* ranking;

@property (nonatomic,strong)PerformanceRanking *myRanking;


@end
