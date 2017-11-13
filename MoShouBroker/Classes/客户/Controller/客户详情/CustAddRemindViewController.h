//
//  CustAddRemindViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "Customer.h"

@interface CustAddRemindViewController : BaseViewController

@property (nonatomic, strong) Customer         *custList;
@property (nonatomic, weak) NSDateFormatter    *inputFormatter;

@end
