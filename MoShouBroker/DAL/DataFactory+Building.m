//
//  DataFactory+Building.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/7/13.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "DataFactory+Building.h"
#import "FMDBSource+Broker.h"
#import "UserData.h"
#import "Building.h"
#import "Ad.h"
#import "RoomLayout.h"
#import "AlbumData.h"
#import "OptionData.h"
#import "NSObject+MJProperty.h"
#import "FMDBSource+Broker.h"
#import "BannerInfo.h"
#import "BuildingListData.h"
#import "NetWork.h"
#import "Photo.h"
#import "CaseTelList.h"
#import "EasemobConfirmModel.h"
#import "EstateDynamicMsgModel.h"
#import "SpecialHouse.h"

@implementation DataFactory (Building)

-(void)getCityListWithCallBack:(HandleInitialResult)callBack
{
   
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        
        [[NetWork manager]POST:@"api/agency/estate/findCityList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray* cityList = nil;
            NSArray* initials = nil;

            if (responseObject) {
                BOOL isHasOverseasEstate = NO;
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    cityList = [NSMutableArray array];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    initials = [data.allKeys sortedArrayUsingComparator: ^(NSString *s1,NSString *s2)
                                {
                                    return [s1 compare:s2];
                                }];
                    
                    for (NSString* initial in initials)
                    {
                        InitialData* initialModel = [[InitialData alloc] init];
                        initialModel.initial = initial;
                        NSArray* items = [data valueForKey:initial];
                        [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{
                                     @"itemValue" : @"cityId",
                                     @"itemName" : @"name"
                                     };
                        }];
                        initialModel.dataList = [OptionData objectArrayWithKeyValuesArray:items];
                        for (OptionData *data in initialModel.dataList) {
                            if ([data.itemName isEqualToString:@"海外"]) {
                                isHasOverseasEstate = YES;
                            }
                        }
                        [cityList appendObject:initialModel];
                    }
                }
                [UserData sharedUserData].overseasEstateEnable = isHasOverseasEstate;
            }
            callBack(initials,cityList);

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            callBack(nil,nil);
        }];
    }
}

-(void)getNotOwnCityListWithCallBack:(HandleInitialResult)callBack;
{
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        
        [[NetWork manager] POST:@"api/agency/estate/findNotOwnCityList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray* cityList = nil;
            NSArray* initials = nil;
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    cityList = [NSMutableArray array];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    initials = [data.allKeys sortedArrayUsingComparator: ^(NSString *s1,NSString *s2)
                                {
                                    return [s1 compare:s2];
                                }];
                    
                    for (NSString* initial in initials)
                    {
                        InitialData* initialModel = [[InitialData alloc] init];
                        initialModel.initial = initial;
                        NSArray* items = [data valueForKey:initial];
                        [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{
                                     @"itemValue" : @"cityId",
                                     @"itemName" : @"name"
                                     };
                        }];
                        initialModel.dataList = [OptionData objectArrayWithKeyValuesArray:items];
                        [cityList appendObject:initialModel];
                    }
                }
            }
            callBack(initials,cityList);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            callBack(nil,nil);
        }];
    }
}



//-(void)getBuildingsWithCallBack:(HandleBuildingsResult)callBack
//{
//
//    
////    [[DownloaderManager sharedManager] checkDownloadItemsUpdate];
//    __block BuildingsResult* buildingsResult = nil;
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
//    {
//        NSString* url = kFullUrlWithSuffix(@"api/estateApi/agencyTwo/findEstateFirst");
//        NetWork *request = [NetWork requestWithUrlString:url];
//        if ([UserData sharedUserData].latitude
//            && [UserData sharedUserData].longitude)
//        {
//            [request addPostValue:[UserData sharedUserData].latitude forKey:@"saleLatitude"];
//            [request addPostValue:[UserData sharedUserData].longitude forKey:@"saleLongitude"];
//        }
//        //以门店城市或用户选择的城市为优先
//
//        [request addPostValue:[UserData sharedUserData].chooseCityName forKey:@"cityName"];
//        NSLog(@"%@",[UserData sharedUserData].chooseCityName);
//
//        __weak NetWork * _request = request;
//        [request setCompletionBlock:^{
//            NSData* responseData = _request.responseData;
//            
//            if (responseData)
//            {
//                NSDictionary * retDic = [self jsonObjectWithData:responseData];
//                ActionResult* result = [ActionResult objectWithKeyValues:retDic];
////                result.code = @"-1000";
//                if (result.success)
//                {
//                    buildingsResult = [[BuildingsResult alloc] init];
//                    NSDictionary* data = [retDic valueForKey:@"data"];
//                    NSArray* buildings = [data valueForKey:@"buildings"];
//                    buildingsResult.buildings = [BuildingListData objectArrayWithKeyValuesArray:buildings];
//                    buildingsResult.morePage = [[data valueForKey:@"morePage"] boolValue];
//                    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
//                        return @{@"itemValue" : @"id",@"itemName" : @"name"};
//                    }];
//                    
//                    NSArray* areas = [data valueForKey:@"areas"];
//                    NSMutableArray*objectAreas = [NSMutableArray arrayWithArray:[OptionData objectArrayWithKeyValuesArray:areas]] ;
//                    OptionData* AreaItem0 = [[OptionData alloc] init];
//                    AreaItem0.itemName = @"不限";
//                    AreaItem0.itemValue = @"";
//                    [objectAreas insertObject:AreaItem0 forIndex:0];
//                    buildingsResult.areas = objectAreas;
//                    
//                    NSArray* featureTags = [data valueForKey:@"featureTags"];
//                    NSMutableArray*objectFeatureTags = [NSMutableArray arrayWithArray:[OptionData objectArrayWithKeyValuesArray:featureTags]] ;
//                    OptionData* tagItem0 = [[OptionData alloc] init];
//                    tagItem0.itemName = @"不限";
//                    tagItem0.itemValue = @"";
//                    [objectFeatureTags insertObject:tagItem0 forIndex:0];
//                    buildingsResult.featureTags = objectFeatureTags;
//                    
//                    NSArray *acreageTypes = [data valueForKey:@"acreageTypes"];
//                    NSMutableArray *objectAcreageTypes = [NSMutableArray arrayWithArray:[OptionData objectArrayWithKeyValuesArray:acreageTypes]];
//                    OptionData *acreageTypesItem0 = [[OptionData alloc]init];
//                    acreageTypesItem0.itemName =@"不限";
//                    acreageTypesItem0.itemValue = @"";
//                    [objectAcreageTypes insertObject:acreageTypesItem0 forIndex:0];
//                    buildingsResult.acreageTypes = objectAcreageTypes;
//
//                    
//                    
//                    NSArray *priceTypes = [data valueForKey:@"priceTypes"];
//                    NSMutableArray *objectPriceTypes = [NSMutableArray arrayWithArray:[OptionData objectArrayWithKeyValuesArray:priceTypes]];
//                    OptionData *priceItem0 = [[OptionData alloc]init];
//                    priceItem0.itemName =@"不限";
//                    priceItem0.itemValue = @"";
//                    [objectPriceTypes insertObject:priceItem0 forIndex:0];
//                    buildingsResult.priceTypes = objectPriceTypes;
//                    
////                    NSDictionary *priceTypesDic = [data valueForKey:@"priceTypes"];
////                    NSString *string1 = [priceTypesDic valueForKey:@"1"];
////                    NSString *string2 = [priceTypesDic valueForKey:@"2"];
////                    NSMutableArray *priceTypesArr = [NSMutableArray array];
////                    [priceTypesArr appendObject:string1];
////                    [priceTypesArr appendObject:string2];
////                    [priceTypesArr appendObject:@"不限"];
////                    buildingsResult.priceTypes = priceTypesArr;
//
//                    
//                    
//                    [BannerInfo setupReplacedKeyFromPropertyName:^NSDictionary *{
//                        return @{
//                                // @"buildingId" : @"estateId",
//                                //@"name" : @"estateName",
//                                 @"descript" : @"description",
//                                 };
//                    }];
//                   
//                    NSArray* bannerInfos = [data valueForKey:@"bannerInfos"];
//                    buildingsResult.bannerInfos = [BannerInfo objectArrayWithKeyValuesArray:bannerInfos];
//                }
//            }
//            callBack(buildingsResult);
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
//            callBack(buildingsResult);
//        }];
//       [request startAsynchronous];
//    }
//    else
//    {
//        callBack(buildingsResult);
//    }
//}

