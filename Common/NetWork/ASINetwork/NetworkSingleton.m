//
//  NetworkSingleton.m
//  AuctionCatalog
//
//  Created by artron artron on 12-2-22.
//  Copyright 2012 LJS. All rights reserved.
//

#import "NetworkSingleton.h"
#import "Tool.h"
#import "NetWork.h"


//#ifdef DEBUG
//#define kisPublish @"false"
//#else
//#define kisPublish @"true"
//#endif

#define kMaxConcurrentRequestCount 4

static NetworkSingleton *network;

@interface NetworkSingleton ()

@end

@implementation NetworkSingleton


//@synthesize isNeedNetWork;
@synthesize isNetworkConnection;
@synthesize globalReachablity;
//@synthesize isNeedVersionAlert;
@synthesize delegate;


//-(void)dealloc
//{
//	[globalReachablity release];
//
//    self.versionAlert = nil;
//	[super dealloc];
//}

-(id)init
{
	self = [super init];
//    self.isNeedNetWork = YES;
//    self.requestArray = [NSMutableArray array];
	//添加网络监听器
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reachabilityChangeds:)
												 name:ReachabilityChangedNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkAlert)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
    currentStatus = XSReachableViaWiFi|XSReachableViaWWAN;
    self.globalReachablity = [XSReachability reachabilityWithHostName:@"www.baidu.com"];
    
    [NSThread detachNewThreadSelector:@selector(listenNetWork) toTarget:self withObject:nil];
    
	return self;
}

-(void)listenNetWork
{
    [self netWorkAlertWithReachability:globalReachablity];
    
    //开始监听,会启动一个run loop
    [globalReachablity startNotifier];
}
    
-(void)netWorkAlert
{
    [self netWorkAlertWithReachability:globalReachablity];
}

//共享单例
+ (NetworkSingleton *)sharedNetWork{
	if (network == nil) {
		network = [[NetworkSingleton alloc] init];
	}
	return network;
}


//处理连接改变后的情况
- (void)netWorkAlertWithReachability:(XSReachability*) curReach
{
    //对连接改变做出响应的处理动作。
	XSNetworkStatus status = [curReach currentReachabilityStatus];
    if  (currentStatus != status)
    {
//        NSLog(@"stauts = %d",status);
        if (status == XSNotReachable)
        {  //没有连接到网络就弹出提实况
            [self performSelectorOnMainThread:@selector(noConnectionAlertView) withObject:nil waitUntilDone:YES]; 
        }
        else if(status == XSReachableViaWWAN)
        {
            [self performSelectorOnMainThread:@selector(wwanConnectionAlertView) withObject:nil waitUntilDone:YES];
        }
        currentStatus = status;
    }
}

- (void)wwanConnectionAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"流量提醒"
                                                    message:@"您正在使用蜂窝移动网络!"
                                                   delegate:nil
                                          cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
    //[alert release];
}

- (void)noConnectionAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"亲，您的网络不给力哦"
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
    //[alert release];
}

- (BOOL)isNetworkConnection{
	XSNetworkStatus status = [globalReachablity currentReachabilityStatus];
	if (status == XSNotReachable) {
		return NO;
	}
    return YES;
//	return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) || ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

- (BOOL)isNetworkConnectionAndShowAlert
{
    BOOL flag = [self isNetworkConnection];
    if (!flag) {
       [self performSelectorOnMainThread:@selector(noConnectionAlertView) withObject:nil waitUntilDone:YES]; 
    }
    return flag;
}

// 连接改变
- (void) reachabilityChangeds:(NSNotification* )note
{
	XSReachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [XSReachability class]]);
    XSNetworkStatus status = [curReach currentReachabilityStatus];
    //
    if (status == XSReachableViaWiFi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkReachableViaWiFi" object:nil];
    }
	[self netWorkAlertWithReachability:curReach];
}

#pragma mark -
#pragma mark 更新提示方法

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

