//
//  EstateDynamicMsgModel.h
//  MoShou2
//
//  Created by Mac on 2016/12/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstateDynamicMsgModel : NSObject

@property(nonatomic,copy) NSString* dynamicMsgId;   //
@property(nonatomic,copy) NSString* estateId;   //
@property(nonatomic,copy) NSString* fromUserId;   //
@property(nonatomic,copy) NSString* fromType;   //
@property(nonatomic,copy) NSString* title;   //
@property(nonatomic,copy) NSString* info;   //
@property(nonatomic,copy) NSString* chatUserName;   //
@property(nonatomic,copy) NSString* chatUserNick;   //
@property(nonatomic,copy) NSString* chatUserPic;   //

@property(nonatomic,copy) NSString* createTime;   //


@end

//"estateDynamicMsgList": [							--
//{
//"id": 7,
//"estateId": 290,
//"fromUserId": 49742,								--发布人user
//"fromType": "confirm",								--发布类型（确客才有环信信息）
//"title": "楼盘动态",
//"info": "测试专用的动态_确客",						--发布信息
//"chatUserName": "aliyun_confirm_18523656781",	--确客的环信信息
//"chatUserNick": "确客大可",
//"chatUserPic": null
//},
//],
