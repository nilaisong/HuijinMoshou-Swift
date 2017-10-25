//
//  PointData.m
//  MoShouBroker
//  用户积分数据模型
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "PointData.h"

@implementation PointData

-(NSString*)title
{
    if (self.point && self.ruleOpt)
    {
        return [NSString stringWithFormat:@"%@%@",self.ruleOpt,self.point];
    }
    return self.point;
}

@end

