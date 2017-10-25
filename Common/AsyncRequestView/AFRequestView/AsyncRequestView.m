//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//
#import "AsyncRequestView.h"
// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@interface AsyncRequestView ()
//@property(nonatomic,retain) NSMutableData * data;
@property(nonatomic,copy)   NSString *downloadPath;
@property(nonatomic,retain) NSURL * fileUrl;
//@property(nonatomic,retain) NSFileHandle *fielHander;
//@property(nonatomic,retain) NSOutputStream * fileStream;
@property(nonatomic,retain) MBProgressHUD* HUDIndicator;
@property(nonatomic,retain) CircleIndicatorView* circleIndicator;
@property(nonatomic,retain) UIActivityIndicatorView* activityIndicator;
@property(nonatomic,retain) ProgressIndicatorView* progressIndicatorView;
@property(nonatomic,assign) SEL methodForExecution;
@property(nonatomic,assign) id targetForExecution;
//@property(nonatomic,assign) NSOperationQueue* requestQueue;
@property(nonatomic,strong) NSURLSessionDownloadTask* request;
@end


//static NSOperationQueue* networkQueue = nil;

@implementation AsyncRequestView

@synthesize indicatorStyle;
//@synthesize data=_data;
@synthesize delegate;
@synthesize HUDIndicator;
@synthesize activityIndicator;
@synthesize circleIndicator;
@synthesize progressIndicatorView;
@synthesize progressViewLength;
@synthesize progess;
//@synthesize fileStream;
//@synthesize fielHander;
@synthesize downloadPath;
@synthesize fileUrl;
@synthesize methodForExecution,targetForExecution;
@synthesize request = _request;
- (void)dealloc 
{
    self.delegate=nil;
    
    [self cancelDownload];
    
//    [super dealloc];
}

//-(NSOperationQueue*)requestQueue
//{
//    if (!networkQueue) {
//        networkQueue = [[NSOperationQueue alloc] init];
//        networkQueue.maxConcurrentOperationCount = 4;
//    }
//    return networkQueue;
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
    if(targetForExecution && methodForExecution)
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
    else if([keyPath isEqualToString:@"completedUnitCount"])
    {
        NSProgress* progress = object;
        NSLog(@"%f",1.0 * progress.completedUnitCount / progress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
        });
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

    [self resumeDownloadWithUrl:fileUrl toPath:downloadPath];
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
    if (_request)
    {
//        request.delegate=nil;
        [_request cancel];
//        [request release];
        self.request=nil;
    }
    

}

-(void)downloadDidFinished{
    loadState = 3;
    if(delegate && [delegate respondsToSelector:@selector(downloadDidFinished:filePath:)])
    {
        [delegate  performSelector:@selector(downloadDidFinished:filePath:) withObject:self withObject:downloadPath];
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
    
    __weak typeof(self) weakSelf = self;
    
    self.fileUrl=url;
    self.downloadPath=path;
//    NSLog(@"%@   %@",url.absoluteString,path);
    [self showIndicatorWithMessage:@"正在下载中..."];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *urlRequest =[serializer requestWithMethod:@"get" URLString:url.absoluteString parameters:nil error:nil];

    self.request = [[AFHTTPSessionManager manager]
               downloadTaskWithRequest:urlRequest progress:nil
      destination: ^NSURL *(NSURL *targetPath, NSURLResponse *response)
      {
          if ([fileManager fileExistsAtPath:path])
          {
              [fileManager removeItemAtPath:path error:nil];
          }
          NSURL *fileURL =[NSURL fileURLWithPath:path];
          return fileURL;
      }
      completionHandler:^(NSURLResponse *response, NSURL *  filePath, NSError *  error)
      {
          if ([fileManager fileExistsAtPath:[filePath path]])
          {
              //回调放到主线程执行，nls，2016-03-29
              dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf hideIndicator];
                  [weakSelf downloadDidFinished];
              });
              
              NSLog(@"下载成功 %@",url.absoluteString);
              
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf downloadFailed];
              });
              NSLog(@"下载失败 %@",url.absoluteString);
          }
      }];
    
    [self.request resume];
    loadState = 1;//

}

#pragma mark - 端点续传
-(unsigned long long)getFileSizeWithPath:(NSString*)path
{
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
    
    __weak typeof(self) weakSelf = self;
    
    [self showIndicatorWithMessage:@"正在下载中..."];

    self.fileUrl=url;
    self.downloadPath=path;

    if (self.request) {
        [_request cancel];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"get";
    //检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //获取已下载的文件长度
        downloadedBytes = [self getFileSizeWithPath:path];
        if (downloadedBytes > 0) {
//            NSMutableURLRequest *mutableURLRequest = [urlRequest mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [urlRequest setValue:requestRange forHTTPHeaderField:@"Range"];
//            urlRequest = mutableURLRequest;
        }
    }
    //不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:urlRequest];
//    __block NSProgress* requestProgress = [NSProgress progressWithTotalUnitCount:0];
    self.request = [[AFHTTPSessionManager manager]
               downloadTaskWithRequest:urlRequest progress:nil
       destination: ^NSURL *(NSURL *targetPath, NSURLResponse *response)
       {
           if ([fileManager fileExistsAtPath:path])
           {
               [fileManager removeItemAtPath:path error:nil];
           }
           NSURL *fileURL =[NSURL fileURLWithPath:path];
           return fileURL;
       }
       completionHandler:^(NSURLResponse *response, NSURL *  filePath, NSError *  error)
       {
           if ([fileManager fileExistsAtPath:[filePath path]])
           {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [weakSelf hideIndicator];
                   [weakSelf downloadDidFinished];
               });
               NSLog(@"下载成功 %@",url.absoluteString);
           }
           else
           {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [weakSelf downloadFailed];
               });
               NSLog(@"下载失败 %@",url.absoluteString);
           }
       }];

    
    [self.request resume];
    loadState = 1;

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


@end
