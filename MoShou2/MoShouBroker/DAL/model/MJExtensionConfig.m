//
//  MJExtensionConfig.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "Ad.h"
#import "UserData.h"
#import "OptionData.h"
#import "ExpectData.h"
#import "Customer.h"
#import "CustomersResult.h"
#import "Building.h"
#import "BuildingsResult.h"
#import "ExchangeRecord.h"
#import "ExchangeGoods.h"
#import "RoomLayout.h"
#import "TradeRecord.h"
#import "AdModel.h"
#import "CommisionData.h"
#import "BuildingListData.h"
#import "ActionResult.h"
#import "PointData.h"
#import "PointRules.h"
#import "Standard.h"
#import "SysDic.h"
#import "DistrictModel.h"
#import "PlatList.h"
#import "Estate.h"
#import "HouseType.h"
#import "House.h"
#import "EstateBuilding.h"
#import "Discount.h"
#import "AlbumData.h"
#import "Photo.h"
#import "MobileVisible.h"

#import "ReportReturnData.h"
#import "FailListData.h"
#import "ProgressStatus.h"
#import "CarReportedRecordModel.h"
#import "CustomerEvaluation.h"

#import "XTMapDoc.h"
#import "XTMapDoclist.h"
#import "XTMapResultModel.h"
#import "XTMapCityInfoModel.h"
#import "XTMapCityGroupModel.h"

#import "XTMapDistricDoc.h"
#import "XTMapDistricDocList.h"
#import "XTMapDistricInfoModel.h"
#import "XTMapDistricGroupModel.h"

#import "XTMapBuildGroupModel.h"

#import "EstateDynamicMsgModel.h"

#import "SpecialHouse.h"
#import "AddressData.h"

#import "EvaluationData.h"

@implementation MJExtensionConfig
/**
 这个方法会在MJExtensionConfig加载进内存时调用一次
 load是只要类所在文件被引用就会被调用,所以如果类没有被引用进项目，就不会有load调用
 */
