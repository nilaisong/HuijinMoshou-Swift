//
//  RotationMessageImageView.m
//  MoShou2
//
//  Created by wangzz on 2016/10/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "RotationMessageImageView.h"
#import "MJRefreshConst.h"

@implementation RotationMessageImageView

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.image = [UIImage imageNamed:MJRefreshSrcName(@"update")];
    }
    return self;
}


- (void)startAnimating
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = .8;
    rotationAnimation.repeatCount = 10000000;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"RotationMessage"];
}

- (void)stopAnimating
{
    [self.layer removeAnimationForKey:@"RotationMessage"];
}

- (BOOL)isAnimating
{
    CAAnimation * animation =  [self.layer animationForKey:@"RotationMessage"];
    if (animation) {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
