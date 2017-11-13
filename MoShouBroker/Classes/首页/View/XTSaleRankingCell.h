//
//  XTSaleRankingCell.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/19.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTSaleRankingCell : UITableViewCell

+ (instancetype)saleRankingCellWithTableView:(UITableView*)tableView;

//排名模型
@property (nonatomic,strong)id rankingModel;

@end
