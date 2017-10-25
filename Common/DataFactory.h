//
//  DataFactory.h
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFactory : NSObject

//应用在app store里的下载地址
@property (nonatomic,strong) NSString* appStoreDownloadUrl;

+ (DataFactory *)sharedDataFactory;

-(id)jsonObjectWithData:(NSData*)data;

-(NSString*)jsonStringWithObject:(id)object;

@end
