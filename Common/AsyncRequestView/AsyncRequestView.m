//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//
#import "asyncRequestView.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@interface AsyncRequestView ()

@property(nonatomic,retain) NSMutableData * data;
@property(nonatomic,copy)   NSString *filePath;
@property(nonatomic,retain) NSURL * fileUrl;
@property(nonatomic,retain) NSFileHandle *fielHander;
@property(nonatomic,retain) NSOutputStream * fileStream;
@property(nonatomic,retain) MBProgressHUD* HUDIndicator;
@property(nonatomic,retain) CircleIndicatorView* circleIndicator;
@property(nonatomic,retain) UIActivityIndicatorView* activityIndicator;
@property(nonatomic,retain) ProgressIndicatorView* progressIndicatorView;
@property(nonatomic,assign) SEL methodForExecution;
@property(nonatomic,assign) id targetForExecution;

@end



static ASINetworkQueue* networkQueue = nil;
//[[ASINetworkQueue alloc] init];

@implementation AsyncRequestView

@synthesize indicatorStyle;
@synthesize data=_data;
@synthesize delegate;
//@synthesize requestFinishedSelector;
//@synthesize downloadFinishedSelector;
@synthesize HUDIndicator;
@synthesize activityIndicator;
@synthesize circleIndicator;
@synthesize progressIndicatorView;
@synthesize progressViewLength;
@synthesize progess;
@synthesize fileStream;
@synthesize fielHander;
@synthesize filePath;
@synthesize fileUrl;
@synthesize methodForExecution,targetForExecution;

+ (NSOperationQueue *)sharedNetworkQueue
{
    if (networkQueue==nil) {
        networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue go];
    }
    return networkQueue;
}
//
//- (void)dealloc 
//{
//    self.delegate=nil;
//    
//    [self cancelDownload];
//    
//    [filePath release];
//    [fileUrl release];
//	[_data release]; 
//    [activityIndicator release];
//    [circleIndicator release];
//    [HUDIndicator release];
//    [progressIndicatorView release];
//    [tempPath release];
//    //NSLog(@"dealloc urlString:%@",urlString);
//    
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
    }
    return self;
}

- (id)initWithView:(UIView *)view andIndicatorStyle:(LoadingIndicatorStyle)style
{
    // [MBProgressHUD hideHUDForView:view animated:NO];
	// Let's check if the view is nil (this is a common error when using the windw initializer above)
	if (!view) {
		[NSException raise:@"MBProgressHUDViewIsNillException"
					format:@"The view used in the MBProgressHUD initializer is nil."];
	}
	id me = [self initWithFrame:view.bounds];
    [view addObserver:self
           forKeyPath:@"frame"
              options:NSKeyValueObservingOptionNew
              context:nil];
    self.indicatorStyle=style;
    
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
//												 name:UIDeviceOrientationDidChangeNotification object:nil];
	return me;
}

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object andMessage:(NSString*)message
{
	[self showIndicatorWithMessage:message];
    self.methodForExecution = method;
    self.targetForExecution = target;
    [NSThread detachNewThreadSelector:@selector(launchExecution:) toTarget:self withObject:object];
}

- (void)launchExecution:(id)object
{
    [targetForExecution performSelector:methodForExecution withObject:object];
    [self.superview removeObserver:self forKeyPath:@"frame"];
    [self removeFromSuperview];
}

-(void)setProgess:(double)_progess
{
    if (indicatorStyle==kRotationIndicatorStyle)
    {
        self.HUDIndicator.progress = _progess;
    }
    else if(indicatorStyle==kCircleIndicatorStyle)
    {
        [self.circleIndicator setArcAngle:(_progess * M_PI*2)];
    }
    else if(indicatorStyle==kProgressLowerStyle)
    {
        self.progressIndicatorView.progressView.progress = _progess;
    }
}

