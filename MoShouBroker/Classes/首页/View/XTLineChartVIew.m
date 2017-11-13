//
//  XTLineChartVIew.m
//  天气绘图
//
//  Created by xiaotei on 15/9/24.
//  Copyright (c) 2015年 xiaotei. All rights reserved.
//

#import "XTLineChartVIew.h"
#import "ChartPoint.h"
#import "NSString+Extension.h"


@interface XTLineChartVIew()

@property (nonatomic,assign)CGPoint point;
@property (nonatomic,assign)CGFloat contentScroll;
//温度底线
@property (nonatomic,assign)CGFloat baseLine;

//温度缩放比例
@property (nonatomic,assign)CGFloat sizeScaleProportion;

@property (nonatomic,weak)UIButton* currentNumberBtn;

@property (nonatomic,weak)UILabel* noResultLabel;

@property (nonatomic,assign)BOOL noResult;

@end

@implementation XTLineChartVIew


//0°线值懒加载
-(CGFloat)baseLine{
    if (_baseLine == 0) {
        _baseLine = self.frame.size.height * 0.3;
    }
    return _baseLine;
}
//温度数据与视图尺寸缩放比例
-(CGFloat)sizeScaleProportion{
    
        CGFloat maxF = 0;
        for (ChartPoint* point in _points) {
            if (maxF < point.maxTmp) {
                maxF = point.maxTmp;
            }
        }
        _sizeScaleProportion = (self.frame.size.height - 30)/maxF;
    return _sizeScaleProportion;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.backgroundColor = [UIColor whiteColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    _point = CGPointZero;
    /**
     *  为自身添加监听事件，监听contentOffset属性
     */

    _contentScroll = 0;
}


-(UIColor*)randonColor{
    
    /**
     *      颜色的表现形式RGB和RGBA
     *      RGB 24位
     *      RGB每个颜色通道有八位
     *      8的二进制是255
     *      R,G,B每个颜色取值0~255
     *      RGBA是32位
     */
    
    CGFloat r = arc4random_uniform(256)/255.0;
    CGFloat g = arc4random_uniform(256)/255.0;
    CGFloat b = arc4random_uniform(256)/255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    if (_points.count <= 0) {
        self.noResultLabel.frame = self.bounds;
        _noResultLabel.hidden = NO;
        return;
    }
    _noResultLabel.hidden = YES;
    // Drawing code
    CGFloat startW = 1;
    CGFloat startH = self.frame.size.height;
    
    int startX  = 0;
    int enxX = self.frame.size.width / ItemWidth;
    
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contexRef, 1.5);
    CGContextMoveToPoint(contexRef, 0, startH - BottomHeight);
    
    CGContextAddLineToPoint(contexRef,self.contentOffset.x + self.frame.size.width, startH - BottomHeight);
    
    CGContextSetStrokeColorWithColor(contexRef, [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f].CGColor);
    CGContextStrokePath(contexRef);
    

    
    if (self.points.count <= 0)return;
    for (int i = startX; i < enxX ; i++) {
//        当结束点大于最大点数量时 结束
        if (i >= _points.count)return;
        ChartPoint* chartPoint = _points[i];
//        绘制竖线
        CGContextRef contexRef = UIGraphicsGetCurrentContext();
        
        CGContextMoveToPoint(contexRef, ItemWidth * (i + 1), 0);
        CGContextSetLineWidth(contexRef, startW);
//        CGContextAddLineToPoint(contexRef, 0, 0);
        
        CGContextAddLineToPoint(contexRef,ItemWidth * (i + 1), startH - BottomHeight);

        CGContextSetStrokeColorWithColor(contexRef, [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f].CGColor);
        
        CGContextStrokePath(contexRef);
        
        
        
        if(i % 2 == 0){//绘制矩形
            CGMutablePathRef path = CGPathCreateMutable();
            //指定矩形
            CGRect rectangle = CGRectMake(ItemWidth * (i + 1), 0,ItemWidth,startH - BottomHeight);
            //将矩形添加到路径中
            CGPathAddRect(path,NULL,rectangle);
            //获取上下文
            CGContextRef currentContext =
            UIGraphicsGetCurrentContext();

            //将路径添加到上下文
            CGContextAddPath(currentContext, path);
     //设置矩形填充色

            [[UIColor colorWithRed:0.98f green:0.99f blue:1.00f alpha:1.00f] setFill];
            //绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
        }

        NSString* test = [NSString stringWithFormat:@"%@月",chartPoint.date];
        
        NSDictionary* attribute = @{@"NSFontAttributeName" :[UIFont systemFontOfSize:12],@"NSForegroundColorAttributeName" :[UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f]};
        CGSize size = [test sizeWithAttributes:attribute];
        [test drawInRect:CGRectMake(ItemWidth * (i + 1) - size.width / 2.0, startH - BottomHeight + 4, size.width , size.height) withAttributes:attribute];
        
        

        if (_noResult){
            self.noResultLabel.hidden = NO;
            continue;
        }
        //        绘制圆点
        contexRef = UIGraphicsGetCurrentContext();
        if (i == _points.count - 1) {
            
            CGContextDrawImage(contexRef, (CGRect){{chartPoint.centerMax.x - CircleRadius / 2.0,chartPoint.centerMax.y - CircleRadius / 2.0},{CircleRadius,CircleRadius}}, [UIImage imageNamed:@"earning-circle"].CGImage);
            NSString* number = [NSString stringWithFormat:@"%.0f",chartPoint.maxTmp];
            CGSize  textSize = [NSString sizeWithString:number font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            self.currentNumberBtn.frame = CGRectMake(chartPoint.centerMax.x - textSize.width / 2.0, chartPoint.centerMax.y - 28, textSize.width, 15);
            [_currentNumberBtn setTitle:[NSString stringWithFormat:@"%.0f",chartPoint.maxTmp] forState:UIControlStateNormal];
            [_currentNumberBtn setTitle:[NSString stringWithFormat:@"%.0f",chartPoint.maxTmp] forState:UIControlStateHighlighted];
            
        }else{
           
            NSString* number = [NSString stringWithFormat:@"%.0f",chartPoint.maxTmp];
            CGSize  textSize = [NSString sizeWithString:number font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            NSDictionary* attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor colorWithRed:0.99f green:0.42f blue:0.20f alpha:1.00f]};
            
            CGRect maxTmpRect = CGRectMake(chartPoint.centerMax.x - textSize.width / 2.0 , chartPoint.centerMax.y - 28, textSize.width, 15);
            [[NSString stringWithFormat:@"%.0f",chartPoint.maxTmp] drawInRect:maxTmpRect withAttributes:attribute];
        }
        CGContextStrokePath(contexRef);
//        连线 --- MaxTmp
        contexRef = UIGraphicsGetCurrentContext();
//        CGContextMoveToPoint(contexRef, chartPoint.centerMax.x, chartPoint.centerMax.x);
        if (i == _points.count - 1) {
            ChartPoint* previousPoint = _points[i - 1];
            CGFloat x1 = previousPoint.centerMax.x;
            CGFloat y1 = previousPoint.centerMax.y;
            CGFloat x2 = chartPoint.centerMax.x;
            CGFloat y2 = chartPoint.centerMax.y;
            
            CGFloat length = 2 / fabs(sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) * ItemWidth;
            if (chartPoint.maxTmp > 0) {
                length *= 2;
            }
            if (chartPoint.maxTmp == 0) {
            CGContextMoveToPoint(contexRef, chartPoint.centerMax.x - length, chartPoint.centerMax.y);    
            }else
            CGContextMoveToPoint(contexRef, chartPoint.centerMax.x - length, chartPoint.centerMax.y + length);
        }else
        CGContextMoveToPoint(contexRef, chartPoint.centerMax.x, chartPoint.centerMax.y);
        CGContextSetLineWidth(contexRef, 1.5);
        //        CGContextAddLineToPoint(contexRef, 0, 0);
        if (i != startX) {
            ChartPoint* previousPoint = _points[i - 1];
            CGContextAddLineToPoint(contexRef,previousPoint.centerMax.x,previousPoint.centerMax.y);
        }else CGContextAddLineToPoint(contexRef,0,startH - BottomHeight - 2);
        
        CGContextSetStrokeColorWithColor(contexRef, [UIColor colorWithRed:0.99f green:0.36f blue:0.00f alpha:1.00f].CGColor);
        
        
        
        
        CGContextStrokePath(contexRef);
    }
    
    
    
    contexRef = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(contexRef, 0, 0);
    CGContextSetLineWidth(contexRef, 2);
    //        CGContextAddLineToPoint(contexRef, 0, 0);
    
    CGContextAddLineToPoint(contexRef,self.frame.size.width, 0);
    
    CGContextSetStrokeColorWithColor(contexRef, [UIColor whiteColor].CGColor);
    
    CGContextStrokePath(contexRef);
#pragma mark 判断是否当日

//    NSLog(@"width%f",self.frame.size.width);
}

