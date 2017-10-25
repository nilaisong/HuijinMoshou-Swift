//
//  CustomerCopyPhoneView.h
//  MoShou2
//
//  Created by wangzz on 16/5/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^copyBtnSelectedBlock)(NSInteger);
//typedef void(^copyCancelBtnBlock)();

@interface CustomerCopyPhoneView : UIView

@property (nonatomic, strong) NSArray *phoneArray;
@property (nonatomic, copy) copyBtnSelectedBlock didCopyPhone;
//@property (nonatomic, copy) copyCancelBtnBlock didCancel;

-(void)copyCustomerPhoneBlock:(copyBtnSelectedBlock)ablock;
//-(void)copyCancelViewBlock:(copyCancelBtnBlock)ablock;

@end
