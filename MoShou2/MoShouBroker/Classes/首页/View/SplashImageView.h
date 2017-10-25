//
//  SplashImageView.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashImageView;
typedef void(^SplashImageViewShowEndBlock)(SplashImageView* view);

@interface SplashImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame callBack:(SplashImageViewShowEndBlock)callBack;


@property (nonatomic,copy)SplashImageViewShowEndBlock callBack;

@end