//创建了监听才会触发这个事件
-(void)willChangeValueForKey:(NSString *)key{
    if ([key isEqualToString:@"contentOffset"]) {
        [self setNeedsDisplay];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

#pragma mark - setter
-(void)setPoints:(NSMutableArray *)points{
    _points = points;
    
    CGFloat he = 0.0f;
    for (int i = 0; i < points.count; i++) {
        ChartPoint * chartPoint = points[i];
        
        CGFloat circleY = self.frame.size.height - self.sizeScaleProportion * chartPoint.maxTmp - BottomHeight - 2;
        CGFloat circleX = (i + 1)* ItemWidth ;
        he += chartPoint.maxTmp;
        
        if (circleY < 27) {
            circleY  += 27;
        }
        
        chartPoint.centerMax = CGPointMake(circleX, circleY);

//        circleY = self.frame.size.height - self.sizeScaleProportion *[chartPoint.minTmp floatValue] - self.baseLine;
//        circleX = i * ItemWidth + ItemWidth/2;
//        chartPoint.centerMin = CGPointMake(circleX, circleY);
    }
    _noResult = he <= 0;
//在传递数据的时候进行属性设置，关闭弹性，设置滚动范围
    self.bounces = NO;
    self.contentSize = CGSizeMake(_points.count * ItemWidth,0);
    
    [self setNeedsDisplay];
//
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}

-(void)dealloc{
//    移除监听事件
//    __weak typeof(self)  weakSelf = self;
//    [self removeObserver:weakSelf forKeyPath:@"contentOffset" context:nil];

}

-(void)addChartPoint:(ChartPoint *)chartPoint{
    [self.points appendObject:chartPoint];
}

- (UIButton *)currentNumberBtn{
    if (!_currentNumberBtn) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0.99f green:0.42f blue:0.20f alpha:1.00f]];
        button.layer.cornerRadius = 4;
        _currentNumberBtn = button;
    }
    return _currentNumberBtn;
}

- (UILabel *)noResultLabel{
    if (!_noResultLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment  = NSTextAlignmentCenter;
        label.frame = self.bounds;
        label.text = @"暂无数据";
        [self addSubview:label];
        _noResultLabel = label;
        label.hidden = YES;
    }
    return _noResultLabel;
}
@end
