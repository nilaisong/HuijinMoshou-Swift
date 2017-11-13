//
//  DataFactory+Main.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "DataFactory+Main.h"
#import "NSObject+MJKeyValue.h"
#import "NetWork.h"
#import "Tool.h"
#import "UserData.h"
#import "NSObject+MJProperty.h"
#import "XTIncomeModel.h"
#import "XTMonthCommission.h"

#import "SignRanking.h"
#import "PerformanceRanking.h"
#import "LookRanking.h"
#import "RemindResult.h"
#import "CustomerCountByGroup.h"
#import "CustomerReportedRecord.h"
#import "CustomerGroup.h"
#import "Ad.h"
#import "AdModel.h"
#import "MobileVisible.h"
#import "ProgressStatus.h"
#import "CarReportedRecordModel.h"
#import "XTAppointmentCarModel.h"
#import "CarRecordListModel.h"
#import "XTOperationModelItem.h"

#import "XTMapResultModel.h"



@implementation DataFactory (Main)

//-(void)getHomeAdvertisementsWithCallback:(HandleArrayResult)callBack
//{
//    __block NSArray* adList = nil;
//    
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
//    {
//        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//        NSString* cityID = [UserData sharedUserData].cityId;
//        [parameters setValue:cityID forKey:@"cityId"];
//        
//        [[NetWork manager] POST:@"/api/agency/estate/getAds" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            if (responseObject) {
//                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
//                if (result.success) {
//                    NSArray* ads = [responseObject valueForKey:@"data"];
//                    adList = [AdModel objectArrayWithKeyValuesArray:ads];
//                }
//            }
//            callBack(adList);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            callBack(adList);
//        }];
//    }
//    else
//    {
//        callBack(adList);
//    }
//}

- (void)getHomeAdvertisementsWithCallback:(HandleArrayResult)callBack failedCallBack:(HandleActionResult)failedCallBack
{
    NSString* filePath = documentFilePathWithFileName(@"advertisedata", DataCacheFolder);
    __block NSArray* adList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        NSString* cityID = [UserData sharedUserData].cityId;
        [parameters setValue:cityID forKey:@"cityId"];

        [[NetWork manager] POST:@"/api/agency/estate/getAds" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    NSDictionary* ads = [[responseObject valueForKey:@"data"] valueForKey:@"ads"];
                    //缓存首页广告数据，2017-01-04，nls
                    [Tool archiveObject:ads withKey:@"advertisedata" ToPath:filePath];
                    
                    adList = [AdModel objectArrayWithKeyValuesArray:ads];
                }else{
                    failedCallBack(result);
                }
            }
            
            callBack(adList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSDictionary* ads = [Tool unarchiveObjectWithKey:@"advertisedata" fromPath:filePath];
            if (ads) {
                adList = [AdModel objectArrayWithKeyValuesArray:ads];
            }
            else
            {
                ActionResult* result = [[ActionResult alloc]init];
                result.message = error.localizedDescription;
                result.code = error.code;
                failedCallBack(result);
            }
            callBack(adList);

        }];
    }
    else
    {
        NSDictionary* ads = [Tool unarchiveObjectWithKey:@"advertisedata" fromPath:filePath];
        if (ads) {
            adList = [AdModel objectArrayWithKeyValuesArray:ads];
        }
        callBack(adList);
    }
}


- (void)getCommissionListWithPage:(NSString *)page WithCallBack:(HandleDataListResult)callBack{
    __block DataListResult* dataList = nil;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:page forKey:@"pageNo"];
        [parameters setValue:[NSNumber numberWithInteger:10] forKey:@"pageSize"];
        
        [[NetWork manager] POST:@"/api/agency/wealth/list" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
//                [ActionResult setupReplacedKeyFromPropertyName:^NSDictionary *{
//                    return @{@"page":@"PageData"};
//                }];
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                
                if (result.success) {
                    NSArray* listData = [responseObject valueForKey:@"data"];
                    dataList = [[DataListResult alloc] init];
                    dataList.dataArray = [XTIncomeModel  objectArrayWithKeyValuesArray:listData];
                    
                    dataList.morePage = result.page.totalCount.intValue > result.page.pageSize.intValue * result.page.pageNo.intValue;
                }
                
            }
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];

    }
    else
    {
        callBack(dataList);
    }

}

- (void)getIncomeAllWithMonthSize:(NSInteger)monthSize callBack:(HandleIncomeAllResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block XTIncomeAllModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        if( monthSize >= 1 && monthSize <= 12){
            [parameters setValue:[NSNumber numberWithInteger:monthSize] forKey:@"monthSize"];
        }
        [[NetWork manager]POST:@"/api/agency/wealth/getComAll" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [XTIncomeAllModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"allCommissionList":@"XTMonthCommission"
                                 };
                    }];
                    
                    NSDictionary* data = [responseObject valueForKey:@"data"];
//                    NSArray* commissionList = [data valueForKey:@"allCommissionList"];
                    dataList = [XTIncomeAllModel objectWithKeyValues:data];
//                    NSMutableArray* monthCommissionArray = [NSMutableArray array];
//                    for (NSDictionary* dict in commissionList) {
//                        XTMonthCommission* commission = [[XTMonthCommission alloc] init];
//                        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//                            
//                            commission.month = key;
//                            commission.commission = [obj floatValue];
//                        }];
//                        
//                        [monthCommissionArray appendObject:commission];
//                    }
                    NSMutableArray* arrayM = [NSMutableArray arrayWithArray:dataList.allCommissionList];
                    XTMonthCommission* commission = [[XTMonthCommission alloc] init];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"yyyy-MM";
                    commission.month = [formatter stringFromDate:[NSDate date]];
                    commission.commission = dataList.currentMonthCommission;
                    [arrayM appendObject:commission];
                   
                    dataList.allCommissionList = arrayM;
                    
                }else{
                    failedCallBack(result);
                }
                callBack(dataList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }else{
        callBack(dataList);
    }
}

