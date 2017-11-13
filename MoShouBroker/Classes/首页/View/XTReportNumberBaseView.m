//
//  XTReportNumberBaseView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTReportNumberBaseView.h"
#import "NSString+Extension.h"

@interface XTReportNumberBaseView()

//方向图片
@property (nonatomic,weak)XTTrendDirectionImageView* directionImageView;

//报备标题
@property (nonatomic,weak)UILabel* reportTitleLabel;
//数目label
@property (nonatomic,weak)UILabel* reportNumberLabel;

@property (nonatomic,weak)UIImageView* backgroundImageView;

@end

@implementation XTReportNumberBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.layer.borderWidth = 5;
        
//        [self.layer setMasksToBounds:YES];
//        self.layer.borderColor = [UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f].CGColor;
        self.backgroundColor = [UIColor clearColor];
        [self backgroundImageView];
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self commonInit];
}


- (void)layoutSubviews{
//    self.layer.borderWidth = 3.5;
//    self.layer.cornerRadius = self.frame.size.width / 2.0f;
//    [self.layer setMasksToBounds:YES];
//    self.layer.borderColor = [UIColor colorWithRed:0.91f green:0.92f blue:0.91f alpha:1.00f].CGColor;
//
    _backgroundImageView.frame = self.bounds;
    
    self.reportTitleLabel.frame = CGRectMake(0, self.frame.size.height * 0.3, self.frame.size.width, 15);
    self.reportNumberLabel.frame = CGRectMake(0, CGRectGetMaxY(_reportTitleLabel.frame) + 10, self.frame.size.width, NumberFontSize);
    CGSize numberSize = [NSString sizeWithString:[NSString stringWithFormat:@"%ld",_reportNumber] font:[UIFont systemFontOfSize:NumberFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.directionImageView.frame = CGRectMake(self.frame.size.width / 2.0 + numberSize.width / 2.0 + 10, _reportNumberLabel.center.y - 5, 10,
                                              17);
}

- (void)commonInit{
    switch (_direction) {
        case 0:
        {
            self.directionImageView.direction = XTTrendDirectionDown;
            if (_reportTitle.length > 0) self.reportTitleLabel.text = _reportTitle;
            self.reportNumberLabel.text = [NSString stringWithFormat:@"%ld",_reportNumber];
        }
            break;
        case 1:
        {
            self.directionImageView.direction = XTTrendDirectionFair;
            if (_reportTitle.length > 0) self.reportTitleLabel.text = _reportTitle;
            self.reportNumberLabel.text = [NSString stringWithFormat:@"%ld",_reportNumber];
        }
            break;
        case 2:
        {
            self.directionImageView.direction = XTTrendDirectionUp;
            if (_reportTitle.length > 0) self.reportTitleLabel.text = _reportTitle;
            self.reportNumberLabel.text = [NSString stringWithFormat:@"%ld",_reportNumber];
        }
        default:
            break;
    }
    [self setNeedsLayout];
}

- (UILabel *)reportTitleLabel{
    if (!_reportTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setTextColor:[UIColor colorWithRed:0.53f green:0.53f blue:0.55f alpha:1.00f]];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        if (_reportTitle) [label setText:_reportTitle];
        [self addSubview:label];
        _reportTitleLabel = label;
    }
    return _reportTitleLabel;
}

- (UILabel *)reportNumberLabel{
    if (!_reportNumberLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setTextColor:[UIColor colorWithRed:0.00f green:0.60f blue:0.92f alpha:1.00f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:NumberFontSize];
        if (_reportNumber) [label setText:[NSString stringWithFormat:@"%ld",_reportNumber]];
        [self addSubview:label];
        _reportNumberLabel = label;
    }
    return _reportNumberLabel;
}

- (XTTrendDirectionImageView *)directionImageView{
    if (!_directionImageView) {
        XTTrendDirectionImageView* imageView = [[XTTrendDirectionImageView alloc]init];
        imageView.direction = _direction;
        [self addSubview:imageView];
        _directionImageView = imageView;
    }
    return _directionImageView;
}

- (void)setReportTitle:(NSString *)reportTitle{
    _reportTitle = reportTitle;
    [self commonInit];
}

- (void)setReportNumber:(NSInteger)reportNumber{
    _reportNumber = reportNumber;
    [self commonInit];
}

- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //边框圆[UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f].CGColor
//    CGContextSetRGBStrokeColor(context,0.00f,0.59f,0.91f,1.00f);//画笔线的颜色
//    CGContextSetLineWidth(context, BlueLineWidth);//线的宽度
//    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(context, self.frame.size.width / 2.0, self.frame.size.width / 2.0, self.frame.size.width / 2.0 - BlueLineWidth, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle-bluewhite"]];
        [self addSubview:imageView];
        _backgroundImageView = imageView;
    }
    return _backgroundImageView;
}

- (void)setDirection:(NSInteger)direction{
    _direction = direction;
    [self commonInit];
}

@end
