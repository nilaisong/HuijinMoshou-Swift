//
//  XTRecdDescriptionModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/29.
//  Copyright © 2016年 5i5j. All rights reserved.
// 推荐详情

#import <Foundation/Foundation.h>

@class XTRecdDescModelItem;
@interface XTRecdDescriptionModel : NSObject

@property (nonatomic,strong)XTRecdDescModelItem* recdDesc;

@property (nonatomic,strong)NSString* shareUrl;

@property (nonatomic,strong)NSArray* relateRecd;
@end
