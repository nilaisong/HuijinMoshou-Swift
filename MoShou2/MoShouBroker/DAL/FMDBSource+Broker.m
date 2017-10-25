//
//  FMDatabaseBroker.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/12.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "FMDBSource+Broker.h"
@implementation FMDBSource(Broker)

//重写init方法
- (instancetype)init
{
    if (self = [super init])
    {
        NSString* dbPath = kPathOfDocument(@"data.sqlite");
        NSLog(@"%@",dbPath);
        if (!dbQueue) {
            dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        }
        [dbQueue inDatabase:^(FMDatabase *db)
         {
             NSString* sql1 = @"CREATE TABLE [keywords_history_building] (id integer NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,keyword varchar,count integer DEFAULT 1,datetime timestamp NOT NULL DEFAULT (datetime('now','localtime')))";
             [self uniqueUpdate:sql1 db:db];
             
             NSString* sql2 = @"CREATE TABLE [keywords_history_br] (id integer NOT NULL PRIMARY KEY AUTOINCREMENT DEFAULT 1,keyword varchar,count integer DEFAULT 1,datetime timestamp NOT NULL DEFAULT (datetime('now','localtime')))";
             [self uniqueUpdate:sql2 db:db];
         }];

    }
    return self;
}

#pragma -楼盘历史搜索关键词
-(void)insertBuildingSearchKeyword:(NSString*)keyword
{
    [dbQueue inDatabase:^(FMDatabase *db)
     {
         NSString* sql1 = [NSString stringWithFormat:@"select * from [keywords_history_building] where keyword='%@'",keyword];
         FMResultSet *result = [db executeQuery:sql1];
         if ([result next])
         {
             NSString* sql2 = [NSString stringWithFormat:@"update  [keywords_history_building]  set count=(count+1),datetime = datetime('now','localtime') where keyword='%@'",keyword];
             [db executeUpdate:sql2];
         }
         else
         {
            NSString* sql3 = [NSString stringWithFormat:@"insert into [keywords_history_building](keyword) values(?)"];
             [db executeUpdate:sql3,keyword];
         }
         [result close];

     }];
}

-(NSArray*)getBuildingSearchKeywords
{
    NSMutableArray* array = [NSMutableArray array];
    
    [dbQueue  inDatabase:^(FMDatabase *db)
     {
         
         NSString* sql = [NSString stringWithFormat:@"delete from [keywords_history_building] where id not in (select id from [keywords_history_building] order by id desc limit 0,5)"];
         [db executeUpdate:sql];
         
         NSString* sql1 = [NSString stringWithFormat:@"select keyword from [keywords_history_building] order by count desc,datetime desc"];
         FMResultSet * result = [db executeQuery:sql1];
         while ([result next])
         {
             NSString* keyword = [result stringForColumnIndex:0];
             [array addObject:keyword];
         }
         [result close];
     }];
    return array;
}

-(BOOL)clearBuildingSearchKeywords
{
    __block BOOL flag;
    [dbQueue  inDatabase:^(FMDatabase *db)
     {
         NSString* sql1 = [NSString stringWithFormat:@"delete from [keywords_history_building]"];
        flag = [db executeUpdate:sql1];

     }];
    return flag;
}

#pragma -报备记录历史搜索关键词
-(void)insertBRSearchKeyword:(NSString*)keyword
{
    [dbQueue inDatabase:^(FMDatabase *db)
     {
         NSString* sql1 = [NSString stringWithFormat:@"select * from [keywords_history_br] where keyword='%@'",keyword];
         FMResultSet *result = [db executeQuery:sql1];
         if ([result next])
         {
             NSString* sql2 = [NSString stringWithFormat:@"update  [keywords_history_br]  set count=(count+1),datetime = datetime('now','localtime') where keyword='%@'",keyword];
             [db executeUpdate:sql2];
         }
         else
         {
             NSString* sql3 = [NSString stringWithFormat:@"insert into [keywords_history_br](keyword) values(?)"];
             [db executeUpdate:sql3,keyword];
         }
         [result close];
         
     }];
}

-(NSArray*)getBRSearchKeywords
{
    NSMutableArray* array = [NSMutableArray array];
    
    [dbQueue  inDatabase:^(FMDatabase *db)
     {
         
         NSString* sql = [NSString stringWithFormat:@"delete from [keywords_history_br] where id not in (select id from [keywords_history_br] order by id desc limit 0,5)"];
         [db executeUpdate:sql];
         
         NSString* sql1 = [NSString stringWithFormat:@"select keyword from [keywords_history_br] order by count desc,datetime desc"];
         FMResultSet * result = [db executeQuery:sql1];
         while ([result next])
         {
             NSString* keyword = [result stringForColumnIndex:0];
             [array addObject:keyword];
         }
         [result close];
     }];
    return array;
}

-(BOOL)clearBRSearchKeywords
{
    __block BOOL flag;
    [dbQueue  inDatabase:^(FMDatabase *db)
     {
         NSString* sql1 = [NSString stringWithFormat:@"delete from [keywords_history_br]"];
         flag = [db executeUpdate:sql1];
         
     }];
    return flag;
}

-(BOOL)clearAllSearchKeywords
{
    __block BOOL flag;
    [dbQueue  inDatabase:^(FMDatabase *db)
     {
         [db beginTransaction];
         
         NSString* sql1 = [NSString stringWithFormat:@"delete from [keywords_history_br]"];
         [db executeUpdate:sql1];
         NSString* sql2 = [NSString stringWithFormat:@"delete from [keywords_history_building]"];
         [db executeUpdate:sql2];
         
         flag = [db commit];
     }];
    return flag;
}
@end
