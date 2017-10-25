//
//  UIScrollView+AllowPanGestureEventPass.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/7.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "UIScrollView+AllowPanGestureEventPass.h"

@implementation UIScrollView (AllowPanGestureEventPass)


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    if ([self isKindOfClass:NSClassFromString(@"XTScheduleInfoTableView")]) {
//        return YES;
//    }
    
    if ([self isKindOfClass:NSClassFromString(@"RecommendationRecordListView")] ) {
//        (self.contentOffset.x <= 0) &&
        CGPoint point = [gestureRecognizer locationInView:self.superview];
        if (point.x <= [UIScreen mainScreen].bounds.size.width * 0.1) {
            return YES;
        }else return NO;
//      return YES;
    }
    return  NO;
}

@end
