//
//  MyButton.m
//  MoShou2
//
//  Created by strongcoder on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    self.titleLabel.textAlignment = NSTextAlignmentCenter;


}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.width-23, (self.height-8)/2, 15, 8);//图片的位置大小
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.width-18, self.height);//文本的位置大小
}

@end
