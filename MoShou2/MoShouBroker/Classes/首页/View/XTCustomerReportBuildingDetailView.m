//
//  XTCustomerReportBuildingDetailView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTCustomerReportBuildingDetailView.h"
#import "XTBuildingProgressView.h"
#import "XTReportMessageView.h"
#import "buildingTrackView.h"
#import "BuildingTrackInfoView.h"



@interface XTCustomerReportBuildingDetailView()

@property (nonatomic,weak)UIView* buildingView;
@property (nonatomic,weak)UILabel* buildingNameLabel;


/**
 *  记录
 */
@property (nonatomic,weak)XTReportMessageView* messageView;

/**
   跟进记录
 */
@property (nonatomic,weak)buildingTrackView* trackLabelView;

@property (nonatomic,weak)UIView* lineView;


@property (nonatomic,strong)NSArray* trackArray;
@end

@implementation XTCustomerReportBuildingDetailView

- (instancetype)initWithCallBack:(BuildingDetailViewActionResult)callBack{
    if (self = [super init]) {
        [self commonInit];
        _callBack = callBack;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.userInteractionEnabled = true;
    }
    return self;
}

- (void)commonInit{

}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.messageView.frame = CGRectMake(0, 0, kMainScreenWidth,_building.messageList.count * 31 + (_building.messageList.count>0?18:0));
    self.trackLabelView.frame = CGRectMake(0, CGRectGetMaxY(_messageView.frame), kMainScreenWidth, 42);
//    CGFloat startY = CGRectGetMaxY(_trackLabelView.frame);
    self.lineView.frame = CGRectMake(16, self.frame.size.height - 0.5, kMainScreenWidth, 0.5);
}

- (void)setBuilding:(ReportDetailBuilding *)building{
    _building = building;
    self.messageView.messageList = building.messageList;
}

//- (UIView *)buildingView{
//    if (!_buildingView) {
//        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 55)];
//        UIImageView* imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"building-icon"]];
//        [view addSubview:imageV];
//        imageV.frame = CGRectMake(16, 20, 13, 15);
//        UILabel* label = [[UILabel alloc]init];
//        label.frame = CGRectMake(34, 20, 200, 16);
//        _buildingNameLabel = label;
//        [view addSubview:label];
//        
//        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 55, kMainScreenWidth - 16, 1)];
//        lineView.backgroundColor = [UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f];
//        [self addSubview:lineView];
//        
//        [self addSubview:view];
//        _buildingView = view;
//    }
//    return _buildingView;
//}
//
//- (UILabel *)buildingNameLabel{
//    if (!_buildingNameLabel) {
//        [self buildingView];
//    }
//    return _buildingNameLabel;
//}

- (XTReportMessageView *)messageView{
    if (!_messageView) {
        XTReportMessageView* messageView = [[XTReportMessageView alloc]init];
        [self addSubview:messageView];
        _messageView = messageView;
    }
    return _messageView;
}


- (buildingTrackView *)trackLabelView{
    if (!_trackLabelView) {
        __weak typeof(self) weakSelf = self;
        buildingTrackView* trackView = [[buildingTrackView alloc]initWithCallBack:^(buildingTrackView *trackView, UIButton *actionBtn) {
            NSLog(@"添加跟进记录");
            if (weakSelf.callBack) {
                weakSelf.callBack(weakSelf,weakSelf.building);
            }
        }];
        [self addSubview:trackView];
        _trackLabelView = trackView;
    }
    return _trackLabelView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
        [self addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

//
//- (void)reloadTrackView{
//    _trackArray = nil;
//    _trackViewHeight = 0;
//    NSMutableArray* arrayM = [NSMutableArray array];
//    __weak typeof(self) weakSelf = self;
//    for (int i = 0; i < _detailModel.building.buildingTrackList.count; i++) {
//        BuildingTrackInfoView* trackView = [[BuildingTrackInfoView alloc]initWithEventCallBack:^(BuildingTrackInfoView *infoView, UIButton *actionBtn) {
//            if (weakSelf.callBack) {
//                weakSelf.callBack(weakSelf,_detailModel);
//            }
//        }];
//        trackView.buildingTrack = _detailModel.building.buildingTrackList[i];
//        _trackViewHeight+= trackView.trackHeight;
//        trackView.frame = CGRectMake(0, 0, kMainScreenWidth, _trackViewHeight);
//        [self addSubview:trackView];
//        [arrayM  addObject:trackView];
//    }
//    _trackArray = arrayM;
//    
////    [self setNeedsLayout];
//}

@end
