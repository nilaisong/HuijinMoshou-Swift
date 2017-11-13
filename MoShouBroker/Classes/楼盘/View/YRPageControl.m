//
//  YRPageControl.m
//  
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.//
//

#import "YRPageControl.h"
#import "UIView+YR.h"

@interface YRPageControl ()

@property (nonatomic,strong) UIButton  *leftBtn;
@property (nonatomic,strong) UIButton  *rightBtn;
@property (nonatomic,strong) UILabel   *countLabel;
@property (nonatomic,assign) NSInteger totalCount;

@end

@implementation YRPageControl

- (instancetype)initWithFrame:(CGRect)frame totalCount:(NSInteger)totalCount {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentPage = 1;
        _totalCount = totalCount;
        self.bounds = CGRectMake(0, 0, kMainScreenWidth, 30);
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, self.height, self.height);
        [_leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(self.width - self.height, 0, self.height, self.height);
        [_rightBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.height, 0, self.width - 2 * self.height, self.height)];
        _countLabel.font = FONT(19);
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = [NSString stringWithFormat:@"1/%ld",(long)totalCount];
        
        [self addSubview:_leftBtn];
        [self addSubview:_rightBtn];
        [self addSubview:_countLabel];
    }
    return self;
}

- (void)pageAction:(UIButton *)btn {
    if (btn == _leftBtn && self.currentPage > 1 ) {
        self.currentPage --;
    }else if (btn == _rightBtn && self.currentPage < _totalCount) {
        self.currentPage ++;
    }else {
        NSLog(@"已到边界!!");
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPageControlClickedAtIndex:)]) {
        [self.delegate didPageControlClickedAtIndex:_currentPage - 1];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currentPage,(long)_totalCount];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
