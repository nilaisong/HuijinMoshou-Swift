//
//  EvaluationData.h
//  MoShou2
//
//  Created by manager on 2017/3/11.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationData : NSObject

@property (nonatomic, strong) NSString   *customer_review_summary;//带看评价
@property (nonatomic, strong) NSString   *customer_review_score ;//带看评分
@property (nonatomic, strong) NSString   *custName;//客户姓名
@property (nonatomic, strong) NSString   *mobile;//客户电话
@property (nonatomic, strong) NSString   *estateName;//带看楼盘
@property (nonatomic, strong) NSString   *create_time;//创建时间


@end
