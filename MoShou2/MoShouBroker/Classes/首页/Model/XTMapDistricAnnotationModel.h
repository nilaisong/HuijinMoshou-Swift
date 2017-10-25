//
//  XTMapDistricAnnotationModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTMapDistricAnnotationModel : NSObject

@property (nonatomic,copy)NSString* districtId;

@property (nonatomic,copy)NSString* districtLongitude;

@property (nonatomic,copy)NSString* districtLatitude;

@property (nonatomic,copy)NSString* districtName;

@property (nonatomic,copy)NSString* numFound;

@property (nonatomic,copy)NSString* start;

@property (nonatomic,assign)CLLocationCoordinate2D coordinate;

@end
