//
//  CustomerDetailEditView.h
//  MoShou2
//
//  Created by wangzz on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editButtonBlock)(NSInteger);
@interface CustomerDetailEditView : UIView

@property (nonatomic, copy) editButtonBlock didSelected;

-(void)createCustomerDetailBlock:(editButtonBlock)ablock;

@end
