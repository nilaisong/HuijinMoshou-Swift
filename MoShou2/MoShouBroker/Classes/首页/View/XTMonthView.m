//
//  XTMonthView.m
//  年历
//
//  Created by xiaotei's on 15/12/1.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "XTMonthView.h"

@interface XTMonthView()


@end

@implementation XTMonthView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f] forState:UIControlStateDisabled];

        self.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.circleView.frame = CGRectMake(0, 0, 36, 36);
    _circleView.center = self.center;
    _circleView.layer.cornerRadius = 18;
}


- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.91, 0.91, 0.91, 1.0);//线条颜色
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, 0,0);
    CGContextAddLineToPoint(context, self.frame.size.width,0);
    CGContextStrokePath(context);
}

- (UIView *)circleView{
    if (!_circleView) {
        UIView* view = [[UIView alloc]init];
        view.hidden = YES;
        [self addSubview:view];
        view.clipsToBounds = YES;

        [view setBackgroundColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]];
        _circleView = view;
    }
    return _circleView;
}
@end
