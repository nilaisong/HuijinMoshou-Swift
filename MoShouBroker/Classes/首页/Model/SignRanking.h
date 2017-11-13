//
//  SignRanking.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/19.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignRanking : NSObject
@property (nonatomic,assign)NSInteger rownum;//排名
@property (nonatomic,assign)NSInteger userId;//经纪人id
@property (nonatomic,copy)NSString* userName;//经纪人姓名
@property (nonatomic,copy)NSString* shopName;//门店
@property (nonatomic,assign)NSInteger signNum;//成交数量
@property (nonatomic,copy)NSString* headPic;//头像
@property (nonatomic,copy)NSString* startDate;//开始时间
@property (nonatomic,copy)NSString* endDate;//结束时间
@end
