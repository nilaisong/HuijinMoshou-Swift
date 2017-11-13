//
//  MutipleResourceRequst.m
//  AuctionCatalog
//
//  Created by Allen King on 12-4-7.
//  Copyright (c) 2012年 Artron. All rights reserved.
//

#import "MultipleResourceRequst.h"
#import "NetWork.h"
#import "NetworkSingleton.h"
#import "Tool.h"
#import "NSStringAdditions.h"
#import "NSDictionary+JSON.h"

@interface MultipleResourceRequst()
//@property(nonatomic,retain)NSDictionary* buildingInfo;
@property(nonatomic,retain)NSMutableArray *resourceArray;
@property(nonatomic,retain)NSString *downloadPath;

@end

@implementation MultipleResourceRequst


//- (void)dealloc
//{
//    //NSLog(@"%s",__func__);
//    
//    self.downloadProgressDelegate = nil;
//    self.delegate = nil;
//
//    [super dealloc];
//}

- (id)initWithBuildingId:(NSString *)bId andName:(NSString*)name
{
    //NSLog(@"%s",__func__);
    self = [super init];
    if (self)
    {
        self.buildingId = bId;
        self.buildingName = name;
        self.resourceArray = [NSMutableArray array];
        self.downloadPath = documentFilePathWithFileName(bId, MainDownloadFolder);
        NSLog(@"%@",self.downloadPath);
        if (![[NSFileManager defaultManager] fileExistsAtPath:_downloadPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_downloadPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    return self;
}

//- (id)initWithBuildingInfo:(NSDictionary *)bInfo
//{
//    self.buildingInfo = bInfo;
//    NSString* buildingId = [bInfo objectForKey:@"buildingId"];
//    NSString* buildingName = [bInfo objectForKey:@"name"];
//    return [self initWithBuildingId:buildingId andName:buildingName];
//}

- (void)handleBackgroundTaskInvalid
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (backgroundTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
            backgroundTask = UIBackgroundTaskInvalid;
        }
    });
    
}

-(void)addImgResourceFromArray:(NSArray*)array
{
    for (NSDictionary* item in array)
    {
        NSString* imgUrl = [item stringValueForKey:@"imgUrl"];//户型图
        if (imgUrl.length>0) {
            [self.resourceArray addObject:smallImgUrl(imgUrl)];
            [self.resourceArray addObject:bigImgUrl(imgUrl)];
        }
        else
        {
            imgUrl = [item stringValueForKey:@"url"];//效果图
            if(imgUrl.length>0)
                [self.resourceArray addObject:bigImgUrl(imgUrl)];
        }
    }
}

