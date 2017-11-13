//
//  MineRankingInfoModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineRankingInfoModel : NSObject
//总业绩
@property (nonatomic,copy)NSAttributedString* performance;
//近一月业绩
@property (nonatomic,copy)NSAttributedString* comission;
//排名
@property (nonatomic,copy)NSAttributedString* rankingInfo;
@end
