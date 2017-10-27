//
//  DataFactory+User.h
//  Enterprise
//  用户信息相关的数据接口
//  Created by NiLaisong on 15/9/23.
//  Copyright © 2015年 NiLaisong. All rights reserved.
//

#import "DataFactory.h"
#import "ActionResult.h"
#import "NetworkSingleton.h"
#import "MessageData.h"
#import "DataListResult.h"
#import "GoodsResult.h"
#import "ExchangeGoods.h"
#import "PointData.h"
#import "ExchangeRecord.h"

typedef void(^HandleArrayResult)(NSArray*result);
typedef void(^HandleInitialResult)(NSArray*indexArray,NSArray*dataArray);


typedef void(^HandleActionResult)(ActionResult*result);
typedef void(^HandleNumberResult)(NSNumber *num);
typedef void(^HandleDataListResult)(DataListResult*result);


typedef void(^HandleMessageResult)(NSString *message);
typedef void(^HandleArrayResult)(NSArray*array);
typedef void(^HandleModelResult)(ShareModel*model);
typedef void(^HandleGoodsResult)(GoodsResult*result);


@interface DataFactory (User)
/**
 *  登录
 *
 *  @param mobile   手机号
 *  @param password 密码
 *  @param callback 回调方法
 */
//-(void)loginWtihMobile:(NSString*)mobile andPassword:(NSString*)password andCallback:(HandleActionResult)callback;
-(void)registerWtihMobile:(NSString*)mobile password:(NSString*)password andVcode:(NSString*)code andCallback:(HandleActionResult)callback;
-(void)forgetPasswordWtihMobile:(NSString*)mobile andVcode:(NSString*)code andNewPassword:(NSString*)password andCallback:(HandleActionResult)callback;
//-(void)getRigisterVcodeWithMobile:(NSString*)mobile andCallback:(HandleActionResult)callback;
-(void)hxUserLoginWithUserInfo:(UserInfo*)userInfo;
/**
 *  获取验证码
 *
 *  @param mobile   手机号
 *  @param callback 回调方法
 */
-(void)getVcodeWithMobile:(NSString*)mobile andCallback:(HandleActionResult)callback;

/**
 *  获取用户信息
 *
 *  @param callBack
 */
//-(void)getUserDataWithCallBack:(HandleActionResult)callBack; 
/**
 *  获取未读消息数量
 *
 *  @param callBack
 */
//delete by wangzz 161114
//-(void)getUnreadMessageCountWithCallback:(HandleNumberResult)callBack;
/**
 *  获取首页数据
 *
 *  @param callback
 */
//-(void)getHomePageData:(HandleActionResult)callback;
/**
 *  修改姓名
 *
 */
-(void)changeNameWithName:(NSString *)name andCallback:(HandleActionResult)callback;

/**
 *  修改性别
 */
-(void)changeSexWithSex:(NSString *)sex andCallback:(HandleActionResult)callback;
/**
 *  修改密码
 */
-(void)changPasswordWithCurrentPassword:(NSString *)currentPass andNewPassword:(NSString *)newPass andCallback:(HandleActionResult)callback;
/**
 *  修改手机号
 */
-(void)changMobileWithMobile:(NSString *)mobile andVcode:(NSString *)code andCallback:(HandleActionResult)callback;
-(void)uploadAvatarWith:(UIImage *)avatar userId:(NSString *)userid andCallback:(HandleActionResult)callback;
-(void)submitCommentsWithcontent:(NSString *)content andImagesArr:(NSArray *)imagesArr andCallback:(HandleActionResult)callback;

-(void)changShopCode:(NSString*)shopCode withEmpoyeeNo:(NSString*)empoyeeNo andShopPic:(UIImage *)shopPic andCallback:(HandleActionResult)callback;
//add by wangzz 160803 修改员工编号
-(void)changEmpoyeeNo:(NSString*)empoyeeNo andCallback:(HandleActionResult)callback;
//end
-(void)signWithCallback:(HandleActionResult)callback;
/**
 *  消息列表
 */
//分页获取消息列表
-(void)getMessagesByPage:(NSString*)page WithCallBack:(HandleDataListResult)callBack;
//阅读消息
-(void)readMessage:(MessageData*)message withCallback:(HandleActionResult)callBack;
-(void)onKeyReadAllMessageWithCallback:(HandleActionResult )callback;

/**
 *  删除消息
 *
 *  @param massageData
 *  @param callback
 */
-(void)deleteMessageWithMessageData:(MessageData *)massageData andCallBack:(HandleActionResult)callback;
//-(void)

-(void)checkVersionUpdateWithCallback:(HandleVersionUpdate)callback;
-(void)updateVersionWithMessage:(NSString*)message mustUpdate:(BOOL)ismust newVersion:(NSString*)newVersion;
//-(void)logoutWithCallback:(HandleActionResult)callback;
//获取所有的日程提醒数据，nls，2015-12-31
-(void)getAllScheduledRemindList:(HandleArrayResult)callback;
//分享app
-(void)getShareAppModelWithCallback:(HandleModelResult)callback;
/**
 *  获取商品列表
 *
 *  @param page
 *  @param callBack
 */
-(void)getPointMallByPage:(NSString*)page andSequenceType:(NSInteger)sequenceType andWithCallBack:(HandleGoodsResult)callBack;
-(void)exchangeGoodsWith:(ExchangeGoods *)goods withAddress:(NSString*)addressId andCallback:(HandleActionResult)callback;
-(void)getPointDataWithPage:(NSString *)page andCallBack:(HandleDataListResult)callback;
-(void)getExchangeDataWithPage:(NSString *)page andCallBack:(HandleDataListResult)callback;
-(void)deleteExchangeWithExchangeRecord:(ExchangeRecord *)record andCallBack:(HandleActionResult)callback;
-(void)getPintsRulesDataWithCallBack:(HandleDataListResult)callback;

//跟进信息
-(void)updateConfirmShowTrackWithYes:(NSString*)yes andCallback:(HandleActionResult)callback;
/*
 描述：记录事件操作日志
 作者：Laison 时间：2016-12-16
 参数：eventId 事件编号    pageId 事件操作所在页面的编号
 */
-(void)addLogWithEventId:(NSString*)eventId andPageId:(NSString*)pageId;

@end
