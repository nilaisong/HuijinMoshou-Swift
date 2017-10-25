//
//  ProgressStatus.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/7/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressStatus : NSObject

//@property(nonatomic,copy) NSString* name;//步骤名称
@property(nonatomic,copy) NSString* status;//状态
@property(nonatomic,copy) NSString* statusText;//状态标签

@property(nonatomic,copy) NSString* confirmText;//确客
@property(nonatomic,copy) NSString* guideText;//带看
@property(nonatomic,copy) NSString* successText;//成交
@property(nonatomic,copy) NSString* commissionText;//结佣


@property(nonatomic,copy) NSString* descriptionText;//description
//是否可以撤销楼盘 1:可以, 0：不可以 2015-10-13 add by wangzz
@property(nonatomic,copy) NSString* can_revokeRecommendation;
@property(nonatomic,strong) NSArray* messages;//交易消息数组，元素MessageData

@end
