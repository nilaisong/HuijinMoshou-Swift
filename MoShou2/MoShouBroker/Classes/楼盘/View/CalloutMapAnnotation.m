//
//  CalloutMapAnnotation.m
//  MoShouBroker
//
//  Created by admin on 15/7/14.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude {
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
