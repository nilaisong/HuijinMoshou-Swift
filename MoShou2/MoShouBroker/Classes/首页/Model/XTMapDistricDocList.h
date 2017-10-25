//
//  XTMapDistricDocList.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTMapDistricDoc.h"

@interface XTMapDistricDocList : NSObject

@property (nonatomic,strong)NSArray* docs;//XTMapDistricDoc

@property (nonatomic,copy)NSString* numFound;

@property (nonatomic,copy)NSString* start;

@end
