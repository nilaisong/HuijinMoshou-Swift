//
//  XTIncomeDetailsCell.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTIncomeModel.h"

@interface XTIncomeDetailsCell : UITableViewCell

+ (instancetype)incomeDetailsCellWithTableView:(UITableView*)tableView;

//收入明细模型
@property (nonatomic,strong)XTIncomeModel* incomeModel;

@end
