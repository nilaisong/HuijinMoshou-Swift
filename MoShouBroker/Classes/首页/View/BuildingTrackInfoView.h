//
//  BuildingTrackInfoView.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportBuildingTrack.h"


@class BuildingTrackInfoView;
typedef void(^BuildingTracnInfoResult)(BuildingTrackInfoView* infoView,UIButton* actionBtn);

@interface BuildingTrackInfoView : UIView

/**
 *  跟进详情
 */
@property (nonatomic,weak)ReportBuildingTrack* buildingTrack;

- (instancetype)initWithEventCallBack:(BuildingTracnInfoResult)callBack;

@property (nonatomic,copy)BuildingTracnInfoResult callBack;

@property (nonatomic,assign)CGFloat trackHeight;
@end