- (void)showIndicatorWithMessage:(NSString*)message
{
    LoadingIndicatorStyle style =indicatorStyle;

    if (style==kDialIndicatorStyle) 
    {
        if (activityIndicator==nil) {
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            // add activityIndicator
            [self addSubview:activityIndicator];
            [activityIndicator startAnimating];
        }
    }
    else if(style==kRotationIndicatorStyle)
    {
        if (HUDIndicator==nil) {
            self.HUDIndicator = [[MBProgressHUD alloc] initWithView:self];
            HUDIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            // Set determinate mode
            HUDIndicator.mode = MBProgressHUDModeIndeterminate;
            //MBProgressHUDModeDeterminate;
            HUDIndicator.delegate = self;
            HUDIndicator.labelText = message;
            [self addSubview:HUDIndicator];
            
            [HUDIndicator show:NO];
        }
    }
    else if(style==kCircleIndicatorStyle)
    {
        if (circleIndicator==nil) {
            self.circleIndicator = [[CircleIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 160, 140.)] ;
            circleIndicator.delegate=self;
            circleIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            circleIndicator.label.text=message;
            // add activityIndicator
            [self addSubview:circleIndicator];
        }
    }
    else if(style==kProgressSeniorStyle
            || style==kProgressLowerStyle
            || style==kProgressDefaultStyle)
    {
        if(progressViewLength==0)
            progressViewLength = self.frame.size.width;
        
        if (progressIndicatorView==nil) 
        {
            self.progressIndicatorView = [[ProgressIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width-progressViewLength)/2,self.frame.size.height-40, progressViewLength, 40)];
            progressIndicatorView.delegate=self;
            [self addSubview:progressIndicatorView];
            if (style==kProgressSeniorStyle) {
                progressIndicatorView.userInteractionEnabled=YES;
            }
            else if (style==kProgressDefaultStyle){
                progressIndicatorView.userInteractionEnabled=NO;
            }
            else
            {
                progressIndicatorView.userInteractionEnabled=NO;
                progressIndicatorView.label.hidden=YES;
            }
        }
    }
    self.progess = 0;
}

-(void)hideIndicator
{
    if (circleIndicator) 
    {
        [circleIndicator removeFromSuperview];
        self.circleIndicator=nil;
    }
    if (HUDIndicator) 
    {
        [HUDIndicator hide:NO];
        [HUDIndicator removeFromSuperview];
        self.HUDIndicator=nil;
    }
    if (activityIndicator) 
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        self.activityIndicator=nil;
    }
    if(progressIndicatorView)
    {
        [progressIndicatorView removeFromSuperview];
        self.progressIndicatorView=nil;
    }
    [self removeFromSuperview];
}

