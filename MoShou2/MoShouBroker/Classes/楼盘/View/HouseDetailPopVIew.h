//
//  HouseDetailPopVIew.h
//  MoShou2
//
//  Created by strongcoder on 15/12/8.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"
#import "Estate.h"
typedef enum {
    kHouseDetail,  //楼盘详情
    kCommissionRule,//佣金规则
    kCooperationRule  // 合作规则
}viewType;

@interface HouseDetailPopVIew : UIView
@property (nonatomic,assign)viewType viewType;
@property (nonatomic,strong)UIScrollView * bgScrollView;
@property (nonatomic,strong)Building *buildingMo;
@property (nonatomic,strong)Estate * estateBuildingMo;




-(id)initWithType:(viewType)viewType AndBuilding:(Building *)building;



@end
