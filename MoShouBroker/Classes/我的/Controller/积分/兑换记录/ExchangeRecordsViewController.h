//
//  ExchangeRecordsViewController.h
//  MoShou2
//
//  Created by Aminly on 15/11/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

@interface ExchangeRecordsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *exchangeTable;
@property(nonatomic ,assign)int page;
@property(nonatomic,strong)NSMutableArray *exchangeListArr;
@property(nonatomic,assign)BOOL morePage;
@end
