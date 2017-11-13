//
//  RotationImageView.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/8/25.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotationImageView : UIImageView
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
