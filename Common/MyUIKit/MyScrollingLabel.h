//
//  MyScrollingLabel.h
//  MarqueeLabel
//  超出显示区域时，字体循环滚动显示
//  Created by nilaisong on 13-9-9.
//  Copyright (c) 2013年 app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScrollingLabel : UIView
{
    CGRect awayLabelFrame;
    CGRect homeLabelFrame;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic,assign) float animationInterval;//字体滚动动画循环间隔时间,默认5.0秒
@property (nonatomic, retain) UILabel *subLabel;
- (void)scrollLeftWithLabel:(UILabel*)label;
-(void)resetLabel;

@end
