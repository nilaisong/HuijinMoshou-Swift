//
//  DataFactory+Customer.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/7/13.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "DataFactory+Customer.h"

@implementation DataFactory (Customer)
#pragma mark - 获取楼盘已经报备的客户列表
-(void)getBuildingCustomersWithBId:(NSString*)bId WithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:bId]) {
            [dic setValue:bId forKey:@"buildingId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/buildingCustomerList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                [Customer setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"name" : @"name"};
                }];
                customerList = [NSMutableArray array];
                NSArray* customers = [dic valueForKey:@"customerList"];
                customerList = [Customer objectArrayWithKeyValuesArray:customers];
                Customer *customer = nil;
                for (int j=0; j<customerList.count; j++) {
                    customer = [customerList objectForIndex:j];
                    if (customer.phoneList.count>0) {
                        MobileVisible *mobile = (MobileVisible *)[customer.phoneList objectForIndex:0];
                        if ([self isBlankString:mobile.hidingPhone]) {
                            customer.listPhone = mobile.totalPhone;
                        }else
                        {
                            customer.listPhone = mobile.hidingPhone;
                        }
                    }
                    NSDictionary *dic = [customers objectForIndex:j];
                    customer.expect = [self returnBackExpectAppendingString:dic];
                }
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }

}
#pragma mark - 为楼盘批量报备客户，数组元素是customer
-(void)batchAddCustomers:(NSMutableDictionary*)dic withCallBack:(HandleReportData)callBack
{
    __block ActionResult* result = nil;
    __block ReportReturnData *reportData = [[ReportReturnData alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/batchFillingCustomers" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
//                [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
//                    return @{@"itemValue" : @"customerId",@"itemName" : @"reason"};
//                }];
                NSDictionary* data = [responseObject valueForKey:@"data"];
                reportData = [ReportReturnData objectWithKeyValues:data];
                NSArray *array = [data valueForKey:@"failCustomerList"];
                if (array.count>0) {
                    reportData.failCustomerList = [FailListData objectArrayWithKeyValuesArray:array];
                }
            }
            callBack(result,reportData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            result.message =@"客户报备失败!";
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,reportData);
        }];
    }
}
#pragma mark - 为楼盘获取可报备的客户列表
-(void)getBuildingCustomersWithBId:(NSString*)bId AndKeyword:(NSString*)keyword WithCallBack:(HandleCustomerArrayResult)callBack
{
    __block ActionResult* result = nil;
    __block NSMutableArray *custArray = [[NSMutableArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:bId]) {
            [dic setValue:bId forKey:@"buildingId"];
        }
        if (![self isBlankString:keyword]) {
            [dic setValue:keyword forKey:@"keyword"];
        }
  
        [[NetWork manager] POST:@"api/estateCustomer/customer/fillingCustomerList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                [Customer setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"name" : @"customerName"};
                }];
                custArray = (NSMutableArray*)[Customer objectArrayWithKeyValuesArray:[dic valueForKey:@"dataList"]];
                Customer *customer = nil;
                for (int j=0; j<custArray.count; j++) {
                    customer = [custArray objectForIndex:j];
                    if (customer.phoneList.count>0) {
                        MobileVisible *mobile = (MobileVisible *)[customer.phoneList objectForIndex:0];
                        if ([self isBlankString:mobile.hidingPhone]) {
                            customer.listPhone = mobile.totalPhone;
                        }else
                        {
                            customer.listPhone = mobile.hidingPhone;
                        }
                    }
                }
                
            }
            callBack(result,custArray);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,custArray);
        }];
    }
}
#pragma mark - 新增客户并报备一个楼盘
-(void)addNewCustomerReportWithDict:(NSMutableDictionary*)dic withCallBack:(HandleReportData)callBack
{
    __block ActionResult* result = nil;
    __block ReportReturnData *reportData = [[ReportReturnData alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/recommendationAndAddCustomer" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary* data = [responseObject valueForKey:@"data"];
                reportData = [ReportReturnData objectWithKeyValues:data];
                NSArray *array = [data valueForKey:@"failBuildingList"];
                if (array.count>0) {
                    reportData.failBuildingList = [FailListData objectArrayWithKeyValuesArray:array];
                }
            }
            callBack(result,reportData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,reportData);
        }];
    }
}
#pragma mark - 快速报备
- (void)fastSaveCustomerWithDict:(NSMutableDictionary*)dic withCallBack:(HandleReportData)callBack
{
    __block ActionResult* result = nil;
    __block ReportReturnData *reportData = [[ReportReturnData alloc] init];
//    __block NSArray *array = [[NSArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/fastSaveCustomer" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];

                NSDictionary* dic = [responseObject valueForKey:@"data"];
                reportData = [ReportReturnData objectWithKeyValues:dic];
                NSArray *array = [dic valueForKey:@"failBuildingList"];
                if (array.count>0) {
                   reportData.failBuildingList = [FailListData objectArrayWithKeyValuesArray:array];
                    for (int i=0; i<array.count; i++) {
                        FailListData *fail = (FailListData*)[reportData.failBuildingList objectForIndex:i];
                        NSLog(@"=====%@=====%@=====",fail.name,fail.phoneList);
                    }
                }
            }
            callBack(result,reportData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,reportData);
        }];
    }
}
#pragma mark - 我的收藏楼盘列表
-(void)getFavoriteBuildingsWithPage:(NSString*)page andCustId:(NSString*)custId andKeyword:(NSString*)keyword andLongitude:(NSString*)longitude andLatitude:(NSString*)latitude andIsFullPhone:(NSString*)isFullPhone withCallBack:(HandleFavoriteBuildingDataListResult)callBack
{
    __block ActionResult* result = nil;
    __block DataListResult* dataListResult = nil;
    result.success = NO;
    __block NSString *count;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:page forKey:@"page"];
        [dic setValue:PAGESIZE forKey:@"pageSize"];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        if (![self isBlankString:keyword]) {
            [dic setValue:keyword forKey:@"keyword"];
        }
        if (![self isBlankString:longitude]) {
            [dic setValue:longitude forKey:@"saleLongitude"];
        }
        if (![self isBlankString:latitude]) {
            [dic setValue:latitude forKey:@"saleLatitude"];
        }
        if (![self isBlankString:isFullPhone]) {
            [dic setValue:isFullPhone forKey:@"isFullPhone"];
        }
        
        [[NetWork manager] POST:@"api/estateCustomer/customer/myFavoriteBuildingForFillingList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    dataListResult = [[DataListResult alloc] init];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    count = [data valueForKey:@"count"];
                    NSArray*buildings = [data valueForKey:@"dataList"];
                    dataListResult.dataArray = [CustomerBuilding objectArrayWithKeyValuesArray:buildings];
//                    dataListResult.morePage = [[data valueForKey:@"morePage"] boolValue];
                    PageData* page = result.page;
                    dataListResult.morePage = page.morePage;
                }
            }
            callBack(result,dataListResult,count);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,dataListResult,count);
        }];
    }
}
#pragma mark - 分页获取全部的楼盘列表
-(void)getFillingBuildingsWithPage:(NSString*)page andCustId:(NSString*)custId andKeyword:(NSString*)keyword andLongitude:(NSString*)longitude andLatitude:(NSString*)latitude andIsFullPhone:(NSString*)isFullPhone withCallBack:(HandleBuildingDataListResult)callBack
{
    __block ActionResult* result = nil;
    __block DataListResult* dataListResult = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:page forKey:@"page"];
        [dic setValue:PAGESIZE forKey:@"pageSize"];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        if (![self isBlankString:keyword]) {
            [dic setValue:keyword forKey:@"keyword"];
        }
        if (![self isBlankString:longitude]) {
            [dic setValue:longitude forKey:@"saleLongitude"];
        }
        if (![self isBlankString:latitude]) {
            [dic setValue:latitude forKey:@"saleLatitude"];
        }
        if (![self isBlankString:isFullPhone]) {
            [dic setValue:isFullPhone forKey:@"isFullPhone"];
        }
        
        [[NetWork manager] POST:@"api/estateCustomer/customer/buildingForFillingList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    dataListResult = [[DataListResult alloc] init];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    NSArray*buildings = [data valueForKey:@"dataList"];
                    dataListResult.dataArray = [CustomerBuilding objectArrayWithKeyValuesArray:buildings];
//                    dataListResult.morePage = [[data valueForKey:@"morePage"] boolValue];
                    PageData* page = result.page;
                    dataListResult.morePage = page.morePage;
                }
            }
            callBack(result,dataListResult);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,dataListResult);
        }];
    }
}
#pragma mark - 补全手机号并报备
-(void)fillPhoneAndRecommendationWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/fillPhoneAndRecommendation" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
//                    NSDictionary* data = [responseObject valueForKey:@"data"];
//                    NSArray*buildings = [data valueForKey:@"dataList"];
                    if ([self isBlankString:result.message]) {
                        result.message = @"报备成功";
                    }
                }
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 获取购房意向
-(void)getExpectDataWithCallBack:(HandleExpectData)callBack
{
    __block ExpectData* expectData = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/buyIntention" parameters:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    expectData = [[ExpectData alloc] init];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    //                    NSArray* areaArray =[data valueForKey:@"areaList"];
                    //                    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                    //                        return @{@"itemValue" : @"areaId",@"itemName" : @"areaName"};
                    //                    }];
                    //                    expectData.areas = [OptionData objectArrayWithKeyValuesArray:areaArray];
                    
                    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{@"itemValue" : @"id",@"itemName" : @"name"};
                    }];
                    NSArray* layoutArray =[data valueForKey:@"layoutList"];
                    expectData.expectLayout = [OptionData objectArrayWithKeyValuesArray:layoutArray];
                    
                    NSArray* typeArray =[data valueForKey:@"typeList"];
