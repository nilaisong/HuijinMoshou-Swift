//
//  ProgressIndicatorView.m
//  Common
//
//  Created by Ni Laisong on 12-7-12.
//  Copyright (c) 2012年 . All rights reserved.
//


#import "ProgressIndicatorView.h"
#import "UIColor+Category.h"
#import "Functions.h"
@interface ProgressIndicatorView()
@property(nonatomic,retain) UIButton* cancelBtn;
@property(nonatomic,retain) UIButton* downloadBtn;
@end

@implementation ProgressIndicatorView

@synthesize progressView,label;
@synthesize delegate;
@synthesize cancelBtn,downloadBtn;

//-(void)dealloc
//{
//    [label release];
//    [progressView release];
//    [cancelBtn release];
//    [downloadBtn release];
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float margin = 5.0;
        self.progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(margin, margin, frame.size.width-margin*2, 9)] ;
        [progressView setOuterColor: [UIColor colorWithString:(NSString*)valueForKeyFromPlistFile(@"ProgressViewOuterColor",@"RequestView.plist")]] ;//边框颜色
        [progressView setInnerColor: [UIColor colorWithString:(NSString*)valueForKeyFromPlistFile(@"ProgressViewInnerColor",@"RequestView.plist")]] ;//进度条颜色
        [progressView setEmptyColor: [UIColor colorWithString:(NSString*)valueForKeyFromPlistFile(@"ProgressViewEmptyColor",@"RequestView.plist")]] ;//轨道颜色
        [self addSubview:progressView];

//        progressView.progressImage = [UIImage imageNamed:@"progressLeft"];
//        progressView.trackImage = [UIImage imageNamed:@"progressRight"];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(margin, self.progressView.frame.origin.y+self.progressView.frame.size.height, frame.size.width-margin*2, 22)] ;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        label.hidden=NO;
        
        UIImage * buttonBgImg = [UIImage imageNamed:@"download_botton_bg"];
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundImage:buttonBgImg forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.showsTouchWhenHighlighted = YES;
        cancelBtn.frame = CGRectMake(frame.size.width-margin-buttonBgImg.size.width, self.progressView.frame.origin.y+self.progressView.frame.size.height, buttonBgImg.size.width, buttonBgImg.size.height);
        [self addSubview:cancelBtn];
        cancelBtn.hidden=YES;
        
        self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadBtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        [downloadBtn setBackgroundImage:buttonBgImg forState:UIControlStateNormal];
        [downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [downloadBtn setTitle:@"继续" forState:UIControlStateSelected];
        [downloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [downloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        downloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        downloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        downloadBtn.showsTouchWhenHighlighted = YES;
        downloadBtn.frame = CGRectMake(cancelBtn.frame.origin.x-margin-cancelBtn.frame.size.width, self.progressView.frame.origin.y+self.progressView.frame.size.height, buttonBgImg.size.width, buttonBgImg.size.height);
        [self addSubview:downloadBtn];
        downloadBtn.hidden=YES;
    }
    return self;
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled_
{
    super.userInteractionEnabled = userInteractionEnabled_;
    
    downloadBtn.hidden=!userInteractionEnabled_;
    cancelBtn.hidden=!userInteractionEnabled_;
    //label.hidden=!userInteractionEnabled_;
    
    if (userInteractionEnabled_) 
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        CALayer *layer= self.layer;
        [layer setValue:(id)[UIColor blackColor].CGColor forKeyPath:@"shadowColor"];
        [layer setValue:[NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)] forKeyPath:@"shadowOffset"];//阴影偏移量
        [layer setValue:[NSNumber numberWithFloat:2.0] forKeyPath:@"shadowRadius"];//阴影大小
        [layer setValue:[NSNumber numberWithFloat:0.8] forKeyPath:@"shadowOpacity"];//透明度
    }
}

-(void)updateProgressInfo:(NSInteger)receivedSize contentSize:(NSInteger)contentSize{
    float received = (float)receivedSize/(1024*1024);
    float content = (float)contentSize/(1024*1024);
    label.text = [NSString stringWithFormat:@"下载进度:%0.2f/%0.2fM",received,content];
    
    float percentage = (float)receivedSize/contentSize;
    [progressView setProgress:percentage];
}

-(void)cancel:(UIButton*)sender{
    if (delegate) {
        if ([delegate respondsToSelector:@selector(cancelDownload:)]) {
            [delegate performSelector:@selector(cancelDownload:)];
        }
    }
}

-(void)download:(UIButton*)sender{
    if (!sender.selected) 
    {
        sender.selected=YES;
        if (delegate && [delegate respondsToSelector:@selector(stopDownload:)]) 
        {
            [delegate performSelector:@selector(stopDownload:)];
        }
    }
    else {
        sender.selected=NO;
        if (delegate && [delegate respondsToSelector:@selector(continueDownload:)])
        {
            [delegate performSelector:@selector(continueDownload:)];
        }
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