- (void)getIncomeAllWithCallBack:(HandleIncomeAllResult)callBack{
    __block XTIncomeAllModel* dataList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/commission/agencyTwo/getComAll" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    [XTMonthCommission setupReplacedKeyFromPropertyName:^NSDictionary*{
                        return @{
                                 @"ID":@"id",
                                 };
                    }];
                    [XTIncomeAllModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"allCommissionList":@"XTMonthCommission"
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTIncomeAllModel objectWithKeyValues:data];
                }
            }
            callBack(dataList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    /*if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    { 
        NSString* url = kFullUrlWithSuffix(@"/api/commission/agencyTwo/getComAll");
        NetWork *request = [NetWork requestWithUrlString:url];
        __weak NetWork * _request = request;
        [request setCompletionBlock:^{
            NSData* responseData = _request.responseData;
            if (responseData)
            {
                NSDictionary * retDic = [self jsonObjectWithData:responseData];
                ActionResult* result = [ActionResult objectWithKeyValues:retDic];
                if (result.success)
                {
                    [XTMonthCommission setupReplacedKeyFromPropertyName:^NSDictionary*{
                        return @{
                                 @"ID":@"id",
                                 };
                    }];
                    [XTIncomeAllModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"allCommissionList":@"XTMonthCommission"
                                 };
                    }];
                    NSDictionary* data = [retDic valueForKey:@"data"];
                    dataList = [XTIncomeAllModel objectWithKeyValues:data];
                }
            }
            callBack(dataList);
        }];
        [request setFailedBlock:^{
            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
            callBack(dataList);
        }];
        [request startAsynchronous];
    }
    else
    {
        callBack(dataList);
    }*/
    
}

- (void)getSignRankingRequestWithCallBack:(HandleSignRankingRequestResult)callBack{
    __block XTSignRankingRequestModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        [[NetWork manager]POST:@"/api/agency/ranking/findSignRanking" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [XTSignRankingRequestModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"ranking":[SignRanking class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTSignRankingRequestModel objectWithKeyValues:data];
                }else{
                    
                }
                
                callBack(dataList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    else
    {
        callBack(dataList);
    }
}

- (void)getPerformanceRankingWithCallBack:(HandlePerformanceRankingResult)callBack{
    __block XTPerformanceRankingRequestModel* dataList = nil;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        
        [[NetWork manager] POST:@"/api/agency/ranking/findPerformanceRanking" parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [XTPerformanceRankingRequestModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"ranking":[PerformanceRanking class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTPerformanceRankingRequestModel objectWithKeyValues:data];
                }
                
                callBack(dataList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
        
        
    }
    else
    {
        callBack(dataList);
    }
}

- (void)getLookRankingWithCallBack:(HandleLookRankingResult)callBack{
    __block XTLookRankingRequestModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        [[NetWork manager] POST:@"/api/agency/ranking/findLookRanking" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [XTLookRankingRequestModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"ranking":[LookRanking class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTLookRankingRequestModel objectWithKeyValues:data];
                }else{
                
                }
            }
             callBack(dataList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
        
        
    }
    else
    {
        callBack(dataList);
    }
    
}

- (void)getScheduleListWithDate:(NSString *)date withCallBack:(HandleScheduleListResult)callBack{
    __block XTScheduleListResultModel* dataList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:date]) {
            [dic setValue:date forKey:@"date"];
        }
        [[NetWork manager] POST:@"api/remind/agencyTwo/myScheduleList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    [XTScheduleListResultModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"remindList":[RemindResult class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTScheduleListResultModel objectWithKeyValues:data];
                }
            }
            callBack(dataList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    /*if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSString* url = kFullUrlWithSuffix(@"/api/remind/agencyTwo/myScheduleList");
        NetWork *request = [NetWork requestWithUrlString:url];
        if (date.length > 0 && date != [NSNull class]) {
            [request addPostValue:date forKey:@"date"];
        }
        __weak NetWork * _request = request;
        [request setCompletionBlock:^{
            NSData* responseData = _request.responseData;
            if (responseData)
            {
                NSDictionary * retDic = [self jsonObjectWithData:responseData];
                ActionResult* result = [ActionResult objectWithKeyValues:retDic];
                if (result.success)
                {
                    [XTScheduleListResultModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"remindList":[RemindResult class]
                                 };
                    }];
                    NSDictionary* data = [retDic valueForKey:@"data"];
                    dataList = [XTScheduleListResultModel objectWithKeyValues:data];
                }
            }
            callBack(dataList);
        }];
        [request setFailedBlock:^{
            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
            callBack(dataList);
        }];
        [request startAsynchronous];
    }
    else
    {
        callBack(dataList);
    }*/
}

- (void)getScheduleListWithDate:(NSString *)date withCallBack:(HandleScheduleListResult)callBack failerCallBack:(HandleActionResult)failerCallBack{
    __block XTScheduleListResultModel* resultModel = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:date]) {
            [dic setValue:date forKey:@"date"];
        }
        [[NetWork manager]POST:@"/api/agency/remind/myScheduleList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                [ActionResult setupReplacedKeyFromPropertyName:^NSDictionary *{
                   return  @{
                        @"message":@"msg",
                        };
                }];
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dict = [responseObject valueForKey:@"data"];
                
                if (result.success) {
                    
                    [XTScheduleListResultModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"remindList":[RemindResult class]
                                 };
                    }];
                    [RemindResult setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"phoneList":[MobileVisible class]
                                 };
                    }];
                    resultModel = [XTScheduleListResultModel objectWithKeyValues:dict];
                }else{
                 failerCallBack(result);
                }
                callBack(resultModel);
            }else{
                callBack(resultModel);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(resultModel);
        }];
    }
}


