//
//  AFHttpRequestManager.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/9/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+JSON.h"
#import "AFHTTPSessionManager.h"

typedef void (^ASIBasicBlock)(void);
typedef void (^AFHTTPRequestSuccess)(NSURLSessionDataTask* task, id responseObject);
typedef void (^AFHTTPRequestFailure)(NSURLSessionDataTask* task, NSError *error);

@interface AFRequest :AFHTTPSessionManager
{
    
}
+(instancetype)managerWithBaseKey:(NSString*)key;
//- (NSURLSessionDataTask *)syncPost:(NSString *)url  //只需传url后缀
//                            parameters:(id)parameters
//                           success:(AFHTTPRequestSuccess)success
//                           failure:(AFHTTPRequestFailure)failure;


@end
