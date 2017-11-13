//
//  PlatList.m
//  MoShou2
//
//  Created by strongcoder on 16/4/26.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "PlatList.h"

@implementation PlatList


-(NSString*) name{
    
    if (_name.length==0) {
        
        return @"";

    }
    return _name;
}



@end
