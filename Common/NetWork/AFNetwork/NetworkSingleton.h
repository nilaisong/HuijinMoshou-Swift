//
//  NetworkSingleton.h
//  与网络相关的一些处理接口
//
//  Created by Laison on 12-2-22.
//  Copyright 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSReachability.h"
#import "AFNetworking.h"
#import "LocalFileSystem.h"

#define kTimeOutSeconds 30

#define kBaseURL [LocalFileSystem sharedManager].baseURL
#define kFullUrlWithSuffix(suffixUrl) [NSString stringWithFormat:@"%@/%@", kBaseURL,suffixUrl]


typedef void(^HandleVersionUpdate)(BOOL isnew, NSString* message,BOOL mustUpdate,NSString* newVersion);

@protocol NetworkSingletonDelegate <NSObject>

-(void)updateDataProgress:(NSNumber*)progress;

@end

@interface NetworkSingleton : NSObject <UIAlertViewDelegate>{
//	Reachability *globalReachablity;
    AFNetworkReachabilityStatus currentStatus;
    BOOL isNeedNetWork;
}


@property (nonatomic,retain) XSReachability *globalReachablity;
@property (nonatomic,assign) BOOL isNetworkConnection;

@property (nonatomic,assign) BOOL isNeedVersionAlert;//是否需要版本更新提示，可以通过程序控制
@property (nonatomic,assign) NSObject<NetworkSingletonDelegate> *delegate;


+ (NetworkSingleton *)sharedNetWork;

- (void)netWorkAlertWithReachability:(AFNetworkReachabilityStatus)status;

- (BOOL)isOnlineCurrentVersion:(NSString*)appVersion storeAppId:(NSString*)storeAppId;

- (void)downloadFileFromUrl:(NSString*)url toPath:(NSString*)path;
- (void)asyncDownloadFileFromUrl:(NSString*)url toPath:(NSString*)path;

- (void)noConnectionAlertView;

- (BOOL)isNetworkConnectionAndShowAlert;

@end
