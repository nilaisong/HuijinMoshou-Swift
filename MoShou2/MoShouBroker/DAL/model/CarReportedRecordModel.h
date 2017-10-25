//
//  CarReportedRecordModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
// 约车报备模型

#import <Foundation/Foundation.h>

@class MobileVisible;
@interface CarReportedRecordModel : NSObject

@property (nonatomic,copy)NSString* optType;

@property (nonatomic,strong)NSArray* phoneList;

@property (nonatomic,copy)NSString* count;

@property (nonatomic,copy)NSString* buildingName;

@property (nonatomic,copy)NSString* trystCar;

@property (nonatomic,copy)NSString* status;

@property (nonatomic,copy)NSString* buildingCustomerId;

@property (nonatomic,copy)NSString* url;

@property (nonatomic,copy)NSString* customerId;

@property (nonatomic,assign)CGFloat priceMin;

@property (nonatomic,assign)CGFloat priceMax;

@property (nonatomic,copy)NSString* name;

@property (nonatomic,assign)BOOL showURL;

@property (nonatomic,copy)NSString* typeList;

@property (nonatomic,strong)NSArray* bedroomNum;

@property (nonatomic,copy)NSString* buildingId;

@property (nonatomic,copy)NSString* trystTimeType;

@property (nonatomic,copy)NSString* trystCarTime;

@end
