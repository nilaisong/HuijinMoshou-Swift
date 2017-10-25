//
//  CreateCallView.h
//  MoShou2
//
//  Created by wangzz on 16/5/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBtnSelectedBlock)(NSInteger);
typedef void(^cancelBtnBlock)();

@interface CreateCallView : UIView

@property (nonatomic, strong) NSArray *telArray;
@property (nonatomic, copy) callBtnSelectedBlock didSelectedCall;
@property (nonatomic, copy) cancelBtnBlock didCancel;

-(void)callCustomerBlock:(callBtnSelectedBlock)ablock;
-(void)cancelViewBlock:(cancelBtnBlock)ablock;

@end
