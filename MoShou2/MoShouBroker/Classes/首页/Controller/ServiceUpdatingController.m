//
//  ServiceUpdatingController.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/13.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ServiceUpdatingController.h"
#import "NSString+Extension.h"

@interface ServiceUpdatingController ()


@property (nonatomic,weak)UIImageView* tipsImageView;

@property (nonatomic,weak)UIView* blueView;

@property (nonatomic,weak)UIView* whiteView;

@property (nonatomic,weak)UIImageView* wenxinView;

@property (nonatomic,weak)UILabel* tipsLabel;

@property (nonatomic,weak)UIView* contentView;

@end

@implementation ServiceUpdatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_tipsString.length > 0) {
        self.tipsLabel.text = _tipsString;
    }
    self.blueView.frame = CGRectMake(0, 0, self.blueView.width, self.blueView.height);
    self.whiteView.frame = CGRectMake(0, _blueView.height, _whiteView.width, _whiteView.height);
    CGSize titleSize = [_tipsString sizeWithfont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(270 * SCALE6 - 40, MAXFLOAT)];
    self.tipsLabel.frame = CGRectMake(20, 31 * SCALE6, _whiteView.width - 40, titleSize.height);
    
    self.contentView.frame = CGRectMake(0, 0, _blueView.width, _blueView.height + _whiteView.height);
    _contentView.center = self.view.center;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.85];
    
    self.wenxinView.frame = CGRectMake((self.contentView.width - 118 * SCALE6) / 2.0   , (self.blueView.height - 46 * SCALE6 * 0.5), 118 * SCALE6, 46 * SCALE6);
    
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        CGSize titleSize = [_tipsString sizeWithfont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(540 * SCALE6 - 40, MAXFLOAT)];
        
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
        [self.view addSubview:view];
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
