//
//  AdModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/4/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject
/*
 "id" : 1,
 "areaId" : 4,
 "estateId" : 1,
 "sequence" : 1,
 "imgUrl" : "1",				--广告图片
 "redirectUrl" : "1",
 "type" : "PAGEHOME",
 "creator" : 1,
 "createTime" : "2016-02-19 16:20:55",
 "updater" : 1,
 "updateTime" : "2016-02-19 16:21:02",
 "delFlag" : "0",
 "description" : null

 */
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,assign)NSInteger areaId;
@property (nonatomic,assign)NSInteger estateId;
@property (nonatomic,assign)NSInteger sequence;
@property (nonatomic,copy)NSString* imgUrl;
@property (nonatomic,copy)NSString* redirectUrl;
@property (nonatomic,copy)NSString* type;
@property (nonatomic,assign)NSInteger creator;
@property (nonatomic,copy)NSString* createTime;
@property (nonatomic,assign)NSInteger updater;
@property (nonatomic,copy)NSString* updateTime;
@property (nonatomic,copy)NSString* delFlag;
@property (nonatomic,copy)NSString* descript;



@end
