//
//  UITableView+XTRefresh.m
//  RefreshTest
//
//  Created by xiaotei's on 16/6/17.
//  Copyright © 2016年 xiaote. All rights reserved.
//

#import "UITableView+XTRefresh.h"

#import <objc/runtime.h>


#define HEADERBEGANKEY @"HEADERBEGANKEY"
#define FOOTERBEGANKEY @"FOOTERBEGANKEY"
#define FOOTERVIEW @"FOOTERVIEW"
#define STATUSVIEW @"STATUSVIEW"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface UITableView()

@property (nonatomic,copy)XTRefreshBegan headerBegan;
@property (nonatomic,copy)XTRefreshBegan footerBegan;



@end

@implementation UITableView (XTRefresh)

static BOOL hasObserver = NO;

static id _refresnSelf;

- (void)addLegendHeaderWithRefreshingBlock:(XTRefreshBegan)headerBegan{
    [self setHeaderBegan:headerBegan];
    
    if (self.legendHeader != nil) {
        return;
    }
    
    hasObserver = YES;
     __weak typeof(self) weakSelf = self;
    _refresnSelf = weakSelf;
    //添加监听
    
    XTRefreshStatusView* statusViwe = [[XTRefreshStatusView alloc] initWithFrame:CGRectMake(-STATUSVIEWHEIGHT, 0,1000, STATUSVIEWHEIGHT)];
    statusViwe.hidden = YES;
    [self addSubview:statusViwe];
    [self setStatusView:statusViwe];
    
    
}

- (void)clearRefreshView{
    objc_setAssociatedObject(self, HEADERBEGANKEY, nil, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, FOOTERBEGANKEY, nil, OBJC_ASSOCIATION_COPY);
    [self.legendHeader removeFromSuperview];
    objc_setAssociatedObject(self, STATUSVIEW, nil, OBJC_ASSOCIATION_ASSIGN);
    [self.legendFooter removeFromSuperview];
    objc_setAssociatedObject(self, FOOTERVIEW, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
 
    
}

//- (void)removeFromSuperview{
  //  if (self.superview) {
    //    [self removeFromSuperview];
    //}
    
//}

- (void)addLegendFooterWithRefreshingBlock:(XTRefreshBegan)footerBegan{
    [self setFooterBegan:footerBegan];
    if (self.legendFooter != nil) {
        return;
    }
    //添加监听
    hasObserver = YES;
//    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    XTRefreshStatusFooterView* statusView = [[XTRefreshStatusFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, STATUSVIEWHEIGHT)];
    
    [self addSubview:statusView];
    [self setFooterView:statusView];
}

- (void)setHeaderBegan:(XTRefreshBegan)headerBegan{
    objc_setAssociatedObject(self, HEADERBEGANKEY, headerBegan, OBJC_ASSOCIATION_COPY);
}

- (XTRefreshBegan)headerBegan{
    return objc_getAssociatedObject(self, HEADERBEGANKEY);
}

- (void)setFooterBegan:(XTRefreshBegan)footerBegan{
    
    objc_setAssociatedObject(self, FOOTERBEGANKEY, footerBegan, OBJC_ASSOCIATION_COPY);
}

- (XTRefreshBegan)footerBegan{
    return objc_getAssociatedObject(self, FOOTERBEGANKEY);
}

- (void)dealloc{
//    if (hasObserver && [_refresnSelf isEqual:self]) {
       //    }
//    [self.statusView removeFromSuperview];
}

- (void)setStatusView:(XTRefreshStatusView *)statusView{
    objc_setAssociatedObject(self, STATUSVIEW, statusView, OBJC_ASSOCIATION_ASSIGN);
}

//- (XTRefreshStatusView *)statusView{
//    return objc_getAssociatedObject(self, STATUSVIEW);
//}

- (XTRefreshStatusView *)legendHeader{
    return objc_getAssociatedObject(self, STATUSVIEW);
}

//- (XTRefreshStatusView *)header{
//    return objc_getAssociatedObject(self, STATUSVIEW);
//}


- (XTRefreshStatusFooterView *)legendFooter{
    return objc_getAssociatedObject(self, FOOTERVIEW);
}
//
//- (XTRefreshStatusFooterView *)footer{
//    return objc_getAssociatedObject(self, FOOTERVIEW);
//}

//- (XTRefreshStatusFooterView *)footerView{
//    return objc_getAssociatedObject(self, FOOTERVIEW);
//}

- (void)setFooterView:(XTRefreshStatusFooterView *)footerView{
    objc_setAssociatedObject(self, FOOTERVIEW, footerView, OBJC_ASSOCIATION_ASSIGN);
}


- (void)endRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            self.legendHeader.status = RefreshViewStatusNone;
            self.legendFooter.status = XTRefreshFooterViewStatusNone;
            [self.legendHeader endAnimation];
        }];
    });
    
}

