//
//  XTAlbumTitleView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 17/1/6.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "XTAlbumTitleView.h"

@interface XTAlbumTitleView()

@property (nonatomic,strong)NSArray* buttonArray;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UIScrollView* contentScrollView;

@property (nonatomic,copy)AlbumTitleViewAction callBack;

@property (nonatomic,weak)UIButton* selectedButton;

@end

@implementation XTAlbumTitleView

- (instancetype)initWithCallBack:(AlbumTitleViewAction)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    if (_titleArray.count <= 0) {
        _contentScrollView.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentScrollView removeAllSubviews];
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton* btn = [_buttonArray objectForIndex:i];
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 10, 1.0, _contentScrollView.height - 20)];
        if (i != _buttonArray.count - 1) {
            [self.contentScrollView addSubview:grayView];
        }
        if (i == 0) {
            self.lineView.frame = CGRectMake(0, self.contentScrollView.height - 2.0, btn.width, 2.0f);
        }
    }
}

- (NSArray *)buttonArray{
    if (!_buttonArray || _buttonArray.count != _titleArray.count) {
        NSMutableArray* btnArray = [NSMutableArray array];
        
        CGFloat width = kMainScreenWidth/_titleArray.count;
        if (width < 86.0f) {
            width = 86.0f;
            self.contentScrollView.contentSize = CGSizeMake(_titleArray.count * width, 0);
        }else{
            self.contentScrollView.contentSize = CGSizeMake(0, 0);
        }
        
        for (int i = 0; i < _titleArray.count; i++) {
            NSString* title = _titleArray[i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnArray appendObject:btn];
            btn.tag = 1000+i;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"37aeff"] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithHexString:@"37aeff"] forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            btn.frame = CGRectMake(i * width, 0, width, 45.0f);
            [self.contentScrollView addSubview:btn];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                _selectedButton = btn;
                btn.selected = YES;
            }
        }
        _buttonArray = btnArray;
    }
    return _buttonArray;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        UIScrollView* scrollV = [[UIScrollView alloc]init];
        scrollV.frame = CGRectMake(0, 4, kMainScreenWidth, 45);
        [self addSubview:scrollV];
        _contentScrollView = scrollV;
    }
    return _contentScrollView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView * line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"37aeff"];
        _lineView=  line;
        [self.contentScrollView addSubview:_lineView];
    }
    return _lineView;
}


- (void)buttonAction:(UIButton*)btn{
    CGFloat offsetX = btn.center.x - _contentScrollView.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    if (offsetX > (_contentScrollView.contentSize.width - _contentScrollView.size.width)) {
        offsetX = _contentScrollView.contentSize.width - _contentScrollView.size.width;
    }

    
    [UIView animateWithDuration:0.25 animations:^{
        if (_contentScrollView.contentSize.width > 0) {
            [_contentScrollView setContentOffset:CGPointMake(offsetX, 0)];
        }
        
        self.lineView.frame = CGRectMake(btn.left, self.contentScrollView.height - 2.0f, btn.width, 2.0f);
    }];
    
    
    if (btn == _selectedButton) {
        return;
    }
    _selectedButton.selected = NO;
    _selectedButton = btn;
    btn.selected = YES;
    if (_callBack) {
        _callBack(self,btn.tag - 1000,btn);
    }
    
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (_selectedButton.tag - 1000 == currentIndex) {
        return;
    }else if(currentIndex < _titleArray.count){
        UIButton* button = [self.contentScrollView viewWithTag:1000+currentIndex];
        _selectedButton.selected = NO;
        button.selected = YES;
        _selectedButton = button;
        [self buttonAction:button];
    }
}

@end
