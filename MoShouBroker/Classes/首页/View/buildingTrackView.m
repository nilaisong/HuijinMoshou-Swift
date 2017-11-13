//
//  buildingTrackView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "buildingTrackView.h"

@interface buildingTrackView()

@property(nonatomic,weak)UILabel* infoLabel;

@property (nonatomic,weak)UIButton* addTrackBtn;

@property (nonatomic,weak)UIView* lineView;
@end

@implementation buildingTrackView

- (instancetype)initWithCallBack:(buildingActionResult)callBack{
    if (self = [super init]) {
        _callBack = callBack;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews{
    self.infoLabel.frame = CGRectMake(16, 0, 100, 42);
    self.addTrackBtn.frame = CGRectMake(kMainScreenWidth - 44, -2, 44, 44);
    self.lineView.frame = CGRectMake(16, self.frame.size.height, kMainScreenWidth - 16, 1);
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"跟进记录";
        [self addSubview:label];
        _infoLabel = label;
    }
    return _infoLabel;
}



- (UIButton *)addTrackBtn{
    if (!_addTrackBtn) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"iconfont-yijianfankui-4.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"iconfont-yijianfankui-4-down.png"] forState:UIControlStateHighlighted];
        _addTrackBtn = button;
        [button addTarget:self action:@selector(addTrackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return _addTrackBtn;
}

- (void)addTrackBtnClick:(UIButton*)btn{
    __weak typeof(self) weakSelf = self;
    if (_callBack) {
        _callBack(weakSelf,btn);
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f];
        _lineView = lineView;
        [self addSubview:lineView];
    }
    return _lineView;
}

@end
