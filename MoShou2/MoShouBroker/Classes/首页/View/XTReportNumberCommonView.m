//
//  XTReportNumberCommonView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTReportNumberCommonView.h"
#import "NSString+Extension.h"

@interface XTReportNumberCommonView()

//方向图片
@property (nonatomic,weak)XTTrendDirectionImageView* directionImageView;

//报备标题
@property (nonatomic,weak)UILabel* reportTitleLabel;
//数目label
@property (nonatomic,weak)UILabel* reportNumberLabel;

@end

@implementation XTReportNumberCommonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //        self.layer.borderWidth = 5;
        
        //        [self.layer setMasksToBounds:YES];
        //        self.layer.borderColor = [UIColor colorWithRed:0.00f green:0.59f blue:0.91f alpha:1.00f].CGColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self commonInit];
}


- (void)layoutSubviews{
//    self.layer.borderWidth = 1;
//    [self.layer setMasksToBounds:YES];
//    self.layer.borderColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.95f alpha:1.00f].CGColor;
    //
    self.reportTitleLabel.frame = CGRectMake(0, self.frame.size.height * 0.3, self.frame.size.width, 15);
    self.reportNumberLabel.frame = CGRectMake(0, CGRectGetMaxY(_reportTitleLabel.frame) + 10, self.frame.size.width, XTNumberFontSize);
    CGSize numberSize = [NSString sizeWithString:_reportNumber font:[UIFont systemFontOfSize:XTNumberFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.directionImageView.frame = CGRectMake(self.frame.size.width / 2.0 + numberSize.width / 2.0 + 8, _reportNumberLabel.center.y - 5, 10,
                                               13);
}

- (void)commonInit{
    
    self.reportNumberLabel.text = @"0";
    switch (_direction) {
        case 0:
        {
            self.directionImageView.direction = XTTrendDirectionDown;
            if (_reportTitle.length > 0) self.reportTitleLabel.text = _reportTitle;
            if (_reportNumber.length > 0)self.reportNumberLabel.text = _reportNumber;
        }
            break;
        case 1:
        {
            self.directionImageView.direction = XTTrendDirectionFair;
            if (_reportTitle.length > 0) self.reportTitleLabel.text = _reportTitle;
            if (_reportNumber.length > 0)self.reportNumberLabel.text = _reportNumber;
        }
            break;
        case 2:
        default:{
            self.directionImageView.direction = XTTrendDirectionUp;
            if (_reportTitle.length > 0) self.reportTitleLabel.text = _reportTitle;
            if (_reportNumber.length > 0)self.reportNumberLabel.text = _reportNumber;
            
        }
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
        label.font = [UIFont systemFontOfSize:XTNumberFontSize];
        if (_reportNumber) [label setText:_reportNumber];
        [self addSubview:label];
        _reportNumberLabel = label;
    }
    return _reportNumberLabel;
}

- (XTTrendDirectionImageView *)directionImageView{
    if (!_directionImageView) {
        XTTrendDirectionImageView* imageView = [[XTTrendDirectionImageView alloc]init];
        if (_direction)imageView.direction = _direction;
        [self addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        _directionImageView = imageView;
    }
    return _directionImageView;
}

- (void)setReportTitle:(NSString *)reportTitle{
    _reportTitle = reportTitle;
    [self commonInit];
}

- (void)setReportNumber:(NSString *)reportNumber{
    _reportNumber = reportNumber;
    [self commonInit];
}

- (void)setDirection:(NSInteger)direction{
    _direction = direction;
    [self commonInit];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint aPoints[3];//坐标点
    aPoints[0] = CGPointMake(self.frame.size.width - 1, 0);//坐标1
    aPoints[1] = CGPointMake(self.frame.size.width - 1, self.frame.size.height - 1);//坐标2
    aPoints[2] = CGPointMake(0, self.frame.size.height - 1);//坐标3
    //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
    //points[]坐标数组，和count大小
//    0.94f green:0.94f blue:0.95f alpha:1.00f
    CGContextSetRGBStrokeColor(context,0.94f,0.94f,0.95f,1.0f);
    CGContextSetLineWidth(context, 1);
    CGContextAddLines(context, aPoints, 3);//添加线
    CGContextDrawPath(context, kCGPathStroke);
}


@end