//-(void)getAllBuildingsWithCallBack:(HandleDataListResult)callBack
//{
//    __block DataListResult* dataListResult = nil;
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
//    {
//        NSString* url = kFullUrlWithSuffix(@"api/agency/estate/findAllEstateList");
//        NetWork *request = [NetWork requestWithUrlString:url];
//
//        
//        __weak NetWork * _request = request;
//        [request setCompletionBlock:^{
//            NSData* responseData = _request.responseData;
//            if (responseData)
//            {
//                NSDictionary * retDic = [self jsonObjectWithData:responseData];
//                
//                DLog(@"retDic====%@",retDic);
//                ActionResult* result = [ActionResult objectWithKeyValues:retDic];
//                if (result.success)
//                {
//                    dataListResult = [[DataListResult alloc] init];
//                    NSArray*buildings = [retDic valueForKey:@"data"];
//                    dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
//                }
//            }
//            callBack(dataListResult);
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
//            callBack(dataListResult);
//        }];
//        [request startAsynchronous];
//    }
//    else
//    {
//        callBack(dataListResult);
//    }                                                                                                                                                                              
//}

-(DataListResult*)parseResponseBuildingsData:(NSDictionary*)dic
{
    ActionResult* result = [ActionResult objectWithKeyValues:dic];
    DataListResult* dataListResult = nil;
    if (result.success)
    {
        NSArray*buildings = [dic valueForKey:@"data"];
        

        dataListResult = [[DataListResult alloc] init];
        
        dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
        
        PageData *pageData = result.page;
        dataListResult.totalCount = pageData.totalCount;
        dataListResult.morePage = pageData.morePage;
    }
    return  dataListResult;
}