- (void)adjustFrameWithPoint:(CGPoint)newPoint{
    //调整self的frame
    CGFloat selfY = self.contentSize.height;
    CGFloat selfW = self.frame.size.width;
    self.legendHeader.hidden = NO;
    self.legendHeader.frame = CGRectMake(0, -STATUSVIEWHEIGHT, selfW, STATUSVIEWHEIGHT);
    self.legendFooter.frame = CGRectMake(0, selfY, selfW, STATUSVIEWHEIGHT);
    //要添加到UItableView的最底部
        CGPoint offset = newPoint;
        
        if (self.dragging) {
            if (self.legendHeader.status == RefreshViewStatusLoading || self.legendFooter.status == XTRefreshFooterViewStatusLoading) {
                
                return;
            }
            self.legendHeader.status = RefreshViewStatusDragging;
            if (offset.y <= -STATUSVIEWHEIGHT && self.legendHeader.hidden == NO) {
                self.legendHeader.status = RefreshViewStatusEndDragging;
            }
            if (offset.y < 0 && self.legendHeader.hidden == NO) {
                CGFloat offsetY = ABS(offset.y);
                if (offset.y < -STATUSVIEWHEIGHT) {
                    offsetY = STATUSVIEWHEIGHT;
                }
                self.legendHeader.progress = (offsetY / STATUSVIEWHEIGHT) * 100;
            }
            
            //1.scrollView最大偏移量 最大只能这么大，因为屏幕其实是有一定宽度的
            CGFloat maxOffSetY = self.contentSize.height - self.frame.size.height;
            //自己的高度
            CGFloat footerVeiwH = STATUSVIEWHEIGHT;
            if (self.contentOffset.y >= maxOffSetY && self.contentOffset.y< maxOffSetY + footerVeiwH && self.legendFooter.hidden == NO)
            {
                //        self.footerView;//设置它的状态为拖拽读取更多
                //                [self setFooterViewStatus:FooterViewStatusDragging];
                self.legendFooter.status = XTRefreshFooterViewStatusDragging;
                
            }
            if (self.contentOffset.y >= maxOffSetY+footerVeiwH && self.legendFooter.hidden == NO)
            {
                //        self.footerView;//设置它的状态为松开读取更多
                //                [self setFooterViewStatus:FooterViewStatusEndDragging];
                self.legendFooter.status = XTRefreshFooterViewStatusEndDragging;
            }
            
        }else{
            if (self.legendHeader.status == RefreshViewStatusEndDragging) {
                self.legendHeader.status = RefreshViewStatusLoading;
                [self.legendHeader beganAnimation];
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.contentInset = UIEdgeInsetsMake(STATUSVIEWHEIGHT, 0, 0, 0);
                    
                } completion:^(BOOL finished) {
                    
                }];
                
                if (self.headerBegan && self.legendHeader.hidden == NO) {
                    self.headerBegan();
                }
            }
            
            if (self.legendFooter.status == XTRefreshFooterViewStatusEndDragging ) {
                self.legendFooter.status = XTRefreshFooterViewStatusLoading;
                [UIView animateWithDuration:0.4 animations:^{
                    self.contentInset = UIEdgeInsetsMake(0, 0, STATUSVIEWHEIGHT, 0);
                }];
                
                if (self.footerBegan && self.legendFooter.hidden == NO) {
                    self.footerBegan();
                }
            }
            
        }

}

- (void)setFooterViewHidden:(BOOL)hidden{
    self.legendFooter.hidden = hidden;
}

- (void)setHeaderViewHidden:(BOOL)hidden{
    self.legendHeader.hidden = hidden;
}

- (void)beganHeaderRefresh{
    if (self.legendHeader.status == RefreshViewStatusLoading) {
        return;
    }
    self.legendHeader.status = RefreshViewStatusDragging;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentOffset = CGPointMake(0, -STATUSVIEWHEIGHT-2);
        self.legendHeader.progress = 105;
    } completion:^(BOOL finished) {
        self.legendHeader.status = RefreshViewStatusEndDragging;
       [self adjustFrameWithPoint:CGPointMake(0, - STATUSVIEWHEIGHT - 2)];
    }];
    
}

@end
