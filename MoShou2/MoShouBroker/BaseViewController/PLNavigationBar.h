//
//  PLNavigationBar.h
//  MoShouBroker
//
//  Created by admin on 15/7/10.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLNavigationBar;
@protocol PLNavigationBarDelegate <NSObject>

@optional
/**
 *  返回按钮必实现
 */
- (void)leftBarButtonItemClick;

/**
 *  DIY按钮  可以不用
 */
- (void)rightBarButtonItemClick;

@end
@interface PLNavigationBar : UIView
//代理
@property(nonatomic,weak) id <PLNavigationBarDelegate> delegate;
//设置背景图片
@property(nonatomic,strong) UIImageView * barBackgroundImageView;
//左侧按钮  返回
@property(nonatomic,strong) UIButton * leftBarButton;
//右侧按钮  DIY按钮1
@property(nonatomic,strong) UIButton * rigthOneButton;
@property(nonatomic,strong) UIView *line;

//titleLabel
@property(nonatomic,strong) UILabel * titleLabel;

- (id)initWithDelegate:(id)delegate;

@end