- (void)getAllScheduleListWithCallBack:(HandleScheduleListResult)callBack{
    __block XTScheduleListResultModel* dataList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/remind/agencyTwo/allMyScheduleList" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    [XTScheduleListResultModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"remindList":[RemindResult class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTScheduleListResultModel objectWithKeyValues:data];
                }
            }
            callBack(dataList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    /*if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSString* url = kFullUrlWithSuffix(@"/api/remind/agencyTwo/allMyScheduleList");
        NetWork *request = [NetWork requestWithUrlString:url];
        __weak NetWork * _request = request;
        [request setCompletionBlock:^{
            NSData* responseData = _request.responseData;
            if (responseData)
            {
                NSDictionary * retDic = [self jsonObjectWithData:responseData];
                ActionResult* result = [ActionResult objectWithKeyValues:retDic];
                if (result.success)
                {
                    [XTScheduleListResultModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"remindList":[RemindResult class]
                                 };
                    }];
                    NSDictionary* data = [retDic valueForKey:@"data"];
                    dataList = [XTScheduleListResultModel objectWithKeyValues:data];
                }
            }
            callBack(dataList);
        }];
        [request setFailedBlock:^{
            NSLog(@"_%s_\r\n%@",__FUNCTION__,_request.responseString);
            callBack(dataList);
        }];
        [request startAsynchronous];
    }
    else
    {
        callBack(dataList);
    }*/
}

- (void)getAllScheduleListWithCallBack:(HandleScheduleListResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block XTScheduleListResultModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [[NetWork manager] POST:@"/api/agency/remind/allMyScheduleList" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                [ActionResult setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                            @"message":@"msg"
                             };
                }];
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [XTScheduleListResultModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"remindList":[RemindResult class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTScheduleListResultModel objectWithKeyValues:data];
                }else{
                    failedCallBack(result);
                }
            }
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
            failedCallBack(result);
        }];
    }else{
        callBack(dataList);
        failedCallBack(result);
    }
}

- (void)addScheduleWithCustomer:(Customer *)customer content:(NSString *)content date:(NSString *)dateStr type:(NSString* )type callBack:(HandleActionResult)callBack{
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if (customer.customerId.length > 0) {
            [parameters setValue:[NSNumber numberWithInteger:[customer.customerId integerValue]] forKey:@"customerId"];
            if (customer.sex.length > 0) {
                if ([customer.sex isEqualToString:@"男"]) {
                    [parameters setValue:@"1" forKey:@"sex"];
                }else if ([customer.sex isEqualToString:@"女"]) {
                    [parameters setValue:@"0" forKey:@"sex"];
                }else
                {
                    [parameters setValue:@"-1" forKey:@"sex"];
                }
            }
        }else
        {
            if (customer.sex.length > 0) {
                [parameters setValue:customer.sex forKey:@"sex"];
            }
        }
        if (type.length > 0) {
            [parameters setValue:type forKey:@"type"];
        }
        if (content.length > 0) {
            [parameters setValue:content forKey:@"content"];
        }
        if (dateStr.length > 0) {
            [parameters setValue:dateStr forKey:@"datetime"];
        }
        if (customer.name.length > 0) {
            [parameters setValue:customer.name forKey:@"name"];
        }
        
        if (customer.listPhone.length > 0) {
            [parameters setValue:customer.listPhone forKey:@"phone"];
        }

        [[NetWork manager] POST:@"/api/agency/remind/save" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                [ActionResult setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"message":@"msg",
                             };
                }];
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerRemind" object:nil];
                }
            }
            callBack(result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result);
        }];
    }
    else
    {
        callBack(result);
    }
}

- (void)deleteScheduleWithRemindId:(NSInteger)remindId callBack:(HandleActionResult)callBack{
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {//   /api/agency/remind/delete
//        NSString* url = kFullUrlWithSuffix(@"/api/remind/agencyTwo/delete");
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if (remindId > 0) {
            [parameters setValue:[NSNumber numberWithInteger:remindId] forKey:@"remindId"];
        }
        [[NetWork manager]POST:@"/api/agency/remind/delete" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                [ActionResult setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"message":@"msg",
                             };
                }];
                
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result);
        }];
    }
    else
    {
        callBack(result);
    }

}

- (void)getCustomerCountByStatusWithKeyword:(NSString *)keyword withCallBack:(HandleArrayResult)callBack{
    __block NSArray* dataList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:keyword forKey:@"keyword"];
        [[NetWork manager] POST:@"/api/estateCustomer/customer/getCustomerCountByStatus" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject)
            {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    NSDictionary* data = [[responseObject valueForKey:@"data"] valueForKey:@"customerCountList"];
                   dataList = [CustomerCountByGroup objectArrayWithKeyValuesArray:data];
                }
            }
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
        
    }
    else
    {
        callBack(dataList);
    }

}


