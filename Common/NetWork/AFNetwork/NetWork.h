//
//  AFHttpRequestManager.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/9/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+JSON.h"
//#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

#define kAFHTTPRequestFailure @"kAFHTTPRequestFailure"
#define kAFHTTPRequestSuccess @"kAFHTTPRequestSuccess"

typedef void (^ASIBasicBlock)(void);
typedef void (^AFHTTPRequestSuccess)(NSURLSessionDataTask* task, id responseObject);
typedef void (^AFHTTPRequestFailure)(NSURLSessionDataTask* task, NSError *error);

@interface NetWork :AFHTTPSessionManager
//AFHTTPRequestOperationManager
{
    
}
/*
//block to execute when request completes successfully
@property (nonatomic,copy) ASIBasicBlock completionBlock;
//block to execute when request fails
@property (nonatomic,copy) ASIBasicBlock failedBlock;

@property (nonatomic,strong) NSMutableDictionary* parameters;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSDictionary* responseObject;
@property (nonatomic,strong) NSData* responseData;
@property (nonatomic,strong) NSString* responseString;

+ (instancetype)requestWithBaseUrl:(NSString*)baseUrl;
+ (instancetype)requestWithUrlString:(NSString *)urlString;//只需传url后缀
*/
+(instancetype)managerWithBaseKey:(NSString*)key;
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)syncPost:(NSString *)url  //只需传url后缀
                            parameters:(id)parameters
                           success:(AFHTTPRequestSuccess)success
                           failure:(AFHTTPRequestFailure)failure;
//- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key;
//- (void)startAsynchronous;
//- (void)startSynchronous;

@end
