//
//  XTPageControl.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/11/30.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTPageControl : UIPageControl
{
    
    UIImage* activeImage;
    
    UIImage* inactiveImage;
    
}

@property (nonatomic,assign)CGFloat dotWidth;
@end
