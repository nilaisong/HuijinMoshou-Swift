//
//  XTNoScheduleResultView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTNoScheduleResultView.h"
#import "NSString+Extension.h"
@interface XTNoScheduleResultView()

@property (nonatomic,weak)UILabel* leftWordLabel;

@property (nonatomic,weak)UILabel* rightWordLabel;

@property (nonatomic,weak)UIButton* touchBtn;

@end

@implementation XTNoScheduleResultView

- (instancetype)initWithCallBack:(XTNoScheduleResultViewCallBack)callBack   {
    if (self = [super init]) {
        _callBack = callBack;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    self.leftWordLabel.text = _leftTitle;
    [self.touchBtn setTitle:_touchTitle forState:UIControlStateNormal];
    self.rightWordLabel.text = _rightTitle;
}

- (UILabel *)leftWordLabel{
    if (!_leftWordLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f];
        [self addSubview:label];
        _leftWordLabel = label;
    }
    return _leftWordLabel;
}

- (UILabel *)rightWordLabel{
    if (!_rightWordLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f];
        [self addSubview:label];
        _rightWordLabel = label;
    }
    return _rightWordLabel;
}

- (UIButton *)touchBtn{
    if (!_touchBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(touchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.08f green:0.44f blue:0.64f alpha:1.00f] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        _touchBtn = btn;
    }
    return _touchBtn;
}

- (void)layoutSubviews{
    CGSize size1 = [NSString sizeWithString:_leftTitle font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize size2 = [NSString sizeWithString:_touchTitle font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize size3 = [NSString sizeWithString:_rightTitle font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    NSString* allTitle = [NSString stringWithFormat:@"%@%@%@",_leftTitle,_touchTitle,_rightTitle];
    CGSize size = [NSString sizeWithString:allTitle font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat x = (self.frame.size.width - size.width)/2.0f;
    
    self.leftWordLabel.frame = CGRectMake(x, 0, size1.width, size1.height);
    self.touchBtn.frame = CGRectMake(CGRectGetMaxX(_leftWordLabel.frame), 0, size2.width, size2.height);
    self.rightWordLabel.frame = CGRectMake(CGRectGetMaxX(_touchBtn.frame), 0, size3.width, size3.height);
    
    [self setNeedsDisplay];
}

- (void)touchBtnClick:(UIButton*)btn{
    if (_callBack) {
        _callBack(btn);
    }
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.11f, 0.62f, 0.92, 1.0f);//线条颜色
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context,_touchBtn.frame.origin.x, CGRectGetMaxY(_touchBtn.frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(_touchBtn.frame),CGRectGetMaxY(_touchBtn.frame));
    CGContextStrokePath(context);
}

@end
