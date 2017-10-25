//
//  XTBuildingSearchController.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuildingListData;

@class XTBuildingSearchController;

@protocol XTBuildingSearchDelegate <NSObject>

- (void)searchViewController:(XTBuildingSearchController*)searchVC didSelecteBuildings:(NSArray*)builidngList;//BuildingListData


@end

@interface XTBuildingSearchController : BaseViewController

@property (nonatomic,weak)id<XTBuildingSearchDelegate> delegate;

@property (nonatomic,copy)NSString* searchCityId;
@property (nonatomic,strong) NSMutableArray *buildingNameArray;


@end
