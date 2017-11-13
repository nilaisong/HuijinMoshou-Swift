//
//  HotRecommendedView.m
//  MoShou2
//
//  Created by strongcoder on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//
#import "MyScrollView.h"
#import "HotRecommendedView.h"
#import "MyImageView.h"
#import "Ad.h"
#import "BannerInfo.h"
#import "BuildingDetailViewController.h"
#import "AutoLabel.h"
@interface HotRecommendedView ()<UIScrollViewDelegate>
{
    
    MyScrollView *_scrView;//滚动视图
    UIPageControl *_pageView;//页码器
    NSTimer *_timer;//定时器
    NSArray *_adsArr;               //_buildingArr;
    UIViewController *_viewController;
    BOOL isAutoScroll;// 标记滚动的状态
    CGFloat offset;
    
    UILabel *_totalAllBuildingNumberLabel;

    
}
@end

// view 的高度 45+ kmainscrmWIth*0.75
@implementation HotRecommendedView

-(id)initWithFrame:(CGRect)frame
{
    
  self = [super initWithFrame:frame];
    if (self)
    {
        
        [self loadUI];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
    
}

-(void)loadUI
{
    UIButton *hotBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 0, 12, 45)];
    [hotBtn setImage:[UIImage imageNamed:@"iconfont-remen.png"] forState:UIControlStateNormal];
    [self addSubview:hotBtn];
    
    UILabel *hotlabel = [[UILabel alloc]initWithFrame:CGRectMake(hotBtn.right, 0, 100, 45)];
    hotlabel.text = @" 热门推荐";
    hotlabel.font = FONT(18.f);
    hotlabel.textColor =NAVIGATIONTITLE;
    [self addSubview:hotlabel];
    
    

    _pageView = [[UIPageControl alloc]initWithFrame:CGRectMake((kMainScreenWidth/3)*2, 15, kMainScreenWidth/3, 20)];
    _pageView.currentPage = 0;
    _pageView.numberOfPages = 5;
    _pageView.hidesForSinglePage = YES;
    _pageView.userInteractionEnabled = NO;
    _pageView.pageIndicatorTintColor = LINECOLOR;
    _pageView.currentPageIndicatorTintColor = BLUEBTBCOLOR;
    [self addSubview:_pageView];

    
    _scrView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, 45, kMainScreenWidth, kMainScreenWidth*0.75)];
    _scrView.delegate =self;
    _scrView.pagingEnabled = YES;
    _scrView.scrollsToTop = NO;
    _scrView.bounces = NO;
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_scrView];
    
    _totalAllBuildingNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _scrView.bottom, kMainScreenWidth-40, 56/2)];
    _totalAllBuildingNumberLabel.textAlignment = NSTextAlignmentLeft;
    _totalAllBuildingNumberLabel.font = FONT(15.f);
    _totalAllBuildingNumberLabel.textColor = LABELCOLOR;
    if (_buildingNumer==0 || _buildingNumer == NULL || _buildingNumer == nil) {
        _buildingNumer = 0;
    }
    _totalAllBuildingNumberLabel.text = [NSString stringWithFormat:@"共有%@个楼盘",_buildingNumer];
    [self addSubview:_totalAllBuildingNumberLabel];
    
}

