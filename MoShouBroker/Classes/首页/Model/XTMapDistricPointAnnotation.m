//
//  XTMapDistricPointAnnotation.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapDistricPointAnnotation.h"

@implementation XTMapDistricPointAnnotation

- (void)setMapDistricInfoModel:(XTMapDistricInfoModel *)mapDistricInfoModel{
    _mapDistricInfoModel = mapDistricInfoModel;
    XTMapDistricAnnotationModel* districAnnModel = [[XTMapDistricAnnotationModel alloc]init];
    if (mapDistricInfoModel.doclist.docs.count > 0) {
        districAnnModel.numFound = mapDistricInfoModel.doclist.numFound;
        XTMapDistricDoc* districDoc = [mapDistricInfoModel.doclist.docs objectForIndex:0];
        districAnnModel.districtName = districDoc.districtName;
        districAnnModel.districtId   = districDoc.districtId;
        districAnnModel.districtLongitude = districDoc.districtLongitude;
        districAnnModel.districtLatitude  = districDoc.districtLatitude;
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = [districDoc.estateLongitude doubleValue];
        coordinate.latitude  = [districDoc.estateLatitude doubleValue];
        districAnnModel.coordinate = coordinate;
        [self setDistricModel:districAnnModel];
        [self setCoordinate:coordinate];
        [self setTitle:@""];
        [self setSubtitle:@""];
    }
}

@end
