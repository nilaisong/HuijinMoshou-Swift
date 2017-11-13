//
//  XTHelpView.m
//  MoShou2
//
//  Created by xiaotei's on 16/3/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTHelpView.h"

@interface XTHelpView()


//移除按钮
@property (nonatomic,weak)UIButton* clearButton;

@property (nonatomic,weak)UIImageView* imageView;

@end


@implementation XTHelpView

+ (instancetype)helpViewWithImageName:(NSString *)imageName buttonY:(CGFloat)buttonY{
    XTHelpView* helpView = [[XTHelpView alloc]init];
    helpView.imageName = imageName;
    helpView.buttonY = buttonY;
    return helpView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
}

- (void)didMoveToSuperview{
    [self imageView];
    [self clearButton];
}

- (UIButton *)clearButton{
    if (!_clearButton ) {
        UIButton* clearButton = [[UIButton alloc]init];
        clearButton.frame = CGRectMake(kMainScreenWidth * 1/3.0, _buttonY, kMainScreenWidth * 1/3.0, 50);
        [self addSubview:clearButton];
        [clearButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _clearButton = clearButton;
    }
    return _clearButton;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_imageName]];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}


- (void)clearAction:(UIButton*)button{
    [self removeFromSuperview];
}

@end
