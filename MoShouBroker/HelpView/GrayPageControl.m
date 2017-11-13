//
//  GrayPageControl.m
//  MoShou2
//
//  Created by xiaotei's on 16/2/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "GrayPageControl.h"

@implementation GrayPageControl
-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    
    activeImage = [UIImage imageNamed:@"pagedot_current"];
    
    inactiveImage = [UIImage imageNamed:@"pagedot_other"];
    
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
        
        size.height = self.dotWidth;     //自定义圆点的大小
        
        size.width = self.dotWidth;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        UIImageView * imaegView = nil;
        [dot removeAllSubviews];
        if(i==self.currentPage){
            imaegView = [[UIImageView alloc]initWithImage:activeImage];
        }else imaegView = [[UIImageView alloc]initWithImage:inactiveImage];
        
        [dot addSubview:imaegView];
//        else dot.image=inactiveImage;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = (self.frame.size.width - self.subviews.count * self.dotWidth) / (self.subviews.count - 1);
    for (int i=0; i<[self.subviews count]; i++) {
        CGSize size;
        
        size.height = self.dotWidth;     //自定义圆点的大小
        
        size.width = self.dotWidth;      //自定义圆点的大小
        UIView* dot = [self.subviews objectForIndex:i];
        [dot setFrame:CGRectMake(i * margin + i * size.width, dot.frame.origin.y, size.width, size.width)];
    }
}

-(void) setCurrentPage:(NSInteger)page

{
//    [self setNeedsLayout];
    if (self.subviews.count == page + 1) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

- (CGFloat)dotWidth{
    if (_dotWidth == 0) {
        return 15;
    }
    return _dotWidth;
}

@end
