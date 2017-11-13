//
//  EditCustomerView.h
//  MoShou2
//
//  Created by wangzz on 15/12/2.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnSelectedBlock)(NSInteger);

@interface EditCustomerView : UIView

@property (nonatomic, copy) btnSelectedBlock didSelectedAtIndex;

-(void)editCustomerBlock:(btnSelectedBlock)ablock;

@end
