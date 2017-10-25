//
//  XTEditCustomerView.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTEditCustomerView;

typedef NS_ENUM(NSUInteger,XTEditCustomerViewSex){
    XTEditCustomerViewSexMan,
    XTEditCustomerViewSexWoMan
};

typedef void(^XTEditCustomerViewEventCallBack)(XTEditCustomerView* view,XTEditCustomerViewSex sex);

@interface XTEditCustomerView : UIView
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
+ (instancetype)editCustomerView;

+ (instancetype)editCustomerViewWithCallBack:(XTEditCustomerViewEventCallBack)callBack;
@property (nonatomic,copy)XTEditCustomerViewEventCallBack callBack;

@end