//                    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
//                        return @{@"itemValue" : @"typeId",@"itemName" : @"typeName"};
//                    }];
                    expectData.expectType = [OptionData objectArrayWithKeyValuesArray:typeArray];
                }
            }
            callBack(result,expectData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,expectData);
        }];
    }
}
#pragma mark - 为客户列表获取自定义组列表
- (void)getCustomerGroupListWithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSMutableArray* groupList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/definedGroupList" parameters:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success)
                {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    //                    NSArray *list = [data valueForKey:@"groupList"];
                    [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{
                                 @"itemValue" : @"groupId",
                                 @"itemName" : @"groupName"
                                 };
                    }];
                    groupList = (NSMutableArray*)[OptionData objectArrayWithKeyValuesArray:[data valueForKey:@"groupList"]];
                }
            }
            callBack(result,groupList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,groupList);
        }];
    }
}
#pragma mark - 为自定义列表获取客户
- (void)getCustomerListWithKeyword:(NSString *)keyword andGroupId:(NSString*)groupId withCallBack:(HandleCustomersResult)callBack
{
    __block CustomersResult* customersResult = [[CustomersResult alloc] init];
    __block ActionResult* result = nil;
    __weak DataFactory *weakSelf = self;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:groupId]) {
            [dic setValue:groupId forKey:@"groupId"];
        }
        if (![self isBlankString:keyword]) {
            [dic setValue:keyword forKey:@"keyword"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/definedGroupCustomerList" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    [Customer setupReplacedKeyFromPropertyName:^NSDictionary *{
                        return @{@"name" : @"name"};
                    }];
                    customersResult = [CustomersResult objectWithKeyValues:data];
                    customersResult.customerList = (NSMutableArray*)[Customer objectArrayWithKeyValuesArray:[data valueForKey:@"customerList"]];
                    NSArray *array = [data valueForKey:@"customerList"];
                    Customer *customer = nil;
                    for (int j=0; j<array.count; j++) {
                        customer = [[Customer alloc] init];
                        Customer *cust = [customersResult.customerList objectForIndex:j];
                        customer = cust;
                        NSDictionary *dic = [array objectForIndex:j];
//                        NSString *str = [self returnBackExpectAppendingString:dic];
//                        customer.expect = str;
                        if (customer.phoneList.count > 0) {
                            MobileVisible *mobile = (MobileVisible *)[customer.phoneList objectForIndex:0];
                            if ([self isBlankString:mobile.hidingPhone]) {
                                customer.listPhone = mobile.totalPhone;
                            }else
                            {
                                customer.listPhone = mobile.hidingPhone;
                            }
                        }
                        customer.groupList = [OptionData objectArrayWithKeyValuesArray:[dic valueForKey:@"groupList"]];
                    }
                }
            }
            callBack(result,customersResult);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customersResult);
        }];
    }
}
#pragma mark - 创建客户组
-(void)createGroupWithGroupName:(NSString*)groupName withCallBack:(HandleAddGroup)callBack
{
    __block ActionResult* result = nil;
    __block OptionData *optionData = [[OptionData alloc] init];
    optionData.itemName = groupName;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:groupName]) {
            [dic setValue:groupName forKey:@"name"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/createGroup" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    result.message = @"添加成功!";
                    NSDictionary *dic = [responseObject valueForKey:@"data"];
                    optionData.itemValue = [NSString stringWithFormat:@"%@",[dic valueForKey:@"groupId"]];
                }else{
                    result.message =@"添加失败!";
                }
            }
            callBack(result,optionData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,optionData);
            
        }];
    }
}
#pragma mark - 编辑客户组
-(void)editGroupWithGroupName:(NSString*)groupName AndGroupId:(NSString*)groupId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:groupName]) {
            [dic setValue:groupName forKey:@"name"];
        }
        if (![self isBlankString:groupId]) {
            [dic setValue:groupId forKey:@"groupId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/editGroup" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    result.message =@"修改成功";
                }else{
                    result.message =@"修改失败";
                }
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
            
        }];
    }
}
#pragma mark - 删除客户组
-(void)deleteGroupWithGroupId:(NSString*)groupId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:groupId]) {
            [dic setValue:groupId forKey:@"groupId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/deleteGroup" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    result.message =@"删除成功";
                }else{
                    
                    result.message =@"删除失败";
                }
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
            
        }];
    }
}
#pragma mark - 添加组成员
-(void)addMemberWithGroupId:(NSString*)groupId AndCustomerIds:(NSString*)customerIds withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:groupId]) {
            [dic setValue:groupId forKey:@"groupId"];
        }
        if (![self isBlankString:customerIds]) {
            [dic setValue:customerIds forKey:@"customerIds"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/addGroupMembers" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    result.message =@"分配成功";
                }else{
                    
                    result.message =@"分配失败";
                }
            }
            callBack(result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
            
        }];
    }
}
#pragma mark - 添加新客户
-(void)addNewCustomerWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/addCustomer" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 编辑客户信息
-(void)editCustomerWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/editCustomer" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            result.message =@"修改失败";
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 删除客户
-(void)deleteCustomerWithId:(NSString*)custId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/deleteCustomer" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            result.message =@"修改失败";
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 添加客户跟进信息
/*-(void)addTrackMessage:(NSString*)message withCustId:(NSString*)custId withConfirm:(NSString*)confirmShowTrack withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        if (![self isBlankString:message]) {
            [dic setValue:message forKey:@"message"];
        }
//        if (![self isBlankString:confirmShowTrack]) {
//            [dic setValue:confirmShowTrack forKey:@"confirmShowTrack"];
//        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/addCustomerFollow" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}*/
#pragma mark - 添加报备跟进信息
/*-(void)addTrackMessage:(NSString*)message withBuildingCustId:(NSString*)buildingCustId withConfirm:(NSString*)confirmShowTrack withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:buildingCustId]) {
            [dic setValue:buildingCustId forKey:@"buildingCustomerId"];
        }
        if (![self isBlankString:message]) {
            [dic setValue:message forKey:@"message"];
        }
//        if (![self isBlankString:confirmShowTrack]) {
//            [dic setValue:confirmShowTrack forKey:@"confirmShowTrack"];
//        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/addCustomerBuildingFollow" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}*/
#pragma mark - 添加跟进信息 2017-03-10
-(void)addTrackMessageWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/custfollowRecord/save" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 获取客户跟进信息列表
-(void)getTrackMessageWithDic:(NSMutableDictionary*)dic withCallBack:(HandleBuildingDataListResult)callBack
{
    __block DataListResult* messagesList = nil;
    __block ActionResult* result = nil;
//    __block NSArray *custArray = [[NSMutableArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/custfollowRecord/queryFollowRecord" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
//                [MessageData setupReplacedKeyFromPropertyName:^NSDictionary *{
//                    return @{
//                             @"msgId" : @"trackId"
//                             };
//                }];
//                NSDictionary *dic = [responseObject valueForKey:@"data"];
                messagesList = [[DataListResult alloc] init];
                messagesList.dataArray = (NSArray*)[CustomerFollowData objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
                NSDictionary *pageData = [responseObject valueForKey:@"page"];
                int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                if (pageCount>pageNo) {
                    messagesList.morePage = YES;
                }else{
                    messagesList.morePage = NO;
                }
            }
            callBack(result,messagesList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,messagesList);
        }];
    }
}
#pragma mark - 查询已报备楼盘 2017-03-10
-(void)getReportBuildingWithDic:(NSMutableDictionary*)dic WithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/custfollowRecord/queryCustomerRecmEstate" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                customerList = [NSMutableArray array];
                customerList = [CustomerFollowData objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }
}
#pragma mark - 查询创建跟进记录的用户 2017-03-10
-(void)getFollowCreatorWithDic:(NSMutableDictionary*)dic WithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/custfollowRecord/queryFollowUser" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                customerList = [NSMutableArray array];
                customerList = [CustomerFollowData objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }
}
#pragma mark - 查询已有跟进记录包含楼盘 2017-03-10
-(void)getFollowBuildingWithDic:(NSMutableDictionary*)dic WithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/custfollowRecord/queryFollowEstate" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                customerList = [NSMutableArray array];
                customerList = [CustomerFollowData objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }
}
#pragma mark - 获取报备楼盘的跟进信息列表
-(void)getTrackMessageWithBuildingCustId:(NSString*)buildingCustId withCallBack:(HandleCustomerArrayResult)callBack
{
    __block ActionResult* result = nil;
    __block NSArray *custArray = [[NSMutableArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:buildingCustId]) {
            [dic setValue:buildingCustId forKey:@"buildingCustomerId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/customerBuilidingFollowList" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                [MessageData setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"msgId" : @"trackId"
                             };
                }];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                custArray = (NSArray*)[MessageData objectArrayWithKeyValuesArray:[dic valueForKey:@"buildingTrackList"]];
            }
            callBack(result,custArray);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,custArray);
        }];
    }
}
#pragma mark - 删除客户或报备跟进信息
-(void)deleteTrackMessageWithTrackId:(NSString*)trackId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:trackId]) {
            [dic setValue:trackId forKey:@"trackId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/deleteFollow" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            result.message =@"删除失败";
            callBack(result);
        }];
    }
}
#pragma mark - 获取客户详细信息
-(void)getCustomerDetailWithId:(NSString *)custId withCallBack:(HandleCustomerDetail)callBack
{
    __block Customer* customer = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/customerDetail" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                
                NSDictionary *NoNUlldic = [self deleteEmpty:responseObject];

                result = [ActionResult objectWithKeyValues:NoNUlldic];
                NSDictionary *dic = [NoNUlldic valueForKey:@"data"];
                [MessageData setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"msgId" : @"trackId"
                             };
                }];
                [Customer setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"name" : @"customerName"};
                }];
                customer = [Customer objectWithKeyValues:dic];
                customer.customerId = custId;
                [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"itemValue" : @"groupId",
                             @"itemName" : @"groupName"
                             };
                }];
                customer.groupList = [OptionData objectArrayWithKeyValuesArray:[dic valueForKey:@"groupList"]];
                //areas   layouts    types
                customer.expect = [self returnBackExpectAppendingString:dic];
                customer.trackArray = [MessageData objectArrayWithKeyValuesArray:[dic valueForKey:@"customerTrackList"]];
                customer.tradeArray = [TradeRecord objectArrayWithKeyValuesArray:[dic valueForKey:@"buildingList"]];
                
                customer.expectData = [[ExpectData alloc] init];
                [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"itemValue" : @"id",@"itemName" : @"name"};
                }];
                NSArray* layoutArray =[dic valueForKey:@"bedroomNum"];
                customer.expectData.expectLayout = [OptionData objectArrayWithKeyValuesArray:layoutArray];
                
                NSArray* typeArray =[dic valueForKey:@"typeList"];
