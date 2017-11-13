//
//  MessageData.h
//  MoShouBroker
//  消息、跟进信息以及项目动态数据模型
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject

@property(nonatomic,copy) NSString* msgId;//消息编号
@property(nonatomic,copy) NSString* title;//消息标题
@property(nonatomic,copy) NSString* content;//消息内容
@property(nonatomic,copy) NSString* datetime;//消息的日期时间
@property(nonatomic,copy) NSString* pushCode;//推送消息业务代码

@property(nonatomic,copy) NSString* imgUrl;//消息图片
@property(nonatomic,copy) NSString* source;//消息来源类型，0是系统消息,1是手发消息
@property(nonatomic,assign) BOOL readed;//是否已读

//add by wangzz 161014
@property(nonatomic,copy) NSString* count;//未读消息数量
@property(nonatomic,copy) NSString* msgType;//消息类型 1汇金行公告,2,汇金行提醒,3,门店公告,4,(报备)流程,5约车相关,6,客户推荐
@property(nonatomic,copy) NSString* estateId;//楼盘客户关联Id
@property(nonatomic,copy) NSString* estateAppointCarId;//约车ID
@property(nonatomic,copy) NSString* custEstateId;//客户楼盘关联ID
@property(nonatomic,copy) NSString* estateName;//楼盘名
@property(nonatomic,copy) NSString* shopId;//门店id
@property(nonatomic,copy) NSString* shopName;//门店名称
////项目动态用到的数据
//@property(nonatomic,copy) NSArray* images;//图片数组，元素ImageData
//@property(nonatomic,copy) NSString* praiseCount;//点赞数量
//@property(nonatomic,assign) BOOL isPraised;//点赞数量
//@property(nonatomic,copy) NSArray*  replyArray;//回复数据列表
@property(nonatomic,assign)BOOL canClick;

//20160707 add by wangzz 客户到访信息  魔售2.2.1
@property(nonatomic,copy) NSString* numPeople;//到访人数
@property(nonatomic,copy) NSString* visitTimeBegin;//到访开始时间
@property(nonatomic,copy) NSString* visitTimeEnd;//到访结束时间
@property(nonatomic,copy) NSString* trafficMode;//交通方式
@property(nonatomic,copy) NSString* confirmUserMobile;//确客电话
@property(nonatomic,copy) NSString* confirmUserName;//确客姓名
@property(nonatomic,copy) NSString* bizType;//业务类型
@property(nonatomic,copy) NSString* bizNodeId;//业务节点id
@property(nonatomic,copy) NSString* waitConfirmId;//待确客id

@end
