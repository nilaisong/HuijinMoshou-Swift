//
//  XTRefreshStatusFooterView.m
//  RefreshTest
//
//  Created by xiaotei's on 16/6/20.
//  Copyright © 2016年 xiaote. All rights reserved.
//

#import "XTRefreshStatusFooterView.h"
#import "UITableView+XTRefresh.h"

@interface XTRefreshStatusFooterView()

@property (nonatomic,weak)UILabel* statusLabel;

@property (nonatomic,weak)UIView* activityView;

@end

@implementation XTRefreshStatusFooterView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
    self.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _scrollView = self.superview;
}

- (void)dealloc{
//    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)endRefreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            if (_scrollView) {
                _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        } completion:^(BOOL finished) {
//            self.legendHeader.status = RefreshViewStatusNone;
//            self.legendFooter.status = XTRefreshFooterViewStatusNone;
            self.status = XTRefreshFooterViewStatusNone;
        }];
    });
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [[change valueForKey:@"new"] CGPointValue];
        if (_scrollView) {
            
            [_scrollView adjustFrameWithPoint:point];
        }
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.statusLabel.frame = self.bounds;
    
    self.activityView.frame = self.bounds;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        _statusLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UIView *)activityView
{
    
    if (_activityView == nil) {
        
        //容器视图
        UIView * tmpView = [[UIView alloc] init];
        tmpView.frame =self.bounds;
        _activityView = tmpView;
        tmpView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        [self addSubview:tmpView];
        
        //繁忙指示器
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
        [tmpView addSubview:indicatorView];
        indicatorView.frame = CGRectMake(80 * SCALE6, (self.frame.size.height - 30)/2.0, 30, 30);
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        //启动菊花动画
        [indicatorView startAnimating];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [tmpView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"正在为你努力加载中...";
        titleLabel.frame = tmpView.bounds;
        
        
    }
    return _activityView;
}


- (void)setStatus:(XTRefreshFooterViewStatus)status{
    _status = status;
    self.activityView.hidden = YES;
    NSString* title = @"";
    switch (status) {
        case XTRefreshFooterViewStatusLoading:
            self.activityView.hidden = NO;
            break;
        case XTRefreshFooterViewStatusEndDragging:
            title = @"松手开始加载。。。";
            break;
        case XTRefreshFooterViewStatusDragging:{
            title = @"上拉加载更多。。。";
        }
            break;
        default:
            break;
    }
    
    self.statusLabel.text = title;
}



@end
