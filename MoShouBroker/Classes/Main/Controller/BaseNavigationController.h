//
//  BaseNavigationController.h
//  MoShouBroker
//
//  Created by xiaotei on 15/11/22.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseNavigationController;

@protocol BaseNavigationControllerDelegate <UINavigationControllerDelegate>

- (void)baseNavigationController:(BaseNavigationController*)controller didReturn:(NSString*)className;

@end


@interface BaseNavigationController : UINavigationController

//设置是否开启侧滑返回
@property (nonatomic,assign)BOOL popGestureRecognizerEnable;


@end
