//
//  XTMapCityAnnotationModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTMapCityAnnotationModel : NSObject

@property (nonatomic,copy)NSString* cityName;

@property (nonatomic,copy)NSString* cityId;

@property (nonatomic,copy)NSString* numFound;

@property (nonatomic,assign)CLLocationCoordinate2D coordinate;

@end
