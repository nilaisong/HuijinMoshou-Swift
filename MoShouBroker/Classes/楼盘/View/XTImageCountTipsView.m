//
//  XTImageCountTipsView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 17/1/9.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "XTImageCountTipsView.h"

@interface XTImageCountTipsView()

@property (nonatomic,weak)UILabel* titleLabel;


@end

@implementation XTImageCountTipsView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = [UIColor clearColor];
    switch (_type) {
        case CountTipsViewTypeBottomImage:{
            
        }
            
            break;
        case CountTipsViewTypeOnImage:{
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.55];
        }
        default:
            break;
    }
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        [self addSubview:label];
        switch (_type) {
            case CountTipsViewTypeOnImage:{
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
            }
                break;
            case CountTipsViewTypeBottomImage:{
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
            }
                break;
            default:
            {
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
            }
                break;
        }
        
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (_totalNumber <= 0) {
        self.titleLabel.text = @"";
        return;
    }
    if (_type == CountTipsViewTypeOnImage) {
        _titleString = @"";
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@%ld/%ld",_titleString,(long)_currentIndex+1,(long)_totalNumber];
}

- (void)setTotalNumber:(NSInteger)totalNumber{
    _totalNumber = totalNumber;
    if (_totalNumber <= 0) {
        self.titleLabel.text = @"";
        return;
    }
    if (_type == CountTipsViewTypeOnImage) {
        _titleString = @"";
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@%ld/%ld",_titleString,(long)_currentIndex+1,(long)_totalNumber];
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    if (_totalNumber <= 0) {
        self.titleLabel.text = @"";
        return;
    }
    if (_type == CountTipsViewTypeOnImage) {
        _titleString = @"";
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@%ld/%ld",_titleString,(long)_currentIndex+1,(long)_totalNumber];
}
@end