//下载整个楼盘
-(void)downloadBuildingResource
{
    NSLog(@"buildingId:%@",_buildingId);
    __block BOOL isSucess = NO;
    if (self.buildingId)
    {
        NSDictionary* params = [NSDictionary  dictionaryWithObjectsAndKeys:_buildingId,@"estateId",@"1",@"download", nil];
        [[NetWork manager] syncPost:@"/api/agency/estate/findEstateDetail" parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
         {
             if (responseObject)
             {
                 NSDictionary * retDic = responseObject;
                 isSucess = [[retDic objectForKey:@"success"] boolValue];
                 if (isSucess)
                 {
                     NSDictionary* _buildingInfo = [retDic objectForKey:@"data"];
                     NSDictionary* detailInfo
                     = [_buildingInfo objectForKey:@"estate"];
                     NSString* filePath = [self.downloadPath stringByAppendingPathComponent:@"buildingInfo"];
                     
                     [Tool archiveObject:_buildingInfo withKey:@"buildingInfo" ToPath:filePath];
                     
//                     NSDictionary* detailInfo = [_buildingInfo objectForKey:@"estateDetailInfo"];
                     NSString * picUrl = [detailInfo stringValueForKey:@"pathUrl"];
                     
                     NSString* logoUrl = smallImgUrl(picUrl);
                     if (logoUrl.length>0) {
                         [self.resourceArray addObject:logoUrl];
                     }
                     picUrl = bigImgUrl(picUrl);
                     if (picUrl.length>0) {
                         [self.resourceArray addObject:picUrl];
                     }
                     
                     NSArray* layouts =  [_buildingInfo objectForKey:@"houseTypeList"];
                     for (NSDictionary* item in layouts)
                     {
                         NSString* imgUrl = [item stringValueForKey:@"pathImgUrl"];//户型图
                         if (imgUrl.length>0) {
                             [self.resourceArray addObject:smallImgUrl(imgUrl)];
                             [self.resourceArray addObject:bigImgUrl(imgUrl)];
                         }
                     }
                   
                     
                     NSArray* effect =  [_buildingInfo objectForKey:@"photoList"];
                     for (NSDictionary* item in effect)
                     {
                         NSString* imgUrl = [item stringValueForKey:@"pathUrl"];//效果图
                         if(imgUrl.length>0)
                             [self.resourceArray addObject:bigImgUrl(imgUrl)];
                     }
                     
                 }
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error){
             
         }];
    }
    NSInteger count = self.resourceArray.count;
//    BOOL connectable=YES;
    BOOL connectable = [[NetworkSingleton sharedNetWork] isNetworkConnection];
    if (count == 0)//如果能获得楼盘数据，没有图片也算下载成功
    {
        if (!isSucess) {
            [self reset];
            return;
        }
    }
    else
    {
        NSString* imageDownloadPath = [self.downloadPath stringByAppendingPathComponent:@"images"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:imageDownloadPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:imageDownloadPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        NSInteger downloadCount = 0;
        //开始循环下载
        if (!self.isCancelled && connectable)
        {
            for (NSInteger index =0; index<count; index++)
            {
//                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                //每次循环都要判断是否满足下载条件
                connectable = [[NetworkSingleton sharedNetWork] isNetworkConnection];
                if (!self.isCancelled && connectable)
                {
                    BOOL isDownload=YES;
                    //下载
                    NSString* imageUrl = [self.resourceArray objectForIndex:index];
                    NSString* imageName = [imageUrl md5Hash];
                    NSString* imagePath =  [imageDownloadPath stringByAppendingPathComponent:imageName];
                    //如果不存在这个资源则开始下载
                    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
                    {
                        connectable = [[NetworkSingleton sharedNetWork] isNetworkConnection];
                        if (!self.isCancelled && connectable)//connectable
                        {
                            [[NetworkSingleton sharedNetWork] downloadFileFromUrl:imageUrl toPath:imagePath];
//                            NSURL *url = [NSURL URLWithString:imageUrl];
//                            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
////                            [request addRequestHeader:@"Referer" value:@"http://www.5i5j.com"];
//                            request.downloadDestinationPath = imagePath;
//                            request.shouldContinueWhenAppEntersBackground = YES;
//                            request.numberOfTimesToRetryOnTimeout = 2;
////                            [request setAllowResumeForFileDownloads:YES];
//                            [request setShouldAttemptPersistentConnection:YES];
//                            [request startSynchronous];//同步下载
                        }
                    }
                    //判断大图是否已下载
                    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
                    {
                        isDownload = NO;
                    }
                    //如果小图和大图都已下载，就开始计数和更新进度
                    if (isDownload)
                    {
                        downloadCount++;
                        //暂停会把downloadProgressDelegate设置为nil
                        if ([self.downloadProgressDelegate respondsToSelector:@selector(setProgress:)])
                        {
                            progress = (float)downloadCount/(float)count;
                            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:[NSThread isMainThread]];
                        }
                        else{
                             NSLog(@"--");
                        }
//                        [pool drain];
                    }
                    else//
                    {
                        NSLog(@"下载失败:%@",imageUrl);
                        [self reset];
//                        [pool drain];
                        return;
                    }

                }
                else//不满足条件就跳出下载循环
                {
                    
                    [self reset];
//                    [pool drain];
                    return;
                }
            }//for
        }//connectable
        else//跳出下载
        {
            [self reset];
            return;
        }
    }
    //下载完成
    [self handleBackgroundTaskInvalid];
    if ([self.delegate respondsToSelector:@selector(mutipleResourceRequestDidFinished:)])
        [self.delegate mutipleResourceRequestDidFinished:self];
    
}

//异步下载
- (void)main
{
    backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backgroundTask != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
                [self cancel];
            }
        });
    }];
    
    [self downloadBuildingResource];
}

- (void)updateProgress:(NSNumber *)num
{
//    NSLog(@"%@:%f",_buildingId,[num floatValue]);
    [self.downloadProgressDelegate setProgress:[num floatValue]];
}


- (void)cancel
{    
    [self reset];      
    [super cancel];
}

- (void)reset
{
    [self handleBackgroundTaskInvalid];
    
    if ([self.delegate respondsToSelector:@selector(multipleResourceRequestDidFailed:)])
        [self.delegate multipleResourceRequestDidFailed:self];
    
    self.downloadProgressDelegate = nil;
    self.delegate = nil;
}
@end