- (void)getReportRecordListWithGroudId:(NSInteger)groupid keyWord:(NSString *)keyword page:(NSInteger)pageNum callBack:(HandleReportedRecordListResult)callBack{
    __block XTReportedRecordListModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
    
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if (keyword.length > 0) {
            [parameters setValue:keyword forKey:@"keyword"];
        }
        if (pageNum <= 0) {
            pageNum = 1;
        }
        [parameters setValue:[NSNumber numberWithInteger:pageNum] forKey:@"page"];
        if (groupid >= 0 && groupid <= 1000) {
            [parameters setValue:[NSNumber numberWithInteger:groupid] forKey:@"groupId"];
        }
        [[NetWork manager]POST:@"/api/estateCustomer/customer/reportedRecordList" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [XTReportedRecordListModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"customerList":[CustomerReportedRecord class]
                                 };
                    }];
                    [CustomerReportedRecord setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"phoneList":[MobileVisible class]
                                 };
                    }];
                    [CustomerReportedRecord setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"quekeName":@"confirmUserName",
                                 @"quekePhone":@"confirmUserMobile"
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTReportedRecordListModel objectWithKeyValues:data];
//                    CustomerReportedRecord* record = [dataList.customerList firstObject];
//                    record.quekeName = @"WOWOSU";
//                    record.quekePhone = @"18518593888";
                    dataList.morePage = result.page.morePage;
                    dataList.totalCount = [result.page.totalCount integerValue];
                }
            }
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    else
    {
        callBack(dataList);
    }
}

- (void)getReportedDetailWithBuildingCustomerId:(NSInteger)buildingCustomerId callBack:(HandleCustomerReportedDetailResult)callBack{
    __block CustomerReportedDetailModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:[NSNumber numberWithInteger:buildingCustomerId] forKey:@"buildingCustomerId"];
        
        [[NetWork manager]POST:@"/api/estateCustomer/customer/reportedDeail" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [CustomerReportedDetailModel setupObjectClassInArray:^NSDictionary *{
                         return @{
                                 @"buildingList":[ReportDetailBuilding class],
                                 @"phoneList":[MobileVisible class]
                                 };
                    }];
  
                    [ReportDetailBuilding setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"messageList":[ReportDetailMessage class],
                                 @"progressList":[ProgressStatus class],
                                 @"buildingTrackList":[ReportBuildingTrack class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [CustomerReportedDetailModel objectWithKeyValues:data];
                    //假数据

                }
            }
            
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
        
    }
    else
    {
        callBack(dataList);
    }

}

- (void)getReportedDetailWithBuildingCustomerId:(NSInteger)buildingCustomerId callBack:(HandleCustomerReportedDetailResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block CustomerReportedDetailModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:[NSNumber numberWithInteger:buildingCustomerId] forKey:@"buildingCustomerId"];
        
        [[NetWork manager]POST:@"/api/estateCustomer/customer/reportedDeail" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [CustomerReportedDetailModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"buildingList":[ReportDetailBuilding class],
                                 @"phoneList":[MobileVisible class]
                                 };
                    }];
                    [CustomerReportedDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"quekeName":@"confirmUserName",
                                 @"quekePhone":@"confirmUserMobile"
                                 };
                    }];
                    [MessageData setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"msgId" : @"trackId"
                                 
                                 
                                 
                                 };
                    }];
                    
                    [ReportDetailBuilding setupObjectClassInArray:^NSDictionary *{
                        return @{
//                                 @"messageList":[ReportDetailMessage class],
                                 @"progressList":[ProgressStatus class],
                                 @"buildingTrackList":[ReportBuildingTrack class]
                                 };
                    }];
                    
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [CustomerReportedDetailModel objectWithKeyValues:data];
//                    dataList.quekePhone = @"18512883884";
//                    dataList.quekeName = @"WOWOSU";
                    //假数据
                }else{
                    failedCallBack(result);
                }
            }
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
        
    }
    else
    {
        callBack(dataList);
    }

}


- (void)getCustomerStatusGroupTagWithCallBack:(HandleCustomerStatusGroupTagResult)callBack{
    __block XTCustomerStatusGroupTagModel* dataList = nil;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        [[NetWork manager]POST:@"/api/estateCustomer/customer/customerStatusGroupTag" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                ActionResult* result = [ActionResult objectWithKeyValues:responseObject];
                
                if (result.success) {
                    [XTCustomerStatusGroupTagModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"groupList":[CustomerGroup class]
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    dataList = [XTCustomerStatusGroupTagModel objectWithKeyValues:data];
                }else{
                    dataList = [[XTCustomerStatusGroupTagModel alloc]init];
                    dataList.message = result.message;
                }
                
            }
            
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    else
    {
        callBack(dataList);
    }

}

- (void)getCustomerStatusGroupTagWithCallBack:(HandleArrayResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block NSArray* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        [[NetWork manager]POST:@"/api/estateCustomer/customer/customerStatusGroupTag" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    //                    NSArray *list = [data valueForKey:@"groupList"];
                    dataList = (NSArray*)[CustomerGroup objectArrayWithKeyValuesArray:data];
                }else{
                    failedCallBack(result);
                }
            }
            
            callBack(dataList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
        
    }else{
        callBack(dataList);
    }
}

- (void)getWorkReportWithType:(NSInteger)type startDate:(NSString *)startDate endDate:(NSString *)endDate withCallBack:(HandleWorkReportResult)callBack{
    __block WorkReportModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        
        [parameters setValue:[NSNumber numberWithInteger:type] forKey:@"type"];
        
        if (startDate.length > 0) {
            [parameters setValue:startDate forKey:@"dateStart"];
        }
        
        if (endDate.length > 0) {
            [parameters setValue:endDate forKey:@"dateEnd"];
        }
        
        [[NetWork manager] POST:@"/api/agency/staticAgencyPerforman/jobReportForms" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* dict = [responseObject valueForKey:@"data"];
                    dataList = [WorkReportModel objectWithKeyValues:dict];
                }
            }
            
            callBack(dataList);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(dataList);
        }];
    }
    else
    {
        callBack(dataList);
    }
    
}

