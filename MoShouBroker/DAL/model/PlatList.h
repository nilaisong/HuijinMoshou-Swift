//
//  PlatList.h
//  MoShou2
//
//  Created by strongcoder on 16/4/26.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatList : NSObject

@property (nonatomic,copy)NSString *listId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *simpleSpell;
@property (nonatomic,copy)NSString *parentId;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *creator;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *updater;
@property (nonatomic,copy)NSString *updateTime;
@property (nonatomic,copy)NSString *delFlag;

@property (nonatomic,copy)NSString *estateCount;


@end

//
//"id": 19,
//"name": "商圈测试",
//"type": "3",
//"simpleSpell": null,
//"parentId": 15,
//"longitude": null,
//"latitude": null,
//"creator": 1,
//"createTime": "2016-02-25 20:13:16",
//"updater": 1,
//"updateTime": "2016-03-25 15:27:47",
//"delFlag": "0"
//"estateCount" : "0",
//