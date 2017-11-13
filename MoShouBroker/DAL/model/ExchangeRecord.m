//
//  ExchangeRecord.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "ExchangeRecord.h"

@implementation ExchangeRecord
-(NSString*) thmUrl{

    if (_thmUrl.length>0) {
        return smallImgUrl(_thmUrl);
    }
    return @"";
}

@end
