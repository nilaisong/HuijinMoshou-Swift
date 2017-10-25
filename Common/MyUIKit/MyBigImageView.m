//
//  MyBigImageView.m
//  AuctionCatalog
//
//  Created by Laison on 12-4-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "MyBigImageView.h"
#import "Functions.h"
#import <QuartzCore/QuartzCore.h>
#import "MyTiledLayer.h"
@interface MyBigImageView()
@property(nonatomic,retain) AsyncRequestView * requetView;

@end

@implementation MyBigImageView

@synthesize delegate;

@synthesize imagePath;
@synthesize image=_image;
@synthesize requetView;
@synthesize imageFrame;
@synthesize zoomingView;

-(void)dealloc
{
    if (requetView) {
        [self removeObserver:requetView forKeyPath:@"frame"];
    }
    self.delegate=nil;
    requetView.delegate=nil;
    [requetView cancelDownload];
    [self.layer removeFromSuperlayer];
    [imagePath release];
    [requetView release];
    
    [super dealloc];
        
   [_image release];
//    NSLog(@"dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initialize];
    }

    return  self;
}

-(id)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    CATiledLayer *tiledLayer = (MyTiledLayer *)[self layer];
    // levelsOfDetail and levelsOfDetailBias determine how
    // the layer is rendered at different zoom levels.  This
    // only matters while the view is zooming, since once the
    // the view is done zooming a new TiledPDFView is created
    // at the correct size and scale.
    tiledLayer.levelsOfDetail = 4;
    tiledLayer.levelsOfDetailBias = 3;
    //The maximum size of each tile used to create the layer's content.
    tiledLayer.tileSize = CGSizeMake(512*2, 512*2);
    // tiledLayer.delegate=self;
    [self setBackgroundColor:[UIColor clearColor]];
    translateCTM=YES;
    self.ImageViewContentModel = UIViewContentModeScaleAspectFill;
}

+ (Class)layerClass {
	return [MyTiledLayer class];
}

- (BOOL)setImageWithPath:(NSString *)path{
    self.imagePath = path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) 
    {
        [self setImage:[UIImage imageWithContentsOfFile:imagePath]];
        return YES;
    }
    else {
        return NO;
    }
}

-(void)setImageWithUrlString:(NSString *)url toPath:(NSString*)path
{
    self.imagePath = path;
    //先取缓存里的图片
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        if (img!=nil)
        {
            [self setImage:img];
            return;
        }
    }
    if (url.length>0)
    {
        if (!requetView)
        {
            self.requetView = [[[AsyncRequestView alloc] initWithFrame:self.bounds] autorelease];
            requetView.delegate=self;
            requetView.indicatorStyle = kDialIndicatorStyle;
            [self addObserver:requetView
                   forKeyPath:@"frame"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        }
        else
        {
            [requetView cancelDownload];
        }
        [self addSubview:requetView];
        [requetView resumeDownloadWithUrl:[NSURL URLWithString:url] toPath:self.imagePath];
    }
}

-(void)setImageWithUrlString:(NSString *)url
{
    //确定图片的缓存地址
    NSString* imgPath = filePathWithUrl(url,@"",@"ImageCache");
    [self setImageWithUrlString:url toPath:imgPath];
}

-(void)setImageWithUrlString:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    [self setImageWithUrlString:url];
}

-(void)setImageWithUrlString:(NSString *)url toPath:(NSString*)path placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    [self setImageWithUrlString:url toPath:path];
}

-(void)downloadDidFinished:(AsyncRequestView*)request filePath:(NSString*)path
{
    //NSLog(@"2.path:%@",path);
    [requetView removeFromSuperview];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
    {
        
        UIImage* img = [UIImage imageWithContentsOfFile:path];
        if (img !=nil)
        {
            self.image = img;
            if (delegate)
            {
                if ([delegate respondsToSelector:@selector(didDownloadWithImage:image:)])
                {
                    [delegate  didDownloadWithImage:self image:self.image];
                }
            }
        }
    }
}

-(void)setImage:(UIImage *)image
{
    if (_image!=image) 
    {
        [_image release];
        _image=nil;
        _image= [image retain];
        //放大到原图大小
        if (zoomingView)
        {
            CGSize imageSize = image.size;
            CGSize imageViewSize = self.frame.size;
            double rate=scaleAspectFitRate(imageSize, imageViewSize);//////反过来
            zoomingView.maximumZoomScale = (rate<1.0?1.0:rate);
//            NSLog(@"rate:%f",rate);
        }
        //重新绘制大图
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setNeedsDisplay) object:nil];
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.4];
    }

}

-(CGRect)imageFrame
{
    if (self.ImageViewContentModel==UIViewContentModeScaleAspectFill)
    {
        imageFrame = self.bounds;
    }
    else
    {
        if (CGRectIsEmpty(imageFrame)
            && !CGSizeEqualToSize(self.image.size, CGSizeZero)) 
        {
            CGSize imageSize = self.image.size;
            //NSLog(@"imageSize:%f,%f",imageSize.width,imageSize.height);
            CGSize imageViewSize = self.frame.size;
            //NSLog(@"imageViewSize:%f,%f",imageViewSize.width,imageViewSize.height);
            double rate=scaleAspectFitRate(imageSize, imageViewSize);
            //NSLog(@"rate:%f",rate);
            imageFrame = CGRectMake(0, 0,round(imageSize.width*rate), round(imageSize.height*rate));
            imageFrame.origin.x = (imageViewSize.width - imageFrame.size.width)/2.0;
            imageFrame.origin.y = (imageViewSize.height - imageFrame.size.height)/2.0;
        }
    }
    return imageFrame;
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
    if (self.image!=nil) 
    {
        //转换当前图层上下文中的坐标系（UIKit）和Quartz 2D原始坐标系保持一致
        if (translateCTM) 
        {
            CGContextTranslateCTM(context, 0, self.frame.size.height); //在x轴上的位置不变，y轴上的位置下移
            CGContextScaleCTM(context, 1.0, -1.0);//x轴方向不变，y轴改为朝上
        }
        if (self.image.CGImage != nil)
        {
            CGContextDrawImage(context, self.imageFrame, self.image.CGImage);
        }
    }
}

@end
