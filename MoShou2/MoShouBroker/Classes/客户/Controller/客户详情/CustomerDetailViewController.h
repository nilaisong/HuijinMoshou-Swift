//
//  CustomerDetailViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

@interface CustomerDetailViewController : BaseViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSString *custId;//前一页面传递的客户id

@end