-(void)getBuildingsWithCityId:(NSString *)cityId andPage:(NSString *)page andKeyword:(NSString *)keyword andAreaId:(NSString*)areaId andFeatureId:(NSString*)featureId andAcreageId:(NSString *)acreageId andPriceId:(NSString *)priceId andPlatId:(NSString *)platId andPriceModel:(PriceModel*)priceModel andpropertyId:(NSString *)propertyId andBedRoomId:(NSString *)bedroomId andTrsyCar:(NSString *)trsyCar withCallBack:(HandleBulidingDataListResult)callBack;
{
//    if (keyword.length>0) {
//        [[FMDBSource sharedFMDBSource] insertBuildingSearchKeyword:keyword];}
    NSString* filePath = documentFilePathWithFileName(@"buildingsdata", DataCacheFolder);
    __block DataListResult* dataListResult = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        NSString* url =@"api/agency/estate/findEstateList";
        [params setValue:page forKey:@"pageNo"];
        [params setValue:PAGESIZE forKey:@"pageSize"];

        if ([UserData sharedUserData].latitude
            && [UserData sharedUserData].longitude)
        {
            [params setValue:[UserData sharedUserData].latitude forKey:@"latitude"];
            [params setValue:[UserData sharedUserData].longitude forKey:@"longitude"];
        }
        if (cityId.length>0) {
            [params setValue:cityId forKey:@"cityId"];
        }else{
            [params setValue:[UserData sharedUserData].chooseCityId forKey:@"cityId"];
 
        }
        if (areaId.length>0) {
            [params setValue:areaId forKey:@"districtId"];
        }
        if (platId.length>0) {
            [params setValue:platId forKey:@"platId"];
        }
        
        if (featureId.length>0) {
            [params setValue:featureId forKey:@"featureId"];
        }
        if (keyword.length>0) {
            [params setValue:keyword forKey:@"name"];
        }
        if (acreageId.length>0) {
            [params setValue:acreageId forKey:@"acreageId"];
        }
        if (priceId.length>0) {
            [params setValue:priceId forKey:@"priceId"];
        }
        if (priceModel.priceMin>0) {
            [params setValue:priceModel.priceMin forKey:@"priceMin"];

        }
        if (priceModel.priceMax>0) {
            [params setValue:priceModel.priceMax forKey:@"priceMax"];
            
        }
        
        if (propertyId.length>0) {
            [params setValue:propertyId forKey:@"propertyId"];
        }
        if (bedroomId.length>0) {
            [params setValue:bedroomId forKey:@"bedroomId"];
        }
        
        if (trsyCar.length>0) {
            
            [params setValue:trsyCar forKey:@"trsyCar"];
        }

        
        [[NetWork manager]POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject)
            {
                NSDictionary *dic = [self deleteEmpty:responseObject];
                if (keyword.length == 0 && areaId.length == 0 && featureId.length==0 && acreageId.length==0 && priceId.length==0 && [page integerValue] ==1 && platId.length == 0 && priceModel.priceMin.length==0 && priceModel.priceMax.length ==0&&propertyId.length==0 && bedroomId.length==0 &&trsyCar.length==0 && dic)
                {
                    [Tool archiveObject:dic withKey:@"buildingsdata" ToPath:filePath];
                }
                dataListResult = [self parseResponseBuildingsData:dic];
            }
            callBack(dataListResult,dataListResult.totalCount);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSDictionary *dic = [Tool unarchiveObjectWithKey:@"buildingsdata" fromPath:filePath];
            if (dic)
            {
                dataListResult = [self parseResponseBuildingsData:dic];
            }
            callBack(dataListResult,dataListResult.totalCount);
            
        }];
        
      }
}
//获取不要自己城市的全部楼盘列表
-(void)getNotOwnCityEstateListWithCityId:(NSString *)cityId andPage:(NSString *)page andKeyword:(NSString *)keyword andAreaId:(NSString*)areaId andFeatureId:(NSString*)featureId andAcreageId:(NSString *)acreageId andPriceId:(NSString *)priceId andPlatId:(NSString *)platId andPriceModel:(PriceModel*)priceModel andpropertyId:(NSString *)propertyId andBedRoomId:(NSString *)bedroomId andTrsyCar:(NSString *)trsyCar withCallBack:(HandleBulidingDataListResult)callBack;
{
    __block DataListResult* dataListResult = nil;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSString* url = @"api/agency/estate/notOwnCityEstateList";
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:page forKey:@"pageNo"];
        [params setValue:PAGESIZE forKey:@"pageSize"];
        
        if ([UserData sharedUserData].latitude
            && [UserData sharedUserData].longitude)
        {
            [params setValue:[UserData sharedUserData].latitude forKey:@"latitude"];
            [params setValue:[UserData sharedUserData].longitude forKey:@"longitude"];
        }
        
        if (areaId.length>0) {
            [params setValue:areaId forKey:@"districtId"];
        }
        if (platId.length>0) {
            [params setValue:platId forKey:@"platId"];
        }
        
        if (featureId.length>0) {
            [params setValue:featureId forKey:@"featureId"];
        }
        if (keyword.length>0) {
            [params setValue:keyword forKey:@"name"];
        }
        if (acreageId.length>0) {
            [params setValue:acreageId forKey:@"acreageId"];
        }
        if (priceId.length>0) {
            [params setValue:priceId forKey:@"priceId"];
        }
        if (priceModel.priceMin>0) {
            [params setValue:priceModel.priceMin forKey:@"priceMin"];
            
        }
        if (priceModel.priceMax>0) {
            [params setValue:priceModel.priceMax forKey:@"priceMax"];
            
        }
        
        if (propertyId.length>0) {
            [params setValue:propertyId forKey:@"propertyId"];
        }
        if (bedroomId.length>0) {
            [params setValue:bedroomId forKey:@"bedroomId"];
        }
        if (trsyCar.length>0) {
            [params setValue:trsyCar forKey:@"trsyCar"];
        }
        [[NetWork manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (responseObject)
            {
                NSDictionary *dic = [self deleteEmpty:responseObject];
                dataListResult = [self parseResponseBuildingsData:dic];
            }
            callBack(dataListResult,dataListResult.totalCount);

            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
           
            callBack(dataListResult,dataListResult.totalCount);

            
        }];
    }
}
-(void)getFavoriteBuildingsWithPage:(NSString *)page andIsHomePage:(BOOL) isHomePage withCallBack:(HandleDataListResult)callBack
{
    __block DataListResult* dataListResult = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSString* url = kFullUrlWithSuffix(@"api/agency/estate/findMyFavoriteEstateList");
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:page forKey:@"pageNo"];
        [params setValue:PAGESIZE forKey:@"pageSize"];
        if ([UserData sharedUserData].latitude
            && [UserData sharedUserData].longitude)
        {
            [params setValue:[UserData sharedUserData].latitude  forKey:@"latitude"];
            [params setValue:[UserData sharedUserData].longitude forKey:@"longitude"];
        }
        [[NetWork manager] POST:url parameters:params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
        {
            if (responseObject)
            {
                NSDictionary *dic = [self deleteEmpty:responseObject];

                
                ActionResult* result = [ActionResult objectWithKeyValues:dic];
                
                if (result.success)
                {
                    dataListResult = [[DataListResult alloc] init];
                    NSArray*buildings = [responseObject valueForKey:@"data"];

                    if (isHomePage) {
                        dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
                        
                    }else{
                        dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
                    }
                    PageData* page = result.page;
                    
                    dataListResult.morePage = page.morePage;
                }
                else
                {
                    //
                }
               callBack(dataListResult);
            }
         }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           callBack(dataListResult);
        }];
    }
    else
    {
        callBack(dataListResult);
    }

}
//解析首页广告数据，2017-01-05，nls
-(DataListResult*)parseResponseHomeBanner:(NSDictionary*)homeBanners
{
    DataListResult* dataListResult = [[DataListResult alloc] init];
    ActionResult* result = [ActionResult objectWithKeyValues:homeBanners];
    NSArray*buildings = [[homeBanners valueForKey:@"data"] valueForKey:@"banner"];
    
    dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
    PageData* page = result.page;
    
    dataListResult.morePage = page.morePage;
    
    return dataListResult;
}

