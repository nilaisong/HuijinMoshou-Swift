//
//  PointDetailsViewController.h
//  MoShou2
//
//  Created by Aminly on 15/12/1.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

@interface PointDetailsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSMutableArray *pointDetailList;
@property(nonatomic,assign)BOOL morePage;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)int page;

@end
