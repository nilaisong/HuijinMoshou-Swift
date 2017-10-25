//
//  Photo.m
//  MoShou2
//
//  Created by strongcoder on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "Photo.h"

@implementation Photo




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
