//
//  XTImageCountTipsView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 17/1/9.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CountTipsViewType) {
    CountTipsViewTypeOnImage,//在图片上边
    CountTipsViewTypeBottomImage,//在图片下边
};

@interface XTImageCountTipsView : UIView

@property (nonatomic,copy)NSString* titleString;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,assign)NSInteger totalNumber;

@property (nonatomic,assign)CountTipsViewType type;

@end
