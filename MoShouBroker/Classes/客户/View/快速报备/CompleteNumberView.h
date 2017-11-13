//
//  CompleteNumberView.h
//  MoShou2
//
//  Created by wangzz on 16/5/11.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteNumTextField.h"

typedef void(^completeTextFieldBlock)(NSInteger);

@interface CompleteNumberView : UIView <UITextFieldDelegate>

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel      *firstNum;
@property (nonatomic, strong) CompleteNumTextField  *middleNum;
@property (nonatomic, strong) UILabel      *tailNum;
@property (nonatomic, assign) NSInteger    index;

@property (nonatomic, copy) completeTextFieldBlock didChangeAtIndex;     //block

- (void)completeTextFieldDidChangedBlock:(completeTextFieldBlock)ablock;

@end
