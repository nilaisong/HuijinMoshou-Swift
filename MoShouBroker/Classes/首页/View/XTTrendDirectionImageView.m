//
//  XTTrendDirectionImageView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTTrendDirectionImageView.h"

@interface XTTrendDirectionImageView()
//持平黑线
@property (nonatomic,weak)UIView* blackLine;

@end

@implementation XTTrendDirectionImageView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self commonInit];
}
//初始化，默认方向向上
- (void)commonInit{
    self.blackLine.hidden = YES;
    switch (_direction) {

        case XTTrendDirectionDown:
        {
            if (!_downImageName || _downImageName.length <= 0) {
                _downImageName = @"iconfont-direction-down";
            }
            [self setImage:[UIImage imageNamed:_downImageName]];
        }
            break;
        case XTTrendDirectionFair:{
            [self setImage:nil];
            _blackLine.hidden = NO;
        }
            break;
        case XTTrendDirectionUp:
        default:{
            if (!_upImageName || _upImageName.length <= 0) {
                _upImageName = @"iconfont-direction-up";
            }
            [self setImage:[UIImage imageNamed:_upImageName]];
        }
            break;
    }
}

-(void)layoutSubviews{
    self.blackLine.frame = CGRectMake(0, 3, self.frame.size.width, 3);
}

- (void)setDirection:(XTTrendDirection)direction{
    _direction = direction;
    [self commonInit];
}

- (void)setUpImageName:(NSString *)upImageName  {
    _upImageName = upImageName;
    [self commonInit];
}

- (void)setDownImageName:(NSString *)downImageName{
    _downImageName = downImageName;
    [self commonInit];
}

- (UIView *)blackLine{
    if (!_blackLine) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.70f green:0.70f blue:0.71f alpha:1.00f];
        [self addSubview:view];
        _blackLine = view;
    }
    return _blackLine;
}

@end
