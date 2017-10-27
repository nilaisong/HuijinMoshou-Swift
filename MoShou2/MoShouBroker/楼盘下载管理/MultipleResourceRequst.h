//
//  MutipleResourceRequst.h
//  负责下载楼盘信息和资源
//
//  Created by  NiLaisong on 15/7/7.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import "ASIHTTPRequest.h"
#import "UserData.h"

#define MainDownloadFolder [NSString stringWithFormat:@"download%@",[UserData sharedUserData].userInfo.userId]

@protocol MultipleResourceRequestProgressDelegate <NSObject>

@optional
//和ASIHTTPRequest 进度条代理一样的方法
- (void)setProgress:(float)newProgress;
- (void)setProgress:(float)newProgress withLength:(float)length;

@end

@protocol MultipleResourceRequestFinishedDelegate;

@interface MultipleResourceRequst : NSOperation
//<ASIProgressDelegate,ASIHTTPRequestDelegate>
{
	UIBackgroundTaskIdentifier backgroundTask;

@private
    float progress;//下载进度
}

@property (nonatomic,retain)NSString *buildingId;
@property (nonatomic,retain)NSString *buildingName;
@property (nonatomic,assign)BOOL isUpdate;//标记是更新还是新下载的（如果是更新的，则不弹框提示）

@property (nonatomic,assign)id<MultipleResourceRequestProgressDelegate>downloadProgressDelegate;
@property (nonatomic,assign)id<MultipleResourceRequestFinishedDelegate>delegate;

- (id)initWithBuildingId:(NSString *)bId andName:(NSString*)name;
//- (id)initWithBuildingInfo:(NSDictionary *)bInfo;

- (void)reset;
@end


@protocol MultipleResourceRequestFinishedDelegate <NSObject>

@optional
- (void)mutipleResourceRequestDidFinished:(MultipleResourceRequst *)request;
- (void)multipleResourceRequestDidFailed:(MultipleResourceRequst *)request;
@end
