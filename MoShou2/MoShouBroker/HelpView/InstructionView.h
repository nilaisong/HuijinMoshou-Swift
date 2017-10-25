//
//  InstructionView.h
//  AuctionCatalog
//
//  Created by Laison on 12-5-9.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageControl.h"
#import "GrayPageControl.h"

/*
 第一次启动时展示的使用说明
*/

@interface InstructionView : UIView<UIScrollViewDelegate>
{    
    UIScrollView *_scrollView;
//    DDPageControl *_pageControl;
//    UIPageControl *_pageControl;
    GrayPageControl* _pageControl;
    NSString *interfacePrefix;
    NSUInteger curIndex;
    UIButton *button;
    
    NSUInteger pageCount;
}
//帮助手册
+ (instancetype)showHelpImagesWithCount:(int)count andInView:(UIView*)theView;
+ (instancetype)showHelpImagesAgainWithCount:(int)count andInView:(UIView*)theView;

//- (id)initWithFrame:(CGRect)frame withPageCount:(NSInteger)count;
//根据热点调整视图显示尺寸
-(void)adjustFrameForHotSpotChange;

@end
