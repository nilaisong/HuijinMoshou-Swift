//
//  XTRemindTimeView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTRemindTimeView;

typedef void(^XTRemindTimeViewEventCallBack)(XTRemindTimeView* timeView);

@interface XTRemindTimeView : UIView

- (instancetype)initWithCallBack:(XTRemindTimeViewEventCallBack)callBack;

@property (nonatomic,copy)XTRemindTimeViewEventCallBack callBack;

@property (nonatomic,strong)NSDate* selectedDate;

@property (nonatomic,copy)NSString* dateStr;

@end
