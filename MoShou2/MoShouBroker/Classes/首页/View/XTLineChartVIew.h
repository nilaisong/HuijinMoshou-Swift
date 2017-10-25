//
//  XTLineChartVIew.h
//  天气绘图
//
//  Created by xiaotei on 15/9/24.
//  Copyright (c) 2015年 xiaotei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BottomHeight 17
#define ItemWidth ((kMainScreenWidth - 32)/4.5)
#define CircleRadius  15


@class ChartPoint;
@interface XTLineChartVIew : UIScrollView
//绘图点对象数组
@property (nonatomic,strong)NSMutableArray* points;

-(void)addChartPoint:(ChartPoint*)chartPoint;


@end
