//
//  CustomerVisitInfoData.h
//  MoShou2
//
//  Created by wangzz on 16/7/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerVisitInfoData : NSObject

@property (nonatomic, copy) NSString *startDateStr;
@property (nonatomic, copy) NSString *endDateStr;
@property (nonatomic, copy) NSString *visitCount;
@property (nonatomic, copy) NSString *transfFunc;
@property (nonatomic, strong) NSDate   *startDate;
@property (nonatomic, strong) NSDate   *endDate;

//add by wangzz 160918
@property(nonatomic,copy) NSString* quekeName;//确客姓名
@property(nonatomic,copy) NSString* quekePhone;//确客电话
//end


@end
