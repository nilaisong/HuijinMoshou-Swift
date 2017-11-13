//
//  XTReportNumberCommonView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

//常规数据展示视图认筹数，认购数，签约数，带看转化率，成交转化率

#import <UIKit/UIKit.h>

#import "XTTrendDirectionImageView.h"

#define XTNumberFontSize 18

@interface XTReportNumberCommonView : UIView

//标题
@property (nonatomic,copy)NSString* reportTitle;

//数目
@property (nonatomic,copy)NSString* reportNumber;

//指标趋势方向，上/下
@property (nonatomic,assign)NSInteger direction;

@end
