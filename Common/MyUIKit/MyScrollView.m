//
//  LongScrollView.m
//  AuctionCategoryDemo
//  避免双击的时候触发单击事件
//  Created by Laison on 12-3-26.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView
//@synthesize scale;

-(void)singleTouch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchDown" object:self userInfo:nil];
}

-(void)doubleTouch
{
    
    if (self.zoomScale==1.0)
    {
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }
    else
    {
        [self setZoomScale:1.0 animated:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount==1) 
    {
        [self performSelector:@selector(singleTouch) withObject:nil afterDelay:0.3];
    }
    if (touch.tapCount==2) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTouch) object:nil];
        [self doubleTouch];
    }
}

@end
