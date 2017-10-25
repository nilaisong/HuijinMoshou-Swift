//
//  DataFactory+Main.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "DataFactory.h"
#import "ActionResult.h"
#import "NetworkSingleton.h"
#import "MessageData.h"
#import "DataListResult.h"
#import "XTIncomeAllModel.h"
#import "XTSignRankingRequestModel.h"
#import "XTPerformanceRankingRequestModel.h"
#import "XTLookRankingRequestModel.h"
#import "XTScheduleListResultModel.h"
#import "CustomerCountByStatusModel.h"
#import "XTReportedRecordListModel.h"
#import "XTCustomerStatusGroupTagModel.h"
#import "CustomerReportedDetailModel.h"
#import "WorkReportModel.h"
#import "OptionData.h"
#import "initialData.h"
#import "Customer.h"
#import "MobileVisible.h"
#import "XTOperationModel.h"
#import "XTRecdDescriptionModel.h"
#import "PriceModel.h"
#import "XTMapBuildingParametersModel.h"
#import "ServiceStatusModel.h"

#define PHPKey @"phpApi"

@class XTMapResultModel;//地图找房回调模型


typedef void(^HandleArrayResult)(NSArray*result);
typedef void(^HandleNumberResult)(NSNumber *num);
typedef void(^HandleDataArrayResult)(NSArray* result,BOOL morePage);
typedef void(^HandleDictionaryResult)(NSDictionary* dict);
typedef void(^HandleDataListResult)(DataListResult*result);
typedef void(^HandleIncomeAllResult)(XTIncomeAllModel* result);
typedef void(^HandleInitialResult)(NSArray*indexArray,NSArray*dataArray);
typedef void(^HandleSignRankingRequestResult)(XTSignRankingRequestModel* result);
typedef void(^HandlePerformanceRankingResult)(XTPerformanceRankingRequestModel* result);
typedef void(^HandleLookRankingResult)(XTLookRankingRequestModel* result);
typedef void(^HandleScheduleListResult)(XTScheduleListResultModel* result);
typedef void(^HandleCustomerCountByStatusResult)(CustomerCountByStatusModel* result);
typedef void(^HandleReportedRecordListResult)(XTReportedRecordListModel* result);
typedef void(^HandleCustomerStatusGroupTagResult)(XTCustomerStatusGroupTagModel* result);
typedef void(^HandleCustomerReportedDetailResult)(CustomerReportedDetailModel* result);
typedef void(^HandleContentOperationResult)(XTOperationModel* result);
typedef void(^HandleWorkReportResult)(WorkReportModel* result);
typedef void(^HandleRecdDescriptionResult)(XTRecdDescriptionModel* result);
typedef void(^HandleStatusResult)(BOOL isSuccess);


typedef void(^HandleMapBuildingResult)(ActionResult* result,XTMapResultModel* resultModel);

typedef void(^HandleActionResult)(ActionResult*result);//add by wangzz 160225

typedef void(^HandleServiceStatusResult)(ActionResult* result,ServiceStatusModel* statusModel);


@interface DataFactory (Main)

/**
 *  获取广告数据
 */
//-(void)getHomeAdvertisementsWithCallback:(HandleArrayResult)callBack;

-(void)getHomeAdvertisementsWithCallback:(HandleArrayResult)callBack failedCallBack:(HandleActionResult)failedCallBack;

////Array里存放的是InitalData数据
//-(void)getCityListWithCallBack:(HandleInitialResult)callBack;
//获取收益明细列表
- (void)getCommissionListWithPage:(NSString*)page WithCallBack:(HandleDataListResult)callBack;
//获取全部收益
- (void)getIncomeAllWithCallBack:(HandleIncomeAllResult)callBack;

//传1-12的数字是要传参，否则，不传
- (void)getIncomeAllWithMonthSize:(NSInteger)monthSize callBack:(HandleIncomeAllResult)callBack failedCallBack:(HandleActionResult)failedCallBack;

//请求成交排名数据
- (void)getSignRankingRequestWithCallBack:(HandleSignRankingRequestResult)callBack;
//请求业绩排名数据
- (void)getPerformanceRankingWithCallBack:(HandlePerformanceRankingResult)callBack;
//请求带看排名数据
- (void)getLookRankingWithCallBack:(HandleLookRankingResult)callBack;

//请求我的日程,date筛选日期，格式 yyyy-MM-dd ,传空代表今天
- (void)getScheduleListWithDate:(NSString*)date withCallBack:(HandleScheduleListResult)callBack;

