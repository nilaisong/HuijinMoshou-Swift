//
//  CustomAnnotationView.m
//  MoShouBroker
//
//  Created by admin on 15/7/13.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "CustomAnnotationView.h"


#define kCalloutWidth       300.0
#define kCalloutHeight      60.0
#define  Arror_height       6


@implementation CustomAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {

        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -65);
        self.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight-Arror_height)];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat jianWidth = 8;
    CGFloat jianHeight = 6;
    
    UIColor* backColor = [UIColor whiteColor];
 
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextFillRect(context, rect);
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - jianHeight) cornerRadius: 5];
    [backColor setFill];
    [rectanglePath fill];
    [UIColorFromRGB(0x888888) setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    //    UIGraphicsGetCurrentContext();
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake((width - jianWidth)/2.0, height - jianHeight - 0.5)];
    [bezierPath addLineToPoint: CGPointMake((width)/2.0, height)];
    [bezierPath addLineToPoint: CGPointMake((width + jianWidth)/2.0, height - jianHeight - 0.5)];
    [bezierPath moveToPoint: CGPointMake((width - jianWidth)/2.0, height - jianHeight - 0.5)];
    [bezierPath closePath];
    [backColor setFill];
    [bezierPath fill];
    [UIColorFromRGB(0x888888) setStroke];
    bezierPath.lineWidth = 0.5;
    [bezierPath stroke];
}

-(void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    //    CGContextSetLineWidth(context, 1.0);
    //     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//        [self getDrawPath:context];
    //    CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

//- (void)drawRect:(CGRect)rect
//{
//    [self drawInContext:UIGraphicsGetCurrentContext()];
//    
//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//}



@end
