//
//  ToolAutoScrView.h
//  MoShouBroker
//
//  Created by yuanqi on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
//model
#import "Ad.h"
#import "AdModel.h"
@interface ToolAutoScrView : UIView

- (UIView*)initWithFrame:(CGRect)frame;
- (void)refreshAdsWithAdsArray:(NSMutableArray*)adsArr andVC:(UIViewController*)viewController;
- (void)beginScroll;
- (void)stopScroll;

@end
