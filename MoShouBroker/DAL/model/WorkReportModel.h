//
//  WorkReportModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkReportModel : NSObject

/**
 *  业绩
 */
@property (nonatomic,copy)NSString* performance;

@property (nonatomic,copy)NSString* dateEnd;
@property (nonatomic,copy)NSString* dateStart;

/**
 *  签约数
 */
@property (nonatomic,assign)NSInteger signNum;
@property (nonatomic,assign)NSInteger signChange;

/**
 *  报备数
 */
@property (nonatomic,assign)NSInteger recomNum;
@property (nonatomic,assign)NSInteger recmChange;

/**
 *  认筹数
 */
@property (nonatomic,assign)NSInteger rowcardNum;
@property (nonatomic,assign)NSInteger rowcardChange;

/**
 *  认购数
 */
@property (nonatomic,assign)NSInteger subscribeNum;
@property (nonatomic,assign)NSInteger subscribeChange;

/**
 *  成交转化率
 */
@property (nonatomic,copy)NSString* completedRate;
@property (nonatomic,assign)NSInteger completedRateChange;

/**
 *  带看数
 */
@property (nonatomic,assign)NSInteger guidNum;
@property (nonatomic,assign)NSInteger lookChange;

/**
 *  带看转化率
 */
@property (nonatomic,copy)NSString* lookRate;
@property (nonatomic,assign)NSInteger lookRateChange;



@end
