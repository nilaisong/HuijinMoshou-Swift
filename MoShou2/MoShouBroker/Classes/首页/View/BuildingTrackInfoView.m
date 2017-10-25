//
//  BuildingTrackInfoView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BuildingTrackInfoView.h"
#import "NSString+Extension.h"
@interface BuildingTrackInfoView()

/*跟进详情*/
@property (nonatomic,weak)UILabel* trackInfoLabel;
/*跟进时间*/
@property (nonatomic,weak)UILabel* trackTimeLabel;
/*删除跟进*/
@property (nonatomic,weak)UIButton* deleteTrackButton;

@property (nonatomic,weak)UIView* lineView;

@end

@implementation BuildingTrackInfoView

- (instancetype)initWithEventCallBack:(BuildingTracnInfoResult)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadInfo];
}

- (void)layoutSubviews{
    CGSize trackSize = [NSString sizeWithString:_buildingTrack.content font:FONT(14) maxSize:CGSizeMake(kMainScreenWidth - 32, CGFLOAT_MAX)];
    _trackInfoLabel.frame = CGRectMake(16, 16, kMainScreenWidth - 32, trackSize.height);
    
    self.trackTimeLabel.frame = CGRectMake(16, CGRectGetMaxY(_trackInfoLabel.frame)+14,200, 14);
    
    self.deleteTrackButton.frame = CGRectMake(kMainScreenWidth - 16 - 30, _trackTimeLabel.frame.origin.y, 30, 36);
    _deleteTrackButton.center = CGPointMake(_deleteTrackButton.center.x, _trackTimeLabel.center.y);
    self.lineView.frame = CGRectMake(16, self.frame.size.height - 1, kMainScreenWidth - 16, 1);
}


- (UILabel *)trackInfoLabel{
    if (!_trackInfoLabel) {
        UILabel* label = [[UILabel alloc]init];
        [self addSubview:label];
        label.textColor = LABELCOLOR;
        label.numberOfLines = 0;
        label.font = FONT(14);
        _trackInfoLabel = label;
    }
    return _trackInfoLabel;
}

- (void)setBuildingTrack:(ReportBuildingTrack *)buildingTrack   {
    _buildingTrack = buildingTrack;
    [self reloadInfo];
}

- (void)reloadInfo{
    if (!_buildingTrack)return;
    self.trackInfoLabel.text = _buildingTrack.content;
    self.trackTimeLabel.text = _buildingTrack.datetime;
    [self setNeedsLayout];
}

- (UIButton *)deleteTrackButton{
    if (!_deleteTrackButton) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _deleteTrackButton = button;
    }
    return _deleteTrackButton;
}

- (UILabel *)trackTimeLabel{
    if (!_trackTimeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f];
        [self addSubview:label];
        _trackTimeLabel = label;
    }
    return _trackTimeLabel;
}


- (void)deleteBtnTouch:(UIButton*)btn{
    __weak typeof(self) weakSelf = self;
    if (_callBack) {
        _callBack(weakSelf,btn);
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}
@end
