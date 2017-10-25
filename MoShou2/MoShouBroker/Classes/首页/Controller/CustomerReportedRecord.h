//
//  CustomerReportedRecord.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//客户的一条报备记录

#import <Foundation/Foundation.h>
@class MobileVisible;
@interface CustomerReportedRecord : NSObject
/**
 *  是否可使用URL生成二维码,true:是 false:否
 */
@property (nonatomic,assign)BOOL showURL;
/**
 *  生成二维码的URL网址
 */
@property (nonatomic,copy)NSString* url;
/**
 *  客户和楼盘关联id
 */
@property (nonatomic,assign)NSInteger buildingCustomerId;
/**
 *  客户id
 */
@property (nonatomic,copy)NSString* customerId;
/**
 *  姓名
 */
@property (nonatomic,copy)NSString* name;
/**
 *  手机号
 */
//@property (nonatomic,copy)NSString* phonenumber;

@property (nonatomic,strong)NSArray* phoneList;//MobileVisible
/**
 *  楼盘id
 */
@property (nonatomic,copy)NSString* buildingId;
/**
 *  楼盘
 */
@property (nonatomic,copy)NSString* buildingName;
/**
 *  报备状态
 */
@property (nonatomic,copy)NSString* status;
/**
 *  报备时间
 */
@property (nonatomic,copy)NSString* datetime;

@property (nonatomic,assign)NSInteger priceMin;

@property (nonatomic,assign)NSInteger priceMax;

@property (nonatomic,assign)NSInteger typeList;

@property (nonatomic,strong)NSArray* bedroomNum;

@property (nonatomic,assign)NSInteger count;

/**
 *  确客姓名
 */
@property (nonatomic,copy)NSString* quekeName;

/**
 *  确客电话
 */
@property (nonatomic,copy)NSString* quekePhone;

@end
