//
//  TipsView.h
//  MoShouBroker
//
//  Created by wangzz on 15/6/16.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsView : UIView

+ (void) showTips:(NSString *)text inView:(UIView *)parentView;
+ (void) showTipImage:(NSString *)imgName inView:(UIView *)parentView;
+ (void) showTips:(NSString *)title andContent:(NSString *)content inView:(UIView *)parentView;
//弹出过程不允许点击
+(void)showTipsCantClick:(NSString *)text inView:(UIView *)parentView;
////经纪人登记离职操作失败页面
+ (void) showAgencyTips:(NSString *)title andContent:(NSString *)content inView:(UIView *)parentView;

@end
