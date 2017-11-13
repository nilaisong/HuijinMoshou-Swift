//
//  HouseType.m
//  MoShou2
//
//  Created by strongcoder on 16/4/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "HouseType.h"

@implementation HouseType


-(NSString*) thmUrl
{
    if (_imgUrl.length>0) {
        
        return smallImgUrl(_imgUrl);
    }
    return @"";
}

-(NSString*) imgUrl
{
    if (_imgUrl.length>0) {
        return bigImgUrl(_imgUrl);
    }
    return @"";
}









@end




