//
//  MSTabBarItemButton.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MSTabBarItemButton.h"

@implementation MSTabBarItemButton

//高亮状态什么都不做
-(void)setHighlighted:(BOOL)highlighted{

}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 3.5 - self.titleLabel.frame.size.height, self.frame.size.width, self.titleLabel.frame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.imageView.frame = CGRectMake((self.frame.size.width - 25)/2, self.frame.size.height - self.titleLabel.frame.size.height - 25 - 6.5, 25, 25);
}

@end
