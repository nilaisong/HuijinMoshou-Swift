//
//  DataFactory+Customer.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/7/13.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "DataFactory.h"
#import "MJExtensionConfig.h"
#import "DataFactory+User.h"
#import "DataFactory+Main.h"
#import "ExpectData.h"
#import "Customer.h"
#import "CustomersResult.h"
#import "NSObject+MJKeyValue.h"
#import "NSObject+MJProperty.h"
#import "MessageData.h"
#import "NetworkSingleton.h"
#import "Tool.h"
#import "NetWork.h"
#import "ActionResult.h"
#import "InitialData.h"
#import "OptionData.h"
#import "ReportReturnData.h"
#import "CustomerBuilding.h"
#import "BuildingsResult.h"
#import "TradeRecord.h"
#import "MobileVisible.h"
#import "FailListData.h"
#import "SeeAboutTheCarObject.h"
#import "ConfirmUserInfoObject.h"
#import "ProgressStatus.h"
#import "CustomerFollowData.h"
#import "AddressData.h"
#import "EvaluationData.h"
#import "CustomerSourceData.h"
#import "UserData.h"
#import "BuildingListData.h"

typedef void(^HandleExpectData)(ActionResult *result,ExpectData*data);
typedef void(^HandleCustomersResult)(ActionResult *actionResult,CustomersResult*result);
typedef void(^HandleCustomerDetail)(ActionResult *actionResult,Customer*result);
typedef void(^HandleAddGroup)(ActionResult*result,OptionData*);
typedef void(^HandleReportData)(ActionResult*result,ReportReturnData*);
typedef void(^HandleRemindStatus)(ActionResult*result,BOOL);
typedef void(^HandleCustomerArrayResult)(ActionResult*result,NSArray*array);
typedef void(^HandleBuildingDataListResult)(ActionResult*actionResult,DataListResult*result);
typedef void(^HandleFavoriteBuildingDataListResult)(ActionResult*actionResult,DataListResult*result,NSString*);
typedef void(^HandleTrystCarRecordInfo)(ActionResult *actionResult,SeeAboutTheCarObject*result);
typedef void(^HandleNoticeDataListResult)(ActionResult *actionResult,DataListResult*result);
typedef void(^HandleRecommenBuildDataListResult)(ActionResult *actionResult,CustomerSourceData*buildingData);

@interface DataFactory (Customer)

