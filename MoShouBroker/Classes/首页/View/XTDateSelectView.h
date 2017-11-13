//
//  XTDateSelectView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTDateSelectView;

typedef void(^XTDateSelectViewEventCallBack)(XTDateSelectView* view,NSDate* selectedDate);

@interface XTDateSelectView : UIView

- (instancetype)initWithEventCallBack:(XTDateSelectViewEventCallBack)callBack;

@property (nonatomic,copy)XTDateSelectViewEventCallBack callBack;

@property (nonatomic,strong)NSDate* selectedDate;

@end
