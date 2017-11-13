//
//  CountDownView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CountDownView.h"

@interface CountDownView()

@property (nonatomic,weak)UIButton* titleButton;

@property (nonatomic,weak)UIImageView* titleImageView;

@end

@implementation CountDownView

- (instancetype)initWithCallBack:(CountDownEventBlock)callBack{
    if (self = [super init]) {
        _callBack = callBack;
        self.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.70f];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleButton.frame = CGRectMake(30, 0, self.frame.size.width - 30, self.frame.size.height);
    
    self.titleImageView.frame = CGRectMake(10, (self.frame.size.height - 13)/2.0, 13, 13);
}


- (UIButton *)titleButton{
    if (!_titleButton) {
        UIButton*  button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"splashdirec"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"splashdirec"] forState:UIControlStateHighlighted];
        [self addSubview:button];
        
        CGFloat left = 33;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 34, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -left, 0, 0)];
        [button setTitle:@"跳过" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [button setTitleColor:[UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(eventAction:) forControlEvents:UIControlEventTouchUpInside];
        _titleButton = button;
    }
    return _titleButton;
}

- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"number5"]];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _titleImageView = imageView;
    }
    return _titleImageView;
}

- (void)eventAction:(UIButton*)button{
    if (_callBack) {
        _callBack(self,button);
    }
}

- (void)setNumber:(NSInteger)number{
    _number = number;
    NSString* imageName = [NSString stringWithFormat:@"number%ld",number];

    [_titleImageView setImage:[UIImage imageNamed:imageName]];
}

@end
