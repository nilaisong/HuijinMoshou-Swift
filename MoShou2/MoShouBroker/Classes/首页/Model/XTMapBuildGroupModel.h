//
//  XTMapBuildGroupModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTMapBuildInfoModel.h"


@interface XTMapBuildGroupModel : NSObject


@property (nonatomic,strong)NSArray* docs;//XTMapBuildInfoModel

@property (nonatomic,copy)NSString* numFound;

@property (nonatomic,copy)NSString* start;


/**
 图片地址
 */
@property (nonatomic,copy)NSString* photoServer;

@end
