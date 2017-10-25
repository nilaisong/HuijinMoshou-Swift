//
//  SplashImageView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "SplashImageView.h"
#import "CountDownView.h"
#import "UserData.h"

@interface SplashImageView()


@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,weak)UIImageView* imageView;

@property (nonatomic,weak)CountDownView* countDownView;

@end


@implementation SplashImageView


- (instancetype)initWithFrame:(CGRect)frame callBack:(SplashImageViewShowEndBlock)callBack{
    if (self = [super initWithFrame:frame]) {
        _callBack = callBack;
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    self.backgroundColor = [UIColor clearColor];
    
}


- (void)didMoveToSuperview
{
    [self imageView];
    [self timer];
    [self countDownView];
}

static int secondsCountDown = 6.0;
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
    }
    return _timer;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray* fileNames = [fileManager contentsOfDirectoryAtPath:SplashImageFolder error:nil];
        NSString* imageName = SplashImageFolder;
        if (fileNames.count > 0) {
            imageName = [NSString stringWithFormat:@"%@/%@",SplashImageFolder,[fileNames firstObject]];
        }
//        NSLog(@"%@",imageName);
        UIImage* image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView* imageView = nil;
        if (image) {
            imageView = [[UIImageView alloc]initWithImage:image];
        }else [self stopShow];
        
//        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
//        [UIImage imageWithContentsOfFile:imageName];
        imageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        
        [self addSubview:imageView];
        
        _imageView = imageView;
    }
    return _imageView;
}

- (CountDownView *)countDownView{
    if (!_countDownView) {
        __weak typeof(self) weakSelf = self;
        CountDownView* countDownView = [[CountDownView alloc]initWithCallBack:^(CountDownView *countdown, UIButton *button) {
            [weakSelf stopShow];
        }];
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        countDownView.frame = CGRectMake(kMainScreenWidth - 88.5, 11.5 + statusHeight, 85, 22);
        [self addSubview:countDownView];
        
        _countDownView = countDownView;
    }
    return _countDownView;
}

- (void)timeFireMethod{
    secondsCountDown--;
    _countDownView.number = secondsCountDown;
//    self.timeLabel.text = [NSString stringWithFormat:@"%d",secondsCountDown];
    
    if (secondsCountDown == 1) {
        [self stopShow];
    }
}

- (void)stopShow{
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:nil];
    if (!_imageView) {
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (_callBack) {
            _callBack(self);
        }
        [self removeFromSuperview];
        
    }];
}



@end