- (void)getBannerBuildingWithPage:(NSString *)page cityID:(NSString *)cityID callBack:(HandleDataListResult)callBack{
    
    NSString* filePath = documentFilePathWithFileName(@"homebanners", DataCacheFolder);
    __block DataListResult* dataListResult = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSString* url = kFullUrlWithSuffix(@"api/agency/estate/getBanner");
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:page forKey:@"pageNo"];
        [params setValue:PAGESIZE forKey:@"pageSize"];
        [params setValue:cityID forKey:@"cityId"];

        [[NetWork manager] POST:url parameters:params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
         {
             if (responseObject)
             {
                 ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                 
                 if (result.success)
                 {
                     //缓存首页热门楼盘数据，2017-01-04，nls
                     if ([page integerValue]==1)
                     {
                         [Tool archiveObject:responseObject withKey:@"homebanners" ToPath:filePath];
                     }
                     
                     NSArray*buildings = [[responseObject valueForKey:@"data"] valueForKey:@"banner"];
                     dataListResult = [[DataListResult alloc] init];
                     dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
                     PageData* page = result.page;
                     
                     dataListResult.morePage = page.morePage;
                 }
                 else
                 {
                     //
                 }
                 callBack(dataListResult);
             }
         }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSDictionary*homeBanners = [Tool unarchiveObjectWithKey:@"homebanners" fromPath:filePath];
            if ([page integerValue]==1 && homeBanners)
            {
               dataListResult = [self parseResponseHomeBanner:homeBanners];
            }
            callBack(dataListResult);
        }];
    }
    else
    {
        NSDictionary*homeBanners = [Tool unarchiveObjectWithKey:@"homebanners" fromPath:filePath];
        if ([page integerValue]==1 && homeBanners)
        {
            dataListResult = [self parseResponseHomeBanner:homeBanners];
        }
        callBack(dataListResult);
    }

}

-(void)findRecommendEstateWithNumber:(NSString *)number andIsHomePage:(BOOL) isHomePage AndCityId:(NSString *)cityId withCallBack:(HandleDataListResult)callBack;
{
    NSString* filePath = documentFilePathWithFileName(@"recommendbuildings", DataCacheFolder);
    __block DataListResult* dataListResult = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSString* url = @"api/agency/estate/findRecommendEstate";
        NSMutableDictionary * params = [NSMutableDictionary dictionary];

        if (cityId.length>0) {
            [params setValue:cityId forKey:@"cityId"];
        }else{
            if (isHomePage) {
                [params setValue:[UserData sharedUserData].cityId forKey:@"cityId"];
                [params setValue:[UserData sharedUserData].cityName forKey:@"cityName"];
                
            }else{
                [params setValue:[UserData sharedUserData].chooseCityId forKey:@"cityId"];
                [params setValue:[UserData sharedUserData].chooseCityName forKey:@"cityName"];
            }
        }
        [params setValue:number forKey:@"number"];
        if ([UserData sharedUserData].latitude
            && [UserData sharedUserData].longitude)
        {
            [params setValue:[UserData sharedUserData].latitude forKey:@"latitude"];
            [params setValue:[UserData sharedUserData].longitude forKey:@"longitude"];
        }
    
      [[NetWork manager]POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
          if (responseObject)
          {
              ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
              if (result.success)
              {
                  //缓存首页推荐楼盘数据，2017-01-04，nls
                  if(isHomePage)
                      [Tool archiveObject:responseObject withKey:@"recommendbuildings" ToPath:filePath];
                  dataListResult = [[DataListResult alloc] init];
                  NSArray*buildings = [responseObject valueForKey:@"data"];
                  dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
                  //                    dataListResult.morePage = [[data valueForKey:@"morePage"] boolValue];
              }
          }
          callBack(dataListResult);
          
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSDictionary * retDic = [Tool unarchiveObjectWithKey:@"recommendbuildings" fromPath:filePath];
          if (retDic && isHomePage) {
              dataListResult = [[DataListResult alloc] init];
              NSArray*buildings = [retDic valueForKey:@"data"];
              dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
          }
          callBack(dataListResult);
          
          
      }];
    
    }else{
        NSDictionary * retDic = [Tool unarchiveObjectWithKey:@"recommendbuildings" fromPath:filePath];
        if (retDic && isHomePage) {
            dataListResult = [[DataListResult alloc] init];
            NSArray*buildings = [retDic valueForKey:@"data"];
            dataListResult.dataArray = [BuildingListData objectArrayWithKeyValuesArray:buildings];
        }
        callBack(dataListResult);

    }
}
-(void)addFavoriteWithBuilding:(Building*)building withCallBack:(HandleActionResult)callBack;
{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSString* url = @"api/agency/estate/saveFavorite";
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:building.buildingId forKey:@"estateId"];
        __block ActionResult* result = [ActionResult alloc];
        result.success = NO;
        [[NetWork manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (responseObject)
            {
                NSDictionary *dic = [self deleteEmpty:responseObject];
                result = [ActionResult objectWithKeyValues:dic];
                if (result.success) {
                    building.favorite = YES;
                }
            }
            else
            {
                result.message =@"操作失败";
            }
            callBack(result);

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            result.message =@"操作失败";
            callBack(result);
        }];
    }
}
-(void)cancelFavoriteWithBuilding:(Building*)building withCallBack:(HandleActionResult)callBack;
{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSString* url = @"api/agency/estate/cancelFavorite";
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        [params setValue:building.buildingId forKey:@"estateId"];
        __block ActionResult* result = [ActionResult alloc];
        result.success = NO;
        [[NetWork manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject)
            {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    building.favorite = NO;
                }
            }
            else
            {
                result.message =@"操作失败";
            }
            callBack(result);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            result.message =@"操作失败";
            callBack(result);
        }];
        
    }
}

