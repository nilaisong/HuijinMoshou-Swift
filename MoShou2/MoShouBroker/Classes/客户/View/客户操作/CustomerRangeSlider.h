//
//  CustomerRangeSlider.h
//  MoShou2
//
//  Created by wangzz on 15/12/11.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerRangeSlider : UIControl
// default 0.0
@property(assign, nonatomic) float minimumValue;

// default 1.0
@property(assign, nonatomic) float maximumValue;

// default 0.0. This is the minimum distance between between the upper and lower values
@property(assign, nonatomic) float minimumRange;

// default 0.0 (disabled)
@property(assign, nonatomic) float stepValue;

@property(assign, nonatomic) BOOL stepValueContinuously;

// defafult YES, indicating whether changes in the sliders value generate continuous update events.
@property(assign, nonatomic) BOOL continuous;

// default 0.0. this value will be pinned to min/max
@property(assign, nonatomic) float lowerValue;

// default 1.0. this value will be pinned to min/max
@property(assign, nonatomic) float upperValue;

// center location for the lower handle control
@property(readonly, nonatomic) CGPoint lowerCenter;

// center location for the upper handle control
@property(readonly, nonatomic) CGPoint upperCenter;

@property(strong, nonatomic) UIImage* lowerHandleImageNormal;
@property(strong, nonatomic) UIImage* lowerHandleImageHighlighted;

@property(strong, nonatomic) UIImage* upperHandleImageNormal;
@property(strong, nonatomic) UIImage* upperHandleImageHighlighted;

@property(strong, nonatomic) UIImage* trackImage;

@property(strong, nonatomic) UIImage* trackBackgroundImage;

- (void)setLowerValue:(float)lowerValue animated:(BOOL) animated;

- (void)setUpperValue:(float)upperValue animated:(BOOL) animated;

- (void) setLowerValue:(float) lowerValue upperValue:(float) upperValue animated:(BOOL)animated;
@end
