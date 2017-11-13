//
//  XTHomeBuildingCell.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/11/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

//区域字体,颜色
#define AreaFont [UIFont systemFontOfSize:12]
#define AreaColor [UIColor colorWithHexString:@"888888"]
#define TitleFont [UIFont boldSystemFontOfSize:16]
#define TitleColor [UIColor colorWithHexString:@"333333"]
#define PriceFont [UIFont systemFontOfSize:12]
#define PriceColor [UIColor colorWithHexString:@"ff6600"]
//佣金
#define CommissionFont [UIFont systemFontOfSize:16]

#import <UIKit/UIKit.h>
@class BuildingListData;

@interface XTHomeBuildingCell : UITableViewCell

+ (CGFloat)buildingCellHeight;

+ (instancetype)buildingCellWithTableView:(UITableView*)tableView;

+ (instancetype)buildingCellWithTableView:(UITableView *)tableView data:(BuildingListData*)listData;

@property (nonatomic,strong)BuildingListData* listData;




@end