//-(void)addShareLogWithBuildingId:(NSString*)buildingId andShareMothed:(NSString*)method
//{
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
//    {
//        NSString* url = kFullUrlWithSuffix(@"api/estateApi/shareEstateLog");
//        NetWork *request = [NetWork requestWithUrlString:url];
//        [request addPostValue:buildingId forKey:@"estateId"];
//        [request addPostValue:method forKey:@"shareMethod"];
//        __block ActionResult* result = [ActionResult alloc];
//        result.success = NO;
//        __weak NetWork * _request = request;
//        [request setCompletionBlock:^{
//            NSData* responseData = _request.responseData;
//            if (responseData)
//            {
//                NSDictionary * retDic = [self jsonObjectWithData:responseData];
//                result = [ActionResult objectWithKeyValues:retDic];
//                if (result.success) {
//                    
//                }
//            }
//            else
//            {
//                result.message =@"操作失败";
//            }
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
//            result.message =@"操作失败";
//        }];
//        [request startAsynchronous];
//    }
//}

-(void)getBuildingKeywordsWithKeyword:(NSString*)keyword WithCallback:(HandleArrayResult)callBack
{
    __block NSArray* keywordsList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSString* url = @"api/agency/estate/findLikeName";
        NSMutableDictionary * params = [NSMutableDictionary dictionary];

        if (keyword.length>0) {
            [params setValue:keyword forKey:@"name"];
        }
        [params setValue:[UserData sharedUserData].chooseCityId forKey:@"cityId"];

         [[NetWork manager]POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
             
             if (responseObject)
             {
                 ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                 if (result.success)
                 {
                     NSArray* data = [responseObject valueForKey:@"data"];
                     keywordsList = [NSString objectArrayWithKeyValuesArray:data];
                 }
             }
             callBack(keywordsList);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             callBack(keywordsList);
             
         }];
        
}
}
-(Building*)getBuildingObjectFromJSONObject:(NSDictionary*)buildingInfo
{
    //楼盘详情信息
    Building* building = [Building objectWithKeyValues:buildingInfo];
    NSDictionary *estateInfo = [buildingInfo valueForKey:@"estate"];
    
    building.estate = [Estate objectWithKeyValues:estateInfo];
    
    NSArray *houseTypeListArr = [buildingInfo valueForKey:@"houseTypeList"];
    NSArray *photoListArr = [buildingInfo valueForKey:@"photoList"];
    NSArray *discountListArr = [buildingInfo valueForKey:@"discountList"];
    NSArray *houseListArr = [buildingInfo valueForKey:@"houseList"];
    NSArray *estateBuildingsArr = [buildingInfo valueForKey:@"estateBuildings"];
    NSArray *caseTelList = [buildingInfo valueForKey:@"caseTelList"];
    NSArray *easemobConfirmLists = [buildingInfo valueForKey:@"easemobConfirmList"];
    NSArray *estateDynamicMsgLists = [buildingInfo valueForKey:@"estateDynamicMsgList"];
    NSArray *specialHouseLists = [buildingInfo valueForKey:@"houseList"];
    
    

//    building.houseTypeLists = [HouseType objectArrayWithKeyValuesArray:houseTypeListArr];
    //把非主力户型的   剔除掉
    NSArray *tempArray = [RoomLayout objectArrayWithKeyValuesArray:houseTypeListArr];
//    NSMutableArray *roomlayoutArr = [NSMutableArray array];
//    for (RoomLayout *room in tempArray) {
//        if (room.mainTypeFlag) {
//            [roomlayoutArr appendObject:room];
//        }
//    }
    building.roomLayoutArray = tempArray;;
    building.photoLists = [Photo objectArrayWithKeyValuesArray:photoListArr];
    //把认筹活动不用显示的去掉
    NSArray *tempDiscountArray  = [Discount objectArrayWithKeyValuesArray:discountListArr];
    NSMutableArray *renChouListArray = [NSMutableArray array];
    NSMutableArray *youHuiListArray = [NSMutableArray array];
    for (Discount * disconunt in tempDiscountArray) {
        if (disconunt.status) {
            //   discountType 活动类型 0:认筹活动、1:优惠活动

            if ([disconunt.discountType isEqualToString:@"0"]) {
                
                [renChouListArray appendObject:disconunt];
            }else if([disconunt.discountType isEqualToString:@"1"]){
                
                [youHuiListArray appendObject:disconunt];
            }
            
        }
    }
    
    
    building.renChouLists = renChouListArray;
    building.youHuiLists = youHuiListArray;
    building.houseLists = [House objectArrayWithKeyValuesArray:houseListArr];
    building.estateBuildings = [EstateBuilding objectArrayWithKeyValuesArray:estateBuildingsArr];
    building.caseTelList = [CaseTelList objectArrayWithKeyValuesArray:caseTelList];
    building.easemobConfirmList = [EasemobConfirmModel objectArrayWithKeyValuesArray:easemobConfirmLists];
    building.estateDynamicMsgList = [EstateDynamicMsgModel objectArrayWithKeyValuesArray:estateDynamicMsgLists];
    building.specialHouseList = [SpecialHouse objectArrayWithKeyValuesArray:specialHouseLists];
          
    building.albumArray = [self getAlbumDataFromBuildingInfo:buildingInfo withAlbumKey:@"photoList"];
    
    //分享model
    Estate *tempEstate = building.estate;
    ShareModel *shareModel = [[ShareModel alloc]init];
    shareModel.buildingId = building.buildingId;
    shareModel.buildingName = building.name;
    shareModel.housePrice =tempEstate.price;
    shareModel.agencyName = [UserData sharedUserData].userInfo.userName;
    shareModel.mobile = [UserData sharedUserData].userInfo.mobile;
    shareModel.linkUrl = building.shareUrl;
    shareModel.content = tempEstate.estateDescription;
    shareModel.img = tempEstate.thmUrl;
    
    shareModel.district = tempEstate.district;
    shareModel.plate = tempEstate.plate;
    shareModel.acreageType = building.saleAreaSegment;
    shareModel.houseType = building.bedroomSegment;
    shareModel.AllPrice = building.minPrice;
    shareModel.buildingSellPoint = tempEstate.buildingSellPoint;
    
    building.shareInfo = shareModel;
    
    
//    //是否收藏
//    NSString* isFavorite = [buildingInfo stringValueForKey:@"favorite"];
//    if ([isFavorite isEqualToString:@"1"]) {
//        building.favorite = YES;
//    }
//    else
//    {
//        building.favorite = NO;
//    }
    //楼盘分享信息
//    NSDictionary* shareInfo =[buildingInfo valueForKey:@"shareInfo"];
//    
//    building.shareInfo = [ShareModel objectWithKeyValues:shareInfo];
//    building.shareInfo.linkUrl = [shareInfo stringValueForKey:@"shareUrl"];
//    building.shareInfo.buildingId = [buildingDetial stringValueForKey:@"id"];
//    building.shareInfo.buildingName = [buildingDetial stringValueForKey:@"name"];
    
    return building;
}
-(AlbumData*)getAlbumDataFromPhohoArr:(NSMutableArray *)photoArr
{
    NSMutableArray *tempPhotoUrlArr = [NSMutableArray array];
    AlbumData *tempData = [[AlbumData alloc]init];
    if (photoArr.count > 0)
    {
        for (Photo *photo in photoArr) {
    
            tempData.albumName = photo.name;
            [tempPhotoUrlArr appendObject:photo.imgUrl];
        }
        tempData.images = tempPhotoUrlArr;
        return tempData;

    }else{
        return nil;
    }
}

