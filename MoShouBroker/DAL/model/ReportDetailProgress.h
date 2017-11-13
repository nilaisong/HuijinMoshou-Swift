//
//  ReportDetailProgress.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//  报备详情-详细

#import <Foundation/Foundation.h>

@interface ReportDetailProgress : NSObject

/**
 *  "confirmText": "确客",
 "status": "2",
 "statusText": "已带看",
 "commissionText": "结佣",
 "guideText": "带看",
 "successText": "成交"

 */

//@property (nonatomic,copy)NSString* name;

@property (nonatomic,assign)NSInteger status;

@property (nonatomic,copy)NSString* statusText;//已带看

@property (nonatomic,copy)NSString* confirmText;//确客

@property (nonatomic,copy)NSString* guideText;//带看

@property (nonatomic,copy)NSString* successText;//成交

@property (nonatomic,copy)NSString* commissionText;//结佣

@end
