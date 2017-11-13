//
//  CustomerEvaluation.h
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerEvaluation : NSObject

@property (nonatomic, copy) NSString   *intentionalPreference;//意向偏好
@property (nonatomic, copy) NSString   *time;//评级时间
@property (nonatomic, copy) NSString   *userName;//评级人
@property (nonatomic, copy) NSString   *adviceInformation;//建议信息
@property (nonatomic, copy) NSString   *evaluation;//客户评级
@property (nonatomic, copy) NSString   *easemobUserName;//环信的用户名
@property (nonatomic, copy) NSString   *guideState;//带看情况


@end
