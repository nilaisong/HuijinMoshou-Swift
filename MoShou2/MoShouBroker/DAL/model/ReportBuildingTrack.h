//
//  ReportBuildingTrack.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//客户与楼盘的跟进信息

#import <Foundation/Foundation.h>

@interface ReportBuildingTrack : NSObject

@property (nonatomic,copy)NSString* content;

@property (nonatomic,copy)NSString* datetime;

@property (nonatomic,copy)NSString* trackId;

@property (nonatomic,assign)CGFloat trackHgiht;

@end
