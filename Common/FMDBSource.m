//
//  FMDatabase.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/12.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "FMDBSource.h"
#import "Tool.h"

@implementation FMDBSource

static FMDBSource *fmDatabase = nil;

+ (FMDBSource *)sharedFMDBSource
{
    if (!fmDatabase) {
        fmDatabase = [[FMDBSource alloc] init];
//        [fmDatabase finalize];
    }
    return fmDatabase;
}

-(void)uniqueUpdate:(NSString*)sql db:(FMDatabase*)db
{
    if (![Tool getCache:sql]) {
        [db executeUpdate:sql];
        [Tool setCache:sql value:[NSNumber numberWithBool:YES]];
    }
    
}


@end
