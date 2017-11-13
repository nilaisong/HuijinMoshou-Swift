//
//  RoomLayout.h
//  MoShouBroker
//  楼盘户型数据模型
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomLayout : NSObject

@property(nonatomic,copy) NSString* layoutId;//编号
@property(nonatomic,copy) NSString* name;//户型名称，例如：A1、A2
@property(nonatomic,copy) NSString* type;//类型，例如：三室一厅

@property(nonatomic,copy) NSString* saleArea;//销售面积
@property(nonatomic,copy) NSString* innerArea;//套内面积
@property(nonatomic,copy) NSString* shareArea;//分摊面积
@property(nonatomic,copy) NSString* presentArea;//赠送面积
@property(nonatomic,copy) NSString* decoration;//装修标准
@property(nonatomic,copy) NSString* towardsType;//朝向
@property(nonatomic,copy) NSString* thumUrl;//缩略图
@property(nonatomic,copy) NSString* imgUrl;//户型图

@property(nonatomic,assign) BOOL mainTypeFlag;  //主力户型标示(1是，0否)
@property(nonatomic,copy) NSString* status;   // 销售状态


@property(nonatomic,copy) NSString* bedroomNum;   //
@property(nonatomic,copy) NSString* livingroomNum;   //
@property(nonatomic,copy) NSString* kitchenNum;   //
@property(nonatomic,copy) NSString* toiletNum;   //
@property(nonatomic,copy) NSString* totalPrice;   //


//    "mainTypeFlag" : "0",					--主力户型标示(1是，0否)
@end

/**
 *  注释的是  服务端返回的所有参数
 */
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

//"id": 3585,
//"estateId": 1067,
//"name": "B1",
//"bedroomNum": 3,
//"livingroomNum": 2,
//"kitchenNum": 0,
//"toiletNum": 3,
//"balconyNum": 0,
//"status": null,
//"mainTypeFlag": "1",
//"insideArea": "124",
//"shareArea": "23",
//"saleArea": "147",
//"giftArea": "50",
//"decorationType": "5",
//"orientationType": "10",
//"imgUrl": "images/layout/2016/08/17/b5f89787-f9ea-466b-a36d-647eabd7f49a.jpg",
//"creator": "1",
//"createTime": "2016-08-17 20:59:06",
//"updater": 1,
//"updateTime": "2016-08-17 20:59:06",
//"delFlag": "0",
//"pathImgUrl": "http://img.99yijia.com/images/layout/2016/08/17/b5f89787-f9ea-466b-a36d-647eabd7f49a.jpg",
//"decoration": "毛坯",
//"orientation": "南北",
//"totalPrice": "4704000.0"




