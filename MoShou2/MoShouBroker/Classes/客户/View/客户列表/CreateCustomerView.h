//
//  CreateCustomerView.h
//  MoShou2
//
//  Created by wangzz on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^createBtnSelectedBlock)(NSString*);
typedef void(^createBtnCancelBlock)();

@interface CreateCustomerView : UIView

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) createBtnSelectedBlock didSelected;
@property (nonatomic, copy) createBtnCancelBlock didCancel;

-(void)createCustomerBlock:(createBtnSelectedBlock)ablock;
-(void)cancelCustomerBlock:(createBtnCancelBlock)ablock;

@end
