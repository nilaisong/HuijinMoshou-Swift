//
//  UILabel+StringFrame.m
//  MoShouBroker
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "UILabel+StringFrame.h"
#import "UIView+YR.h"
@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
-(void)autoLayoutWithFrame:(CGRect)frame{
    self.numberOfLines = 0;
    self.font = [UIFont systemFontOfSize:14.f];
    self.textAlignment = NSTextAlignmentLeft;
    CGSize contentSize = [ self boundingRectWithSize:CGSizeMake(self.frame.size.width, 0)];
    self.frame = CGRectMake(frame.size.width/2-contentSize.width/2,frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kFrame_YHeight(self));
}
-(void)autoLayoutWithFrame:(CGRect)frame andFontSize:(float)size{
    self.numberOfLines = 0;
    self.font = [UIFont systemFontOfSize:size];
    self.textAlignment = NSTextAlignmentLeft;
    CGSize contentSize = [ self boundingRectWithSize:CGSizeMake(frame.size.width, 0)];
    self.frame = CGRectMake(frame.size.width/2-contentSize.width/2,frame.size.height/2-contentSize.height/2, contentSize.width, contentSize.height);
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kFrame_YHeight(self));


}
-(void)autoWithFrame:(CGRect)frame andFontSize:(float)size{
    self.numberOfLines = 0;
    self.font = [UIFont systemFontOfSize:size];
    self.textAlignment = NSTextAlignmentLeft;
    CGSize contentSize = [self boundingRectWithSize:CGSizeMake(frame.size.width, 0)];
    self.frame = CGRectMake(frame.origin.x, frame.origin.y,contentSize.width, contentSize.height);
//    NSLog(@"-----%f---%f",contentSize.width,frame.size.height);
    
}

-(id)initWithPoint:(CGPoint)point andText:(NSString *)text andFontSize:(CGFloat)size{
    if (self =[super init]) {
        self.size =[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
        [self setText:text];
        [self setFont:[UIFont systemFontOfSize:size]];
        self.frame = CGRectMake(point.x, point.y, self.size.width, self.size.height);
    }
    
    return  self;
}



#pragma mark - For UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    if (fontSize > 0) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
{
    UILabel *label = [self createLabelWithFrame:frame text:text textAlignment:textAlignment fontSize:fontSize];
    label.textColor = textColor;
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)bgColor
{
    UILabel *label = [self createLabelWithFrame:frame text:text textAlignment:textAlignment fontSize:fontSize textColor:textColor];
    label.backgroundColor = bgColor;
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                    textAlignment:(NSTextAlignment)textAlignment
                         fontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)bgColor
                     cornerRadius:(CGFloat)cornerRadius
{
    UILabel *label = [self createLabelWithFrame:frame text:text textAlignment:textAlignment fontSize:fontSize textColor:textColor bgColor:bgColor];
    if (cornerRadius > 0) {
        label.clipsToBounds = YES;
        label.layer.cornerRadius = cornerRadius;
    }
    return label;
}




+ (UILabel *)createDeleteLabelWithFrame:(CGRect)frame
                                   text:(NSString *)text
                          textAlignment:(NSTextAlignment)textAlignment
                              textColor:(UIColor *)textColor
                               fontSize:(CGFloat)fontSize;

{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    if (fontSize > 0) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    
    CGSize size =  [label boundingRectWithSize:CGSizeMake(frame.size.width, frame.size.height)];
    label.width = size.width;
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, label.height/2-1, label.width, 1)];
    lineLabel.backgroundColor = textColor;
    [label addSubview:lineLabel];
    
    
    
    return label;

    



}



@end

