//
//  MyImageView.m
//  AuctionCatalog
//
//  Created by Laison on 12-4-12.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "MyImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Functions.h"
#import "UIImageExtras.h"
#import "asyncRequestView.h"
#import "TKRoundedView.h"

@interface MyImageView ()
@property(nonatomic,retain) CALayer * imageLayer;

@end

@implementation MyImageView

@synthesize imageLayer;


-(void)setImageWithUrlString:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setImageWithUrlString:(NSString *)url placeholderImage:(UIImage *)placeholder
{
  [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

-(void)addShadow
{
    CALayer *layer= self.layer;
    
    [layer setBackgroundColor:[UIColor whiteColor].CGColor];
    //阴影
    layer.shadowColor =[UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.shadowRadius = 5.0;
    layer.shadowOffset = CGSizeMake(2, 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    layer.shadowPath = path.CGPath;
}



-(void)addRoundCornerWithBoderColor:(UIColor*)borderColor andContentModel:(NSString*)contentModel
{
    //边框
    CALayer *layer= self.layer;
    layer.cornerRadius = 2.0;
    layer.borderWidth = 2.0;
    layer.borderColor = borderColor.CGColor;
    //[UIColor colorWithRed:152/255. green:61/255. blue:57/255. alpha:1.0].CGColor;
    if (imageLayer==nil)
    {
        //为图片加圆角
        [imageLayer removeFromSuperlayer];
        self.imageLayer = [CALayer layer];
        imageLayer.frame = self.bounds;
        //[imageLayer setBackgroundColor:[UIColor whiteColor].CGColor];
        imageLayer.cornerRadius =5.0;
        //需要设置masksToBounds为YES，图片才会显示为圆角，但会裁去该层的阴影效果
        imageLayer.masksToBounds =YES;
        //@"resizeAspect";
        [layer addSublayer:imageLayer];
    }
    imageLayer.contentsGravity = contentModel;
    if (self.image)
    {
        imageLayer.contents = (id)self.image.CGImage;
//        super.image =nil;
    }
}

//modify by LJS start

- (void)addRoundCorner{
    [self addRoundCornerWithBoderColor:[UIColor clearColor] andContentModel:@"resizeAspectFill"];

}


@end
