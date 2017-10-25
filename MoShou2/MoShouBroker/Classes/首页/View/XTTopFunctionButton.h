//
//  XTTopFunctionButton.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
/**
 顶部工具栏按钮
 */

#import <UIKit/UIKit.h>

#define TitleLabelFont [UIFont systemFontOfSize:13]

#define TitleLableColor [UIColor colorWithHexString:@"333333"]

@interface XTTopFunctionButton : UIButton

- (instancetype)initWithTitle:(NSString*)title normalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage;

+ (instancetype)topFunctionButtonWithTitle:(NSString*)title normalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage;

@end
