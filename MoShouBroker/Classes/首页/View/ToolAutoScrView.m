//
//  ToolAutoScrView.m
//  MoShouBroker
//
//  Created by yuanqi on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//  tag:14000

#import "ToolAutoScrView.h"
#import "MyImageView.h"
#import "MyScrollView.h"
#import "AdShowViewController.h"
#import "AdModel.h"
#import "NSString+Base64.h"
#import "UserData.h"

#import "DataFactory+User.h"

#import "XTPageControl.h"

@interface ToolAutoScrView ()<UIScrollViewDelegate>
{
    MyScrollView *_scrView;//滚动视图
    UIPageControl *_pageView;//页码器
    UIImageView* _normalImageView;//默认图片
    NSTimer *_timer;//定时器
    NSArray *_adsArr;
    UIViewController *_viewController;
    BOOL isAutoScroll;// 标记滚动的状态
    CGFloat offset;
    XTPageControl* _pageControl;
    
}
@end

@implementation ToolAutoScrView

//搭建基本view
-(UIView*)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    isAutoScroll = YES;
    _scrView = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrView.delegate = self;
    _scrView.pagingEnabled = YES;
    _scrView.scrollsToTop = NO;
    _scrView.bounces = NO;
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrView];
    
    _normalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [_normalImageView setImage:[UIImage imageNamed:@"home-refresh-normal"]];
    [self addSubview:_normalImageView];
    
    _pageControl = [[XTPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 100)/2.0, self.height - 10, 100, 2.5)];
    _pageControl.dotWidth = 13.5;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidden = YES;
    //页码器
//    _pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)-20, 0, 20)];
//    _pageView.currentPage = 0;
//    _pageView.numberOfPages = 0;
//    _pageView.hidesForSinglePage = YES;
//    _pageView.userInteractionEnabled = NO;
//    _pageView.pageIndicatorTintColor = [UIColor whiteColor];
//    _pageView.currentPageIndicatorTintColor = [UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f];
    [self addSubview:_pageControl];
    return self;
}

- (void)layoutSubviews{
    
}

//刷新数据
-(void)refreshAdsWithAdsArray:(NSMutableArray*)adsArr andVC:(UIViewController*)viewController{
    
    
    [_pageControl setNumberOfPages:adsArr.count];
    _pageControl.currentPage = 0;
    _pageControl.hidden = !(adsArr.count > 1);
    _normalImageView.hidden = false;
    //判断是否有数据
    if (adsArr == nil) {
        return;
    }
    if (adsArr.count <= 0) {
        return;
    }
    _normalImageView.hidden = true;
    
    //导数据，设置新的容量和偏移量
    _viewController = viewController;
    _adsArr = adsArr;
    [_scrView setContentSize:CGSizeMake(CGRectGetWidth(_scrView.frame) * ((_adsArr.count == 1) ? 1 : _adsArr.count + 2), CGRectGetHeight(_scrView.frame))];
    _scrView.contentOffset = CGPointMake((_adsArr.count == 1)? 0 : _scrView.frame.size.width, 0);
    //清除以前的广告图
    for (UIView *tempView in _scrView.subviews) {
        [tempView removeFromSuperview];
    }
    //放上广告图
    for (int i = 0; i < _adsArr.count+2; i++) {
        //图
        MyImageView *imgView = [[MyImageView alloc]initWithFrame:CGRectMake(_scrView.frame.size.width*i, 0, _scrView.frame.size.width, _scrView.frame.size.height)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;

        [_scrView addSubview:imgView];
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAdsWithUrl:)];
        tap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:tap];
        if (i == 0) {
            AdModel *ad = [_adsArr objectForIndex:adsArr.count - 1];
            [imgView sd_setImageWithURL:[NSURL URLWithString:adImgUrl(ad.imgUrl)] placeholderImage:[UIImage imageNamed:@"home-refresh-normal"]];
            if (_adsArr.count == 1) {
                imgView.tag = 14000;
            }
        }else if(i == adsArr.count+1){
            AdModel *ad = [_adsArr objectForIndex:0];
            [imgView sd_setImageWithURL:[NSURL URLWithString:adImgUrl(ad.imgUrl)] placeholderImage:[UIImage imageNamed:@"home-refresh-normal"]];
            
        }else{
            AdModel *ad = [_adsArr objectForIndex:i - 1];
            [imgView sd_setImageWithURL:[NSURL URLWithString:adImgUrl(ad.imgUrl)] placeholderImage:[UIImage imageNamed:@"home-refresh-normal"]];
            imgView.tag = 14000 + i - 1;
        }
    }
    
    _pageControl.numberOfPages = _adsArr.count;
    
    [self bringSubviewToFront:_pageControl];
    isAutoScroll = NO;
    [self beginScroll];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrView.contentOffset.x < 1) {
        _scrView.contentOffset  = CGPointMake(_scrView.frame.size.width*_adsArr.count, 0);
    }else if (_scrView.contentOffset.x > (_adsArr.count + 1)*_scrView.bounds.size.width - 1) {
        _scrView.contentOffset =  CGPointMake(_scrView.bounds.size.width, 0);
    }
    int tempNum = _scrView.contentOffset.x/_scrView.bounds.size.width - 1;
    if (tempNum != _pageControl.currentPage) {
        _pageControl.currentPage = tempNum;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    [self beginScroll];
}

