//
//  PictureViewController.m
//  Common
//
//  Created by Ni Laisong on 12-7-18.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "PictureViewController.h"
#import "MyImageView.h"
#import "MyScrollView.h"

//私有属性和方法
@interface PictureViewController ()<MyBigImageViewDelegate,MyImageViewDelegate,UIScrollViewDelegate>

@end

@implementation PictureViewController

@synthesize logoUrl;
@synthesize logoPath;
@synthesize imageUrl;
@synthesize imagePath;
@synthesize maximumZoomScale;
@synthesize minimumZoomScale;
@synthesize zoomingView;
@synthesize imageView;
@synthesize logoView;
//@synthesize paintImageView;
//@synthesize paintImagePath;

//@synthesize description;
@synthesize delegate;

-(void)dealloc
{
    [logoUrl release];
    [logoPath release];
    [imageUrl release];
    [imagePath release];
    [zoomingView release];
    [imageView release];
    [logoView release];
//    [description release];

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - ScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.logoView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (delegate && [delegate respondsToSelector:@selector(imageViewDidEndZooming:atScale:)]) {
        [delegate imageViewDidEndZooming:self atScale:scale];
    }
}

//修改frame之前，"缩放"恢复为原始大小
- (void)keeNotZoom
{
    [zoomingView setZoomScale:1.0 animated:YES];
    zoomingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    zoomingView.contentSize = self.view.frame.size;
}

#pragma mark - imageView & logoView
-(void)didDownloadWithImage:(MyBigImageView*)imageView_ image:(UIImage*)image
{

}

-(void)imageDidDownload:(MyImageView*)imageView image:(UIImage*)image{
    
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.frame = CGRectMake(0, 0, self.supperViewController.view.frame.size.width, self.supperViewController.view.frame.size.height);
    
    CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.zoomingView = [[[MyScrollView alloc] initWithFrame:frame] autorelease];
    //[self.zoomingView setBackgroundColor:[UIColor clearColor]];
    zoomingView.showsVerticalScrollIndicator = NO;
    zoomingView.showsHorizontalScrollIndicator = NO;
    zoomingView.delegate = self;
    zoomingView.maximumZoomScale = maximumZoomScale==0?1.0:maximumZoomScale;
    zoomingView.minimumZoomScale = 1.0;
    //minimumZoomScale==0?1.0:minimumZoomScale;
    zoomingView.bouncesZoom = YES;
    zoomingView.bounces=YES;
    zoomingView.clipsToBounds = YES;
    [self.view addSubview:zoomingView];
    
    self.logoView  = [[[MyImageView alloc] initWithFrame:frame] autorelease];
    [zoomingView addSubview:self.logoView];
    
    //[self.logoView setBackgroundColor:[UIColor clearColor]];
    self.logoView.delegate=self;
    self.logoView.contentMode=UIViewContentModeScaleAspectFit;
//    if (![logoView setImageWithPath:logoPath])
    {
        [logoView setImageWithUrlString:logoUrl];
    }
    //添加大图片和手写标记视图
    if (imageUrl.length>0)
    {
        self.imageView  = [[[MyBigImageView alloc] initWithFrame:frame] autorelease];
        [logoView addSubview:self.imageView];
        //[self.imageView setBackgroundColor:[UIColor clearColor]];
        self.imageView.delegate=self;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        if (maximumZoomScale==0)//放大到原图大小
        {
            self.imageView.zoomingView=self.zoomingView;
        }
//        self.paintImageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
//        //[self.paintImageView setBackgroundColor:[UIColor clearColor]];
//        self.paintImageView.contentMode=UIViewContentModeScaleAspectFit;
//        [self.imageView addSubview: self.paintImageView];
    }


}

-(void)showImages
{
//    if (![logoView setImageWithPath:logoPath])
    {
        [logoView setImageWithUrlString:logoUrl];
    }
    //显示大图片和手写标记
    if (imageUrl.length>0)
    {
        //大图非断点续传
        if (![imageView setImageWithPath:imagePath])
        {
            [imageView setImageWithUrlString:imageUrl];
        }
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(NSNotification*)notification
{
    if (![self.view.superview isKindOfClass:[UIScrollView class]]) 
    {
        self.view.frame = CGRectMake(0, 0, self.supperViewController.view.frame.size.width, self.supperViewController.view.frame.size.height);
    }
    
    [self keeNotZoom];
    self.logoView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.imageView  removeFromSuperview];
    self.imageView=nil;
    
}

- (void)didRotateToInterfaceOrientation:(NSNotification*)notification
{
    if (imageUrl.length>0) 
    {
        //    UIInterfaceOrientation toInterfaceOrientation = [(NSNumber*)[notification.userInfo objectForKey:@"toInterfaceOrientation"] intValue] ;
        CGRect frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.imageView  = [[[MyBigImageView alloc] initWithFrame:frame] autorelease];
        [logoView addSubview:self.imageView];
        //[self.imageView setBackgroundColor:[UIColor clearColor]];
        self.imageView.delegate=self;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        if (![imageView setImageWithPath:imagePath]) {
            [imageView setImageWithUrlString:imageUrl];
        }
    }
}

@end
