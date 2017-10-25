//
//  XTNavigationBarRightButton.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/25.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTNavigationBarRightButton.h"

@implementation XTNavigationBarRightButton

- (id)initWithNormalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage{
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    }
    return self;
}

+ (id)navRightButtonWithNormalImage:(NSString *)normalImage selecgtedImage:(NSString *)selectedImage{
    return [[self alloc]initWithNormalImage:normalImage selectedImage:selectedImage];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(6, 11, 22, 22);
}
@end
