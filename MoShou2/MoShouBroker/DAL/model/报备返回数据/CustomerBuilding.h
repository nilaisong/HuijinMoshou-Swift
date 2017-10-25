//
//  CustomerBuilding.h
//  MoShou2
//
//  Created by wangzz on 16/1/7.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerBuilding : NSObject

@property(nonatomic,copy) NSString* buildingId;//楼盘编号
@property(nonatomic,copy) NSString* buildingName;//楼盘名称
@property(nonatomic,copy) NSString* district;//楼盘所在区域
@property(nonatomic,copy) NSString* distance;//距离
@property(nonatomic,copy) NSString* featureTag;//特设标签
@property(nonatomic,copy) NSString* commission;//佣金标准
@property(nonatomic,copy) NSString* customerTelType;//全号 隐号报备 (0:全号隐号均可 1:仅全号)

//20160707
@property(nonatomic,copy) NSString* customerVisitEnable;//楼盘填写客户到访信息(1:必须填 0:不用填 )
@property(nonatomic,copy) NSString* customerVisitText;//提示填写客户到访信息的入口文本

//20160920
@property(nonatomic,copy) NSString* count;//还可报备楼盘的数量
@property(nonatomic,copy) NSString* mechanismType;//楼盘填写客户到访信息(1:必须填 0:不用填 )
@property(nonatomic,copy) NSString* mechanismText;//提示填写确客信息的入口文本

@end
