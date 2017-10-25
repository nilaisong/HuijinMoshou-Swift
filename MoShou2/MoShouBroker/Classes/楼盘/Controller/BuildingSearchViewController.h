//
//  BuildingSearchViewController.h
//  MoShou2
//
//  Created by Mac on 2016/11/30.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

#import "CityFirstResult.h"

@interface BuildingSearchViewController : BaseViewController


@property (nonatomic,strong)CityFirstResult *cityFirstResult;//根据城市ID  初始化数据

/**
 默认不需要传cityid 和buildingNameArray 只有进入海外楼盘需要  其他页面会自动从缓存里面获取
 */
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,strong) NSMutableArray *buildingNameArray;  


@end
