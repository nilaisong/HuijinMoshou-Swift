//
//  XTSignRankingRequestModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//承载请求成交排名数据模型

#import <Foundation/Foundation.h>
@class SignRanking;
@interface XTSignRankingRequestModel : NSObject

@property (nonatomic,assign)NSInteger allCnt;//总成交数
//@property (nonatomic,assign)NSInteger allAgentCount;
@property (nonatomic,strong)NSArray* ranking;
@property (nonatomic,strong)SignRanking* myRanking;


@end
