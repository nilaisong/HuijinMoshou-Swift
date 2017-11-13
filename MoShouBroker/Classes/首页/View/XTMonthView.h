//
//  XTMonthView.h
//  年历
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XTMonthView : UIButton

@property (nonatomic,strong)NSDate* date;

@property (nonatomic,weak)NSDate* maxDate;

@property (nonatomic,weak)UIView* circleView;

@end
