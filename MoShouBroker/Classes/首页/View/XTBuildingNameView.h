//
//  XTBuildingNameView.h
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportDetailBuilding.h"

typedef NS_ENUM(NSInteger,BuildingNameViewEvent) {
    BuildingNameViewEventQR
};

typedef void(^BuildingNameViewActionResult)(BuildingNameViewEvent event);

@interface XTBuildingNameView : UITableViewHeaderFooterView

@property (nonatomic,weak)ReportDetailBuilding* building;

@property (nonatomic,copy)NSString* buildingName;

+ (instancetype)buildingNameViewWith:(UITableView*)tableView;

+ (instancetype)buildingNameViewWith:(UITableView *)tableView eventCallBack:(BuildingNameViewActionResult)callBack;

@end
