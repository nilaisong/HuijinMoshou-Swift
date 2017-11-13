//
//  Customer.h
//  MoShouBroker
//  客户数据模型
//  Created by NiLaisong on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

typedef enum
{
    selfGuideVisit,
    companyGuideVisit
} CustomerVisitMethod;

#import <Foundation/Foundation.h>
#import "ExpectData.h"

@interface Customer : NSObject
//客户和当前楼盘的绑定编号，2015-10-12，nls
@property(nonatomic,copy) NSString* buildingCustomerId;
//是否可以撤销楼盘 1:可以, 0：不可以 2015-10-13 add by wangzz
@property(nonatomic,copy) NSString* can_revokeRecommendation;
//是否有提醒 true:是 false:否
@property(nonatomic,copy) NSString* hasRemind;
//楼盘id,多个用，分隔
//@property(nonatomic,copy) NSString* buildingIds;


@property(nonatomic,copy) NSString* customerId;//客户编号
@property(nonatomic,copy) NSString* name;//客户姓名
@property(nonatomic,copy) NSString* sex;//性别
@property(nonatomic,strong) NSArray* phoneList;//手机号数组，数组元素MobileVisible
//add by wangzz 160509
@property(nonatomic,copy) NSString* listPhone;//列表展示手机号
@property(nonatomic,copy) NSString* count;//还可报备楼盘的数量，
@property(nonatomic,copy) NSString* remark;//备注
@property(nonatomic,copy) NSString* expect;//购房意向概要说明，客户列表用
@property(nonatomic,copy) NSString* status;//客户状态
@property(nonatomic,assign) CustomerVisitMethod visitMethod;//带看方式

@property(nonatomic,strong) ExpectData* expectData;//购房意向相关数据，客户详情用

@property(nonatomic,strong) NSArray* trackArray;//跟进信息数组，元素MessageData
@property(nonatomic,strong) NSArray* tradeArray;//购房记录数据，数组元素TradeRecord

@property(nonatomic,strong) NSArray* groupList;//客户详情客户分组


//add by wangzz 160918
@property(nonatomic,copy) NSString* confirmUserMobile;//确客电话
@property(nonatomic,copy) NSString* confirmUserName;//确客姓名
@property(nonatomic,copy) NSString* exist;
//end

@property(nonatomic,assign) BOOL    managerAllocation;////该客户是否是店长分配, 1:是  否:0
@property(nonatomic,copy) NSString* managerAllocationText;//显示的文字 如果managerAllocation为0时则是空的
@property(nonatomic,copy) NSString* managerAllocationTime;//店长分配时的时间
@property(nonatomic,copy) NSString* cardId;//客户身份证号
@property(nonatomic,copy) NSString* custSource;//客户来源code
@property(nonatomic,copy) NSString* custSourceLabel;//客户来源文本

@end