//                [OptionData setupReplacedKeyFromPropertyName:^NSDictionary *{
//                    return @{@"itemValue" : @"typeId",@"itemName" : @"typeName"};
//                }];
                
                customer.expectData.expectType = [OptionData objectArrayWithKeyValuesArray:typeArray];
                customer.expectData.expectPriceMin = [dic stringValueForKey:@"priceMin"];
                customer.expectData.expectPriceMax = [dic stringValueForKey:@"priceMax"];
                
                if ([self isBlankString:customer.custSourceLabel] ) {
                    customer.custSourceLabel = @"";
                }
                if (customer.phoneList.count > 0) {
                    MobileVisible *mobile = (MobileVisible *)[customer.phoneList objectForIndex:0];
                    if ([self isBlankString:mobile.hidingPhone]) {
                        customer.listPhone = mobile.totalPhone;
                    }else
                    {
                        customer.listPhone = mobile.hidingPhone;
                    }
                }
            }
            callBack(result,customer);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customer);
        }];
    }
}
#pragma mark - 客户评级
-(void)getcustomerEvaluationDetailWithCustId:(NSString*)custId withCallBack:(HandleCustomerDetail)callBack
{
    __block Customer* customer = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/customerEvaluationDetail" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                [Customer setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"name" : @"customerName"};
                }];
                customer = [Customer objectWithKeyValues:dic];
                customer.tradeArray = [TradeRecord objectArrayWithKeyValuesArray:[dic valueForKey:@"buildingList"]];
                
            }
            callBack(result,customer);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customer);
        }];
    }
}
#pragma mark - 移动客户至组
- (void)moveCustToGroupWithCustId:(NSString*)custId andGroupId:(NSString*)groupId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        if (![self isBlankString:groupId]) {
            [dic setValue:groupId forKey:@"groupId"];
        }
        
        [[NetWork manager] POST:@"api/estateCustomer/customer/moveCustomerToGroup" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 移出客户组
-(void)delGroupCustomerWithCustomerId:(NSString*)custId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/delGroupCustomer" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
            
        }];
    }
}
#pragma mark - 修改客户备注
- (void)editCustomerRemarkWithCustId:(NSString*)custId andRemark:(NSString*)remark withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        if (![self isBlankString:remark]) {
            [dic setValue:remark forKey:@"remark"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/editCustomerRemark" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
            
        }];
    }
}
#pragma mark - 判断今日是否有日程提醒
-(void)getTodayRemindStatusWithCallBack:(HandleRemindStatus)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/agency/remind/todayRemindStatus" parameters:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            BOOL hasRemind = NO;
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                hasRemind = [[dic valueForKey:@"hasRemind"] boolValue];
            }
            callBack(result,hasRemind);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,NO);
        }];
    }
}
#pragma mark - 提醒列表
-(void)getRemindListWithCustId:(NSString*)custId withCallBack:(HandleCustomerArrayResult)callBack
{
    __block ActionResult* result = nil;
    __block NSArray *custArray = [[NSMutableArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:custId]) {
            [dic setValue:custId forKey:@"customerId"];
        }
        [[NetWork manager] POST:@"api/agency/remind/remindList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                [MessageData setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"msgId" : @"remindId"
                             };
                }];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                custArray = (NSArray*)[MessageData objectArrayWithKeyValuesArray:[dic valueForKey:@"remindList"]];
            }
            callBack(result,custArray);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,custArray);
        }];
    }
}
#pragma mark - 撤销报备
- (void)revokeRecommendationWithTrackId:(NSString*)trackId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = [ActionResult alloc];
    result.success = NO;
