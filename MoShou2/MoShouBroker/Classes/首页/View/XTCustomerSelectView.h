//
//  XTCustomerSelectView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XTCustomerSelectView;

typedef void(^XTCustomerSelectViewEventCallBack)(XTCustomerSelectView* customerSelect);

@interface XTCustomerSelectView : UIView

- (instancetype)initWithEventCallBack:(XTCustomerSelectViewEventCallBack)callBack;


@property (nonatomic,copy)XTCustomerSelectViewEventCallBack callBack;

@property (nonatomic,weak)UILabel* customerNameLabel;

@property (nonatomic,weak)UILabel* customerPhoneNumberLabel;

@property (nonatomic,weak)NSString* sexString;

- (void)reloadView;

@end
