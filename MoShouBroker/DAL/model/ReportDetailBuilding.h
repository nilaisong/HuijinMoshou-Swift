//
//  ReportDetailBuilding.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/4.
//  Copyright © 2016年 5i5j. All rights reserved.
// 报备详情 - 楼盘

#import <Foundation/Foundation.h>

@interface ReportDetailBuilding : NSObject

@property (nonatomic,assign)NSInteger builidId;

@property (nonatomic,copy)NSString* buildingName;

@property (nonatomic,assign)NSInteger buildingCustomerId;

@property (nonatomic,assign)BOOL can_revokeRecommendation; //判断该推荐记录是否可以撤销（1:可以, 0：不可以）

@property (nonatomic,copy)NSString* district;//丰台区

@property (nonatomic,copy)NSString* expiredate;//到期时间

@property (nonatomic,assign)NSInteger expiredateFlag;

@property (nonatomic,strong)NSArray* messageList;//ReportDetailMessage

@property (nonatomic,strong)NSArray* progressList;//ReportDetailProgress

@property (nonatomic,strong)NSArray* buildingTrackList;//ReportBuildingTrack

@property (nonatomic,assign)CGFloat trackHeight;

@end