//获取购房意向相关参数（包括意向类型、意向户型、意向面积），2015-12-29
-(void)getExpectDataWithCallBack:(HandleExpectData)callBack;
//为客户列表获取自定义组列表 2015-12-30
- (void)getCustomerGroupListWithCallBack:(HandleCustomerArrayResult)callBack;
//为自定义列表获取客户 2015-12-30
- (void)getCustomerListWithKeyword:(NSString *)keyword andGroupId:(NSString*)groupId withCallBack:(HandleCustomersResult)callBack;
//创建客户组 2015-12-31
-(void)createGroupWithGroupName:(NSString*)groupName withCallBack:(HandleAddGroup)callBack;
//编辑客户组 2015-12-31
-(void)editGroupWithGroupName:(NSString*)groupName AndGroupId:(NSString*)groupId withCallBack:(HandleActionResult)callBack;
//删除客户组 2015-12-31
-(void)deleteGroupWithGroupId:(NSString*)groupId withCallBack:(HandleActionResult)callBack;
//添加组成员 2016-01-04
-(void)addMemberWithGroupId:(NSString*)groupId AndCustomerIds:(NSString*)customerIds withCallBack:(HandleActionResult)callBack;
//为楼盘获取可报备的客户列表 2016-01-04
-(void)getBuildingCustomersWithBId:(NSString*)bId AndKeyword:(NSString*)keyword WithCallBack:(HandleCustomerArrayResult)callBack;
//获取楼盘已经报备的客户列表，2016-01-05
-(void)getBuildingCustomersWithBId:(NSString*)bId WithCallBack:(HandleCustomerArrayResult)callBack;
//为楼盘批量报备客户，数组元素是customer，2016-01-05
-(void)batchAddCustomers:(NSMutableDictionary*)dic withCallBack:(HandleReportData)callBack;
//撤销报备，2016-01-05
- (void)revokeRecommendationWithTrackId:(NSString*)trackId withCallBack:(HandleActionResult)callBack;
//快速报备 2016-01-06
- (void)fastSaveCustomerWithDict:(NSMutableDictionary*)dic withCallBack:(HandleReportData)callBack;
////分页获取用户已收藏的楼盘，2016-01-06
//-(void)getFavoriteBuildingsWithPage:(NSString*)page andCustId:(NSString*)custId andKeyword:(NSString*)keyword andLongitude:(NSString*)longitude andLatitude:(NSString*)latitude withCallBack:(HandleDataListResult)callBack;
////分页获取全部的楼盘列表，2016-01-07
//-(void)getFillingBuildingsWithPage:(NSString*)page andCustId:(NSString*)custId andKeyword:(NSString*)keyword andLongitude:(NSString*)longitude andLatitude:(NSString*)latitude withCallBack:(HandleDataListResult)callBack;
//分页获取用户已收藏的楼盘，2016-01-06
-(void)getFavoriteBuildingsWithPage:(NSString*)page andCustId:(NSString*)custId andKeyword:(NSString*)keyword andLongitude:(NSString*)longitude andLatitude:(NSString*)latitude andIsFullPhone:(NSString*)isFullPhone withCallBack:(HandleFavoriteBuildingDataListResult)callBack;
//分页获取全部的楼盘列表，2016-01-07
-(void)getFillingBuildingsWithPage:(NSString*)page andCustId:(NSString*)custId andKeyword:(NSString*)keyword andLongitude:(NSString*)longitude andLatitude:(NSString*)latitude andIsFullPhone:(NSString*)isFullPhone withCallBack:(HandleBuildingDataListResult)callBack;
//添加新客户，2016-01-08
-(void)addNewCustomerWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;
//编辑客户信息，2016-01-08
-(void)editCustomerWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;
//删除客户，2016-05-03
-(void)deleteCustomerWithId:(NSString*)custId withCallBack:(HandleActionResult)callBack;
//获取客户详细信息，2016-01-11
-(void)getCustomerDetailWithId:(NSString*)custId withCallBack:(HandleCustomerDetail)callBack;
//移动客户至组 2016-01-11
- (void)moveCustToGroupWithCustId:(NSString*)custId andGroupId:(NSString*)groupId withCallBack:(HandleActionResult)callBack;
//修改客户备注 2016-01-11
- (void)editCustomerRemarkWithCustId:(NSString*)custId andRemark:(NSString*)remark withCallBack:(HandleActionResult)callBack;
//添加客户跟进信息，2016-01-11
//-(void)addTrackMessage:(NSString*)message withCustId:(NSString*)custId withConfirm:(NSString*)confirmShowTrack withCallBack:(HandleActionResult)callBack;
//添加报备跟进信息，2016-01-11
//-(void)addTrackMessage:(NSString*)message withBuildingCustId:(NSString*)buildingCustId withConfirm:(NSString*)confirmShowTrack withCallBack:(HandleActionResult)callBack;
//获取客户跟进信息列表 2016-01-11
-(void)getTrackMessageWithDic:(NSMutableDictionary*)dic withCallBack:(HandleBuildingDataListResult)callBack;
//获取报备楼盘的跟进信息列表 2016-01-11
-(void)getTrackMessageWithBuildingCustId:(NSString*)buildingCustId withCallBack:(HandleCustomerArrayResult)callBack;
//删除客户或报备跟进信息，2016-01-12
-(void)deleteTrackMessageWithTrackId:(NSString*)trackId withCallBack:(HandleActionResult)callBack;
//判断今日是否有日程提醒 2016-01-12
-(void)getTodayRemindStatusWithCallBack:(HandleRemindStatus)callBack;
//提醒列表 2016-01-12
-(void)getRemindListWithCustId:(NSString*)custId withCallBack:(HandleCustomerArrayResult)callBack;
//移出客户组 2016-01-19
-(void)delGroupCustomerWithCustomerId:(NSString*)custId withCallBack:(HandleActionResult)callBack;
//根据手机号获得可报备数 2016-02-22
-(void)getReportCountWithMobile:(NSString*)mobile withCallBack:(HandleAddGroup)callBack;

