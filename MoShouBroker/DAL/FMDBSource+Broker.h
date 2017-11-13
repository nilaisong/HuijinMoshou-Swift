//
//  FMDatabaseBroker.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/12.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "FMDBSource.h"

@interface FMDBSource(Broker)
//保存楼盘历史搜索关键词
-(void)insertBuildingSearchKeyword:(NSString*)keyword;
//获取楼盘历史搜索关键词
-(NSArray*)getBuildingSearchKeywords;
//清除楼盘历史搜索关键词
-(BOOL)clearBuildingSearchKeywords;

//保存报备记录搜索关键词
-(void)insertBRSearchKeyword:(NSString*)keyword;
//获取报备记录历史搜索关键词
-(NSArray*)getBRSearchKeywords;
//清除报备记录历史搜索关键词
-(BOOL)clearBRSearchKeywords;

//清除缓存时用，删除所有历史关键词
-(BOOL)clearAllSearchKeywords;


@end
