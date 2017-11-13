//
//  ShareDataModel.h
//  TuluAuction
//
//  Created by haoxiangfeng on 15-3-30.
//  Copyright (c) 2015年 artron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic, copy) NSString *buildingId;//楼盘id，分享完成后回调用
@property (nonatomic,copy) NSString *buildingName;   //楼盘名称
//@property (nonatomic,assign)BOOL isShareImage;//是否是分享图片
@property (nonatomic,copy)NSString *housePrice;  //楼盘价钱

@property(nonatomic,copy)NSString *agencyName;
@property(nonatomic,copy)NSString *mobile;
@property (nonatomic, copy) NSString *district;  //区县
@property (nonatomic, copy) NSString *plate;   //商圈


@property (nonatomic, copy) NSString *acreageType;   //面积区间 

@property (nonatomic, copy)  NSString *title;//标题（QQ空间、QQ、微信、朋友圈）
@property (nonatomic, copy) NSString *linkUrl;//分享链接wap页（QQ空间、QQ、微信、朋友圈）对应 shareUrl
@property (nonatomic, copy)  NSString *content;//分享信息（QQ好友、微信好友）
@property (nonatomic, copy) NSString *img;//分享缩略图名称或url地址
@property (nonatomic, copy) NSString *imgPath;//分享图片全路径



//新增字段  2016-12-30  AddBy 70Qiang
@property (nonatomic,copy)NSString *houseType;  //户型区间
@property (nonatomic,copy)NSString *AllPrice ;  // 房子总价
@property (nonatomic,copy)NSString *buildingSellPoint;

//@property (nonatomic, assign) BOOL *isShareApp;//分享缩略图名称或url地址

//@property (nonatomic, strong) NSString *weiboInfo;//微博分享信息(新浪、腾讯微博)

@end

//
// "shareInfo": {
//    "housePrice": "0",
//    "title": "永清国瑞生态城",
//    "content": "国瑞生态城位于廊坊市永清县开发区，由北京国瑞兴业地产股份有限公司开发，临近永清万亩国家森林公园，周边风景宜人，配套较全，永清一中教育设施，828路公交车直达。项目规划占地37平方公里，包括主题生态园、度假村、观光、采摘、垂钓园、生态休闲农庄和运动休闲公园等",
//    "img": "http://test.fangodata.com/images/estate/2015/5/5/thumbnail/0e0ce08d-ac4a-48fb-9a51-45e7bc1517b7.jpg",
//    "agencyName": "无敌",
//    "mobile": "15010241166",
//    "shareUrl": "http://test.fangodata.com/html/housedetail.html?estateId=48&agencyId=11300"
//               },

