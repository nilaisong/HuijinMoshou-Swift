//
//  CountDownView.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountDownView;
typedef void(^CountDownEventBlock)(CountDownView* countdown,UIButton* button);

@interface CountDownView : UIView

- (instancetype)initWithCallBack:(CountDownEventBlock)callBack;

@property (nonatomic,copy)CountDownEventBlock callBack;

@property (nonatomic,assign)NSInteger number;
@end
