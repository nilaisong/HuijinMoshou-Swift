//
//  XTRefreshStatusView.m
//  RefreshTest
//
//  Created by xiaotei's on 16/6/17.
//  Copyright © 2016年 xiaote. All rights reserved.
//

#import "XTRefreshStatusHeaderView.h"
//#import "UIImage+Antialiase.h"
#import <QuartzCore/CATransform3D.h>
#import "UITableView+XTRefresh.h"

@interface XTRefreshStatusView()
{
 CGFloat _angle;
}
@property (nonatomic,weak)UIImageView* imageView;

@property (nonatomic,strong)NSTimer* timer;

@end


@implementation XTRefreshStatusView


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    NSLog(@"-0-0-0-0-0%@",NSStringFromClass([self.superview class]));
    self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    if (self.superview) {
        _scrollView = (UIScrollView*)self.superview;
    }
    
}

- (void)endRefreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            if (_scrollView) {
                _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);    
            }
            
        } completion:^(BOOL finished) {
            self.status = RefreshViewStatusNone;
        }];
    });
}

-(void)beginRefreshing{
    if (self.status == RefreshViewStatusLoading) {
        return;
    }
    self.status = RefreshViewStatusDragging;
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(0, -STATUSVIEWHEIGHT-2);
        self.progress = 105;
    } completion:^(BOOL finished) {
        self.status = RefreshViewStatusEndDragging;
//        [self adjustFrameWithPoint:CGPointMake(0, - STATUSVIEWHEIGHT - 2)];
        _scrollView.contentOffset = CGPointMake(0, - STATUSVIEWHEIGHT - 2);
    }];

}

- (void)dealloc{
//    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [[change valueForKey:@"new"] CGPointValue];
        if (_scrollView) {
    
            [_scrollView adjustFrameWithPoint:point];
        }
    }
    
    
}

BOOL firstLayout = YES;
- (void)layoutSubviews{
    [super layoutSubviews];
    if (firstLayout) {
        self.imageView.frame = CGRectMake((self.frame.size.width - 14) / 2.0, (self.frame.size.height - 13) / 2.0, 14, 13);
    }
//    firstLayout = ;
}



- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xtrefresh"]];
        [self addSubview:imgView];
        _imageView = imgView;
    }
    return _imageView;
}
BOOL flag;
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
//    _imageView.transform=CGAffineTransformMakeRotation(M_PI*2.5);
//    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    CATransform3D rotatedTransform = self.imageView.layer.transform;
//    rotatedTransform = CATransform3DMakeRotation(M_PI * progress / 50, 0, 0, 1.0);//rotate为旋转弧度，绕Z轴转
//    self.imageView.layer.transform = rotatedTransform;

//    self.imageView.transform = CGAffineTransformMakeRotation((M_PI / 180.0f)* progress / 100 * 360.0);
    _angle = progress;
    [self setNeedsDisplay];
}
static CGFloat loadingAngle = 0;
- (void)beganAnimation{
    [_timer invalidate];
    _timer = nil;
    loadingAngle = 0;
    [self timer];
//    [self setNeedsDisplay];
    
}

- (void)endAnimation{
    loadingAngle = 0;
    [_timer invalidate];
}

- (void)drawRect:(CGRect)rect{
    
    switch (_status) {
        case RefreshViewStatusEndDragging:{
        }
        case RefreshViewStatusDragging:
        {
            UIColor *color = [UIColor colorWithRed:0.21f green:0.69f blue:0.99f alpha:1.00f];
            [color set];  //设置线条颜色
            
            UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)
                                                                 radius:15
                                                             startAngle:-M_PI_2
                                                               endAngle: -M_PI_2 + M_PI * _angle / 50.45
                                                              clockwise:YES];
            
            aPath.lineWidth = 1.0;
            aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
            aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
            
            [aPath stroke];
        }
            break;
        case RefreshViewStatusLoading:{
            UIColor *color = [UIColor colorWithRed:0.21f green:0.69f blue:0.99f alpha:1.00f];
            [color set];  //设置线条颜色
            
            UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)
                                                                 radius:15
                                                             startAngle:-M_PI_2 + M_PI * loadingAngle / 50
                                                               endAngle:M_PI * 1.3 + M_PI * loadingAngle / 50
                                                              clockwise:YES];
            
            aPath.lineWidth = 1.0;
            aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
            aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
            loadingAngle += 1;
            if (loadingAngle == 100) {
                loadingAngle = 0;
            }
            [aPath stroke];
        }

        default:
            break;
    }
    

    
}

- (void)setStatus:(RefreshViewStatus)status{
    _status = status;
    if (status == RefreshViewStatusLoading) {
        
    }else{
        
    }
}

- (NSTimer *)timer{
    if (!_timer) {
//        [self setNeedsDisplay];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateAction) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)rotateAction{
    [self setNeedsDisplay];
}



@end
