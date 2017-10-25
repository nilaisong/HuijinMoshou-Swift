//
//  DownloaderManager.m
//  
//
//  Created by  NiLaisong on 15/7/7.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//
#import "NSStringAdditions.h"
#import "DownloaderManager.h"
#import "NetWork.h"
#import "LocalFileSystem.h"
#import "Tool.h"
#import "TipsView.h"
#import "NetworkSingleton.h"
#import "DataFactory+Building.h"
#import "AppDelegate.h"
#import "BuildingListData.h"
#import "Estate.h"
//#import "Building.h"
#define DownloadArrayFilePath documentFilePathWithFileName(@"buildings.plist", MainDownloadFolder)

#define DownloadItemKey @"buildingId"
#define DownloadItemName @"buildingName"
#define DownloadItemTime @"downloadTime"

//NSOperationQueue的最大并发数
#define kMaxConcurrentCount 4

@interface DownloaderManager()

@property(nonatomic,retain)NSOperationQueue *operationQueue;

@end

@implementation DownloaderManager
//@synthesize delegate;
@synthesize requestArray,recordArray,operationQueue;

static DownloaderManager *sharedManager = nil;

+ (DownloaderManager *)sharedManager
{
    if (nil == sharedManager)
    {        
        sharedManager = [[[self class] alloc] init];
    }
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
       
    }
    return  self;
}

//程序要退到后台前持久化一下下载记录的数组
- (void)appWillEnterBackground:(NSNotification *)notification
{    
   [self persistenceRecord];
}


- (NSOperationQueue *)operationQueue
{
    if (nil == operationQueue)
    {
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:kMaxConcurrentCount];
    }
    
    return operationQueue;
}


- (NSMutableArray *)recordArray
{
    if (!recordArray)
    {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:DownloadArrayFilePath];

        if (array)
            recordArray = [array mutableCopy];
        else
            recordArray = [[NSMutableArray alloc] init];
    }
    
    return  recordArray;
}

- (NSMutableArray *)requestArray
{
    if (!requestArray)
    {
        requestArray = [[NSMutableArray alloc] init];
    }
    
    return requestArray;
}


//配置一个多资源下载的request
- (MultipleResourceRequst*)addRequestWithItemId:(NSString *)itemId  andName:(NSString*)name
{
    MultipleResourceRequst *request = nil;
    DownloadStateType state = [self getDownloadStateWithItemId:itemId];
    if (state == kDownloading)
        return nil;    //防止重复添加
    else if (state == kNoDownload)
    {
        if (self.recordArray.count==20)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"对不起，下载上限为20" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
    }
    request = [[MultipleResourceRequst alloc] initWithBuildingId:itemId andName:name];
    request.delegate = self;
    [self.operationQueue addOperation:request];
    [self.requestArray addObject:request];

    return request;
}

-(NSString*)getDownloadItemIds
{
    NSMutableString* itemIds = [NSMutableString string];
    for (NSDictionary *item in self.recordArray)
    {
         NSString* buildingId = [item objectForKey:DownloadItemKey];
        if (itemIds.length==0) {
            [itemIds appendString:buildingId];
        }
        else
        {
            [itemIds appendString:@","];
            [itemIds appendString:buildingId];
        }
    }
    return itemIds;
}