//    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
//    {
//        NSString* url = kFullUrlWithSuffix(@"api/estateCustomer/revokeRecommendation");
//        NetWork *request = [NetWork requestWithUrlString:url];
//        [request addPostValue:trackId forKey:@"estateCustomerId"];
//        
//        __weak NetWork * _request = request;
//        [request setCompletionBlock:^{
//            NSData* responseData = _request.responseData;
//            if (responseData)
//            {
//                NSDictionary * retDic = [self jsonObjectWithData:responseData];
//                result = [ActionResult objectWithKeyValues:retDic];
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
//    else
//    {
//        callBack(result);
//    }
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:trackId]) {
            [dic setValue:trackId forKey:@"estateCustomerId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/revokeRecommendation" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            result.message = @"请求失败";
            callBack(result);
        }];
    }
}
#pragma mark - 根据手机号获得可报备数 2016-02-22
-(void)getReportCountWithMobile:(NSString*)mobile withCallBack:(HandleAddGroup)callBack
{
    __block ActionResult* result = nil;
    __block OptionData *optionData = [[OptionData alloc] init];
    optionData.itemName = mobile;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:mobile]) {
            [dic setValue:mobile forKey:@"mobile"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/reportCount" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *dic = [responseObject valueForKey:@"data"];
                    optionData.itemValue = [NSString stringWithFormat:@"%@",[dic valueForKey:@"count"]];
                }
            }
            callBack(result,optionData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,optionData);
            
        }];
    }
}
#pragma mark - 添加看房专车订单  2016-08-11
-(void)addEstateAppointCarWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager]POST:@"api/estateCustomer/customer/addEstateAppointCar" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}

