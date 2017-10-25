//
//  NetworkSingleton.m
//  AuctionCatalog
//
//  Created by artron artron on 12-2-22.
//  Copyright 2012 LJS. All rights reserved.
//

#import "NetworkSingleton.h"
#import "Tool.h"
#import "TipsView.h"


//#ifdef DEBUG
//#define kisPublish @"false"
//#else
//#define kisPublish @"true"
//#endif

#define kMaxConcurrentRequestCount 4

static NetworkSingleton *network;

@interface NetworkSingleton ()
//@property (nonatomic,retain) Reachability *globalReachablity;
@property (nonatomic,retain) AFNetworkReachabilityManager *reachabilityManager;
//@property (nonatomic,retain) NSOperationQueue* operationQueue;
@property (nonatomic,retain) NSMutableArray* downloadTaskArray;
@end

@implementation NetworkSingleton

//@synthesize isNeedNetWork;
@synthesize isNetworkConnection;
//@synthesize globalReachablity;
@synthesize isNeedVersionAlert;
@synthesize delegate;


-(id)init
{
	self = [super init];
    // 2.设置监听
    /*
     AFNetworkReachabilityStatusUnknown          = -1,  未识别
     AFNetworkReachabilityStatusNotReachable     = 0,   未连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
     AFNetworkReachabilityStatusReachableViaWiFi = 2,  wifi
     */

    self.downloadTaskArray = [NSMutableArray array];
    
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self) weakSelf = self;
    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [_reachabilityManager startMonitoring];
    currentStatus = _reachabilityManager.networkReachabilityStatus;
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        [weakSelf netWorkAlertWithReachability:status];
    }];

    
	return self;
}

//共享单例
+ (NetworkSingleton *)sharedNetWork{
	if (network == nil) {
		network = [[NetworkSingleton alloc] init];
	}
	return network;
}


//处理连接改变后的情况
- (void)netWorkAlertWithReachability:(AFNetworkReachabilityStatus)status
{
    //对连接改变做出响应的处理动作。
    if  (currentStatus != status)
    {
//        NSLog(@"stauts = %d",status);
        if (status == AFNetworkReachabilityStatusNotReachable)
        {  //没有连接到网络就弹出提实况
            [self performSelectorOnMainThread:@selector(noConnectionAlertView) withObject:nil waitUntilDone:YES]; 
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            [self performSelectorOnMainThread:@selector(wwanConnectionAlertView) withObject:nil waitUntilDone:YES];
        }
        currentStatus = status;
    }
}

-(void)showAlert:(NSString*)msg
{
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    
    UIViewController* rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* nv =(UINavigationController*)rootVC;
        
        [TipsView showTips:msg inView:nv.topViewController.view];
    }
    else
    {
        [TipsView showTips:msg inView:rootVC.view];
    }
}

- (void)wwanConnectionAlertView
{
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"流量提醒"
//                                                        message:@"您正在使用蜂窝移动网络!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alert show];
    [self showAlert:@"您正在使用蜂窝移动网络!"];
}

- (void)noConnectionAlertView
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                    message:@"亲，您的网络不给力哦"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//    [alert show];
    [self showAlert:@"亲，您的网络不给力哦!"];
}

- (BOOL)isNetworkConnection{
	
	if (currentStatus == AFNetworkReachabilityStatusNotReachable) {
		return NO;
	}
    return YES;
}

- (BOOL)isNetworkConnectionAndShowAlert
{
    BOOL flag = [self isNetworkConnection];
    if (!flag) {
       [self performSelectorOnMainThread:@selector(noConnectionAlertView) withObject:nil waitUntilDone:YES]; 
    }
    return flag;
}


#pragma mark -
#pragma mark 更新提示方法

-(void)setIsNeedVersionAlert:(BOOL)_isNeedVersionAlert
{
    [[NSUserDefaults standardUserDefaults] setBool:_isNeedVersionAlert  forKey:@"isNeedVersionAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isNeedVersionAlert
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedVersionAlert"])
    {
        BOOL _isNeedVersionAlert  = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNeedVersionAlert"];
        return _isNeedVersionAlert;
    }
    else
    {
        return YES;
    }
}


- (BOOL)isOnlineCurrentVersion:(NSString*)appVersion storeAppId:(NSString*)storeAppId
{
    __block BOOL isCurrentVersionOnline = FALSE;
    
//    NSString* appVersion = kAppVersion;
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", storeAppId];
    //    NSLog(@"=====storeString:%@",storeString);
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ( [data length] > 0 && !error )
         { // Success
             
             NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 // All versions that have been uploaded to the AppStore
                 NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                 //                    NSArray *releaseNotes = [[appData valueForKey:@"results"] valueForKey:@"releaseNotes"];
                 if ( ![versionsInAppStore count] )
                 { // No versions of app in AppStore
                     isCurrentVersionOnline = FALSE;
                 }
                 else
                 {
                     
                     NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                     if ([appVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending)
                     {
                         isCurrentVersionOnline = YES;//当前版本比线上的版本小，说明当前版本是老版本
                     }
                     else if([appVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedSame)
                     {
                         isCurrentVersionOnline = YES;//当前版本和线上的版本一样
                     }
                     else
                     {
                         // Current installed version is the newest public version or newer
                         isCurrentVersionOnline = NO;//当前版本比线上的版本大，说明当前版本是新版本还没上线
                     }
                 }
             });
         }
     }];
    return isCurrentVersionOnline;
}

-(void)downloadFileFromUrl:(NSString*)url toPath:(NSString*)path
{
    if (self.isNetworkConnection)
    {
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request =[serializer requestWithMethod:@"get" URLString:url parameters:nil error:nil];
        __block BOOL syncComplete = NO;

        NSURLSessionDownloadTask* downloadTask = [[AFHTTPSessionManager manager]
         downloadTaskWithRequest:request progress:nil
         destination: ^NSURL *(NSURL *targetPath, NSURLResponse *response)
         {
            NSFileManager *fileManager = [NSFileManager defaultManager];
             if ([fileManager fileExistsAtPath:path])
             {
                 [fileManager removeItemAtPath:path error:nil];
             }
             NSURL *fileURL =[[NSURL alloc] initFileURLWithPath:path];
             return fileURL;
         }
         completionHandler:^(NSURLResponse *response, NSURL *  filePath, NSError *  error)
         {
             syncComplete = YES;
         }];
        [downloadTask resume];
        [self.downloadTaskArray addObject:downloadTask];
        //如果没返回结果就一直执行下去，模拟同步执行
        while (!syncComplete) {
            NSLog(@"runloop…");
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"runloop end.");
        }
    }
}

- (void)asyncDownloadFileFromUrl:(NSString*)url toPath:(NSString*)path
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"get" URLString:url parameters:nil error:nil];

    NSURLSessionDownloadTask* downloadTask = [[AFHTTPSessionManager manager]
     downloadTaskWithRequest:request progress:nil
        destination: ^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path])
        {
            [fileManager removeItemAtPath:path error:nil];
        }
        NSURL *fileURL =[[NSURL alloc] initFileURLWithPath:path];
        return fileURL;
    }
     completionHandler:^(NSURLResponse *response, NSURL *  filePath, NSError *  error)
    {
  
    }];
    [downloadTask resume];
    [self.downloadTaskArray addObject:downloadTask];
}

@end
