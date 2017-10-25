//
//  Ad.h
//  MoShouBroker
//  广告数据模型
//  Created by NiLaisong on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ad : NSObject

//@property (nonatomic,assign)NSInteger ID;
//@property (nonatomic,copy)NSString* name;
//@property (nonatomic,copy)NSString* descript;
//@property (nonatomic,copy)NSString* imgUrl;
//@property (nonatomic,copy)NSString* thumUrl;
//@property (nonatomic,copy)NSString* adUrl;
//@property (nonatomic,assign)NSInteger cityId;
//@property (nonatomic,assign)NSInteger del;
//@property (nonatomic,assign)NSInteger sequence;
//@property (nonatomic,copy)NSString* createTime;
//@property (nonatomic,assign)BOOL isUse;
//@property (nonatomic,copy)NSString* type;


@property (nonatomic,copy)NSString* adId;
@property (nonatomic,copy)NSString* areaId;
@property (nonatomic,copy)NSString* estateId;
@property (nonatomic,copy)NSString* sequence;
@property (nonatomic,copy)NSString* imgUrl;
@property (nonatomic,copy)NSString* redirectUrl;
@property (nonatomic,copy)NSString* type;
@property (nonatomic,copy)NSString* creator;
@property (nonatomic,copy)NSString* createTime;
@property (nonatomic,copy)NSString* updater;
@property (nonatomic,copy)NSString* updateTime;
@property (nonatomic,copy)NSString* delFlag;
@property (nonatomic,copy)NSString* descriptionString;








@end


//
//"id" : 1,
//"areaId" : 4,
//"estateId" : 1,
//"sequence" : 1,
//"imgUrl" : "1",				--广告图片
//"redirectUrl" : "1",
//"type" : "PAGEHOME",
//"creator" : 1,
//"createTime" : "2016-02-19 16:20:55",
//"updater" : 1,
//"updateTime" : "2016-02-19 16:21:02",
//"delFlag" : "0",
//"description" : null