//新的我的日程接口 √
- (void)getScheduleListWithDate:(NSString*)date withCallBack:(HandleScheduleListResult)callBack failerCallBack:(HandleActionResult)failerCallBack;

//获得所有日程
- (void)getAllScheduleListWithCallBack:(HandleScheduleListResult)callBack;
//获取所有日程 √
- (void)getAllScheduleListWithCallBack:(HandleScheduleListResult)callBack failedCallBack:(HandleActionResult)failedCallBack;


//modify by wangzz 160225

//- (void)addScheduleWithCustomer:(Customer*)customer content:(NSString*)content date:(NSString*)dateStr type:(NSString* )type callBack:(HandleStatusResult)callBack;
//
//- (void)deleteScheduleWithRemindId:(NSInteger)remindId callBack:(HandleStatusResult)callBack;
//添加提醒 √
- (void)addScheduleWithCustomer:(Customer*)customer content:(NSString*)content date:(NSString*)dateStr type:(NSString* )type callBack:(HandleActionResult)callBack;

//删除提醒 √
- (void)deleteScheduleWithRemindId:(NSInteger)remindId callBack:(HandleActionResult)callBack;

//end
//获取各个客户状态数量
- (void)getCustomerCountByStatusWithKeyword:(NSString*)keyword withCallBack:(HandleArrayResult)callBack;
//获取报备记录列表
- (void)getReportRecordListWithGroudId:(NSInteger)groupid keyWord:(NSString*)keyword page:(NSInteger)pageNum callBack:(HandleReportedRecordListResult)callBack;

/**
 *  获取报备详情
 */
//- (void)getReportedDetailWithBuildingCustomerId:(NSInteger)buildingCustomerId callBack:(HandleCustomerReportedDetailResult)callBack;
- (void)getReportedDetailWithBuildingCustomerId:(NSInteger)buildingCustomerId callBack:(HandleCustomerReportedDetailResult)callBack failedCallBack:(HandleActionResult)failedCallBack;

//获取客户状态分组
//- (void)getCustomerStatusGroupTagWithCallBack:(HandleCustomerStatusGroupTagResult)callBack;
//获取客户状态分组新后台
- (void)getCustomerStatusGroupTagWithCallBack:(HandleArrayResult)callBack failedCallBack:(HandleActionResult)failedCallBack;
/**
 *  获取工作报表,0，日报；1，周报；2，月报 (必须) 开始日期 startDate起始日期（日报、月报只传起始） endDate 结束日期
 */
- (void)getWorkReportWithType:(NSInteger)type startDate:(NSString*)startDate endDate:(NSString*)endDate withCallBack:(HandleWorkReportResult)callBack;

//下载闪屏数据,nls,2016-01-23
-(void)downloadSplashsData;

/**
 *  约车
 */
- (void)getAppointmentCarListWith:(NSString*)keyword page:(NSInteger)page size:(NSInteger)size callBack:(HandleDataListResult)callBack failedCallBack:(HandleActionResult)failedCallBack;

/**
 *  约车记录 2016-8-10
 */
- (void)getTrystCarReportedRecordListWith:(NSString*)keyword page:(NSInteger)page size:(NSInteger)size callBack:(HandleDataListResult)callBack failedCallBack:(HandleActionResult)failedCallBack;

/**
 *  内容运营接口
 */
- (void)getContentOperationListWithCityID:(NSString*)cityid callBack:(HandleContentOperationResult)callBack faildCallBack:(HandleActionResult)failedCallBack;

- (void)getReportDetailWithType:(NSString*)type recdId:(NSString*)recdId callBack:(HandleRecdDescriptionResult)callBack failedCallBack:(HandleActionResult)faildeCallBack;

- (void)getMoreRecdWithType:(NSString*)recdType pageNo:(NSInteger)no pageSize:(NSInteger)size callBack:(HandleDataArrayResult)callBack faildCallBack:(HandleActionResult)faildCallBack;

- (void)getUnreadCntWithCallBack:(HandleNumberResult)callBack faildCallBack:(HandleActionResult)failedCallBack;

/**
 *  地图找房相关
 **/

-(void)getMapBuildingWith:(XTMapBuildingParametersModel*)model callBack:(HandleMapBuildingResult)callBack;


/**
 *  判断服务器是否在维护
 **/
- (void)getServiceState:(HandleServiceStatusResult)callBack;

/*
 *  上传文件通过本地文件路径
 */
- (void)uploadFileWithContetnFile:(NSString*)filePath callBack:(HandleActionResult)callBack;

@end