+ (void)load
{

    // 相当于在UserData.m中实现了+ignoredCodingPropertyNames方法
    [ActionResult setupReplacedKeyFromPropertyName:^NSDictionary*{
        return @{
                 @"message":@"msg",
                 };
    }];
    
    [Customer setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"trackArray" : @"customerTrackList",
                 @"tradeArray" : @"buildingList"
                 };
    }];
    
    [TradeRecord setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"progress" : @"progressList",
                 @"messages" : @"messageList",
                 @"track" : @"buildingTrackList"
                 };
    }];
    // 类中的trackArray数组中存放的是MessageData模型
    // 类中的adstradeArray组中存放的是TradeRecord模型
    [Customer setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"phoneList" : @"MobileVisible",
                 @"trackArray" : @"MessageData",
                 @"tradeArray" : @"TradeRecord"
                 };
    }];
    [TradeRecord setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"messages" : @"MessageData",
                 @"track" : @"MessageData",
                 @"progress" : @"ProgressStatus",
                 @"customerEvaluationList" : @"CustomerEvaluation"
                 };
    }];
    [ProgressStatus setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"messages" : @"messageList",
                 @"descriptionText" : @"description"
                 };
    }];
    [ProgressStatus setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"messages" : @"MessageData",
                 };
    }];
    // 相当于在Customer.m中实现了+objectClassInArray方法
    [CustomersResult setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"groups" : @"OptionData",
                 @"phoneList" : @"MobileVisible",
                 @"customers" : @"Customer"
                 };
    }];
    
    [ExpectData setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"expectType" : @"OptionData",
                 @"expectLayout" : @"OptionData"
                 };
    }];
    
    [BuildingsResult setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"bannerInfos" : @"Ad",
                 @"areas" : @"OptionData",
                 @"featureTags" : @"OptionData",
                 @"buildings" : @"Building"
                 };
    }];
    
    [BuildingsResult setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"bannerInfos" : @"Ad",
                 @"areas" : @"OptionData",
                 @"featureTags" : @"OptionData",
                 @"buildings" : @"Building"
                 };
    }];
    
    [Building setupObjectClassInArray:^NSDictionary *{
        return @{
//                 @"albumArray" : @"AlbumData",
//                 @"roomLayoutArray" : @"RoomLayout"
                 };
    }];
    
    [Building setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"buildingId" : @"id",
                 @"address" : @"saleLocation",
                 @"partnerNum" : @"shipAgencyNum",
                 @"thmUrl" : @"imageUrl",
                 @"imgUrl" : @"imageMobileUrl",
                 @"brief" : @"description",
                 @"buildDistance" : @"distance"
                 };
    }];

    
    [ BuildingListData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"buildingId" : @"id",
                  @"buildDistance" : @"distance",
//                  @"imgUrl" : @"url",
                 @"saleLatitude" : @"latitude",
                 @"saleLongitude" : @"longitude",
                 
                 
                 };
    }];

    
    
    [RoomLayout setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"layoutId" : @"id",
                 @"type" : @"decoration",
                 @"imgUrl" : @"pathImgUrl",

                 @"innerArea" : @"insideArea",
                 @"presentArea" : @"giftArea",
                 @"towardsType" : @"orientation",

                 };
    }];
    
    [ExchangeRecord setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"exchangeId" : @"goodsId",
                 @"goodsName":@"goodName",
                 @"applyConvertTime" : @"createTime",
                 @"costPoint" : @"convertPoints",
                 @"thmUrl":@"goodImg"
                 };
    }];
    
    
    [ExchangeGoods setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"goodsId" : @"id",
                 @"goodsName":@"name",
                 @"availableNum":@"repertoryNum",
                 @"availableStatus":@"status",
                 @"goodsDescription":@"description",
                 @"activityTime":@"beginTime",
                 @"endTime":@"finishTime",
                 @"remarks":@"activityDescription",
                 @"convertFlow":@"convertFlow",
                 @"goodsInfo":@"info",
                 };
    }];
    [PointData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"goodsId" : @"id",
                 @"operationTime":@"createTime",
                 @"point":@"convertPoints",
                 };
    }];
    [PointRules setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descr" : @"description",
            
                 };
    }];
    
    [CommisionData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"datetime" : @"createTime",
                 @"district" : @"estateDistrict",
                 @"buildingName" : @"estateName"
                 };
    }];
    
    
    [Standard setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"standardId" : @"id",
                 };
    }];
    
    [SysDic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"sysid" : @"id",
                 };
    }];
    
    [DistrictModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"districtId" : @"id",
                 };
    }];
    
    
    [PlatList setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"listId" : @"id",
                 };
    }];
    
    [Estate setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"estateId" : @"id",
                 @"estateDescription" : @"description",
//                 @"url" : @"pathUrl",
                 @"priceDetail" : @"priceDesc",
                 @"buildingSellPoint" : @"estateSell",

                 
                 };
    }];
    
//    [HouseType setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{
//                 @"houseTypeId" : @"id",
//                 @"imgUrl" : @"pathImgUrl",
//
//                 };
//    }];
    
    [Discount setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"discountId" : @"id",
                 };
    }];
    [House setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"houseId" : @"id",
                 };
    }];
    [EstateBuilding setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"estateBuildingId" : @"id",
                 @"estateDescription" : @"description",
                 };
    }];
    
    [Photo setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"albumId" : @"id",
                 @"imgUrl" : @"pathUrl",
                 };
    }];
    
    [ReportReturnData setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"failCustomerList" : @"FailListData",
                 @"failBuildingList" : @"FailListData"
                 };
    }];
    
    [FailListData setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"phoneList" : @"MobileVisible"
                 };
    }];
    
    
    [CarReportedRecordModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"phoneList" : [MobileVisible class],
                 };
    }];
    
    [XTMapDoclist setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"docs":[XTMapDoc class],
                 };
    }];
    
    [XTMapCityGroupModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"groups":[XTMapCityInfoModel class],
                 };
    }];
    
    [XTMapDistricDocList setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"docs":[XTMapDistricDoc class],
                 };
    }];
    
    [XTMapDistricGroupModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"groups":[XTMapDistricInfoModel class],
                 };
    }];
    
    [XTMapBuildGroupModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"docs":[XTMapBuildInfoModel class],
                 };
    }];
    
    [EstateDynamicMsgModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"dynamicMsgId" : @"id",
                 };
    }];
    
    [AdModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descript":@"description"
                 };
    }];
    
    [AddressData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"addressId":@"id"
                 };
    }];
    
    [EvaluationData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"customer_review_summary":@"customerReviewSummary",
                 @"customer_review_score":@"customerReviewScore",
                 @"create_time":@"createTime"
                 };
    }];


    NSLog(@"MJExtensionConfig load");
}
@end
