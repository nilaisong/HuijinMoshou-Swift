//
//  XTTrendDirectionImageView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

/**
 *  上升与下降箭头
 */

//箭头方向
typedef NS_ENUM(NSInteger,XTTrendDirection) {
    XTTrendDirectionUp,
    XTTrendDirectionDown,
    XTTrendDirectionFair,//持平
};

#import <UIKit/UIKit.h>

@interface XTTrendDirectionImageView : UIImageView

//箭头指向，默认向上
@property (nonatomic,assign)XTTrendDirection direction;

//上升与下降图片名字
@property (nonatomic,copy)NSString* upImageName;
@property (nonatomic,copy)NSString* downImageName;

@end
