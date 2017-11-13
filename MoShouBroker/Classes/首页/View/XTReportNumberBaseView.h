//
//  XTReportNumberBaseView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTrendDirectionImageView.h"

#define BlueLineWidth 5.5

#define NumberFontSize 32

@interface XTReportNumberBaseView : UIView

//标题
@property (nonatomic,copy)NSString* reportTitle;

//数目
@property (nonatomic,assign)NSInteger reportNumber;

//指标趋势方向，上/下
//@property (nonatomic,assign)XTTrendDirection direction;

@property (nonatomic,assign)NSInteger direction;

@end