//补全手机号并报备 2016-05-16
-(void)fillPhoneAndRecommendationWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;
//新增客户并报备一个楼盘 2016-05-17
-(void)addNewCustomerReportWithDict:(NSMutableDictionary*)dic withCallBack:(HandleReportData)callBack;

//添加看房专车订单  2016-08-11
-(void)addEstateAppointCarWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;

//获取约车记录详情  2016-08-11
-(void)getTrystCarRecordInfoWithId:(NSString*)estateAppointCarID withCallBack:(HandleTrystCarRecordInfo)callBack;

//通讯录手机号验证  2016-08-19
-(void)validationMobileWithPhone:(NSString*)phone withCallBack:(HandleCustomerDetail)callBack;

//楼盘的确客列表 2016-09-20
-(void)getConfirmUserListWithBId:(NSString*)bId WithCallBack:(HandleCustomerArrayResult)callBack;

//客户评级 2016-10-21
-(void)getcustomerEvaluationDetailWithCustId:(NSString*)custId withCallBack:(HandleCustomerDetail)callBack;

//通知列表 2016-10-21
-(void)getMessagesListByPage:(NSString*)page WithCallBack:(HandleNoticeDataListResult)callBack;

//通知详情 2016-10-21
-(void)getNoticeListByPage:(NSString*)page WithMsgType:(NSString*)msgType AndEatateId:(NSString*)estateId WithCallBack:(HandleNoticeDataListResult)callBack;

//消息列表的报备详情 2016-10-26
- (void)getReportedDetailByRecordId:(NSString*)recordId AndOptType:(NSString*)optType AndBuildingCustomerId:(NSString*)buildingCustomerId callBack:(HandleCustomerReportedDetailResult)callBack failedCallBack:(HandleActionResult)failedCallBack;

//按消息类型读取消息 2016-10-26
- (void)readMessageByMsgType:(NSString*)msgType AndEstateId:(NSString*)estateId withCallBack:(HandleActionResult)callBack;

//旧消息未读取消息数量 2016-11-03
-(void)getOldUnreadMessageCountWithCallback:(HandleNumberResult)callBack;

//添加跟进信息 2017-03-10
-(void)addTrackMessageWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;

//查询已报备楼盘 2017-03-10
-(void)getReportBuildingWithDic:(NSMutableDictionary*)dic WithCallBack:(HandleCustomerArrayResult)callBack;

//查询创建跟进记录的用户 2017-03-10
-(void)getFollowCreatorWithDic:(NSMutableDictionary*)dic WithCallBack:(HandleCustomerArrayResult)callBack;

//查询已有跟进记录包含楼盘 2017-03-10
-(void)getFollowBuildingWithDic:(NSMutableDictionary*)dic WithCallBack:(HandleCustomerArrayResult)callBack;

//添加和修改经纪人收货地址 2017-03-10
-(void)modifyAddressWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;

//查询经纪人收货地址 2017-03-10
-(void)getAddressWithDict:(NSMutableDictionary*)dic withCallBack:(HandleCustomerArrayResult)callBack;

//删除经纪人收货地址 2017-03-10
-(void)deleteAddressWithDict:(NSMutableDictionary*)dic withCallBack:(HandleActionResult)callBack;

//经纪人获取客户评价列表 2017-03-10
-(void)getEvaluationWithDict:(NSMutableDictionary*)dic withCallBack:(HandleBuildingDataListResult)callBack;

//客户来源列表 2017-04-26
-(void)getCustomerSourceWithCallBack:(HandleCustomerArrayResult)callBack;
//推荐周边楼盘列表 2017-04-26
-(void)getRecommenBuildWithDict:(NSMutableDictionary*)dic withCallBack:(HandleRecommenBuildDataListResult)callBack;

@end