//- (void)checkDownloadItemsUpdate
//{
//    if (![UserData sharedUserData].isUserLogined) {
//        return;
//    }
//    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
//        return;
//    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSString* itemIds = [self getDownloadItemIds];
//        if(itemIds.length==0)
//            return ;
////        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NetWork *dataRequest = [NetWork requestWithUrlString:@"/api/agency/estate/judgeEstateDownload"];
//        [dataRequest addPostValue:itemIds forKey:@"estateIds"];
//        [dataRequest startSynchronous];
//        NSString* updateBuildings = nil;
//        BOOL isUpdate = FALSE;
//        NSDictionary* responseObject = dataRequest.responseObject;
//        if (responseObject)
//        {
////            NSDictionary * retDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
//            BOOL isSucess = [[responseObject objectForKey:@"success"] boolValue];
//            if (isSucess)
//            {
//                NSDictionary* data = [responseObject objectForKey:@"data"];
//                updateBuildings = [data objectForKey:@"estateIds"];
//                isUpdate = [[data objectForKey:@"isUpdate"] boolValue];
//                NSLog(@"**********  %@",data);
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (isUpdate && updateBuildings)
//            {
//                [self updateWithDownloadItemIds:updateBuildings];//
//
////                AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;
////                [Tool showTextHUD:@"更新已下载列表中有数据变化的楼盘" andView:appDeleage.window.rootViewController.view];
//            }
//        });
//    });
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==1)
//    {
//        NSString* updateBuildings = [Tool getCache:@"updateBuildings"];
//        [self updateWithDownloadItemIds:updateBuildings];
//        [Tool removeCache:@"updateBuildings"];
//    }
//}

- (void)updateWithDownloadItemIds:(NSString*)itemIds
{
    NSArray* itemIdArray = [itemIds componentsSeparatedByString:@","];
    for (NSDictionary* item in self.recordArray)
    {
        NSString* itemId = [item objectForKey:DownloadItemKey];
        NSString* itemName = [item objectForKey:DownloadItemName];
        if ([itemIdArray containsObject:itemId])
        {
            DownloadStateType state = [self getDownloadStateWithItemId:itemId];
            if (state == kDownloading)
                continue;    //防止重复添加
            MultipleResourceRequst *request = [[MultipleResourceRequst alloc] initWithBuildingId:itemId andName:itemName];
            request.isUpdate = YES;
            request.delegate = self;
            [self.operationQueue addOperation:request];
            [self.requestArray addObject:request];
        }
    }
}
#pragma mark -
#pragma mark mutipleResourceRequest delegate method

-(void)downloadFinishedWithResourceRequest:(MultipleResourceRequst *)request
{
    if (!request.isUpdate)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@下载完成!",request.buildingName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [Tool setCache:@"isCleanBuilding" value:@"0"];

        [alert show];
    }
    //下载完成
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishedDownloadNotification object:request.buildingId];
}

- (void)mutipleResourceRequestDidFinished:(MultipleResourceRequst *)request
{
//    NSLog(@"%s",__func__);
    
    NSLog(@"下载完成:%@",request.buildingName);

    request.downloadProgressDelegate = nil;
    //从下载队列移除
    [self.requestArray removeObject:request];
    
    BOOL isUpdate = NO;
    NSString* downloadTime = getLocationDateTime();
    //更新已下载记录
    for (NSMutableDictionary * item in self.recordArray)
    {
        NSString* itemId = [item objectForKey:DownloadItemKey];
        if ([itemId isEqualToString:request.buildingId])
        {
//            [item  setObject:request.buildingName forKey:DownloadItemName];
            [item  setObject:downloadTime forKey:DownloadItemTime];
            isUpdate = YES;
        }
    }
    //新增下载记录
    if (!isUpdate)
    {
        NSMutableDictionary* downloadItem = [NSMutableDictionary dictionary];
        [downloadItem setObject:request.buildingId forKey:DownloadItemKey];
        [downloadItem setObject:request.buildingName forKey:DownloadItemName];
        [downloadItem setObject:downloadTime forKey:DownloadItemTime];
        [self.recordArray addObject:downloadItem];

    }
    [self persistenceRecord];
    [self performSelectorOnMainThread:@selector(downloadFinishedWithResourceRequest:) withObject:request waitUntilDone:YES];
}

