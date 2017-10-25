//
//  ProgressIndicatorView.h
//  Common
//
//  Created by Ni Laisong on 12-7-12.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"

@protocol ProgressIndicatorViewDelegate;

@interface ProgressIndicatorView : UIView

@property(nonatomic,retain) DDProgressView* progressView;
@property(nonatomic,retain) UILabel* label;
@property(nonatomic,assign) id<ProgressIndicatorViewDelegate> delegate;

-(void)updateProgressInfo:(NSInteger)receivedSize contentSize:(NSInteger)contentSize;

@end

@protocol ProgressIndicatorViewDelegate <NSObject>

- (void)cancelDownload:(ProgressIndicatorView*)progressIndicatorView_;
- (void)stopDownload:(ProgressIndicatorView*)progressIndicatorView_;
- (void)continueDownload:(ProgressIndicatorView*)progressIndicatorView_;

@end