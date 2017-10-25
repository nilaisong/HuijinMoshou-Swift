//
//  CircleIndicatorView.m
//  ASIRequestWithLoadingMessage
//
//  Created by Laisong Ni on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CircleIndicatorView.h"

#define  BUTTONWIDTH 20
#define  BUTTONHEIGHT 20

@implementation CircleIndicatorView

@synthesize  delegate;
@synthesize label;

//-(void)dealloc
//{
//    [label release];
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        for (UIView * subView in self.subviews) 
        {
            [subView  removeFromSuperview];
        }
        CGRect subFrame=CGRectMake(0, BUTTONHEIGHT, frame.size.width-BUTTONWIDTH, frame.size.height-BUTTONHEIGHT);

        UIView *subView = [[UIView alloc] initWithFrame:subFrame] ;
        [subView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:subView];
        
        CALayer *layer= subView.layer;
        [layer setValue:(id)[UIColor blackColor].CGColor forKeyPath:@"backgroundColor"];
        [layer setValue:[NSNumber numberWithInt:20] forKeyPath:@"cornerRadius"];

        // Initialization code
        float  circleRadius = (subView.frame.size.width> subView.frame.size.height?subView.frame.size.height/2:subView.frame.size.width/2)-28;
       // NSLog(@"circleRadius:%f",circleRadius);
        circleIndicator = [[CircleIndicator alloc] initWithFrame:CGRectMake(0,0,circleRadius*2, circleRadius*2)] ;
        circleIndicator.center=CGPointMake(subView.bounds.size.width/2, subView.bounds.size.height/2);
        [subView addSubview:circleIndicator];
        //圆圈中的进度百分比
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, subView.bounds.size.width,30 )] ;
        pLabel.center=CGPointMake(subView.bounds.size.width/2, subView.bounds.size.height/2);
        [pLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        pLabel.textAlignment=NSTextAlignmentCenter;
        [pLabel setBackgroundColor:[UIColor clearColor]];
        [pLabel setTextColor:[UIColor grayColor]];
        [subView addSubview:pLabel];
        //底部的提示文本
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, subView.bounds.size.width, 30)];
        [label setFont:[UIFont boldSystemFontOfSize:16.0]];
        label.textAlignment=NSTextAlignmentCenter;
        label.center=CGPointMake(subView.bounds.size.width/2, subView.bounds.size.height-18);
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [subView addSubview:label];
        
//        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(frame.size.width-BUTTONWIDTH*2.3,BUTTONWIDTH*1.3,BUTTONWIDTH, BUTTONHEIGHT);
//        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [cancelButton setImage:[UIImage imageNamed:@"cancel_Request"] forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancelButton];

    }
    return self;
}

-(void)cancel
{
    
    UIAlertView* alertSheet = [[UIAlertView alloc] initWithTitle:@"确认" message:@"确定取消下载?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alertSheet show];
//    [alertSheet release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (delegate && [delegate respondsToSelector:@selector(cancel:)]) 
        {
            [delegate cancel:self];
        }
    }
}

- (void)setArcAngle:(float)arcAngle
{
    pLabel.text =[NSString stringWithFormat:@"%0.1f%%",floor((arcAngle/(M_PI*2))*100)];
    //NSLog(@"pLabel:%@",pLabel.text);
    circleIndicator.arcAngle=arcAngle;
    [circleIndicator setNeedsDisplay];
}



@end