-(void)setFrame:(CGRect)frame
{
    super.frame= frame;
    
    if (circleIndicator) 
    {
        circleIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    else if(HUDIndicator)
    {
        HUDIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    else if(activityIndicator)
    {
        activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    else if(progressIndicatorView)
    {
        self.progressIndicatorView.frame = CGRectMake((self.frame.size.width-progressViewLength)/2,self.frame.size.height-40, progressViewLength, 40);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) 
    {
        UIView* _superView = object;
        self.frame=CGRectMake(0, 0, _superView.frame.size.width, _superView.frame.size.height);
    }
}

#pragma mark - delegate implementation

-(void)cancel:(CircleIndicatorView*)circleIndicatorView_
{
    [self cancelDownload];
}

-(void)cancelDownload:(ProgressIndicatorView *)progressIndicatorView_{
     [self cancelDownload];
}
-(void)stopDownload:(ProgressIndicatorView *)progressIndicatorView_
{
    loadState=2;
    [self stopDownload];
}
-(void)continueDownload:(ProgressIndicatorView *)progressIndicatorView_{

    [self resumeDownloadWithUrl:fileUrl toPath:filePath];
}

#pragma mark - download process

- (void)cancelDownload
{
    loadState=0;
    [self stopDownload];
    [self hideIndicator];
}

- (void)stopDownload
{
//    if (lengthRequest) 
//    {
//        lengthRequest.delegate=nil;
//        [lengthRequest cancel];
//        [lengthRequest release];
//        lengthRequest=nil;
//    } 
    
    if (request) 
    {
        request.delegate=nil;
        [request cancel];
//        [request release];
        request=nil;
    }
    
//    if (self.fileStream) {
//        [self.fileStream close];
//        self.fileStream = nil;
//    } 
//    
//    if (self.fielHander) {
//        [self.fielHander closeFile];
//        self.fielHander= nil;
//    } 
//    
//    if (_connection) {
//        [_connection cancel];
//        [_connection release];
//        _connection=nil;
//    }
}

-(void)downloadDidFinished{
    loadState = 3;
    if(delegate && [delegate respondsToSelector:@selector(downloadDidFinished:filePath:)])
    {
        [delegate  performSelector:@selector(downloadDidFinished:filePath:) withObject:self withObject:filePath];
    }
}

-(void)dataReceived:( NSData *) data {
    //NSLog(@"urlString:%@",urlString);
    bytesReceived+=[data length];
    if (indicatorStyle==kRotationIndicatorStyle)
    {
        self.HUDIndicator.progress = (double)bytesReceived/contentLength;
    }
    else if(indicatorStyle==kCircleIndicatorStyle)
    {
        [self.circleIndicator setArcAngle:((double)bytesReceived/contentLength) * M_PI*2];
    }
    else if(indicatorStyle==kProgressSeniorStyle
            || indicatorStyle==kProgressLowerStyle
            || indicatorStyle==kProgressDefaultStyle)
    {
        [self.progressIndicatorView updateProgressInfo:bytesReceived contentSize:contentLength];
    }
}

-(void)downloadFailed
{
    if (loadState==2)//暂停下载
    {
        return;
    }
    if (indicatorStyle==kCircleIndicatorStyle) {
        self.circleIndicator.label.text= @"网络链接失败!";
    }
    else if(indicatorStyle==kRotationIndicatorStyle)
    {
        self.HUDIndicator.labelText = @"网络链接失败!";
    }
    else if(indicatorStyle==kProgressDefaultStyle
            || indicatorStyle==kProgressLowerStyle
            || indicatorStyle==kProgressSeniorStyle)

    {
        progressIndicatorView.label.text=@"网络链接失败!";
    }
}

- (void)startDownloadWithUrl:(NSURL*)url toPath:(NSString*)path
{
    if (![url.absoluteString.lowercaseString hasPrefix:@"http"])
    {
        [self removeFromSuperview];
        return;
    }
    
    self.fileUrl=url;
    self.filePath=path;

    [self showIndicatorWithMessage:@"正在下载中..."];
//    //分析leaks去掉了retain
//    self.data = [[NSMutableData data] retain];
    
//    if (request) {
//        [request release];
//    }
    request = [ASIHTTPRequest requestWithURL:url] ;
    request.timeOutSeconds = 60;
    request.numberOfTimesToRetryOnTimeout = 2;
//    [request addRequestHeader:@"Referer" value:@"http://www.5i5j.com"];
    //When downloading data to a file using downloadDestinationPath , data will be saved in a temporary file while the request is in progress. This file’s path is stored in temporaryFileDownloadPath .
    [request setDownloadDestinationPath:filePath];
//    request.downloadProgressDelegate = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif 
    [request startAsynchronous];
    loadState = 1;//
    __weak typeof(self) weakSelf = self;
    [request setStartedBlock:^(void){
//        NSLog(@"file path:%@",request.temporaryFileDownloadPath);
//        NSLog(@"file path:%@",weakSelf.filePath);
    }];
    [request setHeadersReceivedBlock:^(NSDictionary *responseHeaders)
     {
        NSLog(@"header %@", [responseHeaders objectForKey:@"Content-Length"]);
     }];
    // 使用 complete 块，在下载完时做一些事情
    [request setCompletionBlock :^( void ){
        //NSLog(@"complete urlString:%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideIndicator];
            [weakSelf downloadDidFinished];
        });

    }];
    // 使用 failed 块，在下载失败时做一些事情
    [request setFailedBlock :^( void ){
        [weakSelf downloadFailed];
    }];
//    // 使用 received 块，在接受到数据时做一些事情
//    //重写此blok后将不能自动往downloadDestinationPath里下载数据了
//    [request setDataReceivedBlock :^( NSData * data ){
//        [self.data appendData:data];
//        [self dataReceived:data];
//     }];
    

}

#pragma mark - 端点续传
-(unsigned long long)getFileSizeWithPath:(NSString*)path
{
    //TMP_FILE_PATH([path lastPathComponent]);
    // NSLog(@"1.tempPath:%@",tempPath);
    NSDictionary *fileAttributes;
    NSFileManager *_manager = [NSFileManager defaultManager];
    if (![_manager fileExistsAtPath:path]) 
    {
        if (![_manager fileExistsAtPath:tempPath]) 
        {
            [_manager createFileAtPath :tempPath contents : nil attributes : nil ];
            //self.fielHander=[ NSFileHandle fileHandleForWritingAtPath :tempPath];
        }
        fileAttributes = [_manager fileAttributesAtPath:tempPath traverseLink:YES];
    }
    else
    {
        fileAttributes = [_manager fileAttributesAtPath:path traverseLink:YES];
    }
    
    unsigned long long fileLength = 0;
    NSNumber *fileSize;
    NSString *fileOwner, *creationDate;
    NSDate *fileModDate;
    if (fileAttributes != nil) 
    {
        //文件大小
        fileSize = [fileAttributes objectForKey:NSFileSize];
        if (fileSize) {
            fileLength = [fileSize unsignedLongLongValue];
            // NSLog(@"File size: %qi\n", fileLength);
        }
        creationDate = [fileAttributes objectForKey:NSFileCreationDate];
        //文件创建日期
        if (creationDate) {
            // NSLog(@"File creationDate: %@\n", creationDate);
            //textField.text=NSFileCreationDate;
        }
        
        //文件所有者
        fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
        if (fileOwner) {
            // NSLog(@"Owner: %@\n", fileOwner);
        }
        
        //文件修改日期
        fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        if (fileModDate) {
            // NSLog(@"Modification date: %@\n", fileModDate);
        }
    }
    else {
        fileLength=0;
        // NSLog(@"Path (%@) is invalid.", path);
    }
    return fileLength;
}

- (void)resumeDownloadWithUrl:(NSURL*)url toPath:(NSString*)path
{
    if (![url.absoluteString.lowercaseString hasPrefix:@"http"]) {
        [self removeFromSuperview];
        return;
    }

    [self showIndicatorWithMessage:@"正在下载中..."];
    
    contentLength=0;
    self.fileUrl=url;
    self.filePath=path;
    tempPath=[filePath stringByAppendingString:@".tmp"] ;
    
    if (request) {
        [request cancel];
//        [request release];
    }
    request = [ASIHTTPRequest requestWithURL:fileUrl] ;
    request.delegate=nil;
    request.timeOutSeconds = 60;
    request.numberOfTimesToRetryOnTimeout = 2;
    //request.persistentConnectionTimeoutSeconds = NSTimeIntervalSince1970;
//    [request addRequestHeader:@"Referer" value:@"http://www.5i5j.com"];
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    [request setDownloadDestinationPath:filePath];//下载完成后的文件地址
    [request setTemporaryFileDownloadPath:tempPath];//缓存是必须的
    [request setDownloadProgressDelegate:self];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    bytesReceived = [self getFileSizeWithPath:tempPath];
    if (bytesReceived>0) {
             NSLog(@"downloadLen %lld",bytesReceived);
    }
    /*
    //NSLog(@"2.tempPath:%@",tempPath);
    if (fileStream) {
        [fileStream close];
    }
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:tempPath append:YES];
    [self.fileStream open];
    
    if (bytesReceived>0)
    {
        NSString *downloadLen = [NSString stringWithFormat:@"bytes=%llu",bytesReceived];
        [request addRequestHeader:@"Range" value:downloadLen];
    }
     */
    [request startAsynchronous];
    loadState=1;
    
    __weak typeof(self) weakSelf = self;
    
    [request setHeadersReceivedBlock:^(NSDictionary *responseHeaders)
     {
//        NSLog(@"header %@", [responseHeaders objectForKey:@"Content-Length"]);
         [weakSelf downloadHeadersReceived];
     }];
    // 使用 complete 块，在下载完时做一些事情
    [request setCompletionBlock :^( void ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideIndicator];
            [weakSelf downloadDidFinished];
        });
    }];
    // 使用 failed 块，在下载失败时做一些事情
    [request setFailedBlock :^( void ){
        [weakSelf downloadFailed];
    }];
    /*
    // 使用 received 块在接受到数据时做一些事情，
    //重写此blok后将不能自动往downloadDestinationPath里下载数据了
    [request setDataReceivedBlock :^( NSData * data )
     {
         //更新下载进度
         [weakSelf dataReceived:data];
         //写入接收的数据
         NSInteger bytesWritten = [weakSelf.fileStream write:[data bytes] maxLength:[data length]];
         if (bytesWritten == -1) {
             //NSLog(@"文件写入出错");
             [weakSelf stopDownload];
         }   
     }];
     */
}

-(void)downloadHeadersReceived
{
    contentLength = request.contentLength;
    if (contentLength==0) {
        [request cancel];
    }
}

- (void)setProgress:(float)newProgress
{
    if (indicatorStyle==kRotationIndicatorStyle)
    {
        self.HUDIndicator.progress = newProgress;
    }
    else if(indicatorStyle==kCircleIndicatorStyle)
    {
        [self.circleIndicator setArcAngle:(newProgress * M_PI*2)];
    }
}

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSLog(@"downloadLen %lld",bytes);
}

//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    
//}

@end
