//
//  XTMapBuildPointAnnotation.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapBuildPointAnnotation.h"

@implementation XTMapBuildPointAnnotation

- (void)setInfoModel:(XTMapBuildInfoModel *)infoModel{
    if (!infoModel) {
        return;
    }
    _infoModel = infoModel;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [infoModel.estateLatitude doubleValue];
    coordinate.longitude = [infoModel.estateLongitude doubleValue];
    [self setCoordinate:coordinate];
    [self setTitle:@""];
    [self setSubtitle:@""];
}

@end
