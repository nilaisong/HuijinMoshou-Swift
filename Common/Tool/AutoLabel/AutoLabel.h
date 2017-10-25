//
//  AutoLabel.h
//  MoShouBroker
//
//  Created by strongcoder on 15/8/14.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoLabel : UIView
@property (nonatomic,assign)float maxHeight;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* contentLabel;


//2016-12-06 21:48:55   目前楼盘详情使用中   前灰 后 黑
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andContent:(NSString *)contentString;


-(id)initWithFrame:(CGRect)frame andContent:(NSString *)contentString;
-(id)initWithFrame:(CGRect)frame withContent:(NSString *)contentString fountSize:(CGFloat)size andColor:(UIColor *)color;

-(id)initWithFrame:(CGRect)frame withContent:(NSString *)contentString AndBorderColor:(UIColor *)BorderColor;


-(id)initWithFrame:(CGRect)frame withContent:(NSString *)contentString AndcornersColor:(UIColor*)cornerColor;


//多工程公用  复制出来用  囧   目前楼盘主力户型 使用 
-(id)initWithFrame:(CGRect)frame andNewTitle:(NSString *)title andNewContent:(NSString *)contentString;

//竖向的
-(id)initVerticalWithFrame:(CGRect)frame andNewTitle:(NSString *)title andNewContent:(NSString *)contentString;



-(void)setContent:(NSString *)contet;
@end
