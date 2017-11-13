//
//  BuildingDynamicMsgListCell.h
//  MoShou2
//
//  Created by Mac on 2016/12/18.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstateDynamicMsgModel.h"

#import "BuildingListData.h"
@interface BuildingDynamicMsgListCell : UITableViewCell

@property (nonatomic,strong)EstateDynamicMsgModel *msgModel;


+ (CGFloat)buildingCellHeightWithModel:(EstateDynamicMsgModel *)model;



@end
