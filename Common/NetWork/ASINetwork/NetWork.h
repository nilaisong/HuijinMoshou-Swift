//
//  NetWork.h
//  网络请求的基类
//
//  Created by Laison on 14-8-19.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "NSDictionary+JSON.h"

@interface NetWork : ASIFormDataRequest

//- (void)addDeviceHeader;
//- (id)initWithUrlString:(NSString *)urlString;
+ (id)requestWithUrlString:(NSString *)urlString;


@end
