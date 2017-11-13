//
//  XTServiceUpdatingView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/13.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTServiceUpdatingView.h"
#import "NSString+Extension.h"

@interface XTServiceUpdatingView()


@property (nonatomic,weak)UIImageView* tipsImageView;

@property (nonatomic,weak)UIView* blueView;

@property (nonatomic,weak)UIView* whiteView;

@property (nonatomic,weak)UIButton* tipsButton;

@property (nonatomic,weak)UILabel* tipsLabel;

@property (nonatomic,weak)UIImageView* wenxinView;
@property (nonatomic,weak)UIView* contentView;

@end

@implementation XTServiceUpdatingView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_tipsString.length > 0) {
        self.tipsLabel.text = _tipsString;
    }
    self.blueView.frame = CGRectMake(0, 0, self.blueView.width, self.blueView.height);
    self.whiteView.frame = CGRectMake(0, _blueView.height, _whiteView.width, _whiteView.height);
    
    CGSize titleSize = [_tipsString sizeWithfont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(270 * SCALE6 - 40, MAXFLOAT)];
    self.tipsLabel.frame = CGRectMake(20, 31 * SCALE6, _whiteView.width - 40, titleSize.height);
    
    self.contentView.frame = CGRectMake(0, 0, _blueView.width, _blueView.height + _whiteView.height);
    _contentView.center = self.center;
    
    self.wenxinView.frame = CGRectMake((self.contentView.width - 118 * SCALE6) / 2.0   ,_blueView.height - 35 * SCALE6 * 0.5, 118 * SCALE6, 46 * SCALE6);
    self.tipsImageView.frame = CGRectMake((_blueView.width - 166 * SCALE6)/2.0, _blueView.height - 119 * SCALE6 - 35 * SCALE6 * 0.5 - 10 * SCALE6, 166 * SCALE6, 119 * SCALE6);
    
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.85];
    
}

- (UIView *)blueView{
    if (!_blueView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270 * SCALE6, 164 * SCALE6)];
        
        [self.contentView addSubview:view];
        
        view.backgroundColor = [UIColor colorWithHexString:@"56c8e2"];
        
        view.layer.masksToBounds = YES;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii: (CGSize){5.0f, 5.0f}].CGPath;
        
        view.layer.mask = maskLayer;
        
        _blueView = view;
    }
    return _blueView;
}

- (UIView *)whiteView{
    if (!_whiteView) {
        CGSize titleSize = [_tipsString sizeWithfont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(270 * SCALE6 - 40, MAXFLOAT)];
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270 * SCALE6, 51 * SCALE6 + titleSize.height)];
        
        [self.contentView addSubview:view];
        
        view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        view.layer.masksToBounds = YES;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){5.0f, 5.0f}].CGPath;
        
        view.layer.mask = maskLayer;
        
        _whiteView = view;
    }
    return _whiteView;
}

- (UIImageView *)tipsImageView{
    if (!_tipsImageView) {
        UIImageView* imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"service-updating"]];
        [self.blueView addSubview:imgV];
        _tipsImageView = imgV;
    }
    return _tipsImageView;
}


- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [self.whiteView addSubview:label];
        label.contentMode = UIViewContentModeTopLeft;
        label.numberOfLines = 0;
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (UIView *)contentView{
    if (!_contentView) {
        UIView* view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}


- (UIImageView *)wenxinView{
    if (!_wenxinView) {
        UIImageView* imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenxintishi"]];
        [self.contentView addSubview:imgV];
        _wenxinView = imgV;
    }
    return _wenxinView;
}


- (void)setTipsString:(NSString *)tipsString{
    _tipsString = tipsString;
}
@end
