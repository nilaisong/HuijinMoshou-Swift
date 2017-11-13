//
//  SeeAboutTheCarObject.h
//  MoShou2
//
//  Created by wangzz on 16/8/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeeAboutTheCarObject : NSObject

@property(nonatomic,copy) NSString* estateCustomerId;//客户楼盘关联id
@property(nonatomic,copy) NSString* estateName;//预约楼盘名称
@property(nonatomic,copy) NSString* buildingId;//楼盘id
@property(nonatomic,copy) NSString* customerName;//预约客户姓名
@property(nonatomic,copy) NSString* customerMobile;//客户手机号
@property(nonatomic,copy) NSString* custId;//客户id
@property(nonatomic,copy) NSString* subscribePlace;//约车地点
@property(nonatomic,copy) NSString* subscribeTime;//约车时间
@property(nonatomic,copy) NSString* followStaffCount;//乘车人数


@property(nonatomic,copy) NSString* estateAppointCarID;//约车记录id
@property(nonatomic,copy) NSString* driverName;//约车司机
@property(nonatomic,copy) NSString* driverMobile;//司机电话
@property(nonatomic,copy) NSString* carNo;//车牌号
@property(nonatomic,copy) NSString* orderId;//订单id

@property (nonatomic,copy)NSString* trystTimeType;//预约上车时间类型，day天，minute分钟，hour小时
@property (nonatomic,copy)NSString* trystCarTime;//2天

@end


