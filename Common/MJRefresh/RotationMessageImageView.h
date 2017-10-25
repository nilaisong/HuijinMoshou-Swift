//
//  RotationMessageImageView.h
//  MoShou2
//
//  Created by wangzz on 2016/10/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotationMessageImageView : UIImageView

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
