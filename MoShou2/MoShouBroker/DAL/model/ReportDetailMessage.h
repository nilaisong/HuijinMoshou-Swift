//
//  ReportDetailMessage.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//报备详情详细-消息

#import <Foundation/Foundation.h>

@interface ReportDetailMessage : NSObject

/**
 *  报备内容
 */
@property (nonatomic,copy)NSString* content;

/**
 *  报备时间
 */
@property (nonatomic,copy)NSString* datetime;

@end
