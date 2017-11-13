//
//  CustomerTextField.m
//  MoShou2
//
//  Created by wangzz on 15/12/10.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerTextField.h"

@implementation CustomerTextField

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
//    return CGRectInset(bounds, 0, 10);
    CGRect inset = CGRectMake(bounds.size.width/2-12, bounds.origin.y+3, 24, bounds.size.height-6);//更好理解些
    return inset;
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [TFPLEASEHOLDERCOLOR setFill];
    
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
