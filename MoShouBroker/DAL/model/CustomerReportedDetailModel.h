//
//  CustomerReportedDetailModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//报备详情

#import <Foundation/Foundation.h>

#import "ReportDetailBuilding.h"
#import "ReportDetailMessage.h"
#import "ReportDetailProgress.h"
#import "ReportBuildingTrack.h"
#import "MobileVisible.h"
@interface CustomerReportedDetailModel : NSObject
/**
 *  客户id
 */
@property (nonatomic,copy)NSString* customerId;
/**
 *  客户姓名
 */
@property (nonatomic,copy)NSString* customerName;

@property (nonatomic,copy)NSString* sex;

@property (nonatomic,copy)NSString* phone;

@property (nonatomic,strong)NSArray* phoneList;

@property (nonatomic,strong)NSArray* buildingList;//ReportDetailBuilding

@property (nonatomic,copy)NSString* quekeName;

@property (nonatomic,copy)NSString* quekePhone;



@property (nonatomic,assign)BOOL hasRemind;
@end
