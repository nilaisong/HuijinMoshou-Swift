//
//  TipsView.m
//  MoShouBroker
//
//  Created by wangzz on 15/6/16.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "TipsView.h"
#import "Tool.h"
@implementation TipsView

static UIView *tipsView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (void) showTips:(NSString *)title andContent:(NSString *)content inView:(UIView *)parentView{

    if (tipsView && tipsView.superview) {
        [tipsView removeFromSuperview];
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
       [backgroundView.layer setMasksToBounds:YES];
    [backgroundView.layer setCornerRadius:5];
    backgroundView.layer.zPosition = MAXFLOAT;
    
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    tipsView = backgroundView;
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = title;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.textColor = [UIColor whiteColor];
    [titleL setFont:[UIFont systemFontOfSize:16]];
    [titleL setCenter:CGPointMake(backgroundView.center.x, backgroundView.center.y-30)];
    [backgroundView addSubview:titleL];
    
    UIView *line =[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 190, 0.5)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [backgroundView addSubview:line];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,kFrame_Height(titleL), backgroundView.bounds.size.width-20, backgroundView.bounds.size.height-20)];
    label.text = content;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
//    [label setCenter:backgroundView.center];
    [backgroundView addSubview:label];
    
    //set location of tip view
    [backgroundView setCenter:parentView.center];
    [parentView addSubview:backgroundView];
    
    [UIView animateWithDuration:0.2 //1.show tip view first
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         backgroundView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 //2.hide tip view in second
                                               delay:0.8
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^(){
                                              backgroundView.alpha = 0;
                                          }
                                          completion:^(BOOL finished){
                                              [backgroundView removeFromSuperview]; //3.finally remove tip view
                                          }];
                     }];

}

+ (void) showAgencyTips:(NSString *)title andContent:(NSString *)content inView:(UIView *)parentView{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [backgroundView.layer setMasksToBounds:YES];
    [backgroundView.layer setCornerRadius:5];
    backgroundView.layer.zPosition = MAXFLOAT;
    
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.8;
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 25,200, 30)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = title;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.textColor = [UIColor whiteColor];
    [titleL setFont:[UIFont systemFontOfSize:17]];
//    [titleL setCenter:CGPointMake(backgroundView.center.x, backgroundView.center.y-30)];
    [backgroundView addSubview:titleL];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,titleL.bottom, backgroundView.bounds.size.width-20, 20)];
    label.text = content;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    //    [label setCenter:backgroundView.center];
    [backgroundView addSubview:label];
    
    //set location of tip view
    [backgroundView setCenter:parentView.center];
    //    CGRect frame = backgroundView.frame;
    //    frame.origin.y -= 25;
    //    [backgroundView setFrame:frame];
    [parentView addSubview:backgroundView];
    
    [UIView animateWithDuration:0.2 //1.show tip view first
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         backgroundView.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 //2.hide tip view in second
                                               delay:0.8
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^(){
                                              backgroundView.alpha = 0;
                                          }
                                          completion:^(BOOL finished){
                                              [backgroundView removeFromSuperview]; //3.finally remove tip view
                                          }];
                     }];
    
}

+ (void) showTips:(NSString *)text inView:(UIView *)parentView
{
//    return [Tool showTextHUD:text andView:parentView];
    dispatch_async(dispatch_get_main_queue(), ^{
        //add by wangzz 160817
        
        NSDictionary *attributes = @{NSFontAttributeName:FONT(16)};
        CGSize size = [text sizeWithAttributes:attributes];
        
        CGSize labelSize = [[[TipsView alloc]init] textSize:text withConstraintWidth:MIN(size.width+20, kMainScreenWidth*3/4)];
        
        //end
        
        if (tipsView && tipsView.superview) {
            [tipsView removeFromSuperview];
        }
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelSize.width+30, labelSize.height+30)];//CGRectMake(0, 0, 200, 80)
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.7;
        [backgroundView.layer setMasksToBounds:YES];
        [backgroundView.layer setCornerRadius:5];
        //    backgroundView.alpha = 0;
        backgroundView.layer.zPosition = MAXFLOAT;
        tipsView = backgroundView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, labelSize.width, labelSize.height)];//backgroundView.bounds
        label.text = text;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont systemFontOfSize:16]];
        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [label setCenter:backgroundView.center];
        [backgroundView addSubview:label];
        
        //set location of tip view
        [backgroundView setCenter:parentView.center];
        //    CGRect frame = backgroundView.frame;
        //    frame.origin.y -= 25;
        //    [backgroundView setFrame:frame];
        [parentView addSubview:backgroundView];
        
        [UIView animateWithDuration:0.2 //1.show tip view first
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(){
                             backgroundView.alpha = 0.7;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.5 //2.hide tip view in second
                                                   delay:2.3
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^(){
                                                  backgroundView.alpha = 0;
                                              }
                                              completion:^(BOOL finished){
                                                  [backgroundView removeFromSuperview]; //3.finally remove tip view
                                              }];
                         }];
        

    });
}

+ (void) showTipImage:(NSString *)imgName inView:(UIView *)parentView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    view.userInteractionEnabled = YES;
    [parentView addSubview:view];
    
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 150)];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgName]];
    backgroundView.alpha = 0;
    backgroundView.layer.zPosition = MAXFLOAT;
    [backgroundView setCenter:parentView.center];
    CGRect frame = backgroundView.frame;
    frame.origin.y -= 25;
    [backgroundView setFrame:frame];
    [view addSubview:backgroundView];
    
    
    [UIView animateWithDuration:0.2 //1.show tip view first
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         backgroundView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 //2.hide tip view in second
                                               delay:0.8
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^(){
                                              backgroundView.alpha = 0;
                                          }
                                          completion:^(BOOL finished){
                                              [view removeFromSuperview]; //3.finally remove tip view
                                          }];
                     }];

}
+(void)showTipsCantClick:(NSString *)text inView:(UIView *)parentView{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
//        view.userInteractionEnabled = NO;
//        [view setBackgroundColor:[UIColor whiteColor]];
        [parentView addSubview:view];

        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.7;
        [backgroundView.layer setMasksToBounds:YES];
        [backgroundView.layer setCornerRadius:5];
        //    backgroundView.alpha = 0;
        backgroundView.layer.zPosition = MAXFLOAT;
        
        UILabel *label = [[UILabel alloc] initWithFrame:backgroundView.bounds];
        label.text = text;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont systemFontOfSize:16]];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [label setCenter:backgroundView.center];
        [backgroundView addSubview:label];
        
        //set location of tip view
        [backgroundView setCenter:parentView.center];
        //    CGRect frame = backgroundView.frame;
        //    frame.origin.y -= 25;
        //    [backgroundView setFrame:frame];
        [view addSubview:backgroundView];
        
        [UIView animateWithDuration:0.2 //1.show tip view first
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(){
                             backgroundView.alpha = 0.7;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.5 //2.hide tip view in second
                                                   delay:0.8
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^(){
                                                  backgroundView.alpha = 0;
                                              }
                                              completion:^(BOOL finished){
                                                  [view removeFromSuperview]; //3.finally remove tip view
                                              }];
                         }];
        
        
    });

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//add by wangzz 160817
//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
}

//end

@end
