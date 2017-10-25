//
//  OptionData.h
//  MoShouBroker
//  通用数据项结构，常用来存筛选数据项，
//  例如：城市、楼盘区域、楼盘价格、 楼盘面积、购房进度状态等
//  Created by NiLaisong on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionData : NSObject

@property(nonatomic,copy) NSString* itemValue;//编号
@property(nonatomic,copy) NSString* itemName;//名称

@property (nonatomic,copy)NSString* longitude;
@property (nonatomic,copy)NSString* latitude;

@property(nonatomic,assign) BOOL isSelect;//是否选中

@end
