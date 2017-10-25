//
//  XTMapBuildingParametersModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/5.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceModel.h"

@interface XTMapBuildingParametersModel : NSObject

/**
 *  最大经度，必填
 **/
@property (nonatomic,copy)NSString* maxLongitude;
/**
 *  最小经度，必填
 **/
@property (nonatomic,copy)NSString* minLongitude;
/**
 *  最大纬度，必填
 **/
@property (nonatomic,copy)NSString* maxLatitude;
/**
 *  最小纬度，必填
 **/
@property (nonatomic,copy)NSString* minLatitude;
/**
 *  城市ID，选填
 **/
@property (nonatomic,copy)NSString* cityId;
/**
 *  区县ID，选填
 **/
@property (nonatomic,copy)NSString* districtId;
/**
 *  商圈ID，选填
 **/
@property (nonatomic,copy)NSString* platId;
/**
 *  特色标签ID，选填
 **/
@property (nonatomic,copy)NSString* featureId;
/**
 *  面积区间ID，选填
 **/
@property (nonatomic,copy)NSString* acreageId;
/**
 *  物业类型ID，选填
 **/
@property (nonatomic,copy)NSString* propertyId;
/**
 *  最小价格，选填
 **/
@property (nonatomic,copy)NSString* priceMin;
/**
 *  最大价格，选填
 **/
@property (nonatomic,copy)NSString* priceMax;
/**
 *  几居室
 **/
@property (nonatomic,copy)NSString* bedroomId;
/**
 *  是否约车
 **/
@property (nonatomic,copy)NSString* trsyCar;
/**
 *  返回的数据类型（1，2为分组统计/3为楼盘列表）：
*   城市数据（1），区县数据（2），楼盘数据（3）       必填
 **/
@property (nonatomic,copy)NSString* modelType;
/**
 *  位置：中心点经纬度（格式："纬度，经度"）//附近时传
 **/
@property (nonatomic,copy)NSString* location;
/**
 *  公里：不限(0)，1公里(1),3公里(3),5公里(5)
 **/
@property (nonatomic,copy)NSString* km;
/**
 *  搜索框：可搜索楼盘名，城市，区县，地址，特色标签，物业类型，面积区间
 **/
@property (nonatomic,copy)NSString* keywords;
@end
