//
//  XTLookRankingRequestModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//排行榜-带看

#import <Foundation/Foundation.h>

@class LookRanking;

@interface XTLookRankingRequestModel : NSObject

@property (nonatomic,assign)NSUInteger allCnt;//总带看数

//@property (nonatomic,assign)NSUInteger allAgentCount; //经纪人数

@property (nonatomic,strong)NSArray* ranking;//带看排名模型数组

@property (nonatomic,strong)LookRanking* myRanking;

@end
