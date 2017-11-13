//
//  XTButton.m
//  QudaoTuozhan
//
//  Created by xiaotei's on 16/6/14.
//  Copyright © 2016年 NiLaisong. All rights reserved.
//

#import "XTButton.h"

@interface XTButton()
{
    CGRect _imageRect;
    
}

@end

@implementation XTButton

- (id)initWithNormalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage imageFrame:(CGRect)rect{
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        _imageRect = rect;
        _showHighlight = YES;
    }
    return self;
}

- (instancetype)initWithNormalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage imageFrame:(CGRect)rect{
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
        _imageRect = rect;
        _showHighlight = NO;
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted{
    if (_showHighlight) {
        [super setHighlighted:highlighted];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectIsNull(_imageRect)) {
        self.imageView.frame = _imageRect;
    }
}


@end
