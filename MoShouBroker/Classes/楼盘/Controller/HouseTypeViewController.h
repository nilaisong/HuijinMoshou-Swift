//
//  HouseTypeViewController.h
//  MoShouBroker
//
//  Created by strongcoder on 15/7/16.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "RoomLayout.h"
#import "Building.h"

typedef enum
{
    kSpecialPriceBuilding,
    kAllBuilding
}buildingType;

@interface HouseTypeViewController : BaseViewController
@property (nonatomic,strong)Building *building;

@property (nonatomic,assign)NSInteger currentIndex;   //当前户型详情在总数组中的位置索引

@property (nonatomic, assign) buildingType  vcType;

@end
