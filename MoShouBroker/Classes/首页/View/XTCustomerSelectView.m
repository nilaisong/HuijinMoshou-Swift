//
//  XTCustomerSelectView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCustomerSelectView.h"

#import "NSString+Extension.h"

@interface XTCustomerSelectView()



@property (nonatomic,weak)UIImageView* arrowImageView;

@end

@implementation XTCustomerSelectView

- (instancetype)initWithEventCallBack:(XTCustomerSelectViewEventCallBack)callBack{
    if (self = [super init]) {
        [self commonInit];
        _callBack = callBack;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        
        
    }
    return self;
}

- (void)commonInit{
    self.customerNameLabel.text = @"客户名";
    self.customerPhoneNumberLabel.text = nil;
    
    [self arrowImageView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCustomerAction:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews{
    CGSize size = [_customerNameLabel.text sizeWithfont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _customerNameLabel.frame = CGRectMake(16, 0, size.width, self.frame.size.height);
    _customerPhoneNumberLabel.frame = CGRectMake(CGRectGetMaxX(_customerNameLabel.frame) + 5, 0, self.frame.size.width / 2.0f, self.frame.size.height);
    
    _arrowImageView.frame = CGRectMake(self.frame.size.width - 16 - 8, 0, 8, 13);
    _arrowImageView.center = CGPointMake(_arrowImageView.center.x, self.frame.size.height / 2.0f);
}

- (UILabel *)customerNameLabel{
    if (!_customerNameLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        [self addSubview:label];
        _customerNameLabel = label;
    }
    return _customerNameLabel;
}

- (UILabel *)customerPhoneNumberLabel{
    if (!_customerPhoneNumberLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        [self addSubview:label];
        _customerPhoneNumberLabel = label;
    }
    return _customerPhoneNumberLabel;
}


- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-right"]];
        
        [self addSubview:imageView];
        
        _arrowImageView = imageView;
    }
    return _arrowImageView;
}

- (void)selectCustomerAction:(UIGestureRecognizer*)gesture{
    if (_callBack) {
        _callBack(self);
    }
}

- (void)reloadView{
    [self setNeedsLayout];
}


@end