-(void)beginScroll{
    if (!isAutoScroll && _adsArr.count > 1) {
        isAutoScroll = YES;
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoSwitchPages) userInfo:nil repeats:YES];
    }
}
-(void)autoSwitchPages{
    //NSLog(@"我是超人！！！！！！！！");
    if (isAutoScroll && _adsArr.count > 1) {
        offset = (_pageControl.currentPage+2)*_scrView.bounds.size.width;
        if (offset > (_adsArr.count + 1)*_scrView.bounds.size.width - 1) {
            [_scrView setContentOffset:CGPointMake(offset, 0) animated:YES];
            dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.7*NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                _scrView.contentOffset = CGPointMake(offset, 0);
            });
        }else{
//            [UIView animateWithDuration:0.3 animations:^{
                [_scrView setContentOffset:CGPointMake(offset, 0) animated:YES];
//            } completion:^(BOOL finished){
//                if (finished) {
//                    _scrView.contentOffset = CGPointMake(offset, 0);
//                }
//            }];
        }
    }
}
-(void)stopScroll{
    if (isAutoScroll == YES) {
        isAutoScroll = NO;
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}
#pragma mark - 点击触发事件
-(void)getIntoAdsWithUrl:(UITapGestureRecognizer*)tap
{
    if (tap.view.tag-14000 < _adsArr.count&&tap.view.tag-14000 >= 0) {
        
//        Ad *ad =  _adsArr[tap.view.tag-14000];
//        if (![self isBlankString:ad.adUrl]) {
//            AdShowViewController *adWebView = [[AdShowViewController alloc]init];
//            adWebView.adUrl = ad.adUrl;
//            adWebView.name = ad.name;
//            [_viewController.navigationController pushViewController:adWebView animated:YES];
//        }
        
        
        AdModel *ad =  _adsArr[tap.view.tag-14000];
        if (![self isBlankString:ad.redirectUrl]) {
            [MobClick event:@"sy_lbtu"];
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LBT" andPageId:@"PAGE_SY"];
            AdShowViewController *adWebView = [[AdShowViewController alloc]init];
            adWebView.adUrl = [self extensionUrlWithUrlStr:ad.redirectUrl];
//            adWebView.adUrl = @"http://10.1.66.68/jsdemo.html";
            adWebView.name = ad.descript;
            [_viewController.navigationController pushViewController:adWebView animated:YES];
            
        }
    }
}

- (NSString*)extensionUrlWithUrlStr:(NSString*)urlStr{
    NSString* userID = [NSString encodeBase64String:[UserData sharedUserData].userInfo.userId];
    NSString* cityID = [NSString encodeBase64String:[UserData sharedUserData].cityId];
    NSString* phone  = [NSString encodeBase64String:[UserData sharedUserData].userInfo.mobile];
    if ([urlStr rangeOfString:@"?"].length > 0) {
        urlStr = [urlStr stringByAppendingString:@"&"];
    }else{
        urlStr = [urlStr stringByAppendingString:@"?"];
    }
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"userid=%@",userID]];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&phone=%@",phone]];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&city_id=%@",cityID]];
    return urlStr;
}


- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