//刷新数据
-(void)refreshAdsWithAdsArray:(NSMutableArray*)adsArr andVC:(UIViewController*)viewController{
   
    _totalAllBuildingNumberLabel.text = [NSString stringWithFormat:@"共有%@个楼盘",_buildingNumer];

    //判断是否有数据
    if (adsArr == nil) {
        return;
    }
    if (adsArr.count <= 0) {
        return;
    }
    //导数据，设置新的容量和偏移量
    _viewController = viewController;
    _adsArr = adsArr;
    [_scrView setContentSize:CGSizeMake(CGRectGetWidth(_scrView.frame) * ((_adsArr.count == 1) ? 1 : _adsArr.count + 2), CGRectGetHeight(_scrView.frame))];
    _scrView.contentOffset = CGPointMake((_adsArr.count == 1)? 0 : _scrView.frame.size.width, 0);
    //清除以前的广告图
    for (UIView *tempView in _scrView.subviews) {
        [tempView removeFromSuperview];
    }
    //放上楼盘广告图
    for (int i = 0; i < _adsArr.count+2; i++) {
        //图
        
        MyImageView *imgView = [[MyImageView alloc]initWithFrame:CGRectMake(_scrView.frame.size.width*i, 0, _scrView.frame.size.width, _scrView.frame.size.height)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.userInteractionEnabled = YES;
        [_scrView addSubview:imgView];
        
        
        UIImageView *downBlackBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imgView.height-55, kMainScreenWidth, 55)];
        downBlackBgImageView.image = [UIImage imageNamed:@"矩形-12.png"];
        [imgView addSubview:downBlackBgImageView];
        

        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth/2, imgView.height-31, kMainScreenWidth/2-10, 20)];
        priceLabel.textColor = BLUEBTBCOLOR;
        priceLabel.text = @"4万元起";
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = FONT(18.f);
        [imgView addSubview:priceLabel];
        
        
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAdsWithUrl:)];
        tap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:tap];
        if (i == 0) {
            BannerInfo *ad = [_adsArr objectForIndex:adsArr.count - 1];
            [imgView setImageWithUrlString:ad.imgUrl placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            
            UILabel *buildNamelabel =[[UILabel alloc]init];
            buildNamelabel.text = ad.estateName;
            buildNamelabel.textColor = [UIColor whiteColor];
            buildNamelabel.font = [UIFont boldSystemFontOfSize:16.f];
            CGSize size = [buildNamelabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 25)];
            buildNamelabel.frame = CGRectMake(16, imgView.bottom-30, size.width, size.height);
            [imgView addSubview:buildNamelabel];
            
            if (![self isBlankString:ad.price]) {
                
                if ([ad.price isEqualToString:@"0"]) {
                    priceLabel.text= @"售价待定";
                }else{
                    priceLabel.text =[NSString stringWithFormat:@"%@元/平米", ad.price];
                }
            }else{
                priceLabel.text= @"售价待定";

            }
           

            if (![self isBlankString:ad.featureTag]) {
                if ([ad.featureTag rangeOfString:@","].location!=NSNotFound)
                {  //有分号,
                    NSArray *array = [ad.featureTag componentsSeparatedByString:@","];

                    AutoLabel *label = [[AutoLabel alloc]initWithFrame:CGRectMake(buildNamelabel.right+5, buildNamelabel.top+1, 50, 15) withContent:array[0] AndcornersColor:BLUEBTBCOLOR];
                    [imgView addSubview:label];
                
                }else{
                    AutoLabel *label = [[AutoLabel alloc]initWithFrame:CGRectMake(buildNamelabel.right+5, buildNamelabel.top+1, 50, 15) withContent:ad.featureTag AndcornersColor:BLUEBTBCOLOR];
                    [imgView addSubview:label];
                }
            }
            
        }else if(i == adsArr.count+1){
            BannerInfo *ad = [_adsArr objectForIndex:0];
            [imgView setImageWithUrlString:ad.imgUrl placeholderImage:[UIImage imageNamed:@"默认图片.png"]];

            UILabel *buildNamelabel =[[UILabel alloc]init];
            buildNamelabel.text = ad.estateName;
            buildNamelabel.textColor = [UIColor whiteColor];
            buildNamelabel.font = [UIFont boldSystemFontOfSize:16.f];
            CGSize size = [buildNamelabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 25)];
            buildNamelabel.frame = CGRectMake(16, imgView.bottom-30, size.width, size.height);
            [imgView addSubview:buildNamelabel];
            
            if (![self isBlankString:ad.price]) {
                
                if ([ad.price isEqualToString:@"0"]) {
                    priceLabel.text= @"售价待定";
                }else{
                    priceLabel.text =[NSString stringWithFormat:@"%@元/平米", ad.price];
                }
            }else{
                priceLabel.text= @"售价待定";
                
            }
            
            if (![self isBlankString:ad.featureTag]) {
                if ([ad.featureTag rangeOfString:@","].location!=NSNotFound)
                {  //有分号,
                    NSArray *array = [ad.featureTag componentsSeparatedByString:@","];
                    
                    AutoLabel *label = [[AutoLabel alloc]initWithFrame:CGRectMake(buildNamelabel.right+5, buildNamelabel.top+1, 50, 15) withContent:array[0] AndcornersColor:BLUEBTBCOLOR];
                    [imgView addSubview:label];
                    
                }else{
                    AutoLabel *label = [[AutoLabel alloc]initWithFrame:CGRectMake(buildNamelabel.right+5, buildNamelabel.top+1, 50, 15) withContent:ad.featureTag AndcornersColor:BLUEBTBCOLOR];
                    [imgView addSubview:label];
                }
            }

        }else{
            BannerInfo *ad = [_adsArr objectForIndex:i - 1];
            [imgView setImageWithUrlString:ad.imgUrl placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            imgView.tag = 14000 + i - 1;

            UILabel *buildNamelabel =[[UILabel alloc]init];
            buildNamelabel.text = ad.estateName;
            buildNamelabel.textColor = [UIColor whiteColor];
            buildNamelabel.font = [UIFont boldSystemFontOfSize:16.f];
            CGSize size = [buildNamelabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 25)];
            buildNamelabel.frame = CGRectMake(16, imgView.bottom-30, size.width, size.height);
            [imgView addSubview:buildNamelabel];
            
            if (![self isBlankString:ad.price]) {
                
                if ([ad.price isEqualToString:@"0"]) {
                    priceLabel.text= @"售价待定";
                }else{
                    priceLabel.text =[NSString stringWithFormat:@"%@元/平米", ad.price];
                }
            }else{
                priceLabel.text= @"售价待定";
                
            }
            
            if (![self isBlankString:ad.featureTag]) {
                if ([ad.featureTag rangeOfString:@","].location!=NSNotFound)
                {  //有分号,
                    NSArray *array = [ad.featureTag componentsSeparatedByString:@","];
                    
                    AutoLabel *label = [[AutoLabel alloc]initWithFrame:CGRectMake(buildNamelabel.right+5, buildNamelabel.top+1, 50, 15) withContent:array[0] AndcornersColor:BLUEBTBCOLOR];
                    [imgView addSubview:label];
                    
                }else{
                    AutoLabel *label = [[AutoLabel alloc]initWithFrame:CGRectMake(buildNamelabel.right+5, buildNamelabel.top+1, 50, 15) withContent:ad.featureTag AndcornersColor:BLUEBTBCOLOR];
                    [imgView addSubview:label];
                }
            }
        }
    }
    _pageView.numberOfPages = _adsArr.count;
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
    if (tempNum != _pageView.currentPage) {
        _pageView.currentPage = tempNum;
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
        offset = (_pageView.currentPage+2)*_scrView.bounds.size.width;
        if (offset > (_adsArr.count + 1)*_scrView.bounds.size.width - 1) {
            [_scrView setContentOffset:CGPointMake(offset, 0) animated:YES];
            dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.7*NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                _scrView.contentOffset = CGPointMake(offset, 0);
            });
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [_scrView setContentOffset:CGPointMake(offset, 0) animated:NO];
            } completion:^(BOOL finished){
                if (finished) {
                    _scrView.contentOffset = CGPointMake(offset, 0);
                }
            }];
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
    [MobClick event:@"lp_rxlbtu"];
    
    if (tap.view.tag-14000 < _adsArr.count&&tap.view.tag-14000 >= 0) {
        BannerInfo *ad =  _adsArr[tap.view.tag-14000];
        if (![self isBlankString:ad.estateId]) {
            //按照常理这里应该跳转楼盘详情

            BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
            VC.buildingId = ad.estateId;
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            [nav pushViewController:VC animated:YES];

            
            //按照常理这里应该跳转楼盘详情
//            AdShowViewController *adWebView = [[AdShowViewController alloc]init];
//            adWebView.adUrl = ad.adUrl;
//            adWebView.name = ad.name;
//            [_viewController.navigationController pushViewController:adWebView animated:YES];
        }
    }else if (_adsArr.count == 1){
        
        BannerInfo *ad =  _adsArr[0];
        if (![self isBlankString:ad.estateId]) {
            //按照常理这里应该跳转楼盘详情
            
            BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
            VC.buildingId = ad.estateId;
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            [nav pushViewController:VC animated:YES];
        }
    }
}
- (BOOL)isBlankString:(NSString*)string
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




@end
