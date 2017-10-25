//
//  XTMapPinView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>

typedef NS_ENUM(NSInteger,XTMapPinViewType) {
    XTMapPinViewTypeBus = 0,
    XTMapPinViewTypeShop ,
    XTMapPinViewTypeBank,
    XTMapPinViewTypeSubway,
    XTMapPinViewTypeSchool,
    XTMapPinViewTypeHospital,
};

@interface XTMapPinView : BMKPinAnnotationView



- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier type:(XTMapPinViewType)type;

@end
