//
//  XTMapDistricInfoModel.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTMapDistricDocList.h"

@interface XTMapDistricInfoModel : NSObject

@property (nonatomic,copy)NSString* groupValue;

@property (nonatomic,strong)XTMapDistricDocList* doclist;

@end