-(void)downloadSplashsData
{
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
      	  return;
    }
    if ([UserData sharedUserData].cityId.length>0)
    {
        //闪屏json数据存储地址
        NSString* splashDownloadPath = documentFilePathWithFileName(@"splashs", SplashDownloadFolder);
        //下载和缓存闪屏数据
        NSDictionary* params = [NSDictionary  dictionaryWithObjectsAndKeys:[UserData sharedUserData].cityId,@"cityId", nil];
        [[NetWork manager] syncPost:@"/api/agency/splash/getSplash" parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
        {
            if (responseObject)
            {
                NSDictionary * retDic = responseObject;
                BOOL isSucess = [[retDic valueForKey:@"success"] boolValue];
                if (isSucess)
                {
//                    NSDictionary* data = [retDic valueForKey:@"data"];
                    NSArray* splashs = [retDic valueForKey:@"data"];
  
                    [Tool archiveObject:splashs withKey:@"splashs" ToPath:splashDownloadPath];
                }
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error)
        {
             
        }];
        //下载和缓存闪屏用图片
        if ([[NSFileManager defaultManager] fileExistsAtPath:splashDownloadPath])
        {
            NSArray*splashs = [Tool unarchiveObjectWithKey:@"splashs" fromPath:splashDownloadPath];
            int validItemCount = 0;//有效闪屏数据的索引
            NSMutableArray* splashIdArray = [NSMutableArray array];
            for (NSDictionary* item in splashs)
            {
                NSString* startTime = [item stringValueForKey:@"startTime"];
                NSString* endTime = [item stringValueForKey:@"endTime"];//@"2016-02-01 00:00:00";
                NSString* nowTime = getLocationDate();
                
                NSString* imgUrl =[item stringValueForKey:@"imgUrl"];
                imgUrl = iPhone4?fullScreen4ImgUrl(imgUrl):fullScreen6ImgUrl(imgUrl);
                
                NSString* itemId = [item stringValueForKey:@"id"];
                if (itemId)
                {
                    [splashIdArray appendObject:itemId];
                    NSString* splashImgFolder = documentFilePathWithFileName(itemId,SplashDownloadFolder);
                    
                    if ([nowTime compare:endTime]==NSOrderedDescending)//过期了，移除图片
                    {
                        if ([[NSFileManager defaultManager] fileExistsAtPath:splashImgFolder])
                        {
                            [[NSFileManager defaultManager] removeItemAtPath:splashImgFolder error:nil];
                        }
                    }
                    else
                    {
                        if (![[NSFileManager defaultManager] fileExistsAtPath:splashImgFolder])
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:splashImgFolder withIntermediateDirectories:NO attributes:nil error:nil];
                        }
                        NSString* imgName = imgUrl.md5Hash;
                        NSString* splashImgPath = [splashImgFolder  stringByAppendingPathComponent:imgName];
                        //如果缓存里不存在图片，则下载
                        if (![[NSFileManager defaultManager] fileExistsAtPath:splashImgPath])
                        {
                            [[NetworkSingleton sharedNetWork] downloadFileFromUrl:imgUrl toPath:splashImgPath];
                        }
                        
                        if ([nowTime compare:startTime]==NSOrderedDescending
                            ||[nowTime compare:startTime]==NSOrderedSame)//如果是有效期内的闪屏数据
                        {
                            validItemCount++;
                            //如果是第一张有效期内的闪屏图片，则把它拷贝到显示用的位置
                            if (validItemCount==1)
                            {
                                if ([[NSFileManager defaultManager] fileExistsAtPath:splashImgPath])
                                {
                                    //先移除后新建
                                    NSString* currentSplashImgFolder = SplashImageFolder;
                                    if ([[NSFileManager defaultManager] fileExistsAtPath:currentSplashImgFolder])
                                    {
                                        [[NSFileManager defaultManager] removeItemAtPath:currentSplashImgFolder error:nil];
                                    }
                                    [[NSFileManager defaultManager] createDirectoryAtPath:currentSplashImgFolder withIntermediateDirectories:NO attributes:nil error:nil];
                                    
                                    //拷贝到用来显示闪屏图片的位置
                                    NSString* currentSplashImgPath =[currentSplashImgFolder stringByAppendingPathComponent:imgName];
                                    [[NSFileManager defaultManager] copyItemAtPath:splashImgPath toPath:currentSplashImgPath error:nil];
                                }
                            }
                        }
                    }
                }
            }
            //如果不存在有效期内的闪屏数据，则清除缓存中旧的闪屏数据
            if(validItemCount==0)
            {
                NSString* currentSplashImgFolder = SplashImageFolder;
                if ([[NSFileManager defaultManager] fileExistsAtPath:currentSplashImgFolder])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:currentSplashImgFolder error:nil];
                }
            }
            //移除老旧无效的闪屏图片
            NSArray* splashFolderArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:kPathOfDocument(SplashDownloadFolder) error:nil];
            for (NSString* fileName in splashFolderArray)
            {
                if (![fileName isEqualToString:@"splashs"]
                    &&![fileName isEqualToString:@"image"]
                    && ![splashIdArray containsObject:fileName]) {
                    NSString* splashImgFolder = documentFilePathWithFileName(fileName,SplashDownloadFolder);
                     [[NSFileManager defaultManager] removeItemAtPath:splashImgFolder error:nil];
                }
            }
        }
    }
}

