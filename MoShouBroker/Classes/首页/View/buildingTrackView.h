//
//  buildingTrackView.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class buildingTrackView;
typedef void(^buildingActionResult)(buildingTrackView* trackView,UIButton* actionBtn);

@interface buildingTrackView : UIView

- (instancetype)initWithCallBack:(buildingActionResult)callBack;

@property (nonatomic,copy)buildingActionResult callBack;
@end
