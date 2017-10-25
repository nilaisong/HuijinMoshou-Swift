//
//  PageControlScrollViewController.h
//  BinUIKit
//
//  Created by Free Bin on 11-3-23.
//  Copyright 2011年 ioTree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    LazyLoadingSlotLeftPage,
    LazyLoadingSlotCenterPage,
    LazyLoadingSlotRightPage,
}LazyLoadingSlot;


@protocol PageControlScrollViewControllerDataSource;
@protocol PageControlScrollViewControllerDelegate;


@interface PageControlScrollViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    
    NSMutableArray* pageViewControllers;
    
    BOOL pageControlUsed;
    int newCenterPage;
    UIGestureRecognizer* trapRecognizer;
}

@property(nonatomic, assign)    id<PageControlScrollViewControllerDataSource> dataSource;
@property(nonatomic, assign)    id<PageControlScrollViewControllerDelegate> delegate;

@property(nonatomic, retain)    UIScrollView* scrollView;
@property(nonatomic, retain)    UIPageControl* pageControl;
@property(nonatomic, assign)    BOOL willRotate;


// retrieve single pageViewController
-(UIViewController*)pageViewControllerAtIndex:(int)page;

// current pageViewController
-(UIViewController*)currentPageController;

// total number of pageViewControllers
-(int)numOfPageViewControllers;

- (void)updatePagesWithCenterPage:(int)centerPage;
// unpdate page content with new page index
-(void)changeToNewPage:(int)page Animated:(BOOL)animated;

// reload from the dataSource
-(void)reloadData;
-(void)releasePageViewController:(int)page;
- (void)willRotateToInterfaceOrientation:(NSNotification*)notification;
- (void)didRotateToInterfaceOrientation:(NSNotification*)notification;
@end


@protocol PageControlScrollViewControllerDataSource <NSObject>

@required

// retrieve custom view controller for each page. The return value must not be nil or null.
- (UIViewController *)demandViewControllerForPage:(int)page;

@optional

// return your custom scroll view for the main scroll process
- (UIScrollView *)pageControlScrollViewControllerScrollView;

// return your UIPageControl if you need one
- (UIPageControl *)pageControlScrollViewControllerPageControl;

// if you do not return the UIPageControl, you should implement this by return the total number of pages
- (int)pageControlScrollViewControllerNumOfPages;

// initial page index, default value is 0
- (int)pageControlScrollViewControllerInitialPage;

// a view in which any user gestures is blocked from main scrolling
- (UIView* )pageControlScrollViewControllerViewToEncloseGestures;

@end


@protocol PageControlScrollViewControllerDelegate <NSObject>

@optional

// called when the page in main scrollView just changed
- (void) pageControlScrollViewControllerPageDidChanged:(int)currentPage;

// typical called for center page in multi thread when scroll view did end decelerating
-(void) pageControlScrollViewControllerLazyLoadingForPage:(int)page;

-(BOOL) shouldLazyLoadingForSlot:(LazyLoadingSlot)lazyLoadingSlot;

@end