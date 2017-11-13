//
//  TradeData.h
//  MoShouBroker
//  客户购房过程的备案记录
//  Created by NiLaisong on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRecord : NSObject
//是否可以撤销楼盘 1:可以, 0：不可以 2015-10-13 add by wangzz 
@property(nonatomic,copy) NSString* can_revokeRecommendation;
//是否显示客户有效期 0：不显示  1：显示 2015-10-14 add by wangzz
@property(nonatomic,copy) NSString* expiredateFlag;
//是否可使用URL生成二维码,true:是 false:否 2015-11-09 add by wangzz
@property(nonatomic,copy) NSString* showURL;
//生成二维码的URL网址 2015-11-09 add by wangzz
@property(nonatomic,copy) NSString* url;

@property(nonatomic,copy) NSString* buildingCustomerId;//交易编号
@property(nonatomic,copy) NSString* buildingName;//楼盘名称
@property(nonatomic,copy) NSString* district;//楼盘所在区域
@property(nonatomic,copy) NSString* expiredate;//有效期

@property(nonatomic,strong) NSArray* progress;//交易状态数组，元素ProgressStatus
@property(nonatomic,strong) NSArray* messages;//交易消息数组，元素MessageData
@property(nonatomic,strong) NSArray* track;//跟进信息数组，元素MessageData

//add by wangzz 160918(丁璞玉报备详情页面需要)
@property(nonatomic,copy) NSString* confirmUserMobile;//确客电话
@property(nonatomic,copy) NSString* confirmUserName;//确客姓名
//end
//add by wangzz 161021
@property(nonatomic,strong) NSArray* customerEvaluationList;//客户评级，元素CustomerEvaluation
@property(nonatomic,copy) NSString* districy;//楼盘所在区域
@property(nonatomic,copy) NSString* pathUrl;//有效期
@property(nonatomic,copy) NSString* plate;
@property(nonatomic,copy) NSString* buildingId;
//end

@end