/*
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

-(void)checkTestVersionWithUrl:(NSString*)versionUrl
{
    if (self.testDownloadUrl.length>0)
    {
        return;
    }
    if (!self.isNetworkConnection) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString* localTestVersion = [NSString stringWithFormat:@"%d",kVersionCode];
        
        self.testDownloadUrl =
        [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", versionUrl];
        NSURL * latestTestVersionUrl =  [NSURL URLWithString:versionUrl];
        NSDictionary* latestTestVersionDic = [NSDictionary dictionaryWithContentsOfURL:latestTestVersionUrl];
            
        dispatch_async(dispatch_get_main_queue(), ^{

            NSString* latestTestVersion = [[[[latestTestVersionDic objectForKey:@"items"] objectAtIndex:0] objectForKey:@"metadata"] objectForKey:@"bundle-version"];
            NSString* newFeatures = [[[[latestTestVersionDic objectForKey:@"items"] objectAtIndex:0] objectForKey:@"metadata"] objectForKey:@"subtitle"];
            
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:latestTestVersion message:newFeatures delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//            [alert show];
            
            if ([localTestVersion compare:latestTestVersion options:NSNumericSearch] == NSOrderedAscending)
            {
//               NSString* message = [NSString stringWithFormat:@"您当前的版本批次: %@\n最新的版本批次: %@\n%@",localTestVersion,latestTestVersion,newFeatures];
               NSString* message = [NSString stringWithFormat:@"%@",newFeatures];
                UIAlertView* versionAlert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立即升级", nil];
                versionAlert.tag = 3;
                [versionAlert show];
//                [Tool setCache:@"checkTestVersion" value:[NSNumber numberWithBool:YES]];
            }
        });
    });
}

- (void)checkVersion
{
    if (self.isNeedVersionAlert)
    {
        NSString* appVersion = kAppVersion;

        // Asynchronously query iTunes AppStore for publically available version
        NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kStoreAppID];
    //    NSLog(@"=====storeString:%@",storeString);
        NSURL *storeURL = [NSURL URLWithString:storeString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
        [request setHTTPMethod:@"GET"];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            //[request autorelease];[queue autorelease];
            if ( [data length] > 0 && !error ) { // Success
                
                NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //            NSLog(@"=======appData:%@",appData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // All versions that have been uploaded to the AppStore
                    NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                    NSArray *releaseNotes = [[appData valueForKey:@"results"] valueForKey:@"releaseNotes"];
                    if ( ![versionsInAppStore count] )
                    { // No versions of app in AppStore
                        return;
                    }
                    else
                    {
                        BOOL isCurrentVersionOnline = FALSE;
                        NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                        if ([appVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending)
                        {
                            isCurrentVersionOnline = YES;//当前版本比线上的版本小，说明当前版本是老版本需要更新
                            NSString* newFeatures = @"";
                            if (releaseNotes.count>0){
                             newFeatures = [releaseNotes  objectAtIndex:0];
                            }
                            NSString* message = [NSString stringWithFormat:@"您当前的版本号 : %@\n最新的版本号是 : %@\n%@",appVersion,currentAppStoreVersion,newFeatures];
                            [self performSelectorOnMainThread:@selector(versionUpdateAlertWithMessage:)
                                                   withObject:message
                                                waitUntilDone:YES];
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
                        //是否禁用icloud备份
                        NSString* currentVersionOnlineKey = [NSString stringWithFormat:@"isAppOnline_%@",kAppVersion];
                        BOOL isOnline = [[NSUserDefaults standardUserDefaults] boolForKey:currentVersionOnlineKey];
                        //            NSLog(@"isAppOnline:%d",(int)isAppOnline);
                        if (isCurrentVersionOnline!=isOnline)
                        {
//                            [[Datasource sharedDataSource]  setBackupAttribute:isCurrentVersionOnline];
                            [[LocalFileSystem sharedManager] setBackupAttribute:isCurrentVersionOnline];
                            [[HPThemeManager sharedThemeManager] setBackupAttribute:isCurrentVersionOnline];
                        }
                        [[NSUserDefaults standardUserDefaults] setBool:isCurrentVersionOnline forKey:currentVersionOnlineKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                });
            }
            
        }];
    }
}
*/

-(void)downloadFileFromUrl:(NSString*)url toPath:(NSString*)path
{
    if (self.isNetworkConnection)
    {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.timeOutSeconds = 60;
        [request setShouldAttemptPersistentConnection:NO];
        request.shouldContinueWhenAppEntersBackground = YES;
        request.downloadDestinationPath = path;
        [request startSynchronous];
    }
}

- (void)asyncDownloadFileFromUrl:(NSString*)url toPath:(NSString*)path
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeOutSeconds = 120;
//    [request addRequestHeader:@"Referer" value:@"http://www.5i5j.com"];
    [request setShouldAttemptPersistentConnection:NO];
    request.shouldContinueWhenAppEntersBackground = YES;
    request.downloadDestinationPath = path;
    [request startAsynchronous];
}

@end