#pragma mark - 获取约车记录详情  2016-08-11
-(void)getTrystCarRecordInfoWithId:(NSString*)estateAppointCarID withCallBack:(HandleTrystCarRecordInfo)callBack
{
    __block SeeAboutTheCarObject* carObj = [[SeeAboutTheCarObject alloc] init];
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:estateAppointCarID]) {
            [dic setValue:estateAppointCarID forKey:@"id"];
        }
        [[NetWork manager]POST:@"api/estateCustomer/customer/trystCarRecordInfo" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                
                NSArray *array = [SeeAboutTheCarObject objectArrayWithKeyValuesArray:[dic valueForKey:@"estateAppointCar"]];
                if (array.count>0) {
                    carObj = [array objectForIndex:0];
                }
                
//                carObj.customerId = custId;
                
            }
            callBack(result,carObj);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,carObj);
        }];
    }
}
#pragma mark - 通讯录手机号验证  2016-08-19
-(void)validationMobileWithPhone:(NSString*)phone withCallBack:(HandleCustomerDetail)callBack
{
    __block ActionResult* result = nil;
    __block Customer* customer = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    NSDictionary *dic = @{@"phone":phone};
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager]POST:@"api/estateCustomer/customer/validationMobile" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            BOOL hasRemind = NO;
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                customer = [Customer objectWithKeyValues:dic];
//                hasRemind = [[dic valueForKey:@"exist"] boolValue];
            }
            callBack(result,customer);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customer);
        }];
    }
}
#pragma mark - 楼盘的确客列表 2016-09-20
-(void)getConfirmUserListWithBId:(NSString*)bId WithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:bId]) {
            [dic setValue:bId forKey:@"buildingId"];
        }
        [[NetWork manager] POST:@"api/estateCustomer/customer/confirmUserList" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
//                NSDictionary *dic = [responseObject valueForKey:@"data"];
                [ConfirmUserInfoObject setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"confirmUserId" : @"id"};
                }];
                customerList = [NSMutableArray array];
                customerList = [ConfirmUserInfoObject objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }
}
#pragma mark 获取消息列表
-(void)getMessagesListByPage:(NSString*)page WithCallBack:(HandleNoticeDataListResult)callBack
{
    __block DataListResult* messagesList = nil;
    __block ActionResult * result = nil;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:page]) {
            [dic setValue:page forKey:@"pageNo"];
            [dic setValue:PAGESIZE forKey:@"pageSize"];
        }
