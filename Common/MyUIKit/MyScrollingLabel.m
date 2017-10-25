//
//  MyScrollingLabel.m
//  MarqueeLabel
//
//  Created by nilaisong on 13-9-9.
//  Copyright (c) 2013年 app. All rights reserved.
//

#import "MyScrollingLabel.h"

@interface MyScrollingLabel ()

@end

@implementation MyScrollingLabel

@synthesize subLabel,text;
@synthesize textAlignment,font,textColor;
@synthesize animationInterval;

-(void)dealloc
{
    self.subLabel = nil;
    self.text = nil;
    self.textColor = nil;
    self.font = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setClipsToBounds:YES];
        self.animationInterval=5.0;
    }
    return self;
}

-(void)setFrame:(CGRect)newFrame
{

    if (self.frame.size.width!=newFrame.size.width)
    {
        super.frame = newFrame;
        [self resetLabel];
    }
    else{
         super.frame = newFrame;
    }

}

-(void)setFont:(UIFont *)_font
{
    if (font!=_font)
    {
        [font release];
        font = [_font retain];
    }
    [self resetLabel];
}

-(void)setText:(NSString *)_text
{
    // Set labelText to incoming newText
    if (![_text isEqualToString:text])
    {
        [text release];
        text = [_text retain];
        [self resetLabel];
    }
}

-(void)setTextAlignment:(NSTextAlignment)_textAlignment
{
    if (textAlignment!=_textAlignment)
    {
        textAlignment = _textAlignment;
        if (subLabel) {
            subLabel.textAlignment= textAlignment;
        }
    }
}

-(void)setTextColor:(UIColor *)_textColor
{
    if (textColor!=_textColor)
    {
        [textColor release];
        textColor = [_textColor retain];
        if (subLabel) {
            subLabel.textColor= textColor;
        }
    }
}

-(void)resetLabel
{
    // Create sublabel
    subLabel.tag = 2;
    [subLabel removeFromSuperview];
    UILabel *newLabel = [[UILabel alloc] initWithFrame:self.bounds];
    newLabel.tag = 1;
    self.subLabel = newLabel;
    self.subLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.subLabel];
    [newLabel release];

    subLabel.font = font;
    subLabel.text = text;
    subLabel.textAlignment = textAlignment;
    subLabel.textColor = textColor;
    // Calculate label size
    CGSize maximumLabelSize = CGSizeMake(9999, self.frame.size.height);
    CGSize expectedLabelSize = [self.subLabel.text sizeWithFont:subLabel.font
                                              constrainedToSize:maximumLabelSize
                                                  lineBreakMode:subLabel.lineBreakMode];
    if (expectedLabelSize.width>self.bounds.size.width)
    {
        // Create home label frame
        homeLabelFrame = CGRectMake(0, 0, expectedLabelSize.width, self.bounds.size.height);
        awayLabelFrame = CGRectOffset(homeLabelFrame, -expectedLabelSize.width + self.bounds.size.width, 0.0);
        self.subLabel.frame =homeLabelFrame;
        [self scrollLeftWithLabel:subLabel];
    }
    else
    {
        self.subLabel.frame = self.bounds;
    }
}

- (void)scrollLeftWithLabel:(UILabel*)label{
    if (self.superview && label.tag==1)
    {
        // Perform animation
//        NSLog(@"label:%@",label);
//        NSLog(@"animationInterval:%f",animationInterval);
        [UIView animateWithDuration:animationInterval
                              delay:2.0
                            options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             label.frame = awayLabelFrame;
                        }
                        completion:^(BOOL finished)
                        {
                            [UIView animateWithDuration:2.0 animations:^{
                                label.alpha = 0;
                            }
                            completion:^(BOOL finished)
                            {
                                  label.alpha = 1;
                                  label.frame = homeLabelFrame;
                                  [self scrollLeftWithLabel:label];
                              }];
                        }];
    
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
