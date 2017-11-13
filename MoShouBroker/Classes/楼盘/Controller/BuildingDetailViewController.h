//
//  BuildingDetailViewController.h
//  MoShou2
//
//  Created by strongcoder on 15/12/2.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "Building.h"
@interface BuildingDetailViewController : BaseViewController

@property (nonatomic,copy)NSString *buildingId;

@property (nonatomic,strong)Building *caCheBuildingMo;

@property (nonatomic,copy)NSString *eventId;  //来源ID 
@property(nonatomic,copy) NSString* buildDistance;//距离



@end
