//
//  LQToolView.m
//  MoShouBroker
//
//  Created by strongcoder on 15/7/21.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "LQToolView.h"
#import <Foundation/Foundation.h>

typedef enum {
    
    ChooseSaveImage = 0,
    ChooseShareIamge = 1,
    ChooseCacel = 2,
    
} ChooseType ;


@implementation LQToolView


//   165   50   50   15  50

-(id)initWithDelegate:(id)delegate andFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.delegate =delegate;
        [self addBackgroundView];
        [self loadUI];
        
    }
    return self;
}
-(void)addBackgroundView
{
    UIControl * control = [[UIControl alloc] initWithFrame:self.bounds];
    control.backgroundColor = [UIColor blackColor];
    control.alpha = 0.3;
    [self addSubview:control];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [control addGestureRecognizer:tap];
}

//根据热点调整视图显示尺寸
-(void)adjustFrameForHotSpotChange{
  
#warning 这里多注释了一句  就是下面这句  有啥后果??
    [self removeAllSubviews];
    [self addBackgroundView];
    [self loadUI];
}

-(void)loadUI
{
    //保存到手机
    UIView *oneVIew = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-165, self.frame.size.width, 49)];
    oneVIew.backgroundColor =[UIColor whiteColor];
    [self addSubview:oneVIew];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SaveImageAction)];
    [oneVIew addGestureRecognizer:oneTap];
    
    UIImageView *saveImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-80-16)/2, (kFrame_Height(oneVIew)-16)/2, 16, 16)];
    saveImageView.image = [UIImage imageNamed:@"build－保存"];
    [oneVIew addSubview:saveImageView];
    UILabel *saveLabel = [[UILabel alloc]initWithFrame:CGRectMake(kFrame_XWidth(saveImageView)+5, (kFrame_Height(oneVIew)-16)/2, 90, 20)];
    saveLabel.text = @"保存到手机";
    saveLabel.textColor = kRGB(93, 182, 224);
    saveLabel.font = FONT(17);
    saveLabel.font = [UIFont boldSystemFontOfSize:17.f];

    saveLabel.textAlignment = NSTextAlignmentLeft;
    [oneVIew addSubview:saveLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-116, self.frame.size.width, 1)];
    lineLabel.backgroundColor = UIColorFromRGB(0xd9d9db);
    [self addSubview:lineLabel];
    
    
    //分享图片
    UIView *twoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-115, self.frame.size.width, 50)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:twoView];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareImageAction)];
    [twoView addGestureRecognizer:twoTap];
    
    
    UIImageView *shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-80-16)/2, (kFrame_Height(oneVIew)-16)/2, 16, 16)];
    shareImageView.image = [UIImage imageNamed:@"build－分享"];
    [twoView addSubview:shareImageView];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(kFrame_XWidth(saveImageView)+5, (kFrame_Height(oneVIew)-16)/2, 80, 20)];
    shareLabel.text = @"分享图片";
    shareLabel.font = [UIFont boldSystemFontOfSize:17.f];
    shareLabel.textColor = kRGB(93, 182, 224);
    shareLabel.textAlignment = NSTextAlignmentLeft;
    [twoView addSubview:shareLabel];
 
    //取消
    UIView *threeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    threeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:threeView];
    
    UITapGestureRecognizer *cacelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cacelAction)];
    [threeView addGestureRecognizer:cacelTap];
    
    UILabel *cacelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    cacelLabel.text = @"取消";
    cacelLabel.textColor = UIColorFromRGB(0xf4595b);
    cacelLabel.textAlignment = NSTextAlignmentCenter;
    cacelLabel.font = [UIFont boldSystemFontOfSize:17.f];

    [threeView addSubview:cacelLabel];
    
}




-(void)SaveImageAction
{
    DLog(@"保存图像");
    if ([self.delegate respondsToSelector:@selector(chooseBtn:withChooseIndex:)])
    {
        [self.delegate chooseBtn:self withChooseIndex:ChooseSaveImage];
        
    }
    
    
    
    
}

-(void)shareImageAction
{
    DLog(@"分享");
    if ([self.delegate respondsToSelector:@selector(chooseBtn:withChooseIndex:)])
    {
        [self.delegate chooseBtn:self withChooseIndex:ChooseShareIamge];
        
    }
    
    
}
    
-(void)cacelAction
{
    if ([self.delegate respondsToSelector:@selector(chooseBtn:withChooseIndex:)])
    {
        [self.delegate chooseBtn:self withChooseIndex:ChooseCacel];
        
    }
    DLog(@"取消");
    
//    [self removeFromSuperview];
    
    
}


-(void)tapClick:(UITapGestureRecognizer *)tap
{
    
    DLog(@"点击隐藏本身");
    if ([self.delegate respondsToSelector:@selector(backgroundViewTapClick)])
    {
        [self.delegate backgroundViewTapClick];
    }
    
}


@end