#pragma mark - 楼盘详情

-(void)getBuildingDetailWithId:(NSString*)bId andeventId:(NSString *)eventId WithCallback:(HandleBuildingDetail)callBack
{
    __block Building* building = nil;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (bId.length>0) {
            [dic setValue:bId forKey:@"estateId"];
        }
        
        if (eventId.length>0) {
            [dic setValue:eventId forKey:@"eventId"];
            [dic setValue:@"PAGE_LPXQ" forKey:@"pageId"];            
        }
        
        [[NetWork manager] POST:@"api/agency/estate/findEstateDetail" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                NSDictionary *dic = [self deleteEmpty:responseObject];
                ActionResult* result = [ActionResult objectWithKeyValues:dic];
                if (result.success)
                {
                    NSDictionary* dataDic = [dic valueForKey:@"data"];
                    
                    if (dataDic)
                    {
                        building = [self getBuildingObjectFromJSONObject:dataDic];
                    }
                }
                callBack(building,result.message);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            callBack(building,@"");
            
        }];
    }
    
}

-(NSMutableArray*)getAlbumDataFromBuildingInfo:(NSDictionary*)buildingInfo withAlbumKey:(NSString*)key
{
    //效果图
    NSMutableArray* albumArray = [NSMutableArray array];
    NSArray* effectImages =[buildingInfo valueForKey:key];
    if (effectImages.count>0) {
        for (int i=0;i<effectImages.count;i++)
        {
            BOOL flag = FALSE;
            NSDictionary* item = [effectImages objectForIndex:i];
            NSString* albumName  = [item stringValueForKey:@"photoName"];
            NSString*imgUrl = [item stringValueForKey:@"pathUrl"];
            for(AlbumData*album1 in albumArray)
            {
                if([album1.albumName isEqualToString:albumName])
                {
                    NSMutableArray* images = [NSMutableArray arrayWithArray:album1.images];
                    if (imgUrl.length>0) {
                        [images appendObject:bigImgUrl(imgUrl)];
                    }
                    album1.images = images;
                    flag = TRUE;//该组相册已存在，则直接把图片添加到此相册里
                    break;
                }
            }
            //创建新相册
            if (!flag)
            {
                AlbumData*album = [[AlbumData alloc] init];
                album.albumName = albumName;
                NSMutableArray* images =  [NSMutableArray array];
                if (imgUrl.length>0) {
                    [images appendObject:bigImgUrl(imgUrl)];
                }
                album.images = images;
                [albumArray appendObject:album];
            }
        }
    }
    return albumArray;
}




//-(AlbumData*)getAlbumDataFromBuildingInfo:(NSDictionary*)buildingInfo withAlbumKey:(NSString*)key
//{
//    //效果图
//    NSArray* effectImages =[buildingInfo valueForKey:key];
//    if (effectImages.count>0) {
//        AlbumData*album = [[AlbumData alloc] init];
//        NSMutableArray* images = [NSMutableArray array];
//        for (int i=0;i<effectImages.count;i++)
//        {
//            NSDictionary* item = [effectImages objectForIndex:i];
//            if (i==0) {
//                album.albumName = [item stringValueForKey:@"imageTypeName"];
//            }
//            NSString*imgUrl = [item stringValueForKey:@"mobileLink"];
//            if (imgUrl.length>0) {
//                [images appendObject:imgUrl];
//            }
//        }
//        album.images = images;
//
//        return album;
//    }
//    return nil;
//}

