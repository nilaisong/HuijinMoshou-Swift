//
//  XTNoScheduleResultView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮点击回调
typedef void(^XTNoScheduleResultViewCallBack)(UIButton* touchBtn);

@interface XTNoScheduleResultView : UIView

@property (nonatomic,copy)NSString* leftTitle;

@property (nonatomic,copy)NSString* rightTitle;

@property (nonatomic,copy)NSString* touchTitle;

- (instancetype)initWithCallBack:(XTNoScheduleResultViewCallBack)callBack;

@property (nonatomic,copy)XTNoScheduleResultViewCallBack callBack;

@end
