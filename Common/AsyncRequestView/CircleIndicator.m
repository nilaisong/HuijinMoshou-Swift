//
//  CircleIndicator.m
//  AuctionCatalog
//
//  Created by Laisong Ni on 12-4-2.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "CircleIndicator.h"

@implementation CircleIndicator
@synthesize  arcAngle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //UKit坐标系
    //为什么用quartz 2d在UIView中画出来的坐标起点是在左上角?
    //因为这个context是由 UIGraphicsGetCurrentContext()得到的，
    //这个context已经把坐标系换过来了，和UIKit坐标系一致（绘制几何图形的时候采用）
    //但绘制图片的时候一定要转换回quartz 2d的原坐标系,因为是从图片的左下角和坐标原点对应开始画的。
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect bounds = CGRectMake(3.0, 3.0, self.bounds.size.width-6.0, self.bounds.size.height-6.0);
    CGContextClearRect(context, self.bounds);
    // 坐标轴变换A->B
    // 平移坐标轴
    //CGContextTranslateCTM(context, 0, bounds.size.height); // B
    //翻转Y坐标轴
    //CGContextScaleCTM(context, 1, -1);                     //A
    //CGContextRotateCTM
    
    //绘制圆形
    //CGContextSetRGBFillColor(context,255.0/255,204.0/255,102.0/255, 1.0);
//    CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
//    CGContextFillEllipseInRect(context,bounds);
    
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context,1.5);
    CGContextStrokeEllipseInRect(context,bounds);
    
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,self.bounds.size.width/2,self.bounds.size.height/2);
    //CGContextAddEllipseInRect(context,CGRectMake(100, 100, 200, 200));
    //CGContextAddArc(context, 100, 100, 100, 0, 3.14, 1);
    
    CGContextAddArc(context,self.bounds.size.width/2,self.bounds.size.height/2, bounds.size.width/2, 0,self.arcAngle, 0);
    //NSLog(@"self.circleIndicator.arcAngle:%f",self.arcAngle);
    //CGContextStrokePath(context);
    CGContextFillPath(context);
    //CGContextClosePath(context);
    
    CGContextRestoreGState(context);
}

@end
