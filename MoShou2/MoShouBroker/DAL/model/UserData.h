//
//  UserData.h
//  用户数据模型
//
//  Created by Laisong on 2015-06-18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#define UserUnreadMessageCountNotification @"UserUnreadMessageCountUpdate"

@interface UserData : NSObject

+(UserData*)sharedUserData;

@property(nonatomic,readonly) BOOL isUserLogined;//是否已登录
@property(nonatomic,copy) NSString* userId;//用户编号，可用作极光推送的别名alias
@property(nonatomic,copy) NSString* userName;//用户名


@property(nonatomic,copy) NSString * storeId;//门店Id

@property(nonatomic,copy) NSString * storeNum;//门店编号  唯一码
@property(nonatomic,copy) NSString * storeName;//店面名称

@property(nonatomic,copy) NSString * orgnizationName;//机构名称


@property(nonatomic,copy) NSString * offlineMsgCount;//环信离线消息

@property(nonatomic,copy) NSString * shareRange;//分享途径  "shareRange": "wxfriend,qqfriend"   //分享范围标识，多个以逗号分隔，表示可以分享的第三方应用（为空时表示不允许分享）说明：wxfriend:'微信好友', wxfriendc:'微信朋友圈', qqfriend:'QQ好友', sinablog:'新浪微博', sms:'手机短信'


@property(nonatomic,strong)NSMutableArray *shareRangeArray;  //拆成的分享途径数组

@property(nonatomic,strong)NSMutableArray *hotBuildingNameArray;  //热销楼盘数组



//楼盘/资讯分享途径显示需求
//大后台在城市级别增加允许分享范围的开关，分享途径包含：朋友圈、微信好友、QQ好友、新浪微博、短信。@杨威
//app端调取开关中允许分享途径进行分享显示，不允许分享的途径不予显示。@王日辉、齐灵强
//工作报表分享途径为固定途径：微信、QQ、短信，不根据接口进行判断。@王日辉、齐灵强
//附后台开关设置图


//@property(nonatomic,copy) NSString * storeAddress;//店面地址
@property(nonatomic,copy) NSString* avatar;//头像
@property(nonatomic,copy) NSString* cityId;//门店所在城市  后台返回  绑定过门店才有
@property(nonatomic,copy) NSString* cityName;//门店所在城市  后台返回  绑定过门店才有

//@property(nonatomic,readonly) NSString* theCityName;//当前应该显示的城市名(门店城市/手选城市/定位城市)


@property(nonatomic,copy) NSString* chooseCityId;// 手动选择ID
@property(nonatomic,copy) NSString* chooseCityName;// 手动选择的城市名字


@property(nonatomic,copy) NSString* locationCityName;//用户所在地的城市（坐标计算所得）

@property(nonatomic,strong)BMKUserLocation *userLocation;

@property(nonatomic,copy) NSString* deviceToken;//通知推送用到的
//@property(nonatomic,copy) NSString* registrationID;//JPush标识此设备的registrationID

@property(nonatomic,copy) NSString* sex;//性别
@property(nonatomic,copy) NSString* mobile;//手机号
@property(nonatomic,copy) NSString * points ;//积分总额
//add by wangzz 160802
@property (nonatomic, copy) NSString *employeeNo;//员工编号
@property (nonatomic, assign) BOOL limitEmployeeNo;//员工编号是否为必填项，0非必填  1为必填
@property (nonatomic, assign) BOOL trystCarEnable;//是否展示约车信息，0为未开通，1为开通

@property (nonatomic, assign) BOOL overseasEstateEnable;//是否展示海外房产，0为未开通，1为开通


//end
@property(nonatomic,copy) NSString*  latitude;//用户坐标纬度
@property(nonatomic,copy) NSString* longitude;//用户坐标经度

@property (nonatomic,copy)NSString* selectedLongitude;//选中的经度
@property (nonatomic,copy)NSString* selectedLatitude;//选中的纬度

@property(nonatomic,assign) BOOL isSignIn;//当天是否签到
//delete by wangzz 161114
//@property(nonatomic,assign) int unreadMsgCount;//用户未读消息数量   废弃  无用
//经纪人换店 的 状态 -1 是没有,0是待审批 1是审批通过,2是不通过
//是否有待审批的换店审请(新后台)
@property(nonatomic,assign) int changeShopVerifyStatus;
//手机号是否全部显示 （0全部显示，1部分显示）
@property(nonatomic,assign) BOOL mobileVisable;//add by wangzz 151008
//是否让确客看到   1:看到 0:看不到
@property(nonatomic,assign) BOOL confirmShowTrack;//add by wangzz 160224
//客户来源开关  0为不需填写，1为必须填写
@property(nonatomic,copy) NSString* customerSource;//add by wangzz 170508

@property(nonatomic,copy) NSString* maxRecommendCount;//最大报备数

@property(nonatomic,assign) NSInteger newUnreadMsgCount;//新版接口  未读消息

//add by wangzz 170217  2.5.3版本 获取用户信息接口增加字段
@property(nonatomic,assign) NSInteger isExchangeShop;//0代表可以换店，1代表不能换店
//add by wangzz 170315 2.6.0版本 获取当前城市的客服电话
@property(nonatomic,copy) NSString *customerServiceTel;
@property(nonatomic,copy) NSString *addressId;//经纪人收货地址id，如果id为0此经纪人未添加收货地址
//获取和更新用户未读消息的数量，2015-07-27
//-(void)updateUnreadMsgCount;
-(void)cleareUserData;
//为用户注册消息推送，nls，2016-02-18
-(void)setJPushAlias;

@end