-(void)downloadFailedWithResourceRequest:(MultipleResourceRequst *)request
{
    if (request.isUpdate) {
        return;
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@下载失败!",request.buildingName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFailedDownloadNotification object:request.buildingId];
}
//
- (void)multipleResourceRequestDidFailed:(MultipleResourceRequst *)request
{
    NSLog(@"下载失败:%@",request.buildingName);
    request.downloadProgressDelegate = nil;
    //从下载队列移除
    [self.requestArray removeObject:request];
    [self performSelectorOnMainThread:@selector(downloadFailedWithResourceRequest:) withObject:request waitUntilDone:YES];
}


//持久化保存下载记录的数组
- (void)persistenceRecord
{
    // add by zhm 修复0.18kb
    if ([[Tool getCache:@"isCleanBuilding"] isEqualToString:@"0"]) {
        [self.recordArray writeToFile:DownloadArrayFilePath atomically:YES];

    }
}

-(MultipleResourceRequst*)resourceRequestWithItemId:(NSString*)itemId
{
    MultipleResourceRequst *resourceRequest=nil;
    
    for (MultipleResourceRequst *request in self.requestArray)
    {
        NSString *buildingId = request.buildingId;
        if ([buildingId isEqualToString:itemId])
        {
            resourceRequest = request;
        }
    }
    return resourceRequest;
}

-(DownloadStateType)getDownloadStateWithItemId:(NSString*)itemId
{

    for (MultipleResourceRequst *request in self.requestArray)
    {
        NSString *buildingId = request.buildingId;
        if ([itemId isEqualToString:buildingId])
        {
            //正在下载
            return kDownloading;
        }
    }
    
    for (NSDictionary *item in self.recordArray)
    {
        NSString* buildingId = [item objectForKey:DownloadItemKey];
        if ([buildingId isEqualToString:itemId])
        {
            //下载完成
            return kDownloadFinished;
        }
    }
    
    //未下载
    return kNoDownload;
}

-(NSString*)getImageDownloadPathWithItemId:(NSString*)itemId andImgUrl:(NSString*)imgUrl
{
    NSString* downloadPath = documentFilePathWithFileName(itemId, MainDownloadFolder);
    NSString* imagesDownloadPath = [downloadPath stringByAppendingPathComponent:@"images"];
    NSString* imageName = [imgUrl md5Hash];
    NSString* imagePath =  [imagesDownloadPath stringByAppendingPathComponent:imageName];
    return imagePath;
}

-(void)updateDownloadTimeWithItemId:(NSString*)bId
{
    NSString* downloadTime = getLocationDateTime();
    for (NSMutableDictionary * item in self.recordArray)
    {
        NSString* itemId = [item objectForKey:DownloadItemKey];
        if ([itemId isEqualToString:bId])
        {
            //            [item  setObject:request.buildingName forKey:DownloadItemName];
            [item  setObject:downloadTime forKey:DownloadItemTime];
            break;
        }
    }
    [self persistenceRecord];
}

- (BOOL)deleteDownloadItemWithIndex:(int)index
{
    if (index<self.recordArray.count)
    {
        NSDictionary* item = [self.recordArray objectAtIndex:index];
        NSString* itemId = [item objectForKey:DownloadItemKey];
        NSString* downloadPath = documentFilePathWithFileName(itemId, MainDownloadFolder);
        if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
        }
        [self.recordArray removeObjectAtIndex:index];
        if (self.recordArray.count==0)
        {
            if([[NSFileManager defaultManager] fileExistsAtPath:kPathOfDocument(MainDownloadFolder)])
            {
                [[NSFileManager defaultManager] removeItemAtPath:kPathOfDocument(MainDownloadFolder) error:nil];
            }
        }
        else
        {
            [self persistenceRecord];
        }
        return YES;
    }
    return NO;
}

- (BOOL)deleteDownloadItemWithId:(NSString *)itemId
{
    for (NSDictionary *item in self.recordArray)
    {
        NSString* buildingId = [item objectForKey:DownloadItemKey];
        if ([itemId isEqualToString:buildingId])
        {
            NSString* downloadPath = documentFilePathWithFileName(itemId, MainDownloadFolder);
            if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
            }

            [self.recordArray removeObject:item];
            if (self.recordArray.count==0)
            {
                if([[NSFileManager defaultManager] fileExistsAtPath:kPathOfDocument(MainDownloadFolder)])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:kPathOfDocument(MainDownloadFolder) error:nil];
                }
            }
            else
            {
                [self persistenceRecord];
            }
            return YES;
        }
    }
    return NO;
}

