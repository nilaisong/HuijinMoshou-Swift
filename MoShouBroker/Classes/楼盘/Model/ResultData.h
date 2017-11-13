//
//  ResultData.h
//  MoShou2
//
//  Created by strongcoder on 16/1/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultData : NSObject

@property (nonatomic,copy)NSString *houseAllPrice;  //房屋总价
@property (nonatomic,copy)NSString *daiKuanAllPrice; //贷款总额
@property (nonatomic,copy)NSString *huanKuanAllPrice; //还款总额
@property (nonatomic,copy)NSString *ziFuLixi;


@property (nonatomic,copy)NSString *firstPay;  //首期付款   //首付
@property (nonatomic,copy)NSString *nianShu;    //按揭年数



@property (nonatomic,copy)NSString *firstYuePay;  //首月还款
@property (nonatomic,copy)NSString *lastYuePay;  //末月还款
@property (nonatomic,copy)NSString *everyMonthDiminish; //每月递减



@property (nonatomic,copy)NSString *everyMonthMean;  //月均还款

@property (nonatomic,copy)NSString *lastYearsMonthMean;  //后几年月供值   只有在两个年数不一样的时候才有值

@property (nonatomic,copy)NSString *lastYearsMonthMeanTitle;

@end
