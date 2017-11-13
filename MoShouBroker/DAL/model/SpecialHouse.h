//
//  SpecialHouse.h
//  MoShou2
//
//  Created by Mac on 2016/12/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialHouse : NSObject


@property(nonatomic,copy) NSString* id;   //
@property(nonatomic,copy) NSString* estateId;   //
@property(nonatomic,copy) NSString* buildingId;   //
@property(nonatomic,copy) NSString* houseTypeId;   //
@property(nonatomic,copy) NSString* floor;   //
@property(nonatomic,copy) NSString* unit;   //
@property(nonatomic,copy) NSString* houseNo;   //
@property(nonatomic,copy) NSString* sequence;   //
@property(nonatomic,copy) NSString* saleArea;   //
@property(nonatomic,copy) NSString* insideArea;   //
@property(nonatomic,copy) NSString* shareArea;   //
@property(nonatomic,copy) NSString* giftArea;   //
@property(nonatomic,copy) NSString* unitPrice;   //
@property(nonatomic,copy) NSString* totalPrice;   //
@property(nonatomic,copy) NSString* cheapTotalPrice;   //
@property(nonatomic,copy) NSString* cheapSinglePrice;   //
@property(nonatomic,copy) NSString* cheapBeginTime;   //
@property(nonatomic,copy) NSString* cheapEndTime;   //
@property(nonatomic,copy) NSString* cheapType;   //
@property(nonatomic,copy) NSString* bedroomNum;   //
@property(nonatomic,copy) NSString* livingroomNum;   //
@property(nonatomic,copy) NSString* kitchenNum;   //
@property(nonatomic,copy) NSString* toiletNum;   //
@property(nonatomic,copy) NSString* buildingName;   //
@property(nonatomic,copy) NSString* houseTypeName;   //
@property(nonatomic,copy) NSString* decoration;   //
@property(nonatomic,copy) NSString* orientation;   //
@property(nonatomic,copy) NSString* saleStatus;   //
@property(nonatomic,copy) NSString* sights;   //
@property(nonatomic,copy) NSString* property;   //
@property(nonatomic,copy) NSString* propertyDetail;   //
@property(nonatomic,copy) NSString* pathImgUrl;   //


@end



//"houseList": [										-房源list
//{
//"id": 515,
//"estateId": 290,
//"buildingId": 259,
//"houseTypeId": 1291,
//"floor": "3",									--楼层
//"unit": "1",										--单元
//"houseNo": "3",									--房间号
//"sequence": null,								--序号
//"saleArea": "91",								--销售面积
//"insideArea": "90",								--套内面积
//"shareArea": "1",								--分摊面积
//"giftArea": "1",									--赠送面积
//"unitPrice": 11221,								--平米价格
//"totalPrice": 12000,								--总价
//"cheapTotalPrice": "1112222",					--优惠总价
//"cheapSinglePrice": "12333",					--优惠单机
//"cheapBeginTime": "2016-11-01 00:00:00",		--优惠开始时间
//"cheapEndTime": "2016-11-18 00:00:00",			--优惠结束时间
//"cheapType": "1",								--优化类型，0为普通，1为优惠
//"bedroomNum": 0,								--室
//"livingroomNum": 0,							--厅
//"kitchenNum": 0,								--厨
//"toiletNum": 0,									--卫
//"buildingName": "22",
//"houseTypeName": "4",
//"decoration": "精装修",							--装修标准
//"orientation": "南东北",							--朝向
//"saleStatus": "可售",							--销售状态
//"sights": null,									--景观
//"property": "商业",								--物业类型
//"propertyDetail": "商住两用"					--物业详细类型
//}
//],