//  @{@"pageNo":page,@"pageSize":PAGESIZE};
        [[NetWork manager] POST:@"api/sys_msg/showlist" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [MessageData setupReplacedKeyFromPropertyName:^NSDictionary*{
                        return @{
                                 @"msgId":@"id",
                                 @"datetime":@"createTime"
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    //                    NSArray* listData = [data valueForKey:@"listdata"];
                    messagesList = [[DataListResult alloc] init];
                    messagesList.dataArray = [MessageData  objectArrayWithKeyValuesArray:data];
                    
                    NSDictionary *pageData = [responseObject valueForKey:@"page"];
                    int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                    int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                    if (pageCount>pageNo) {
                        messagesList.morePage = YES;
                    }else{
                        messagesList.morePage = NO;
                    }
                    
                    //                    NSArray* listData = [data valueForKey:@"listdata"];
                    //                    messagesList = [[DataListResult alloc] init];
                    //                    messagesList.dataArray = [MessageData  objectArrayWithKeyValuesArray:listData];
                    //                    messagesList.morePage = [[data valueForKey:@"morePage"] boolValue];
                    
                }
                callBack(result,messagesList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,messagesList);
        }];
    }
}
#pragma mark - 通知详情
-(void)getNoticeListByPage:(NSString*)page WithMsgType:(NSString*)msgType AndEatateId:(NSString*)estateId WithCallBack:(HandleNoticeDataListResult)callBack
{
    __block DataListResult* messagesList = nil;
    __block ActionResult * result = nil;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:page]) {
            [dic setValue:page forKey:@"pageNo"];
            [dic setValue:PAGESIZE forKey:@"pageSize"];
        }
        if (![self isBlankString:msgType]) {
            [dic setValue:msgType forKey:@"msgType"];
        }
        if (![self isBlankString:estateId]) {
            [dic setValue:estateId forKey:@"estateId"];
        }
        //  @{@"pageNo":page,@"pageSize":PAGESIZE};
        [[NetWork manager] POST:@"api/sys_msg/list" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [MessageData setupReplacedKeyFromPropertyName:^NSDictionary*{
                        return @{
                                 @"msgId":@"id",
                                 @"datetime":@"createTime"
                                 };
                    }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    //                    NSArray* listData = [data valueForKey:@"listdata"];
                    messagesList = [[DataListResult alloc] init];
                    messagesList.dataArray = [MessageData  objectArrayWithKeyValuesArray:data];
                    
                    NSDictionary *pageData = [responseObject valueForKey:@"page"];
                    int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                    int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                    if (pageCount>pageNo) {
                        messagesList.morePage = YES;
                    }else{
                        messagesList.morePage = NO;
                    }
                }
                callBack(result,messagesList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,messagesList);
        }];
    }
}
#pragma mark - 消息列表的报备详情
- (void)getReportedDetailByRecordId:(NSString*)recordId AndOptType:(NSString*)optType AndBuildingCustomerId:(NSString*)buildingCustomerId callBack:(HandleCustomerReportedDetailResult)callBack failedCallBack:(HandleActionResult)failedCallBack{
    __block CustomerReportedDetailModel* dataList = nil;
    __block ActionResult* result = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:recordId]) {
            [parameters setValue:recordId forKey:@"recordId"];
        }else
        {
            [parameters setValue:@"0" forKey:@"recordId"];
        }
        if (![self isBlankString:optType]) {
            [parameters setValue:optType forKey:@"optType"];
        }else
        {
            [parameters setValue:@"0" forKey:@"optType"];
        }
        if (![self isBlankString:buildingCustomerId]) {
            [parameters setValue:buildingCustomerId forKey:@"buildingCustomerId"];
        }else
        {
            [parameters setValue:@"0" forKey:@"buildingCustomerId"];
        }
        [[NetWork manager]POST:@"api/estateCustomer/customer/reportedDeailByRecordId" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark - 按消息类型读取消息
- (void)readMessageByMsgType:(NSString*)msgType AndEstateId:(NSString*)estateId withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:msgType]) {
            [dic setValue:msgType forKey:@"msgType"];
        }
        if (![self isBlankString:estateId]) {
            [dic setValue:estateId forKey:@"estateId"];
        }
        [[NetWork manager]POST:@"api/sys_msg/readByMsgType" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
            
        }];
    }
}
#pragma mark 获取未读消息数量
-(void)getOldUnreadMessageCountWithCallback:(HandleNumberResult)callBack{
    
    __block ActionResult *result =[ActionResult alloc];
    __block NSNumber* unreadCount = nil;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        //api/sys_msg/oldunreadcnt
        [[NetWork manager] POST:@"api/sysmsg/unreadcnt" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data = [responseObject valueForKey:@"data"];
                    unreadCount = [data valueForKey:@"unreadCnt"];
                    
                    
                }else{
                    
                }
                callBack(unreadCount);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(unreadCount);
        }];
    }
    
}
#pragma mark - 添加和修改经纪人收货地址 2017-03-10
-(void)modifyAddressWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/sysUserAddress/save" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 查询经纪人收货地址 2017-03-10
-(void)getAddressWithDict:(NSMutableDictionary*)dic withCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/sysUserAddress/list" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                customerList = [NSMutableArray array];
                customerList = [AddressData objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }
}
#pragma mark - 删除经纪人收货地址 2017-03-10
-(void)deleteAddressWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack
{
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/sysUserAddress/delete" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            callBack(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result);
        }];
    }
}
#pragma mark - 经纪人获取客户评价列表 2017-03-10
-(void)getEvaluationWithDict:(NSMutableDictionary*)dic withCallBack:(HandleBuildingDataListResult)callBack
{
    __block DataListResult* messagesList = nil;
    __block ActionResult* result = nil;
    //    __block NSArray *custArray = [[NSMutableArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/agency/agencyReview" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                //                [MessageData setupReplacedKeyFromPropertyName:^NSDictionary *{
                //                    return @{
                //                             @"msgId" : @"trackId"
                //                             };
                //                }];
                //                NSDictionary *dic = [responseObject valueForKey:@"data"];
                messagesList = [[DataListResult alloc] init];
                messagesList.dataArray = (NSArray*)[EvaluationData mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
                
                NSDictionary *pageData = [responseObject valueForKey:@"page"];
                int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                if (pageCount>pageNo) {
                    messagesList.morePage = YES;
                }else{
                    messagesList.morePage = NO;
                }
            }
            callBack(result,messagesList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,messagesList);
        }];
    }
}
#pragma mark - 客户来源列表 2017-04-26
-(void)getCustomerSourceWithCallBack:(HandleCustomerArrayResult)callBack
{
    __block NSArray* customerList = nil;
    __block ActionResult* result = nil;
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [[NetWork manager] POST:@"api/estateCustomer/customer/getAgencyCustSource" parameters:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSString* filePath = documentFilePathWithFileName(@"customerSourcedata", DataCacheFolder);
                NSDictionary *resDic = [responseObject valueForKey:@"data"];
                [Tool archiveObject:resDic withKey:@"customerSourcedata" ToPath:filePath];
                customerList = [NSMutableArray array];
                customerList = [CustomerSourceData objectArrayWithKeyValuesArray:resDic];
                
            }
            callBack(result,customerList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,customerList);
        }];
    }
}
#pragma mark - 推荐周边楼盘列表 2017-04-26
-(void)getRecommenBuildWithDict:(NSMutableDictionary*)dic withCallBack:(HandleRecommenBuildDataListResult)callBack
{
    __block CustomerSourceData* messagesList = [[CustomerSourceData alloc] init];
    __block ActionResult* result = nil;
    //    __block NSArray *custArray = [[NSMutableArray alloc] init];
    result.success = NO;
    __weak DataFactory *weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[NetWork manager] POST:@"api/agency/estate/recommendEstateList" parameters:dic  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary *dic = [responseObject valueForKey:@"data"];
                messagesList.recomMess = [dic valueForKey:@"recomMess"];
                messagesList.customerEffective = [dic valueForKey:@"customerEffective"];
                messagesList.customerVisteRule = [dic valueForKey:@"customerVisteRule"];
                messagesList.result = (NSArray*)[BuildingListData objectArrayWithKeyValuesArray:[dic valueForKey:@"result"]];
                
                
            }
            callBack(result,messagesList);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([weakSelf isBlankString:result.message]) {
                result = [[ActionResult alloc] init];
                result.message = @"请求失败";
            }
            callBack(result,messagesList);
        }];
    }
}
#pragma mark - 购房意向,用“，“表示不同类型选项；用”/“表示同1类别的多个选项
- (NSString*)returnBackExpectAppendingString:(NSDictionary*)data
{
    NSString* expect = nil;
    NSArray *types = [data valueForKey:@"typeList"];
    NSString *minStr = [data stringValueForKey:@"priceMin"];
    NSString *maxStr = [data stringValueForKey:@"priceMax"];
    if ([self isBlankString:minStr]) {
        minStr = @"0";
    }
    if ([self isBlankString:maxStr]) {
        maxStr = @"1000";
    }
    if ([minStr integerValue]==0 && [maxStr integerValue]==1000) {
        if (expect==nil) {
            expect = @"不限";
        }
    }
//    else if ([minStr integerValue]==1000 && [maxStr integerValue]==1000) {
//        if (expect==nil) {
//            expect = @"1000万元以上";
//        }
//    }
    else if ([minStr integerValue] == [maxStr integerValue]) {
        if (expect==nil) {
            expect = [NSString stringWithFormat:@"%@万元以上",maxStr];
        }
    }
    else
    {
//        if ([minStr integerValue] >= 0 && [maxStr integerValue] <= 1000) {
        if ([minStr integerValue] >= 0 && [maxStr integerValue] >= 0) {
            if (expect==nil) {
                expect = [NSString stringWithFormat:@"%@-%@(万元)",minStr,maxStr];
            }
        }
    }
    if (types.count>0) {
        for (int i=0; i<types.count; i++) {
            if (expect==nil) {
                if (types.count==1) {
                    expect = [[types objectForIndex:i] valueForKey:@"name"];
                }else{
                    expect = [NSString stringWithFormat:@"%@/",[[types objectForIndex:i] valueForKey:@"name"]];
                }
            }else{
                if (i==0) {
                    if (types.count==1) {
                        expect = [expect stringByAppendingFormat:@"，%@",[[types objectForIndex:i] valueForKey:@"name"]];
                    }else{
                        expect = [expect stringByAppendingFormat:@"，%@/",[[types objectForIndex:i] valueForKey:@"name"]];
                    }
                }else if (i==types.count-1) {
                    expect = [expect stringByAppendingFormat:@"%@",[[types objectForIndex:i] valueForKey:@"name"]];
                }else{
                    expect = [expect stringByAppendingFormat:@"%@/",[[types objectForIndex:i] valueForKey:@"name"]];
                }
            }
        }
    }
    NSArray *layouts = [data valueForKey:@"bedroomNum"];
    if (layouts.count>0) {
        for (int i=0; i<layouts.count; i++) {
            if (expect==nil) {
                if (layouts.count==1) {
                    expect = [[layouts objectForIndex:i] valueForKey:@"name"];
                }else{
                    expect = [NSString stringWithFormat:@"%@/",[[layouts objectForIndex:i] valueForKey:@"name"]];
                }
            }else{
                if (i==0) {
                    if (layouts.count==1) {
                        expect = [expect stringByAppendingFormat:@"，%@",[[layouts objectForIndex:i] valueForKey:@"name"]];
                    }else{
                        expect = [expect stringByAppendingFormat:@"，%@/",[[layouts objectForIndex:i] valueForKey:@"name"]];
                    }
                }else if (i==layouts.count-1) {
                    expect = [expect stringByAppendingFormat:@"%@",[[layouts objectForIndex:i] valueForKey:@"name"]];
                }else{
                    expect = [expect stringByAppendingFormat:@"%@/",[[layouts objectForIndex:i] valueForKey:@"name"]];
                }
            }
        }
    }
//    NSArray *areas = [data valueForKey:@"areas"];
//    if (areas.count>0) {
//        for (int i=0; i<areas.count; i++) {
//            if (expect==nil) {
//                if (areas.count==1) {
//                    expect = [[areas objectForIndex:i] valueForKey:@"name"];
//                }else{
//                    expect = [NSString stringWithFormat:@"%@/",[[areas objectForIndex:i] valueForKey:@"name"]];
//                }
//            }else{
//                if (i==0) {
//                    if (areas.count==1) {
//                        expect = [expect stringByAppendingFormat:@"，%@",[[areas objectForIndex:i] valueForKey:@"name"]];
//                    }else{
//                        expect = [expect stringByAppendingFormat:@"，%@/",[[areas objectForIndex:i] valueForKey:@"name"]];
//                    }
//                }else if (i==areas.count-1) {
//                    expect = [expect stringByAppendingFormat:@"%@",[[areas objectForIndex:i] valueForKey:@"name"]];
//                }else{
//                    expect = [expect stringByAppendingFormat:@"%@/",[[areas objectForIndex:i] valueForKey:@"name"]];
//                }
//            }
//        }
//    }
    return expect;
}

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
