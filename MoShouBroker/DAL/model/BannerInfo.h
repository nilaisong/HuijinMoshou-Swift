//
//  BannerInfo.h
//  MoShou2
//  楼盘页面BannerInfos数据模型
//  Created by strongcoder on 16/1/5.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerInfo : NSObject

@property(nonatomic,copy) NSString* bannerEstateId;   //广告ID
@property(nonatomic,copy) NSString* areaId;
@property(nonatomic,copy) NSString* estateId;
@property(nonatomic,copy) NSString* sequence;
@property(nonatomic,copy) NSString* imgUrl;

@property(nonatomic,copy) NSString* type;
@property(nonatomic,copy) NSString* creator;
@property(nonatomic,copy) NSString* createTime;
@property(nonatomic,copy) NSString* updater;
@property(nonatomic,copy) NSString* updateTime;
@property(nonatomic,copy) NSString* delFlag;
@property(nonatomic,copy) NSString* descriptionString;
@property(nonatomic,copy) NSString* estateName;
@property(nonatomic,copy) NSString* featureTag;
@property(nonatomic,copy) NSString* cityName;
@property(nonatomic,copy) NSString* price;


@end



//"id": 58,
//"areaId": 4,
//"estateId": 7,
//"sequence": null,
//"imgUrl": "test/2016/03/24/11/56f35a275d390.png",
//"redirectUrl": null,
//"type": "ESTATE",
//"creator": 1,
//"createTime": "2016-03-24 11:08:26",
//"updater": null,
//"updateTime": "2016-03-24 11:08:26",
//"delFlag": "0",
//"description": "",
//"estateName": "不要删除",
//"featureTag": null,
//"cityName": "北京",
//"price": ""
