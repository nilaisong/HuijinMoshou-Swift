//
//  LQToolView.h
//  MoShouBroker
//
//  Created by strongcoder on 15/7/21.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQToolView;

@protocol LQToolViewDelegate <NSObject>

@optional
/**
 *  点击黑背景的事件
 */
-(void)backgroundViewTapClick;

/**
 *  选择不不同的按钮的代理方法
 *
 *  @param view        <#view description#>
 *  @param chooseIndex <#chooseIndex description#>
 */
-(void)chooseBtn:(LQToolView *)view withChooseIndex:(NSInteger)chooseIndex;


@end

@interface LQToolView : UIView

-(id)initWithDelegate:(id)delegate andFrame:(CGRect)frame;
//根据热点调整视图显示尺寸
-(void)adjustFrameForHotSpotChange;
@property (nonatomic,weak)id<LQToolViewDelegate>delegate;

@end
