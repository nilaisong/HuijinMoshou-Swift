//
//  MyLookRanking.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLookRanking : NSObject
@property (nonatomic,copy)NSString* ID;//我的排名
@property (nonatomic,copy)NSString* agencyId;//经纪人id
@property (nonatomic,copy)NSString* agencyName;//经纪人名称
@property (nonatomic,copy)NSString* agencyMobile;//经纪人手机号
@property (nonatomic,copy)NSString* shopName;//门店
@property (nonatomic,copy)NSString* agencyOrganizationId;//机构id
@property (nonatomic,copy)NSString* countNum;//成交数量
@property (nonatomic,copy)NSString* headPic;//头像
@end
