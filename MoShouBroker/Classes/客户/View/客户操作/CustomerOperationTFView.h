//
//  CustomerOperationTFView.h
//  MoShou2
//
//  Created by wangzz on 16/4/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTextField.h"
@protocol CustomerOperationTFViewDelegate <NSObject>

@optional

- (void)firstNumTextFieldDidChanged;
- (void)tailNumTextFieldDidChanged;

@end
@interface CustomerOperationTFView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) id<CustomerOperationTFViewDelegate>delegate;
@property (nonatomic, strong) CustomerTextField    *firstNum;
@property (nonatomic, strong) CustomerTextField    *tailNum;
@property (nonatomic, strong) UILabel        *middleNum;
@end
