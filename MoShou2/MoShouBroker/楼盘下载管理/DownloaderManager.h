//
//  DownloaderManager.h
//  管理楼盘下载
//
//  Created by  NiLaisong on 15/7/7.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "ASIHTTPRequest.h"
#import "Constant.h"
#import "MultipleResourceRequst.h"
@class Building;

typedef enum {
    kNoDownload = 0,//未开始下载
    kDownloading = 1,//正在下载
    kDownloadFinished = 2//已完成下载

}DownloadStateType;

//notification about download
#define kDidFinishedDownloadNotification  @"didFinishedDownload"
#define kDidFailedDownloadNotification  @"didFailedDownload"

@interface DownloaderManager : NSObject<MultipleResourceRequestFinishedDelegate>
{
        
}

@property(nonatomic,retain)NSMutableArray *recordArray;
@property(nonatomic,retain)NSMutableArray *requestArray;

+ (DownloaderManager *)sharedManager;
//请求楼盘下载
- (MultipleResourceRequst*)addRequestWithItemId:(NSString *)itemId andName:(NSString*)name;
- (MultipleResourceRequst*)resourceRequestWithItemId:(NSString*)itemId;
- (DownloadStateType)getDownloadStateWithItemId:(NSString*)itemId;
//删除某下载的楼盘数据
- (BOOL)deleteDownloadItemWithIndex:(int)index;
- (BOOL)deleteDownloadItemWithId:(NSString *)itemId;
//清除所有下载的楼盘数据
- (BOOL)removeAllDownloadItems;
//检测已下载楼盘是否有数据更新
- (void)checkDownloadItemsUpdate;
//获取已下载的楼盘列表，数组元素building
-(NSArray*)getDownloadItems;
//更新楼盘数据的下载时间
-(void)updateDownloadTimeWithItemId:(NSString*)bId;

//获取楼盘图片的下载路径
-(NSString*)getImageDownloadPathWithItemId:(NSString*)itemId andImgUrl:(NSString*)imgUrl;



-(Building *)getBuildingDetailWithBuildingId:(NSString *)buildingId;



@end

