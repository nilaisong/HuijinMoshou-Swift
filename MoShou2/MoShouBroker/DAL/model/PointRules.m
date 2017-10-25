//
//  PointRules.m
//  MoShou2
//
//  Created by Aminly on 16/5/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "PointRules.h"

@implementation PointRules
-(NSString*) descr{
    
    if (_descr.length>0) {
        return _descr;
    }
    return @"";
}
@end
