//
//  XTMapDistricDoc.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//  区域

#import <Foundation/Foundation.h>

@interface XTMapDistricDoc : NSObject

@property (nonatomic,copy)NSString* districtId;

@property (nonatomic,copy)NSString* districtLatitude;

@property (nonatomic,copy)NSString* districtLongitude;

@property (nonatomic,copy)NSString* districtName;

/**
 楼盘纬度
 */
@property (nonatomic,copy)NSString* estateLatitude;

/**
 楼盘经度
 */
@property (nonatomic,copy)NSString* estateLongitude;



@end

