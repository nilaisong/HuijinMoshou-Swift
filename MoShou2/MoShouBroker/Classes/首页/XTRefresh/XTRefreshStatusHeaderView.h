//
//  XTRefreshStatusView.h
//  RefreshTest
//
//  Created by xiaotei's on 16/6/17.
//  Copyright © 2016年 xiaote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int,RefreshViewStatus){
    RefreshViewStatusDragging,
    RefreshViewStatusEndDragging,
    RefreshViewStatusLoading,
    RefreshViewStatusNone
};


@interface XTRefreshStatusView : UIView
{
    __weak UITableView* _scrollView;

}

//360°进度
@property (nonatomic,assign)CGFloat progress;

@property (nonatomic,assign)RefreshViewStatus status;

- (void)beganAnimation;

- (void)endAnimation;

- (void)endRefreshing;

- (void)beginRefreshing;

@end
