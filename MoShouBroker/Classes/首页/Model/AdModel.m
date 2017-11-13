//
//  AdModel.m
//  MoShou2
//
//  Created by xiaotei's on 16/4/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = [value integerValue];
    }else if([key isEqualToString:@"description"]){
        _descript = value;
    }
}

@end
