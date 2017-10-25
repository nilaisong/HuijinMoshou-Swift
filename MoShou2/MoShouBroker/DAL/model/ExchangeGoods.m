//
//  ExchangeGoods.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "ExchangeGoods.h"
#import "HMTool.h"

@implementation ExchangeGoods


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
