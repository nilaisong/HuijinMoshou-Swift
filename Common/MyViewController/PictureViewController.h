//
//  PictureViewController.h
//  Common
//
//  Created by Ni Laisong on 12-7-18.
//  Copyright (c) 2012年 . All rights reserved.
//


#import "MyScrollView.h"
#import "MyImageView.h"
#import "MyBigImageView.h"

@protocol PictureViewControllerDelegate;

@interface PictureViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,copy) NSString* logoUrl;
@property(nonatomic,copy) NSString* logoPath;
@property(nonatomic,copy) NSString* imageUrl;
@property(nonatomic,copy) NSString* imagePath;

@property(nonatomic,assign) float maximumZoomScale;
@property(nonatomic,assign) float minimumZoomScale;

@property(nonatomic,assign) UIViewController* supperViewController;
@property(nonatomic,assign) id<PictureViewControllerDelegate> delegate;
@property(nonatomic,retain) MyImageView* logoView;
@property(nonatomic,retain) MyBigImageView* imageView;
@property(nonatomic,retain) UIImageView* paintImageView;

@property(nonatomic,retain) MyScrollView* zoomingView;

-(void)showImages;
- (void)keeNotZoom;
@end

@protocol PictureViewControllerDelegate <NSObject>

- (void)imageViewDidEndZooming:(PictureViewController *)imageViewController atScale:(float)scale;
- (void)didSavePaintImage:(PictureViewController *)imageViewController;
- (void)didRemovePaintImage:(PictureViewController *)imageViewController;

@end 