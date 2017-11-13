//
//  HouseType.h
//  MoShou2
//
//  Created by strongcoder on 16/4/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseType : NSObject

@property (nonatomic, copy) NSString *houseTypeId; //需要映射
@property (nonatomic, copy) NSString *estateId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bedroomNum;
@property (nonatomic, copy) NSString *livingroomNum;
@property (nonatomic, copy) NSString *kitchenNum;
@property (nonatomic, copy) NSString *toiletNum;
@property (nonatomic, copy) NSString * balconyNum;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *mainTypeFlag;
@property (nonatomic, copy) NSString *insideArea;
@property (nonatomic, copy) NSString *acreageType;
@property (nonatomic, copy) NSString * shareArea;
@property (nonatomic, copy) NSString * saleArea;
@property (nonatomic, copy) NSString *giftArea;
@property (nonatomic, copy) NSString *orientationType;

@property(nonatomic,copy) NSString* thmUrl;//缩略图
@property(nonatomic,copy) NSString* imgUrl;//大图

@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString * updater;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, copy) NSString *decoration;
@property (nonatomic, copy) NSString *orientation;





@end
//"houseTypeList" : [ {					--户型list
//    "id" : 3,
//    "estateId" : 21,
//    "name" : "户型",						--户型名称
//    "bedroomNum" : 1,						--室
//    "livingroomNum" : 1,					--厅
//    "kitchenNum" : 1,						--厨
//    "toiletNum" : 1,						--卫
//    "balconyNum" : null,					--阳
//    "status" : null,						--状态
//    "mainTypeFlag" : "0",					--主力户型标示(1是，0否)
//    "insideArea" : 11.0,					--套内面积
//    "shareArea" : 22.0,					--分摊面积
//    "saleArea" : 33.0,						--销售面积
//    "giftArea" : 44.0,						--赠送面积
//    "decorationType" : "1",
//    "orientationType" : "1",
//    "imgUrl" : "",						--户型url
//    "creator" : "1",
//    "createTime" : "2016-03-04 15:00:24",
//    "updater" : 1,
//    "updateTime" : "2016-03-05 16:23:26",
//    "delFlag" : "0",
//    "decoration" : "豪华装修",				--装修标准
//    "orientation" : "东西"					--朝向
//}],