- (void)getAppointmentCarListWith:(NSString *)keyword page:(NSInteger)page size:(NSInteger)size callBack:(HandleDataListResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block ActionResult* result = [[ActionResult alloc]init];
    result.success = NO;
    __block DataListResult* dataResult = [[DataListResult alloc]init];
    dataResult.dataArray = @[];
    dataResult.morePage = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:keyword forKey:@"keyword"];
        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
        if (size <= 0) {
            size = 20;
        }
        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)size] forKey:@"pageSize"];
//        NSMutableArray* arrayM = [NSMutableArray array];
//        for (int i = 0; i < 20; i++) {
//            CarReportedRecordModel* model = [[CarReportedRecordModel alloc]init];
//            model.name = [NSString stringWithFormat:@"哈哈%d",i];
//            model.buildingName = @"呵呵大的楼盘";
//            model.phoneList = [[MobileVisible alloc]init];
//            model.phoneList.hidingPhone = @"18518928883";
//            model.status = @"已预约";
//            model.trystCar = @"去预约哈";
//            model.buildingCustomerId = @"12";
//            model.buildingId = @"14";
//            [arrayM appendObject:model];
//        }
//        
//        dataResult.dataArray = @[];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            callBack(dataResult);
        });
        [[NetWork manager] POST:@"/api/estateCustomer/customer/trystCarReportedRecordList" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    NSArray* dataArray = [data valueForKey:@"customerList"];
                    dataResult.dataArray = [CarReportedRecordModel objectArrayWithKeyValuesArray:dataArray];
                    dataResult.morePage = result.page.morePage;
                }
                
            }
            callBack(dataResult);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedCallBack(result);
            callBack(dataResult);
        }];
        
    }
}

- (void)getTrystCarReportedRecordListWith:(NSString *)keyword page:(NSInteger)page size:(NSInteger)size callBack:(HandleDataListResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block ActionResult* result = [[ActionResult alloc]init];
    result.success = NO;
    __block DataListResult* dataResult = [[DataListResult alloc]init];
    dataResult.dataArray = @[];
    dataResult.morePage = NO;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:keyword forKey:@"keyword"];
        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
        if (size <= 0) {
            size = 20;
        }
        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)size] forKey:@"pageSize"];
//        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//        formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
////        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)size] forKey:@"size"];
//        NSMutableArray* arrayM = [NSMutableArray array];
//        for (int i = 0; i < 10; i++) {
//            CarRecordListModel* model = [[CarRecordListModel alloc]init];
//            model.customerName = [NSString stringWithFormat:@"小明%d",i];
//            model.buildingName = @"呵呵呵哒的楼盘";
//            model.customerMobile = @"18528834912";
//            if (i % 2 == 0) {
//                model.status = @"已分配";
//            }else if (i % 3 == 0){
//                model.status = @"已约车";
//            }else if (i % 4 == 0){
//                model.status = @"已出发";
//            }else if (i % 5 == 0){
//                model.status = @"已送达";
//            }else if(i % 6 == 0){
//                model.status = @"已作废";
//            }else if (i % 1 == 0){
//                model.status = @"已出发";
//            }
//            
//            model.createTime = @"2015-12-11 13:12:55";
//            
//            
//            [arrayM appendObject:model];
//        }
//        dataResult.dataArray = @[];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            callBack(dataResult);
        });
        [[NetWork manager] POST:@"/api/estateCustomer/customer/trystCarRecordList" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    NSArray* dataArray  = [data valueForKey:@"customerList"];
                    NSArray* modelArray = [CarRecordListModel objectArrayWithKeyValuesArray:dataArray];
                    dataResult.morePage = result.page.morePage;
                    for (CarRecordListModel* model in modelArray) {
                        if (model.createTime.length > 11) {
                            model.createTime = [model.createTime substringFromIndex:11];
                        }
                    }
                    dataResult.dataArray = modelArray;
                }
            }
            callBack(dataResult);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedCallBack(result);
            callBack(dataResult);
        }];
    }
}



- (void)getContentOperationListWithCityID:(NSString *)cityid callBack:(HandleContentOperationResult)callBack faildCallBack:(HandleActionResult)failedCallBack{
    
    NSString* filePath = documentFilePathWithFileName(@"zixundata", DataCacheFolder);
    __block ActionResult* result = [[ActionResult alloc]init];
    __block XTOperationModel* resultObj = nil;
    result.success = NO;
    NSMutableDictionary* parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:cityid forKey:@"city"];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[NetWork manager] POST:@"/api/contentOperate/getContentOperateList" parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
