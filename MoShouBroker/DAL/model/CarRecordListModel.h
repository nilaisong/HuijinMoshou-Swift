//
//  CarRecordListModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/8/11.
//  Copyright © 2016年 5i5j. All rights reserved.
// 约车记录模型

#import <Foundation/Foundation.h>

@interface CarRecordListModel : NSObject
/**
 *  "showURL": false,
 "url": ""，
 "estateAppointCarID":1,
 "customerName": 客户1,
 "customerMobile": "18311111111",
 "buildingName": "流程用的楼盘22",
 "status": "已约车", 	//'0:已约车 1:已分配 2:已出发 3:已送达 4:已作废'
 "createTime": "2016-06-23 20:42:29",

 */
@property (nonatomic,assign)BOOL showURL;

@property (nonatomic,copy)NSString* optType;

@property (nonatomic,copy)NSString* url;

@property (nonatomic,copy)NSString* estateAppointCarID;

@property (nonatomic,copy)NSString* customerName;

@property (nonatomic,copy)NSString* customerMobile;

@property (nonatomic,copy)NSString* buildingName;

@property (nonatomic,copy)NSString* status;

@property (nonatomic,copy)NSString* statusId;

@property (nonatomic,copy)NSString* createTime;

@end
