//
//  SearchTableView.h
//  MoShouBroker
//
//  Created by caotianyuan on 15/7/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchTableView;

@protocol SearchTableViewDeleagate <NSObject>
@optional

-(void)didSelectWith:(SearchTableView*)searchTableView andKeyword:(NSString *)keyWord;


/**
 地图找房需要的传index的回调 by xiaotei
 */
-(void)didSelectWith:(SearchTableView*)searchTableView andKeyword:(NSString *)keyWord index:(NSInteger)index;

-(void)didCanCelSelect;


@end



@interface SearchTableView : UIView


@property(nonatomic,assign)BOOL isHotRecommendBuildingName;  //是否是推荐楼盘

@property(nonatomic,strong) NSArray *dataArray;

@property (nonatomic,weak)id<SearchTableViewDeleagate>delegate;

-(void)reloadTableView;




@end
