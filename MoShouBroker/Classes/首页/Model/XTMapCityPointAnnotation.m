//
//  XTMapCityAnnotation.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapCityPointAnnotation.h"

@implementation XTMapCityPointAnnotation

//赋值后台传来的多层模型，进行解析
- (void)setMapCityInfoModel:(XTMapCityInfoModel *)mapCityInfoModel{
    if (!mapCityInfoModel) {
        return;
    }
    _mapCityInfoModel = mapCityInfoModel;
    XTMapCityAnnotationModel* cityAnnModel = [[XTMapCityAnnotationModel alloc]init];
    if (mapCityInfoModel.doclist.docs.count > 0) {
        cityAnnModel.numFound = mapCityInfoModel.doclist.numFound;
        XTMapDoc* cityDoc = [mapCityInfoModel.doclist.docs objectForIndex:0];
        cityAnnModel.cityName = cityDoc.cityName;
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = [cityDoc.cityLongitude doubleValue];
        coordinate.latitude  = [cityDoc.cityLatitude doubleValue];
        cityAnnModel.coordinate = coordinate;
        cityAnnModel.cityId = cityDoc.cityId;
        [self setCityModel:cityAnnModel];
        [self setCoordinate:coordinate];
        [self setTitle:@""];
        [self setSubtitle:@""];
    }
}

@end