//-(void)setTopForBuilding:(NSString*)buildingID withCallBack:(HandleActionResult)callBack
//{
//    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
//    {
//        NSString* url = kFullUrlWithSuffix(@"api/agency/estate/saveTop");
//        NetWork *request = [NetWork requestWithUrlString:url];
//        [request addPostValue:buildingID forKey:@"estateId"];
//        __block ActionResult* result = [ActionResult alloc];
//        result.success = NO;
//        __weak NetWork * _request = request;
//        [request setCompletionBlock:^{
//            NSData* responseData = _request.responseData;
//            if (responseData)
//            {
//                NSDictionary * retDic = [self jsonObjectWithData:responseData];
//                result = [ActionResult objectWithKeyValues:retDic];
//                if (result.success) {
////                    building.isTop = YES;
//                }
//            }
//            else
//            {
//                result.message =@"操作失败";
//            }
//            callBack(result);
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
////            result.message =@"操作失败";
//            callBack(result);
//        }];
//        [request startAsynchronous];
//    }
//}

//-(void)cancelTopForBuilding:(NSString*)buildingID withCallBack:(HandleActionResult)callBack
//{
//    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
//    {
//        NSString* url = kFullUrlWithSuffix(@"api/agency/estate/cancelTop");
//        NetWork *request = [NetWork requestWithUrlString:url];
//        [request addPostValue:buildingID forKey:@"estateId"];
//        __block ActionResult* result = [ActionResult alloc];
//        result.success = NO;
//        __weak NetWork * _request = request;
//        [request setCompletionBlock:^{
//            NSData* responseData = _request.responseData;
//            if (responseData)
//            {
//                NSDictionary * retDic = [self jsonObjectWithData:responseData];
//                result = [ActionResult objectWithKeyValues:retDic];
//                if (result.success) {
////                    building.isTop = NO;
//                }
//            }
//            else
//            {
//                result.message =@"操作失败";
//            }
//            callBack(result);
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
//            result.message =@"操作失败";
//            callBack(result);
//        }];
//        [request startAsynchronous];
//    }
//}


//-(void)getestateTopNumberCountWithCallback:(HandleBuilgingTopNumberResult)callBack;
//{
//    
//    __block ActionResult *result = [ActionResult alloc];
//    __block NSString *TopNumberCount;
//    result.success = NO;
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
////        NSDictionary *dic = @{@"cityName":[UserData sharedUserData].theCityName};
//
//        [[NetWork manager] POST:@"api/agency/estate/estateTopNumber" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            
//            if (responseObject) {
//                result =[ActionResult objectWithKeyValues:responseObject];
//                if (result.success) {
//                    
//                  TopNumberCount = [responseObject valueForKey:@"data"];
//                    
//                }else{
//                    
//                }
//                callBack(TopNumberCount);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            callBack(TopNumberCount);
//        }];
//    }
//    
//    
//}

-(void)getBuildingCustomerCount:(NSString*)buildingID WithCallback:(HandleBuildingCustomerCountResult)callBack;
{
    __block ActionResult *result = [ActionResult alloc];
    __block NSString *customerCount;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSDictionary *dic;
        if (buildingID) {
            dic = @{@"buildingId": buildingID};
        }
        
        [[NetWork manager] POST:@"api/estateCustomer/customer/buildingCustomerCount" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data = [responseObject valueForKey:@"data"];
                    customerCount = [data valueForKey:@"count"];
                    
                }else{
                    
                }
                callBack(customerCount);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(customerCount);
        }];
    }
}
//解析城市数据，2017-01-04，nls
-(CityFirstResult*)parseResponseCityData:(NSDictionary*)data
{
    CityFirstResult *cityResult = [[CityFirstResult alloc] init];
    
    NSDictionary *decorationData = [data valueForKey:@"decoration"];
    NSArray *sys = [decorationData valueForKey:@"sysDics"];
    Standard *stand = [[Standard alloc]init];
    stand = [Standard objectWithKeyValues:decorationData];
    stand.sysDics =[SysDic objectArrayWithKeyValuesArray:sys];
    cityResult.decoration = stand;
    
    NSDictionary *propertyData = [data valueForKey:@"property"];
    NSArray *sys2 = [propertyData valueForKey:@"sysDics"];
    Standard *stand2 = [[Standard alloc]init];
    stand2 = [Standard objectWithKeyValues:propertyData];
    stand2.sysDics =[SysDic objectArrayWithKeyValuesArray:sys2];
    cityResult.property = stand2;
    
    NSDictionary *featureData = [data valueForKey:@"feature"];
    NSArray *sys3 = [featureData valueForKey:@"sysDics"];
    Standard *stand3 = [[Standard alloc]init];
    stand3 = [Standard objectWithKeyValues:featureData];
    stand3.sysDics =[SysDic objectArrayWithKeyValuesArray:sys3];
    cityResult.feature = stand3;
    //     district  商圈重新写
    NSArray *districts = [data valueForKey:@"district"];
    
    NSMutableArray *districtTempArr = [NSMutableArray array];
    for (NSInteger i = 0; i < districts.count; i ++) {
        DistrictModel *districtMo = [[DistrictModel alloc]init];
        districtMo = [DistrictModel objectWithKeyValues:districts[i]];
        NSArray *platLists = [districts[i] valueForKey:@"platList"];
        districtMo.platLists = [PlatList objectArrayWithKeyValuesArray:platLists];
        [districtTempArr appendObject:districtMo];
    }
    cityResult.districts = [NSArray arrayWithArray:districtTempArr];
    
    NSDictionary *acreageData = [data valueForKey:@"acreage"];
    NSArray *sys4 = [acreageData valueForKey:@"sysDics"];
    Standard *stand4 = [[Standard alloc]init];
    stand4 = [Standard objectWithKeyValues:acreageData];
    stand4.sysDics =[SysDic objectArrayWithKeyValuesArray:sys4];
    cityResult.acreage = stand4;
    
    NSDictionary *vicinityDic = [data valueForKey:@"vicinity"];
    NSArray *sys5 = [vicinityDic valueForKey:@"sysDics"];
    Standard *stand5 = [[Standard alloc]init];
    stand5 = [Standard objectWithKeyValues:vicinityDic];
    stand5.sysDics =[SysDic objectArrayWithKeyValuesArray:sys5];
    cityResult.vicinity = stand5;
    
    
    
    NSArray *priceTypes = [data valueForKey:@"priceTypes"];
    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"itemValue" : @"id",
                 @"itemName" : @"name"
                 };
    }];
    cityResult.priceTypes = [OptionData objectArrayWithKeyValuesArray:priceTypes];
    
    
    
    NSArray *bedroomList = [data valueForKey:@"bedroomList"];
    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"itemValue" : @"id",
                 @"itemName" : @"name"
                 };
    }];
    cityResult.bedroomList = [OptionData objectArrayWithKeyValuesArray:bedroomList];
    
    
    NSArray *trystCarLists = [data valueForKey:@"trystCarList"];
    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"itemValue" : @"id",
                 @"itemName" : @"name"
                 };
    }];
    cityResult.trystCarLists = [OptionData objectArrayWithKeyValuesArray:trystCarLists];
    
    
    NSArray *banners = [data valueForKey:@"banner"];
    [BannerInfo setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"bannerEstateId" : @"id",};
    }];
    cityResult.banners = [BannerInfo objectArrayWithKeyValuesArray:banners];
    
    NSArray *ads = [data valueForKey:@"ads"];
    [Ad setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"adId" : @"id",
                 @"descriptionString" : @"description",};
    }];
    cityResult.ads = [Ad objectArrayWithKeyValuesArray:ads];
    
    return cityResult;
}

