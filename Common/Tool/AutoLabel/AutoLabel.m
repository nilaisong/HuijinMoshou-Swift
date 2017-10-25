//
//  AutoLabel.m
//  MoShouBroker
//
//  Created by strongcoder on 15/8/14.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//
#import "UILabel+StringFrame.h"
#import "AutoLabel.h"
#import "UIView+YR.h"
@implementation AutoLabel

//XXXXXXX
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andContent:(NSString *)contentString;
{
    self = [super initWithFrame:frame];
    if (self)
    {
 
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = UIColorFromRGB(0x888888);
        self.titleLabel.font = [UIFont systemFontOfSize:13.f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        CGSize size = [self.titleLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
        self.titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
        [self addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.text = contentString;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = UIColorFromRGB(0x333333);
        self.contentLabel.font = [UIFont systemFontOfSize:13.f];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        CGSize contentSize = [self.contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width-kFrame_Width(self.titleLabel), 0)];
        self.contentLabel.frame = CGRectMake(kFrame_Width(self.titleLabel)+2, 0, contentSize.width, contentSize.height);
        [self addSubview:self.contentLabel];

        self.maxHeight = kFrame_YHeight(self.contentLabel);
    
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.titleLabel.width+2+self.contentLabel.width, self.maxHeight);
        self.height = self.contentLabel.bottom;
    }
    
    
    return self;
    
}


-(id)initWithFrame:(CGRect)frame andContent:(NSString *)contentString{
    self = [super initWithFrame:frame];
    if (self)
    {
   self.contentLabel = [[UILabel alloc]init];
     self.contentLabel.text = contentString;
     self.contentLabel.numberOfLines = 0;
     self.contentLabel.textColor = UIColorFromRGB(0x717171);
     self.contentLabel.font = [UIFont systemFontOfSize:14.f];
     self.contentLabel.textAlignment = NSTextAlignmentCenter;
    CGSize contentSize = [ self.contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
     self.contentLabel.frame = CGRectMake(frame.size.width/2-contentSize.width/2,frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
    [self addSubview: self.contentLabel];
    
    self.maxHeight = kFrame_YHeight( self.contentLabel);
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.maxHeight);
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withContent:(NSString *)contentString fountSize:(CGFloat)size andColor:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.text = contentString;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = color;
        self.contentLabel.font = [UIFont systemFontOfSize:size];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        CGSize contentSize = [ self.contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
        self.contentLabel.frame = CGRectMake(frame.size.width/2-contentSize.width/2,frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
        [self addSubview: self.contentLabel];
        
        self.maxHeight = kFrame_YHeight( self.contentLabel);
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.maxHeight);
    }
    return self;


}
-(void)setContent:(NSString *)contet{
    self.contentLabel.text = contet;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    CGSize contentSize = [ self.contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
    self.contentLabel.frame = CGRectMake(self.frame.size.width/2-contentSize.width/2,self.frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
    [self addSubview: self.contentLabel];
    
    self.maxHeight = kFrame_YHeight( self.contentLabel);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.maxHeight);}

-(id)initWithFrame:(CGRect)frame withContent:(NSString *)contentString AndBorderColor:(UIColor *)BorderColor;{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.text = contentString;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = BorderColor;
        self.contentLabel.font = FONT(14);
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        CGSize contentSize = [ self.contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
        self.contentLabel.frame = CGRectMake(frame.size.width/2-contentSize.width/2,frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
        [self addSubview: self.contentLabel];
        
        self.maxHeight = kFrame_YHeight( self.contentLabel);
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width-2, self.maxHeight);
        [self.layer setBorderColor:BorderColor.CGColor];
        [self.layer setBorderWidth:0.8];
        
    }
    return self;
    
    
}


-(id)initWithFrame:(CGRect)frame withContent:(NSString *)contentString AndcornersColor:(UIColor*)cornerColor;

{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHeight:16.f];
        if (contentString.length>=4) {
            [self setWidth:contentString.length*12.f];
        }
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.contentLabel.text = [NSString stringWithFormat:@"%@",contentString];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = cornerColor;
        self.contentLabel.font = FONT(11.f);
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
//        CGSize contentSize = [ self.contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
//        self.contentLabel.frame = CGRectMake(frame.size.width/2-contentSize.width/2,frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
//        [self.contentLabel setWidth:contentSize.width];
        [self addSubview: self.contentLabel];
        
        
        [self.layer setBorderColor:cornerColor.CGColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self.layer setBorderWidth:0.5f];

    }
    return self;
    
}


//多工程公用  复制出来用  囧   经纪人2.0 楼盘详情使用
-(id)initWithFrame:(CGRect)frame andNewTitle:(NSString *)title andNewContent:(NSString *)contentString;

{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        CGSize size = [titleLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
        titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
        [self addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.text = contentString;
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        CGSize contentSize = [contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width-kFrame_Width(titleLabel), 0)];
        contentLabel.frame = CGRectMake(kFrame_Width(titleLabel)+2, 0, contentSize.width, contentSize.height);
        [self addSubview:contentLabel];
        
        self.maxHeight = kFrame_YHeight(contentLabel);
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.maxHeight);
        
    }
    
    
    return self;

}

-(id)initVerticalWithFrame:(CGRect)frame andNewTitle:(NSString *)title andNewContent:(NSString *)contentString;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
//        椭圆-lan@2x
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setImage:[UIImage imageNamed:@"椭圆-lan.png"] forState:UIControlStateNormal];
        [self addSubview:button];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        CGSize size = [titleLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
        titleLabel.frame = CGRectMake(button.right, 3, size.width, size.height);
        [self addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.text = contentString;
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        CGSize contentSize = [contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width-kFrame_Width(button), 0)];
        contentLabel.frame = CGRectMake(button.right, titleLabel.bottom, contentSize.width, contentSize.height);
        [self addSubview:contentLabel];
        
        self.maxHeight = kFrame_YHeight(contentLabel);
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.maxHeight);
        
    }
    
    
    return self;

    
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
