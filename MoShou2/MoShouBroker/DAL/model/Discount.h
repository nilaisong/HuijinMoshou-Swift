//
//  Discount.h
//  MoShou2
//
//  Created by strongcoder on 16/4/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discount : NSObject


@property (nonatomic, copy) NSString *discountId; //
@property (nonatomic, copy) NSString *name; //
@property (nonatomic, copy) NSString *amount; //
@property (nonatomic, copy) NSString *estateId; //
@property (nonatomic, copy) NSString *startTime; //
@property (nonatomic, copy) NSString *endTime; //
@property (nonatomic, copy) NSString *discription; //
@property (nonatomic, copy) NSString *discountType; //  活动类型 0:认筹活动、1:优惠活动


@property (nonatomic,assign) BOOL status;  //是否显示 认筹  （状态,1是启用，0是未启用）
@property (nonatomic, copy) NSString *creator; //
@property (nonatomic, copy) NSString *createTime; //
@property (nonatomic, copy) NSString *updater; //
@property (nonatomic, copy) NSString *updateTime; //
@property (nonatomic, copy) NSString *delFlag; //
@property (nonatomic, copy) NSString *pledgeStatus; //
@property (nonatomic, copy) NSString *username; //

@end




//"discountList" : [ {
//--活动list

//    "id" : 14,
//    "name" : "5万抵8万",				--活动名称
//    "amount" : 50000.0,				--应付金额
//    "estateId" : 21,
//    "startTime" : "2016-03-02 00:00:00",	--开始时间
//    "endTime" : "2016-03-11 23:59:59",	--结束时间
//    "discription" : "1234",				--描述
//    "status" : "1",					--认筹活动描述
//    "creator" : "1",
//    "createTime" : "2016-03-02 16:52:48",
//    "updater" : 1,
//    "updateTime" : "2016-03-10 16:08:47",
//    "delFlag" : "0",
//    "pledgeStatus" : null,
//    "username" : null
