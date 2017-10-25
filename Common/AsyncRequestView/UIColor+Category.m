//
//  UIColor+Category.m
//  Common
//
//  Created by nilaisong on 12-8-9.
//  Copyright (c) 2012年 artron. All rights reserved.
//

#import "UIColor+Category.h"
#import "Functions.h"
//#import "SuperView.h"
#import <objc/runtime.h>
@implementation UIColor(Category)

+ (UIColor *)colorWithString:(NSString *)rgba{
    UIColor *color = nil;
//    NSLog(@"#########bg -> %@",rgba);
    if (rgba.length>0)
    {
        NSArray *colors = [rgba componentsSeparatedByString:@","];
        if ([colors count] == 4) {
            
            float _red = [[colors objectAtIndex:0] floatValue];
            float _greed = [[colors objectAtIndex:1] floatValue];
            float _blue = [[colors objectAtIndex:2] floatValue];
            float _alpha = [[colors objectAtIndex:3] floatValue];
            
            if ( _red > 1)   _red = (float)(_red / 255.0);
            if ( _blue > 1)  _blue = (float)(_blue / 255.0);
            if ( _greed > 1) _greed = (float)(_greed / 255.0);
            
            color = [UIColor colorWithRed:_red green:_greed blue:_blue alpha:_alpha];
            
            //        NSLog(@"BGColor -> red:%f greed:%f blue:%f alpha:%f" ,_red,_greed,_blue,_alpha);
        }else {
            color = [UIColor whiteColor];
        }
    }
    
    return color; 
}


@end