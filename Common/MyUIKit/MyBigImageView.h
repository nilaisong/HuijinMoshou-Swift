//
//  MyBigImageView.h
//  断点续传异步下载，并分区绘制显示高清图
//
//  Created by Laison on 12-4-10.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncRequestView.h"

@protocol MyBigImageViewDelegate; 



@interface MyBigImageView : UIView<AsyncRequestViewDelegate>
{
    BOOL translateCTM;
}
@property(nonatomic,assign) id<MyBigImageViewDelegate> delegate;

@property(nonatomic,copy) NSString* imagePath;
@property(nonatomic,retain) UIImage* image;
@property(nonatomic,assign) CGRect imageFrame;
@property(nonatomic,assign) UIScrollView * zoomingView;
@property(nonatomic,assign) UIViewContentMode ImageViewContentModel;

- (BOOL)setImageWithPath:(NSString *)path;
//保存到指定路径
-(void)setImageWithUrlString:(NSString *)url toPath:(NSString*)path;

-(void)setImageWithUrlString:(NSString *)url toPath:(NSString*)path placeholderImage:(UIImage *)placeholder;
//保存到默认路径
-(void)setImageWithUrlString:(NSString *)url;
-(void)setImageWithUrlString:(NSString *)url placeholderImage:(UIImage *)placeholder;

@end

@protocol MyBigImageViewDelegate <NSObject>

-(void)didDownloadWithImage:(MyBigImageView*)imageView image:(UIImage*)image;

@end