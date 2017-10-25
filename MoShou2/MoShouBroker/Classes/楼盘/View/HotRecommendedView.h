//
//  HotRecommendedView.h
//  MoShou2
//
//  Created by strongcoder on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotRecommendedView : UIView
@property (nonatomic,strong)NSNumber *buildingNumer;

- (id)initWithFrame:(CGRect)frame;

- (void)refreshAdsWithAdsArray:(NSMutableArray*)adsArr andVC:(UIViewController*)viewController;
- (void)beginScroll;
- (void)stopScroll;

@end
