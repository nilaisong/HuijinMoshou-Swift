//
//  LQScrollBtnView.m
//  MoShouBroker
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "LQScrollBtnView.h"

#define BtnHeight 49.0

#define TitleBtnWith 60  //单个按钮宽度


@interface LQScrollBtnView ()<UIScrollViewDelegate>
{
    
    UIScrollView    *_tabScrollView;
    NSArray         *_titles;
    NSInteger    _chooseIndex;
    CGFloat        _titleBtnWith;
    
}

@end
@implementation LQScrollBtnView

- (id)initWithTitles:(NSArray *)Titles;
{
    self = [super initWithFrame:CGRectMake(0, kMainScreenHeight-BtnHeight, kMainScreenWidth, BtnHeight)];
    if (self)
    {
        _titles = Titles;
        _chooseIndex = 0;
        _titleBtnWith = kMainScreenWidth/_titles.count;
        
    [self loadScrollView];
    }
    return self;
}

- (void)loadScrollView
{
    _tabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, BtnHeight)];
    _tabScrollView.pagingEnabled = NO;
    _tabScrollView.delegate =self;
    _tabScrollView.showsHorizontalScrollIndicator = NO;
    _tabScrollView.bounces = YES;
    _tabScrollView.contentOffset = CGPointMake(0, 0);
    _tabScrollView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < _titles.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*_titleBtnWith, 0, _titleBtnWith, 49);
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(choosebBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2000+i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [_tabScrollView addSubview:button];

    }
    [_tabScrollView setContentSize:CGSizeMake(_titles.count*_titleBtnWith, 49)];
    [self addSubview:_tabScrollView];
}
-(void)choosebBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(choosebtn:withBtntag:)])
    {
        [self.delegate choosebtn:self withBtntag:sender.tag-2000];
    }
    

    if (sender.tag - 2000 != _chooseIndex )
    {
        UIButton *pastBtn = (UIButton *)[self viewWithTag:_chooseIndex +2000];
        [pastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _chooseIndex = sender.tag -2000;
    }
    
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"scrollView.offset===%f",scrollView.contentOffset.x);
    
    
    
}



@end
