//
//  FollowDetailTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"
#import "CustomerShowVisitInfoView.h"

@interface FollowDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL      bIsShowVisitInfo;
@property (nonatomic, assign) BOOL      bIsShowConfirmInfo;
@property (nonatomic, strong) CustomerShowVisitInfoView  *showVisitInfoView;

- (id)initWithMessageData:(MessageData*)data TrackType:(NSInteger)trackType AndIndexPath:(NSInteger)indexPath;

@end
