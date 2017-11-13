//
//  RotationImageView.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/8/25.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "RotationImageView.h"
#import "MJRefreshConst.h"

@implementation RotationImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.image = [UIImage imageNamed:MJRefreshSrcName(@"arrow")];
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
    [self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

- (void)stopAnimating
{
    [self.layer removeAnimationForKey:@"Rotation"];
}

- (BOOL)isAnimating
{
    CAAnimation * animation =  [self.layer animationForKey:@"Rotation"];
    if (animation) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
