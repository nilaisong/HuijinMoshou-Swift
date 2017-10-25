//
//  NetworkSingleton.h
//  与网络相关的一些处理接口
//
//  Created by Laison on 12-2-22.
//  Copyright 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSReachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LocalFileSystem.h"

#define kTimeOutSeconds 30

#define kBaseURL [LocalFileSystem sharedManager].baseURL

//#define kSuffixUrlByKey(key) [[LocalFileSystem sharedManager].suffixUrlDic objectForKey:key]
//#define kFullUrlByKey(key) [NSString stringWithFormat:@"%@/%@", kBaseURL,kSuffixUrlByKey(key)]

#define kFullUrlWithSuffix(suffixUrl) [NSString stringWithFormat:@"%@/%@", kBaseURL,suffixUrl]

typedef void(^HandleVersionUpdate)(BOOL isnew, NSString* message,BOOL mustUpdate,NSString* newVersion);

@protocol NetworkSingletonDelegate <NSObject>

-(void)updateDataProgress:(NSNumber*)progress;

@end

@interface NetworkSingleton : NSObject <UIAlertViewDelegate>{
//	Reachability *globalReachablity;
    XSNetworkStatus currentStatus;
    BOOL isNeedNetWork;
}
@property (nonatomic,retain) XSReachability *globalReachablity;
@property (nonatomic,assign) BOOL isNetworkConnection;
//是否需要版本更新提示，可以通过程序控制
//@property (nonatomic,assign) BOOL isNeedVersionAlert;
@property (nonatomic,assign) NSObject<NetworkSingletonDelegate> *delegate;

+ (NetworkSingleton *)sharedNetWork;

- (BOOL)isOnlineCurrentVersion:(NSString*)appVersion storeAppId:(NSString*)storeAppId;
- (void)downloadFileFromUrl:(NSString*)url toPath:(NSString*)path;
- (void)asyncDownloadFileFromUrl:(NSString*)url toPath:(NSString*)path;

- (void)noConnectionAlertView;

- (BOOL)isNetworkConnectionAndShowAlert;

@end