-(void)getCityFirstWithMapCityId:(NSString *)MapCityId CallBack:(HandleCityFirst)callBack;
{
    NSString* filePath = documentFilePathWithFileName(@"citydata", DataCacheFolder);

    __block CityFirstResult *cityResult = nil;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic;
        //MapCityId 地图筛选模式的cityId 单独处理
        if (MapCityId.length>0) {
            dic = @{@"cityId":MapCityId};
        }else{
            if ([UserData sharedUserData].chooseCityId.length>0) {
                dic = @{@"cityId":[UserData sharedUserData].chooseCityId};
            }
        }
        [[NetWork manager] POST:@"/api/agency/estate/getCityFirst" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                NSDictionary *dic = [self deleteEmpty:responseObject];
                __block ActionResult *result = [ActionResult objectWithKeyValues:dic];
                if (result.success) {
                    
                    NSDictionary *data = [dic valueForKey:@"data"];
                    if (data) {
                        cityResult = [self parseResponseCityData:data];
                        //缓存城市数据,2017-01-04,nls
                        if (MapCityId.length==0) { //地图模式的数据不做缓存
                            [Tool archiveObject:data withKey:@"citydata" ToPath:filePath];

                        }
                    }
                    
                }
                callBack(cityResult);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(cityResult);

        }];
        
    }
    else
    {
        //如果没有网络，则获取缓存的城市数据,2017-01-04,nls
        NSDictionary *data = [Tool unarchiveObjectWithKey:@"citydata" fromPath:filePath];
        if (data) {
            cityResult = [self parseResponseCityData:data];
            callBack(cityResult);
        }
    }
    
}
#pragma mark - 聊天详情的根据确客获得楼盘列表  add by wangzz 161220
-(void)getEstateByConfirmUser:(NSString *)confirmUserId andConfirmChatUserName:(NSString*)confirmChatUserName withCallBack:(HandleEstateResult)callBack
{
    __block ActionResult *result = [ActionResult alloc];
    __block NSArray* estateList = nil;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (confirmUserId.length > 0) {
            [dic setValue:confirmUserId forKey:@"confirmUserId"];
        }
        if (confirmChatUserName.length > 0) {
            [dic setValue:confirmChatUserName forKey:@"confirmChatUserName"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/getEstateByConfirmUser" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data = [responseObject valueForKey:@"data"];
                    estateList = [NSMutableArray array];
                    estateList = [Estate objectArrayWithKeyValuesArray:data];
                    
                }else{
                    
                }
                callBack(result,estateList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result,estateList);
        }];
    }
}


//把请求回来的数据 空值替换掉

//删除字典里的null值
- (NSDictionary *)deleteEmpty:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    for (id obj in mdic.allKeys)
    {
        id value = mdic[obj];
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:value];
            [dicSet setValue:changeDic forKey:obj];
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:value];
            [arrSet setValue:changeArr forKey:obj];
        }
        else
        {
            if ([value isKindOfClass:[NSNull class]]) {
                [set appendObject:obj];
            }
        }
    }
    for (id obj in set)
    {
        mdic[obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        mdic[obj] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        mdic[obj] = arrSet[obj];
    }
    
    return mdic;
}

//删除数组中的null值
- (NSArray *)deleteEmptyArr:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    
    for (id obj in marr)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:obj];
            NSInteger index = [marr indexOfObject:obj];
            [dicSet setValue:changeDic forKey:@(index)];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:obj];
            NSInteger index = [marr indexOfObject:obj];
            [arrSet setValue:changeArr forKey:@(index)];
        }
        else
        {
            if ([obj isKindOfClass:[NSNull class]]) {
                NSInteger index = [marr indexOfObject:obj];
                [set appendObject:@(index)];
            }
        }
    }
    for (id obj in set)
    {
        marr[(int)obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = arrSet[obj];
    }
    return marr;
}


@end