//                    [XTOperationModel setupReplacedKeyFromPropertyName:^NSDictionary *{
//                        return @{
//                                 @"recd_project":@"XTOperationModel",
//                                 @"recd_agency":@"XTOperationModel",
//                                 @"recd_news":@"XTOperationModel",
//                                 @"recd_features":@"XTOperationModel"
//                                 };
//                    }];
                    
                    [XTOperationModelItem setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"ID":@"id"
                                 };
                    }];
                    
                    NSDictionary* dic  = [responseObject valueForKey:@"data"];
                    resultObj = [XTOperationModel objectWithKeyValues:dic];
                    if (resultObj) {
                        //缓存首页资讯数据，2017-01-04，nls
                        [Tool archiveObject:dic withKey:@"zixundata" ToPath:filePath];
//                        resultObj.recd_news.contentUrl = @"https://www.baidu.com";
                        if (resultObj.recd_project.title.length <= 0 && resultObj.recd_news.title.length <= 0 && resultObj.recd_agency.title.length <= 0 && resultObj.recd_features.title.length <= 0) {
                            resultObj = nil;
                        }
                    }
                    
                }
            }
            callBack(resultObj);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSDictionary* dic  = [Tool unarchiveObjectWithKey:@"zixundata" fromPath:filePath];
            if (dic) {
                resultObj = [XTOperationModel objectWithKeyValues:dic];
                if (resultObj) {
                    if (resultObj.recd_project.title.length <= 0 && resultObj.recd_news.title.length <= 0 && resultObj.recd_agency.title.length <= 0 && resultObj.recd_features.title.length <= 0) {
                        resultObj = nil;
                    }
                }
            }
            else
            {
                failedCallBack(result);
            }
            callBack(resultObj);
        }];

    }
    else
    {
        NSDictionary* dic  = [Tool unarchiveObjectWithKey:@"zixundata" fromPath:filePath];
        if (dic) {
            resultObj = [XTOperationModel objectWithKeyValues:dic];
            if (resultObj) {
                //缓存首页资讯数据，2017-01-04，nls
                if (resultObj.recd_project.title.length <= 0 && resultObj.recd_news.title.length <= 0 && resultObj.recd_agency.title.length <= 0 && resultObj.recd_features.title.length <= 0) {
                    resultObj = nil;
                }
            }
        }
        callBack(resultObj);
    }
}

- (void)getReportDetailWithType:(NSString *)type recdId:(NSString *)recdId callBack:(HandleRecdDescriptionResult)callBack failedCallBack:(HandleActionResult)faildeCallBack{
    __block ActionResult* result = [[ActionResult alloc]init];
    __block XTRecdDescriptionModel* model = nil;
    result.success = NO;
    
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary* paramer = [NSMutableDictionary dictionary];
        [paramer setValue:type forKey:@"recdType"];
        [paramer setValue:recdId forKey:@"recdId"];
        [paramer setValue:[UserData sharedUserData].cityId forKey:@"city"];
        [[NetWork manager] POST:@"/api/contentOperate/recdDescription" parameters:paramer success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    [XTRecdDescriptionModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"recdDesc":@"desc"
                                 };
                    }];
                    [XTRecdDescriptionModel setupObjectClassInArray:^NSDictionary *{
                        return @{
                                 @"relateRecd":[XTOperationModelItem class],
                                 };
                    }];
                    
                    [XTOperationModelItem setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"ID":@"id",
                                 @"imgUrl":@"imageUrl",
                                 };
                    }];
                    
                    model = [XTRecdDescriptionModel objectWithKeyValues:data];
                }else{
                    faildeCallBack(result);
                }
            }
            callBack(model);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(model);
            faildeCallBack(result);
        }];
    }
}

- (void)getMoreRecdWithType:(NSString *)recdType pageNo:(NSInteger)no pageSize:(NSInteger)size callBack:(HandleDataArrayResult)callBack faildCallBack:(HandleActionResult)faildCallBack{
    __block ActionResult* result = [[ActionResult alloc]init];
    __block NSArray * dataArray = nil;
    __block BOOL morePage = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary* parame = [NSMutableDictionary dictionary];
        [parame setValue:recdType forKey:@"recdType"];
        [parame setValue:[NSNumber numberWithInteger:no] forKey:@"pageNo"];
        [parame setValue:[NSNumber numberWithInteger:size] forKey:@"pageSize"];
        [parame setValue:[UserData sharedUserData].cityId forKey:@"city"];
        [[NetWork manager] POST:@"/api/contentOperate/moreRecd" parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                morePage = result.page.morePage;
                if (result.success) {
                    NSDictionary* dataDic = [responseObject valueForKey:@"data"];
                    [XTOperationModelItem setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"ID":@"id",
                                 @"imgUrl":@"imageUrl"
                                 };
                    }];
                    dataArray = [XTOperationModelItem objectArrayWithKeyValuesArray:dataDic];
                }else{
                    faildCallBack(result);
                }
            }
            callBack(dataArray,morePage);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,NO);
            faildCallBack(result);
        }];
    }
}

- (void)getUnreadCntWithCallBack:(HandleNumberResult)callBack faildCallBack:(HandleActionResult)failedCallBack{
    __block ActionResult *result = [[ActionResult alloc]init];
    result.success = NO;
    __block NSNumber* resultNumber = @(-1);
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[NetWork manager] POST:@"/api/sys_msg/unreadcnt" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    if (data) {
                        resultNumber = [data valueForKey:@"unreadCnt"];
                        [UserData sharedUserData].newUnreadMsgCount = [resultNumber integerValue];

                    }
                }
            }
            callBack(resultNumber);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedCallBack(result);
            callBack(@(-1));
        }];
    }
}

