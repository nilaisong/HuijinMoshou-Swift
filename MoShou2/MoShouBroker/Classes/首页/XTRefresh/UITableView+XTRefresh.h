//
//  UITableView+XTRefresh.h
//  RefreshTest
//
//  Created by xiaotei's on 16/6/17.
//  Copyright © 2016年 xiaote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTRefreshStatusHeaderView.h"
#import "XTRefreshStatusFooterView.h"

#define STATUSVIEWHEIGHT (60.0f * SCALE6)

typedef void(^XTRefreshBegan)();

@interface UITableView (XTRefresh)

/**
 *  xiaotei 头部刷新
 */
- (void)addLegendHeaderWithRefreshingBlock:(XTRefreshBegan)headerBegan;

/**
 *  xiaotei 底部刷新
 */
- (void)addLegendFooterWithRefreshingBlock:(XTRefreshBegan)footerBegan;

/**
 *  xiaotei 结束刷新
 */
- (void)endRefresh;

- (void)setFooterViewHidden:(BOOL)hidden;

- (void)setHeaderViewHidden:(BOOL)hidden;

//k开始头部刷新
- (void)beganHeaderRefresh;

- (void)adjustFrameWithPoint:(CGPoint)newPoint;

@property (nonatomic,weak)XTRefreshStatusView* legendHeader;

@property (nonatomic,weak)XTRefreshStatusFooterView* legendFooter;

//@property (nonatomic,weak)XTRefreshStatusView* header;

//@property (nonatomic,weak)XTRefreshStatusFooterView* footer;
- (void)clearRefreshView;

@end
