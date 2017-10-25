//
//  XTMapBuildInfoModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BuildingListData;

@interface XTMapBuildInfoModel : NSObject

@property (nonatomic,strong)NSArray* acreageTypeLabel;//String

@property (nonatomic,copy)NSString* address;

@property (nonatomic,copy)NSString* cityName;

@property (nonatomic,copy)NSString* commissionBegin;

@property (nonatomic,copy)NSString* commissionDisplay;

@property (nonatomic,copy)NSString* commissionEnd;

@property (nonatomic,copy)NSString* commissionStandard;

@property (nonatomic,copy)NSString* commissionType;

@property (nonatomic,copy)NSString* customerTelType;

@property (nonatomic,copy)NSString* customerVisitEnable;

@property (nonatomic,copy)NSString* districtName;

@property (nonatomic,copy)NSString* estateId;//楼盘ID

@property (nonatomic,copy)NSString* estateLatitude;

@property (nonatomic,copy)NSString* estateLongitude;

@property (nonatomic,strong)NSArray* featureTagLabel;

@property (nonatomic,copy)NSString* isVisibleFreeAgency;

@property (nonatomic,copy)NSString* maxBedroom;

@property (nonatomic,copy)NSString* maxSaleArea;

@property (nonatomic,copy)NSString* mechanismType;

@property (nonatomic,copy)NSString* minBedroom;

@property (nonatomic,copy)NSString* minSaleArea;

@property (nonatomic,copy)NSString* name;

@property (nonatomic,copy)NSString* orgId;

@property (nonatomic,copy)NSString* platName;

@property (nonatomic,copy)NSString* price;

@property (nonatomic,copy)NSString* processTime;

@property (nonatomic,strong)NSArray* propertyTypeLabel;

@property (nonatomic,copy)NSString* status;

@property (nonatomic,copy)NSString* trystCar;

@property (nonatomic,assign)BOOL isSelected;

@property (nonatomic,copy)NSString* url;


/**
 格式化佣金字段
 */
@property (nonatomic,copy)NSString* formatCommissionStandard;
/**
 缩略图
 */
@property (nonatomic,copy)NSString* thmUrl;

/**
 将楼盘列表数据转化为XTMapBuildInfoModel
 */
@property (nonatomic,weak)BuildingListData* buildingListData;

@end
