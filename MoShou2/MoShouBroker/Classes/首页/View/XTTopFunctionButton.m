//
//  XTTopFunctionButton.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTTopFunctionButton.h"

@interface XTTopFunctionButton()
{
    NSString* _title;
    NSString* _normalImage;
    NSString* _selectedImage;
}


@end

@implementation XTTopFunctionButton

-(instancetype)initWithTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage{
    if (self = [super init]) {
        _title = title;
        _normalImage = normalImage;
        _selectedImage = selectedImage;
        self.titleLabel.font = TitleLabelFont;
        [self setTitleColor:TitleLableColor forState:UIControlStateNormal];
        [self setTitle:_title forState:UIControlStateNormal];
        
    }
    return self;
}

+ (instancetype)topFunctionButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage{
    return [[self alloc]initWithTitle:title normalImage:normalImage selectedImage:selectedImage];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self setImage:[UIImage imageNamed:_normalImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:_selectedImage] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:_selectedImage] forState:UIControlStateSelected];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 15 * SCALE6, 45 * SCALE6, 45  * SCALE6);
    self.imageView.center = CGPointMake(self.frame.size.width/2.0, self.imageView.center.y);
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10  * SCALE6, self.frame.size.width, self.titleLabel.frame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
