//
//  SettingViewController.h
//  MoShou2
//
//  Created by Aminly on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) BOOL needUpdate;
@property(nonatomic,assign)BOOL isNew;
@property(nonatomic,strong)NSString *version;
@property(nonatomic,strong)NSString *updateMsg;
@end
