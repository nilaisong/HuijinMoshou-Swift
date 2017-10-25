//
//  CircleIndicatorView.h
//  ASIRequestWithLoadingMessage
//
//  Created by Laisong Ni on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleIndicator.h"

@protocol CircleIndicatorViewDelegate;

@interface CircleIndicatorView : UIView
{
    CircleIndicator * circleIndicator;
    UILabel* pLabel;
}

@property(nonatomic,assign) id<CircleIndicatorViewDelegate> delegate;
@property(nonatomic,retain) UILabel * label;

- (void)setArcAngle:(float)arcAngle; 

@end

@protocol CircleIndicatorViewDelegate <NSObject>

-(void)cancel:(CircleIndicatorView*)circleIndicatorView_;

@end