- (void)getMapBuildingWith:(XTMapBuildingParametersModel*)model callBack:(HandleMapBuildingResult)callBack{
    __block ActionResult *result = [[ActionResult alloc]init];
    __block XTMapResultModel* resultModel = [[XTMapResultModel alloc] init];
    result.success = NO;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if (model.maxLongitude.length > 0) {
            [parameters setValue:model.maxLongitude forKey:@"maxLongitude"];//最大经度
        }
        if (model.minLongitude.length > 0) {
            [parameters setValue:model.minLongitude forKey:@"minLongitude"];
        }
        if (model.maxLatitude.length > 0) {
            [parameters setValue:model.maxLatitude forKey:@"maxLatitude"];
        }
        if (model.minLatitude.length > 0) {
            [parameters setValue:model.minLatitude forKey:@"minLatitude"];    
        }
        
        
        if (model.cityId.length > 0) {
            [parameters setValue:model.cityId forKey:@"cityId"];
        }
        if (model.districtId.length > 0) {
            [parameters setValue:model.districtId forKey:@"districtId"];
        }
        if (model.platId.length > 0) {
            [parameters setValue:model.platId forKey:@"platId"];
        }
        if (model.featureId.length > 0) {
            [parameters setValue:model.featureId forKey:@"featureId"];
        }
        
        if (model.acreageId.length > 0) {
            [parameters setValue:model.acreageId forKey:@"acreageId"];
        }
        if (model.propertyId.length > 0) {
            [parameters setValue:model.propertyId forKey:@"propertyId"];
        }
        if (model.priceMin.length > 0) {
            [parameters setValue:model.priceMin forKey:@"priceMin"];
        }
        if (model.priceMax.length > 0) {
            [parameters setValue:model.priceMax forKey:@"priceMax"];
        }
        if (model.bedroomId.length > 0) {
            [parameters setValue:model.bedroomId forKey:@"bedroomId"];
        }
        if (model.trsyCar.length > 0) {
            [parameters setValue:model.trsyCar forKey:@"trsyCar"];
        }
        if (model.modelType.length > 0) {
            [parameters setValue:model.modelType forKey:@"modelType"];
        }
        if (model.location.length > 0) {
            [parameters setValue:model.location forKey:@"location"];
        }
        if (model.km.length > 0) {
            [parameters setValue:model.km forKey:@"km"];
        }
        if (model.keywords.length > 0) {
            [parameters setValue:model.keywords forKey:@"keywords"];
        }
        
        
        
        [[NetWork manager] POST:@"/api/agency/estate/findMapEstateList" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    if (data && ![data isKindOfClass:[NSNull class]]) {
                        resultModel.modelType = [[data valueForKey:@"modelType"] integerValue];
                        NSDictionary* result = [data valueForKey:@"result"];
                        
                        switch (resultModel.modelType) {
                            case 1:
                            {
                                NSDictionary* grouped = [result valueForKey:@"grouped"];
                                if (grouped) {
                                    NSDictionary* cityId = [grouped valueForKey:@"cityId"];
                                    resultModel.cityGroupModel = [XTMapCityGroupModel objectWithKeyValues:cityId];
                                }
                               
                            }
                                break;
                            case 2:{
                                NSDictionary* grouped = [result valueForKey:@"grouped"];
                                if (grouped) {
                                    NSDictionary* districtId = [grouped valueForKey:@"districtId"];
                                    resultModel.districtGroupModel = [XTMapDistricGroupModel objectWithKeyValues:districtId];
                                    
                                }
                            }
                                break;
                            case 3:{
                                
                            }
                                break;
                            case 4:{
                                NSDictionary* response = [result valueForKey:@"response"];
                                if (response) {
                                    resultModel.buildGroupModel = [XTMapBuildGroupModel objectWithKeyValues:response];
                                    NSString* photoServer = [data valueForKey:@"photoServer"];
                                    if (photoServer.length > 0)
                                    for (XTMapBuildInfoModel* bModel in resultModel.buildGroupModel.docs) {
                                        NSString* lastChar = [photoServer substringFromIndex:photoServer.length - 1];
                                        NSString* firstChar = bModel.url.length>0?[bModel.url substringToIndex:1]:@"";
                                        if ([lastChar isEqualToString:@"/"]) {
                                            photoServer = [photoServer substringToIndex:photoServer.length - 1];
                                        }
                                        if ([firstChar isEqualToString:@"/"]) {
                                            bModel.url = [bModel.url substringFromIndex:1];
                                        }
                                        bModel.url = [NSString stringWithFormat:@"%@/%@",photoServer,bModel.url];
                                    }
                                }
                            }
                                
                            default:
                                break;
                        }
                        
                    }
                }
                
            }
            callBack(result,resultModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result,resultModel);
        }];
    }
}

- (void)getServiceState:(HandleServiceStatusResult)callBack{
    __block ActionResult* result = [[ActionResult alloc]init];
    __block ServiceStatusModel* model = [[ServiceStatusModel alloc] init];
    model.isServerStop = @"0";
    result.success = NO;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"1" forKey:@"appType"];
    [parameters setValue:@"zfLXVZJ7W8L4Go0ezjsdng==" forKey:@"token"];
    
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[NetWork managerWithBaseKey:PHPKey] POST:@"filter/appstatus/index" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    model = [ServiceStatusModel objectWithKeyValues:[responseObject valueForKey:@"data"]] ;
                }
            }
            callBack(result,model);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result,model);
        }];
        
    }
}

- (void)uploadFileWithContetnFile:(NSString *)filePath callBack:(HandleActionResult)callBack{
    __block ActionResult* result = [[ActionResult alloc] init];
    result.success = NO;
    NSData* myCrashData = [NSData dataWithContentsOfFile:filePath];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection && myCrashData) {
        [[NetWork manager] POST:@"/api/exception/addException" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.txt", str];
            
            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:myCrashData name:@"file" fileName:fileName mimeType:@"text"];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    //日志上传成功后把本地文件删除掉
                    NSFileManager *fileManger = [NSFileManager defaultManager];
                    [fileManger removeItemAtPath:filePath error:nil];
                }
            }
            callBack(result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result);
        }];
    }else{
        callBack(result);
    }
}

#pragma mark - 判断字符串是否为空
- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
