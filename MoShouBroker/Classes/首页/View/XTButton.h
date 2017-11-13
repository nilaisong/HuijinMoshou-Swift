//
//  XTButton.h
//  QudaoTuozhan
//
//  Created by xiaotei's on 16/6/14.
//  Copyright © 2016年 NiLaisong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+StateColor.h"

@interface XTButton : UIButton

//设置是否点击变色
@property (nonatomic,assign)BOOL showHighlight;

- (instancetype)initWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage imageFrame:(CGRect)rect;
- (instancetype)initWithNormalImage:(NSString*)normalImage highlightImage:(NSString*)highlightImage imageFrame:(CGRect)rect;

@end
