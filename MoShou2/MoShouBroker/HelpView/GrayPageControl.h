//
//  GrayPageControl.h
//  MoShou2
//
//  Created by xiaotei's on 16/2/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrayPageControl : UIPageControl

{
    
    UIImage* activeImage;
    
    UIImage* inactiveImage;
    
}

@property (nonatomic,assign)CGFloat dotWidth;
@end