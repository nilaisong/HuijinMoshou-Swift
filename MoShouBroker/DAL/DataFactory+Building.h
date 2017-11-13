//
//  DataFactory+Building.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/7/13.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "DataFactory+User.h"
#import "DataFactory.h"
//#import "DataFactory+Broker.h"
#import "BuildingsResult.h"
#import "Building.h"
#import "NetWork.h"
#import "ActionResult.h"
#import "NSObject+MJKeyValue.h"
#import "InitialData.h"
#import "CityFirstResult.h"
#import "Standard.h"
#import "SysDic.h"
#import "Estate.h"
#import "EstateBuilding.h"
#import "House.h"
#import "HouseType.h"
#import "Discount.h"
#import "PriceModel.h"

typedef void(^HandleInitialResult)(NSArray*indexArray,NSArray*dataArray);

typedef void(^HandleBuildingsResult)(BuildingsResult*result);
typedef void(^HandleBuildingDetail)(Building*result,NSString *msg);

typedef void(^HandleBuilgingTopNumberResult)(NSString *number);

typedef void(^HandleBuildingCustomerCountResult)(NSString *number);


typedef void(^HandleCityFirst)(CityFirstResult *cityResult);

typedef void(^HandleBulidingDataListResult)(DataListResult*result,NSNumber *buildingNumber);
//add by wangzz 161220
typedef void(^HandleEstateResult)(ActionResult *result,NSArray *array);

@interface DataFactory (Building)

#pragma --begin 楼盘相关接口
//Array里存放的是InitalData数据,2015-07-13

//获取城市列表
-(void)getCityListWithCallBack:(HandleInitialResult)callBack;


//根据城市Id初始化
-(void)getCityFirstWithMapCityId:(NSString *)MapCityId CallBack:(HandleCityFirst)callBack;

//分页获取楼盘数据（并且根据关键字和筛选）

-(void)getBuildingsWithCityId:(NSString *)cityId andPage:(NSString *)page andKeyword:(NSString *)keyword andAreaId:(NSString*)areaId andFeatureId:(NSString*)featureId andAcreageId:(NSString *)acreageId andPriceId:(NSString *)priceId andPlatId:(NSString *)platId andPriceModel:(PriceModel*)priceModel andpropertyId:(NSString *)propertyId andBedRoomId:(NSString *)bedroomId andTrsyCar:(NSString *)trsyCar withCallBack:(HandleBulidingDataListResult)callBack;


//获取不要本城市的城市列表
-(void)getNotOwnCityListWithCallBack:(HandleInitialResult)callBack;

//获取不要自己城市的全部楼盘列表
-(void)getNotOwnCityEstateListWithCityId:(NSString *)cityId andPage:(NSString *)page andKeyword:(NSString *)keyword andAreaId:(NSString*)areaId andFeatureId:(NSString*)featureId andAcreageId:(NSString *)acreageId andPriceId:(NSString *)priceId andPlatId:(NSString *)platId andPriceModel:(PriceModel*)priceModel andpropertyId:(NSString *)propertyId andBedRoomId:(NSString *)bedroomId andTrsyCar:(NSString *)trsyCar withCallBack:(HandleBulidingDataListResult)callBack;



#pragma 废弃的数据接口,2017-01-04,nls
////获取楼盘初始化接口
//-(void)getBuildingsWithCallBack:(HandleBuildingsResult)callBack;
//////获取一个城市的全部楼盘数据，2015-08-27
//-(void)getAllBuildingsWithCallBack:(HandleDataListResult)callBack;
#pragma end

//分页获取用户已收藏的楼盘，2015-07-15
-(void)getFavoriteBuildingsWithPage:(NSString *)page andIsHomePage:(BOOL) isHomePage withCallBack:(HandleDataListResult)callBack;

- (void)getBannerBuildingWithPage:(NSString*)page cityID:(NSString*)cityID callBack:(HandleDataListResult)callBack;

//推荐楼盘
-(void)findRecommendEstateWithNumber:(NSString *)number andIsHomePage:(BOOL) isHomePage AndCityId:(NSString *)cityId withCallBack:(HandleDataListResult)callBack;


//收藏楼盘，2015-07-15
-(void)addFavoriteWithBuilding:(Building*)building withCallBack:(HandleActionResult)callBack;
//取消楼盘收藏，2015-07-15
-(void)cancelFavoriteWithBuilding:(Building*)building withCallBack:(HandleActionResult)callBack;
//获取楼盘联想关键词，2015-07-16
-(void)getBuildingKeywordsWithKeyword:(NSString*)keyword WithCallback:(HandleArrayResult)callBack;
//把JSON数据转化为楼盘数据对象，2015-07-21
-(Building*)getBuildingObjectFromJSONObject:(NSDictionary*)buildingInfo;
//获取楼盘详情信息，2015-07-17
-(void)getBuildingDetailWithId:(NSString*)bId andeventId:(NSString *)eventId WithCallback:(HandleBuildingDetail)callBack;

#pragma --end 楼盘相关接口


#pragma 废弃的数据接口,2017-05-26 11:07:09
//添加分享日志，2015-07-16
//-(void)addShareLogWithBuildingId:(NSString*)buildingId andShareMothed:(NSString*)method;

//设置楼盘置顶，2015-07-21
//-(void)setTopForBuilding:(NSString*)buildingID withCallBack:(HandleActionResult)callBack;
//取消楼盘置顶，2015-07-21
//-(void)cancelTopForBuilding:(NSString*)buildingID withCallBack:(HandleActionResult)callBack;
//获取城市置顶楼盘数量
//-(void)getestateTopNumberCountWithCallback:(HandleBuilgingTopNumberResult)callBack;
#pragma end





//获取意向客户总数
-(void)getBuildingCustomerCount:(NSString*)buildingID WithCallback:(HandleBuildingCustomerCountResult)callBack;

//聊天详情的根据确客获得楼盘列表  add by wangzz 161220
-(void)getEstateByConfirmUser:(NSString *)confirmUserId andConfirmChatUserName:(NSString*)confirmChatUserName withCallBack:(HandleEstateResult)callBack;



@end
