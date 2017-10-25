//
//  XTMapCityGroupModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//  城市组

#import <Foundation/Foundation.h>
#import "XTMapCityInfoModel.h"
@interface XTMapCityGroupModel : NSObject

@property (nonatomic,strong)NSArray* groups;//XTMapCityInfoModel

@property (nonatomic,copy)NSString* matches;

@end
