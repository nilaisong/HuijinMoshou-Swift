//
//  XTPageControl.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/11/30.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTPageControl.h"

@implementation XTPageControl

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    
    activeImage = [UIImage imageNamed:@"切换蓝"];
    
    inactiveImage = [UIImage imageNamed:@"切换灰"];
    
    self.backgroundColor =[UIColor clearColor];
    return self;
    
}


-(void) updateDots

{
    //    CGFloat margin = (self.frame.size.width - self.subviews.count * 20) / (self.subviews.count - 1);
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIView* dot = [self.subviews objectForIndex:i];
        dot.backgroundColor = [UIColor clearColor];
        CGSize size;
        
        size.height = 2.5;     //自定义圆点的大小
        
        size.width = self.dotWidth;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        UIImageView * imaegView = nil;
        [dot removeAllSubviews];
        if(i==self.currentPage){
            imaegView = [[UIImageView alloc]initWithImage:activeImage];
        }else imaegView = [[UIImageView alloc]initWithImage:inactiveImage];
        imaegView.frame = CGRectMake(0, 0, self.dotWidth, 2.5);
        [dot addSubview:imaegView];
        //        else dot.image=inactiveImage;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat margin = 7.5;
    if (self.subviews.count <= 1) {
        margin = 0.0f;
    }
    
    CGFloat allWidth = self.dotWidth * self.subviews.count + (7.5 * self.subviews.count - 1);
    CGFloat startY = (self.width - allWidth)/2.0;
    for (int i=0; i<[self.subviews count]; i++) {
        CGSize size;
        
        size.height = 2.5;     //自定义圆点的大小
        
        size.width = self.dotWidth;      //自定义圆点的大小
        UIView* dot = [self.subviews objectForIndex:i];
        [dot setFrame:CGRectMake(i * margin + i * size.width + startY,0, dot.width, dot.height)];
        
    }
}

-(void) setCurrentPage:(NSInteger)page

{
    [self setNeedsLayout];
//    if (self.subviews.count == page + 1) {
//        self.hidden = YES;
//    }else{
//        self.hidden = NO;
//    }
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

- (CGFloat)dotWidth{
    if (_dotWidth == 0) {
        return 20;
    }
    return _dotWidth;
}


@end
