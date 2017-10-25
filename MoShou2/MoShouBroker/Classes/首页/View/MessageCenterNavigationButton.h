//
//  MessageCenterNavigationButton.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterNavigationButton : UIButton

- initWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage;

+ messageCenterButtonWithNormalImage:(NSString*)normalImage selecgtedImage:(NSString*)selectedImage;


@end
