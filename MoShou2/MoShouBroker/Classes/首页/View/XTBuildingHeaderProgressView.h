//
//  XTBuildingHeaderProgressView.h
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportDetailBuilding;
@class ProgressStatus;
typedef NS_ENUM(NSInteger,BuildingHeaderProgressViewEvent) {
    BuildingHeaderProgressViewEventOpen,
    BuildingHeaderProgressViewEventTap
};

typedef void(^BuildingHeaderProgressViewActionResult)(BuildingHeaderProgressViewEvent event,NSInteger section,UIButton*   button);

@interface XTBuildingHeaderProgressView : UITableViewHeaderFooterView

+ (instancetype)buildingHeaderProgressViewWith:(UITableView*)tableView;

+ (instancetype)buildingHeaderProgressViewWith:(UITableView *)tableView eventCallBack:(BuildingHeaderProgressViewActionResult)callBack;

//进度模型
//@property (nonatomic,strong)NSArray* progressArray;

@property (nonatomic,strong)ProgressStatus* status;


@property (nonatomic,assign)NSInteger section;

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,assign)BOOL isLast;

@end
