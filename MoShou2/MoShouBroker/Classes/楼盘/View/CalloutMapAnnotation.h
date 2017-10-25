//
//  CalloutMapAnnotation.h
//  MoShouBroker
//
//  Created by admin on 15/7/14.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalloutMapAnnotation : NSObject<BMKAnnotation>
{
    
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude;
@end
