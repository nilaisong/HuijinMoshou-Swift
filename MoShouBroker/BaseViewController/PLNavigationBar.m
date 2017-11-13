
//
//  PLNavigationBar.m
//  MoShouBroker
//
//  Created by admin on 15/7/10.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "PLNavigationBar.h"
#import "HMTool.h"
@interface PLNavigationBar ()
@end

@implementation PLNavigationBar

-(id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    self.barBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.barBackgroundImageView];
    self.barBackgroundImageView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7" alpha:0.97];

    self.leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBarButton.frame = CGRectMake(0, 20, 40, 44);
    [self.leftBarButton setImage:[UIImage imageNamed:@"base-leftBarButton"] forState:UIControlStateNormal];
    [self.leftBarButton setImage:[UIImage imageNamed:@"base-leftBarButton"] forState:UIControlStateSelected];
    
    [self.leftBarButton addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBarButton];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBarButtonClick:)];
    [self.leftBarButton addGestureRecognizer:tap];
    
    //titleLabel  显示标题的Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, kMainScreenWidth - 60 -60, 44)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.titleLabel.textColor =NAVIGATIONTITLE;
//    [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:39.0/255.0 alpha:1];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    //右侧按钮
    self.rigthOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rigthOneButton.frame = CGRectMake(kMainScreenWidth - 40, 44, 40, 40);
//    self.rigthOneButton.backgroundColor = [UIColor grayColor];
    [self.rigthOneButton addTarget:self action:@selector(rigthBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rigthOneButton];
    
    self.line = [HMTool creareLineWithFrame:CGRectMake(0,63.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [self addSubview:self.line];
    
    
}

-(void)leftBarButtonClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(leftBarButtonItemClick)]) {
        [self.delegate leftBarButtonItemClick];
    }
}


- (void)rigthBarButtonClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(rightBarButtonItemClick)]) {
        [self.delegate rightBarButtonItemClick];
    }
}


@end