- (BOOL)removeAllDownloadItems
{
    NSString* downloadPath = kPathOfDocument(MainDownloadFolder);
    if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
    {
       if([[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil])
       {
           [self.recordArray removeAllObjects];
           return TRUE;
       }
    }
    return FALSE;
}

-(NSArray*)getDownloadItems
{
    NSMutableArray* buildingArray = [NSMutableArray array];
    for (NSDictionary* item  in self.recordArray)
    {
        NSString* itemId = [item objectForKey:DownloadItemKey];
        NSString* downloadPath = documentFilePathWithFileName(itemId, MainDownloadFolder);
        NSString* infoPath = [downloadPath stringByAppendingPathComponent:@"buildingInfo"];
        if([[NSFileManager defaultManager] fileExistsAtPath:infoPath])
        {
            NSDictionary*buildingInfo = [Tool unarchiveObjectWithKey:@"buildingInfo" fromPath:infoPath];
            Building* building = [[DataFactory sharedDataFactory] getBuildingObjectFromJSONObject:buildingInfo];
            
            BuildingListData *listData =[self getBuildingListDataFromeBuilding:building];
            
            [buildingArray addObject:listData];
        }
    }
    return buildingArray;
}

-(Building *)getBuildingDetailWithBuildingId:(NSString *)buildingId
{
    Building* building;
    
    NSString* downloadPath = documentFilePathWithFileName(buildingId, MainDownloadFolder);
    NSString* infoPath = [downloadPath stringByAppendingPathComponent:@"buildingInfo"];
    if([[NSFileManager defaultManager] fileExistsAtPath:infoPath])
    {
        NSDictionary*buildingInfo = [Tool unarchiveObjectWithKey:@"buildingInfo" fromPath:infoPath];
         building = [[DataFactory sharedDataFactory] getBuildingObjectFromJSONObject:buildingInfo];
    }
    return building;
}



-(BuildingListData *)getBuildingListDataFromeBuilding:(Building *)building
{
    
    Estate *eatateBuilding = building.estate;
    
    BuildingListData *tempListData = [[BuildingListData alloc]init];
    
    tempListData.buildingId = building.buildingId;
    tempListData.name = building.name;
    tempListData.price = eatateBuilding.price;
    tempListData.url = eatateBuilding.url;
    tempListData.thmUrl = eatateBuilding.thmUrl;
    tempListData.imgUrl = eatateBuilding.imgUrl;
    tempListData.districtName = eatateBuilding.districtName;
    tempListData.featureTag = eatateBuilding.featureTag;
    tempListData.saleLatitude = eatateBuilding.latitude;
    tempListData.saleLongitude = eatateBuilding.longitude;
    tempListData.commissionType = eatateBuilding.commissionType;
    tempListData.commissionBegin = eatateBuilding.commissionBegin;
    tempListData.commissionEnd = eatateBuilding.commissionEnd;
    
    tempListData.trystCar = eatateBuilding.trystCar;
    //是否使用客户到访信息(1:使用 0:不使用)
    tempListData.customerVisitEnable = eatateBuilding.customerVisitEnable;
    tempListData.mechanismType = eatateBuilding.mechanismType;
    tempListData.formatCommissionStandard = eatateBuilding.formatCommissionStandard;
    tempListData.isTop = building.isTop;
    tempListData.shipAgencyNum = building.shipAgencyNum;
    tempListData.favorite = building.favorite;
    tempListData.recommendationNum = building.recommendationNum;
    tempListData.visitNum = building.visitNum;
    tempListData.signNum = building.signNum;
    tempListData.commissionDisplay = eatateBuilding.commissionDisplay;
    tempListData.customerTelType = eatateBuilding.customerTelType;
    tempListData.status = eatateBuilding.status;
    tempListData.address = eatateBuilding.address;
    
    return tempListData;
    
}




@end
