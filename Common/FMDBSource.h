//
//  FMDatabase.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/12.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBSource : NSObject
{
    FMDatabaseQueue* dbQueue;
}
+ (FMDBSource *)sharedFMDBSource;
//同样的sql语句仅执行一次
-(void)uniqueUpdate:(NSString*)sql db:(FMDatabase*)db;

@end
