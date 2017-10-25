//
//  XTHelpView.h
//  MoShou2
//
//  Created by xiaotei's on 16/3/2.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTHelpView : UIView

@property (nonatomic,copy)NSString* imageName;

@property (nonatomic,assign)CGFloat buttonY;

+ (instancetype)helpViewWithImageName:(NSString*)imageName buttonY:(CGFloat)buttonY;

@end
