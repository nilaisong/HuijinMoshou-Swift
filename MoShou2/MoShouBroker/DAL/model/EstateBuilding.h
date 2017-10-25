//
//  EstateBuilding.h
//  MoShou2
//
//  Created by strongcoder on 16/4/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstateBuilding : NSObject

@property (nonatomic, copy) NSString *estateBuildingId; //   需要映射
@property (nonatomic, copy) NSString *estateId; //
@property (nonatomic, copy) NSString *name; //
@property (nonatomic, copy) NSString *nature; //
@property (nonatomic, copy) NSString *unitNum; //
@property (nonatomic, copy) NSString *floorNum; //
@property (nonatomic, copy) NSString *houseNum; //
@property (nonatomic, copy) NSString *location; //
@property (nonatomic, copy) NSString *stages; //
@property (nonatomic, copy) NSString *subarea; //
@property (nonatomic, copy) NSString *moveinTime; //
@property (nonatomic, copy) NSString *estateDescription; //  需要映射   description
@property (nonatomic, copy) NSString *creator; //
@property (nonatomic, copy) NSString *createTime; //
@property (nonatomic, copy) NSString *updater; //
@property (nonatomic, copy) NSString *updateTime; //
@property (nonatomic, copy) NSString *delFlag; //
@property (nonatomic, copy) NSString *stageName; //
@property (nonatomic, copy) NSString *subareaName; //









@end




//
//
//"estateBuildings" : [ {			--楼座List（部分实体参照户型）
//    "id" : 2,
//    "estateId" : 21,
//    "name" : "楼座1",
//    "nature" : null,
//    "unitNum" : 1,
//    "floorNum" : 1,
//    "houseNum" : 1,
//    "location" : null,
//    "stages" : null,
//    "subarea" : 34,
//    "moveinTime" : "2016-03-10 00:00:00",
//    "description" : null,
//    "creator" : "1",
//    "createTime" : "2016-03-03 13:57:37",
//    "updater" : 1,
//    "updateTime" : "2016-03-03 13:57:37",
//    "delFlag" : "0",
//    "stageName" : null,
//    "subareaName" : "C区"
//}]







