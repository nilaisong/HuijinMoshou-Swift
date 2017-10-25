//
//  XTMineRankingInfoView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface XTMineRankingInfoView : UIView

//当前排名
@property (weak, nonatomic) IBOutlet UILabel *currentRankingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPic;
//近一个月成交数
@property (weak, nonatomic) IBOutlet UILabel *currentMonthInfoLabel;
//总成交数
@property (weak, nonatomic) IBOutlet UILabel *allIncomLabel;


+ (instancetype)mineRankingInfoView;

@end
