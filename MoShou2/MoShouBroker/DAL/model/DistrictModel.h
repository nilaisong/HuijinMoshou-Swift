//
//  DistrictModel.h
//  MoShou2
//
//  Created by strongcoder on 16/4/26.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistrictModel : NSObject

@property (nonatomic,copy)NSString *districtId;
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
@property (nonatomic,copy)NSString *district;
@property (nonatomic,copy)NSString *city;

@property (nonatomic,copy)NSString *estateCount;  //一个大区的所有数量


@property (nonatomic,strong)NSArray *platLists;    // PlatList

@end


//
//
//"id": 15,
//"name": "朝阳",
//"type": "2",
//"simpleSpell": null,
//"parentId": 4,
//"longitude": null,
//"latitude": null,
//"creator": 1,
//"createTime": "2016-02-25 16:53:19",
//"updater": 1,
//"updateTime": "2016-02-25 16:53:33",
//"delFlag": "0",
//"district": null,
//"city": null,
//"platList": [