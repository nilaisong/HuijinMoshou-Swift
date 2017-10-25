//
//  CustomerSelectViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFactory+Customer.h"

typedef void (^CustomerSelectBlock) (Customer*);

@interface CustomerSelectViewController : BaseViewController

@property(copy,nonatomic)CustomerSelectBlock custoemrSelectBlock;//传参block块

-(void)returnCustoemrResultBlock:(CustomerSelectBlock)ablock;

@end
