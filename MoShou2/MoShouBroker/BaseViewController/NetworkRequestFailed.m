//
//  NetworkRequestFailed.m
//  MoShouBroker
//
//  Created by caotianyuan on 15/8/24.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//
#import "NetworkSingleton.h"
#import "NetworkRequestFailed.h"
#import "TipsView.h"
@implementation NetworkRequestFailed

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self createUI];
        self.backgroundColor=[UIColor whiteColor];
        //        self.backgroundColor=[UIColor purpleColor];
        //        self.alpha=0.95;
    }
    return self;
}

-(void)adjustFrameForHotSpotChange
{
    for (UIView* subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self createUI];
}

-(void)createUI//140/1200   240/750   272/750   201/1200
{
    UIImageView *pictureImage=[[UIImageView alloc]initWithFrame:CGRectMake(240.0/750*kMainScreenWidth, 140.0/1200*kMainScreenHeight, 272.0/750*kMainScreenWidth, 201.0/750*kMainScreenWidth)];//CGRectMake(kMainScreenWidth/2-136/2, kMainScreenHeight/5*1, 136, 100)
    pictureImage.image=[UIImage imageNamed:@"iconfont-gaosuwangluo"];
    [self addSubview:pictureImage];
    
    UILabel *promptLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, pictureImage.bottom+25, kMainScreenWidth, 20)];
    promptLabel1.text=@"网络故障";
    promptLabel1.font=[UIFont systemFontOfSize:14];
    promptLabel1.textColor=LABELCOLOR;
    promptLabel1.textAlignment=NSTextAlignmentCenter;
    [self addSubview:promptLabel1];
    

    UILabel *promptLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, promptLabel1.bottom, kMainScreenWidth, 20)];
    promptLabel2.text=@"请检查您的网络设置稍后重试";
    promptLabel2.font=[UIFont systemFontOfSize:14];
    promptLabel2.textColor=LABELCOLOR;
    promptLabel2.textAlignment=NSTextAlignmentCenter;
    [self addSubview:promptLabel2];
    
//    UILabel *promptLabel3=[[UILabel alloc]initWithFrame:CGRectMake(203.0/2/320*kMainScreenWidth, promptLabel2.frame.size.height+promptLabel2.frame.origin.y+11.0/480*self.bounds.size.height, kMainScreenWidth-203.0/320*kMainScreenWidth, promptLabel2.frame.size.height)];
//    promptLabel3.text=@"点击按钮重新加载";
//    promptLabel3.font=[UIFont systemFontOfSize:14];
//    promptLabel3.textColor=UIColorFromRGB(0xc0c0c0);
//    promptLabel3.textAlignment=NSTextAlignmentCenter;
//    [self addSubview:promptLabel3];
    
    UIButton *reloadButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setTitle:@"重新链接" forState:UIControlStateNormal];
    reloadButton.titleLabel.font =[UIFont systemFontOfSize:14];
    [reloadButton setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    reloadButton.layer.cornerRadius=8;
    reloadButton.clearsContextBeforeDrawing=UITextFieldViewModeAlways;
    reloadButton.layer.borderWidth=0.8;
    reloadButton.frame=CGRectMake(270.0/750*kMainScreenWidth, promptLabel2.bottom+115.0/1200*kMainScreenHeight, 210.0/750*kMainScreenWidth, 60.0/1200*kMainScreenHeight);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [reloadButton.layer setBorderColor:[BLUEBTBCOLOR CGColor]];
    [reloadButton addTarget:self action:@selector(reloadDataClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reloadButton];

}

-(void)reloadDataClick
{

    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        [self removeFromSuperview];
        if (self.reloadData)
        {
            self.reloadData();
        }
    }
    else
    {
        [TipsView showTips:@"网络连接失败" inView:self];
    }
}

@end
