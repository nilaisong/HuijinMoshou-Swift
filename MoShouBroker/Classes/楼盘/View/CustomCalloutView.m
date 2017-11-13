//
//  CustomCalloutView.m
//  Category_demo2D
//
//  Created by xiaoming han on 13-5-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomCalloutView.h"
#import <QuartzCore/QuartzCore.h>
#define kPortraitMargin     8
#define kPortraitWidth      150
#define kPortraitHeight     50
#define kArrorHeight    10
@implementation CustomCalloutView

//宽   250   高49

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self initSubView];
    }
    return self;
}

-(void)initSubView
{
    self.buildTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kPortraitMargin, 0, 250 ,25)];
    self.buildTitleLabel.font = [UIFont systemFontOfSize:15.f];
    self.buildTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.buildTitleLabel];
    
    self.buildLocationLabel = [[UILabel alloc]initWithFrame:CGRectMake(kPortraitMargin, kFrame_Height(_buildTitleLabel), 230, 25)];
    self.buildLocationLabel.font = [UIFont systemFontOfSize:13.f];
    self.buildLocationLabel.textColor =LABELCOLOR;
    [self addSubview:self.buildLocationLabel];
    
    self.navigationlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-60, 0, 60, 60)];
    self.navigationlabel.backgroundColor = BLUEBTBCOLOR;
    self.navigationlabel.textColor =[UIColor whiteColor];
    self.navigationlabel.font = [UIFont systemFontOfSize:14.f];
    self.navigationlabel.numberOfLines = 0;
    self.navigationlabel.textAlignment = NSTextAlignmentCenter;
    self.navigationlabel.text  = @"   \n导航";
    self.navigationlabel.userInteractionEnabled = YES;
    [self addSubview:self.navigationlabel];

    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-60+((60-44/2)/2), 5, 44/2, 38/2)];
    arrowImage.image = [UIImage imageNamed:@"位置及周边-导航.png"];
    [self addSubview:arrowImage];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(navgationAction)];
    [self.navigationlabel addGestureRecognizer:tap];
}

-(void)navgationAction
{
    if ([self.delegate respondsToSelector:@selector(CallOutNavgationAction)])
    {
        [self.delegate CallOutNavgationAction];
    }
}

@end
