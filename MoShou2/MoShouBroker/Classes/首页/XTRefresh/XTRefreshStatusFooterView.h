//
//  XTRefreshStatusFooterView.h
//  RefreshTest
//
//  Created by xiaotei's on 16/6/20.
//  Copyright © 2016年 xiaote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int,XTRefreshFooterViewStatus) {
    XTRefreshFooterViewStatusDragging = 0,
    XTRefreshFooterViewStatusEndDragging,
    XTRefreshFooterViewStatusLoading,
    XTRefreshFooterViewStatusNone
};



@interface XTRefreshStatusFooterView : UIView
{
    __weak UITableView* _scrollView;
    
}
@property (nonatomic,assign)XTRefreshFooterViewStatus status;

/**
 结束刷新
 */
- (void)endRefreshing;

@end
