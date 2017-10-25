
//  AsyncRequestView.h
//
//  Created by Laisong on 2012-03-10.

//
typedef enum {
    kDialIndicatorStyle=1,//只有轮转
    kProgressDefaultStyle=2,//进度条和文本提示
    kProgressSeniorStyle=3,//进度条提示和文本，有取消和暂停按钮
    kProgressLowerStyle=6,//只有进度条提示
    kRotationIndicatorStyle=4,//圆角矩形上有轮转，文字提示
    kCircleIndicatorStyle=5//圆角矩形上饼图填充，有文字提示
} LoadingIndicatorStyle;

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "CircleIndicatorView.h"
#import "MBProgressHUD.h"
#import "ProgressIndicatorView.h"


#if NS_BLOCKS_AVAILABLE
typedef void (^RequestCompletionBlock)(id data);
#endif

@class AsyncRequestView;

@protocol AsyncRequestViewDelegate<NSObject>

-(void)dataDidDownloaded:(AsyncRequestView*)request data:(NSMutableData*)data;
-(void)downloadDidStarted:(AsyncRequestView*)request tempPath:(NSString*)path;
-(void)downloadDidFinished:(AsyncRequestView*)request filePath:(NSString*)path;

@end

@interface AsyncRequestView : UIView<MBProgressHUDDelegate,CircleIndicatorViewDelegate,ProgressIndicatorViewDelegate> {
	//could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to 
	// to build into this class?
    ASIHTTPRequest *request;
    ASIHTTPRequest *lengthRequest;
    NSURLConnection *_connection;
    int loadState;//0:未下载,1:正在下载,2:停止下载,3:下载完成
//    RequestCompletionBlock completion;
    
    unsigned long long bytesReceived;
    long long expectedBytes;
    unsigned long long contentLength;
     
    NSString* urlString;
    NSString* tempPath;
}

@property (nonatomic , assign) LoadingIndicatorStyle indicatorStyle;
@property (nonatomic,assign) float progressViewLength;
@property (nonatomic , assign) id<AsyncRequestViewDelegate> delegate;//数据需求者
@property (nonatomic,assign) double progess;//数据范围:0.0 - 1.0
//@property (nonatomic , assign) SEL requestFinishedSelector;
//@property (nonatomic , assign) SEL downloadFinishedSelector;

-(unsigned long long)getFileSizeWithPath:(NSString*)path;
- (void)startDownloadWithUrl:(NSURL*)url toPath:(NSString*)path;
- (void)resumeDownloadWithUrl:(NSURL*)url toPath:(NSString*)path;
- (void)stopDownload;
- (void)cancelDownload;

//- (void (^)(id data))completionBlock NS_AVAILABLE(10_6, 4_0);
//- (void)setCompletionBlock:(void (^)(id data))block NS_AVAILABLE(10_6, 4_0);

//- (void)showIndicator;
- (void)hideIndicator;

- (id)initWithView:(UIView *)view andIndicatorStyle:(LoadingIndicatorStyle)style;
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object andMessage:(NSString*)message;

@end

int getFileSizeFromPath(char * path);
