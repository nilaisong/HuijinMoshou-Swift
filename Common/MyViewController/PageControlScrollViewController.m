//
//  PageControlScrollViewController.m
//  BinUIKit
//
//  Created by Ni Laisong on 11-3-23.
//  Copyright 2011年 ioTree. All rights reserved.
//

#import "PageControlScrollViewController.h"


@interface PageControlScrollViewController (PrivateMethods)
- (void)loadViewControllerForPage:(int)page;
- (void)updatePagesWithCenterPage:(int)centerPage;
- (void)addTrapGesture;
- (void)lazyLoadingConfig;
@end


@implementation PageControlScrollViewController

@synthesize dataSource;
@synthesize delegate;

@synthesize scrollView;
@synthesize pageControl;
@synthesize willRotate;

- (void)dealloc
{
    for (int i=0; i<pageViewControllers.count; i++) 
    {
        [self releasePageViewController:i];
    }
    [pageViewControllers release];
    [pageControl release];
    [scrollView release];
    [super dealloc];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.pageControl = nil;
    self.scrollView = nil;
    
    [pageViewControllers release];
    pageViewControllers = nil;
}

-(void)releasePageViewController:(int)page
{
    UIViewController* pageViewController = [pageViewControllers objectAtIndex:page];
    if ((NSNull *)pageViewController != [NSNull null])
    {
        [pageViewController.view removeFromSuperview];
        pageViewController.view = nil;
        [pageViewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)didReceiveMemoryWarning
{
    
//    for (int page=0; page<[pageViewControllers count]; page++) 
//    {
//        if (page == pageControl.currentPage - 1 ) continue;
//        if (page == pageControl.currentPage + 0 ) continue;
//        if (page == pageControl.currentPage + 1 ) continue;
//        
//        [self releasePageViewController:page];
//    }
    
    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)willRotateToInterfaceOrientation:(NSNotification*)notification
{
    //NSLog(@"==============12");
    // reload configuration
    int numOfPages = [self numOfPageViewControllers];
    int initialPage;
    float pageWidth = self.scrollView.frame.size.width;
    float pageHeight = self.scrollView.frame.size.height;
    if ([dataSource respondsToSelector:@selector(pageControlScrollViewControllerInitialPage)]) 
    {
        initialPage = [dataSource pageControlScrollViewControllerInitialPage];
    }else{
        initialPage = 0;
    }
    self.scrollView.contentSize = CGSizeMake((float)numOfPages*pageWidth, pageHeight);
    self.scrollView.contentOffset = CGPointMake((float)initialPage * pageWidth, 0.); 
    //每次旋转后，重新修改所有已经添加到scrollView上面的视图的大小和位置
    for (int page=0; page<[pageViewControllers count]; page++)
    {
        UIViewController* pageViewController = [pageViewControllers objectAtIndex:page];
        if ((NSNull *)pageViewController != [NSNull null])
        {
            if (pageViewController.view.superview != nil)
            {
                CGRect frame = scrollView.frame;
                frame.origin.x = frame.size.width * page;
                frame.origin.y = 0;
                
                if ([pageViewController respondsToSelector:@selector(keeNotZoom)]) {
                    [pageViewController performSelector:@selector(keeNotZoom)];
                }
                pageViewController.view.frame = frame;
                
                if ([pageViewController respondsToSelector:@selector(willRotateToInterfaceOrientation:)]) {
                    [pageViewController performSelector:@selector(willRotateToInterfaceOrientation:) withObject:notification];
                }
            }
        }
    }
    willRotate=NO;
}

- (void)didRotateToInterfaceOrientation:(NSNotification*)notification
{
    for (int page=0; page<[pageViewControllers count]; page++)
    {
        UIViewController* pageViewController = [pageViewControllers objectAtIndex:page];
        if ((NSNull *)pageViewController != [NSNull null])
        {
            if (pageViewController.view.superview != nil)
            {
                if ([pageViewController respondsToSelector:@selector(didRotateToInterfaceOrientation:)]) {
                    [pageViewController performSelector:@selector(didRotateToInterfaceOrientation:) withObject:notification];
                }
            }
        }
    }
}

-(void)reloadData{
    
    // clean
    for (int page=0; page<[pageViewControllers count]; page++)
    {
        [self releasePageViewController:page];
    }
    
    // reload dataSource
    if ([dataSource respondsToSelector:@selector(pageControlScrollViewControllerScrollView)]) {
        self.scrollView = [dataSource pageControlScrollViewControllerScrollView];   
    }else{
        self.scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    }
    
    if ([dataSource respondsToSelector:@selector(pageControlScrollViewControllerPageControl)]) {
        self.pageControl = [dataSource pageControlScrollViewControllerPageControl];   
    }else{
        self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    if ([dataSource respondsToSelector:@selector(pageControlScrollViewControllerNumOfPages)]) {
        self.pageControl.numberOfPages = [dataSource pageControlScrollViewControllerNumOfPages];
    }
    
    if ([dataSource respondsToSelector:@selector(pageControlScrollViewControllerInitialPage)]) {
        self.pageControl.currentPage = [dataSource pageControlScrollViewControllerInitialPage];
    }else{
        self.pageControl.currentPage = 0;
    }
    
    // reload configuration
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:(UIControlEventValueChanged)];
        
    int numOfPages = self.pageControl.numberOfPages;
    int initialPage = self.pageControl.currentPage;
    float pageWidth = self.scrollView.frame.size.width;
    float pageHeight = self.scrollView.frame.size.height;
    //NSLog(@"initialPage:%d",initialPage);
    [pageViewControllers removeAllObjects];
    for (int i=0; i<numOfPages; i++)
    {
        [pageViewControllers addObject:[NSNull null]];
    }

    self.scrollView.pagingEnabled = YES;    
    self.scrollView.contentSize = CGSizeMake((float)numOfPages * pageWidth, pageHeight);
    self.scrollView.contentOffset = CGPointMake((float)initialPage * pageWidth, 0.); 
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;    
    self.scrollView.scrollsToTop = NO;    
    self.scrollView.delegate = self;
        
    newCenterPage = -1;
    [self updatePagesWithCenterPage:initialPage];
    
    if ([delegate respondsToSelector:@selector(pageControlScrollViewControllerLazyLoadingForPage:)]) {
        [self lazyLoadingConfig];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageViewControllers = [[NSMutableArray alloc] init];
    
    //[self reloadData];
    
    if ([dataSource respondsToSelector:@selector(pageControlScrollViewControllerViewToEncloseGestures)]) {
        [self addTrapGesture];
    }
}

- (void)updatePagesWithCenterPage:(int)centerPage{
    
    if (centerPage < 0) return;
    if (centerPage >= pageControl.numberOfPages) return;
    
    //if (newCenterPage == centerPage) return;
    newCenterPage = centerPage;
    pageControl.currentPage = centerPage;
    int i=0;
    //for (int i=0; i<pageViewControllers.count; i++) 
    {
        i =centerPage-2;
        if (0<= i && i<pageViewControllers.count) 
        {
            [self releasePageViewController:i];
        }
        i=centerPage+2;
        if (0<= i && i<pageViewControllers.count) 
        {
            [self releasePageViewController:i];
        }
    }
    
    i = centerPage - 1;
    if (0<= i && i<pageViewControllers.count) {
        [self loadViewControllerForPage:centerPage - 1];
    }
    [self loadViewControllerForPage:centerPage + 0];
    i = centerPage + 1;
   if (0<= i && i<pageViewControllers.count) {
        [self loadViewControllerForPage:centerPage + 1];
    }

    if ([delegate respondsToSelector:@selector(pageControlScrollViewControllerPageDidChanged:)]) {
        [delegate pageControlScrollViewControllerPageDidChanged: centerPage];
    }
    
}

- (void)loadViewControllerForPage:(int)page{

    if (page < 0) return;
    if (page >= pageControl.numberOfPages) return;
    
    UIViewController* pageViewController = [pageViewControllers objectAtIndex:page];
    
    if ((NSNull *)pageViewController == [NSNull null]){
        
        pageViewController = [dataSource demandViewControllerForPage:page];
        [pageViewControllers replaceObjectAtIndex:page withObject:pageViewController];
    }
    
    if (pageViewController.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        pageViewController.view.frame = frame;
        [scrollView addSubview:pageViewController.view];
    }
}

- (UIViewController *)demandViewControllerForPage:(int)page{
    
    return [[[UIViewController alloc] init] autorelease];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //added by Laisong,2012.03.23
    if (willRotate) //旋转完成前不允许滚动
    {
        return;
    }
    
    if (pageControlUsed) return;
	
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != newCenterPage) {
        [self updatePagesWithCenterPage:page];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    pageControlUsed = NO;
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)newscrollView willDecelerate:(BOOL)decelerate
//{
//    if (pageControlUsed) return;
//	
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    NSLog(@"page:%d",page);
//    [self updatePagesWithCenterPage:page];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    pageControlUsed = NO;
    
    if ([delegate respondsToSelector:@selector(pageControlScrollViewControllerLazyLoadingForPage:)]) {
        
        [self lazyLoadingConfig];
    }
}

- (void)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    [self changeToNewPage:page Animated:YES];
}

-(void)changeToNewPage:(int)page Animated:(BOOL)animated{
    
    if (page < 0) return;
    if (page >= pageControl.numberOfPages) return;
    if (newCenterPage == page) return;

    [self updatePagesWithCenterPage:page];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    [scrollView scrollRectToVisible:frame animated:animated];
    
    if (animated) {
        pageControlUsed = YES;
    }else{
        if ([delegate respondsToSelector:@selector(pageControlScrollViewControllerLazyLoadingForPage:)]) {
            [self lazyLoadingConfig];
        }    
    }
}

#pragma mark - Detail Implementation


- (void)addTrapGesture{
    
    UILongPressGestureRecognizer* gestureGecognizer = [[UILongPressGestureRecognizer alloc] init];
    gestureGecognizer.minimumPressDuration = 0.0;
    gestureGecognizer.allowableMovement = 0.0;
    gestureGecognizer.cancelsTouchesInView = NO;
    gestureGecognizer.delegate = self;
    
    UIView* viewForTrapdGestures = self.scrollView;
    for (UIGestureRecognizer* trapedRecognizer in viewForTrapdGestures.gestureRecognizers) {
        [trapedRecognizer requireGestureRecognizerToFail:gestureGecognizer];
    }
    
    [viewForTrapdGestures addGestureRecognizer:gestureGecognizer];
    [gestureGecognizer release];

    trapRecognizer = gestureGecognizer;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == trapRecognizer) {
        
        UIView* encloseView = [dataSource pageControlScrollViewControllerViewToEncloseGestures];
        CGPoint touchPoint = [gestureRecognizer locationInView:encloseView];
        if ([encloseView pointInside:touchPoint withEvent:nil]) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{    

    if (gestureRecognizer == trapRecognizer) {
        return YES;
    }
    
    return NO;
}

-(UIViewController*)pageViewControllerAtIndex:(int)page{
    
    UIViewController* controller = (UIViewController*)[pageViewControllers objectAtIndex:page];
    
    if ([controller class] == [NSNull class]) {
        return nil;
    }else{
        return controller;
    }
    
}

-(UIViewController *)currentPageController{
  
    if (newCenterPage < 0) return nil;
    if (newCenterPage >= pageControl.numberOfPages) return nil;

    return [self pageViewControllerAtIndex:newCenterPage];
}

-(int)numOfPageViewControllers{
    
    return [pageViewControllers count];
}

-(void)lazyLoadingConfig{
    
    if ([delegate respondsToSelector:@selector(shouldLazyLoadingForSlot:)]) {
        
        if ([delegate shouldLazyLoadingForSlot:LazyLoadingSlotLeftPage]) {
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(lazyLoadingProcess:) userInfo:[NSNumber numberWithInt:newCenterPage - 1] repeats:NO];
        }
        if ([delegate shouldLazyLoadingForSlot:LazyLoadingSlotCenterPage]) {
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(lazyLoadingProcess:) userInfo:[NSNumber numberWithInt:newCenterPage + 0] repeats:NO];
        }
        if ([delegate shouldLazyLoadingForSlot:LazyLoadingSlotRightPage]) {
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(lazyLoadingProcess:) userInfo:[NSNumber numberWithInt:newCenterPage + 1] repeats:NO];
        }
        
    }else{
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(lazyLoadingProcess:) userInfo:[NSNumber numberWithInt:newCenterPage - 1] repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(lazyLoadingProcess:) userInfo:[NSNumber numberWithInt:newCenterPage + 0] repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(lazyLoadingProcess:) userInfo:[NSNumber numberWithInt:newCenterPage + 1] repeats:NO];
    }
    
}

- (void)lazyLoadingProcess:(NSTimer*)timer{
    
    int page = [[timer userInfo] intValue];
    
    if (page < 0) return;
    if (page >= pageControl.numberOfPages) return;
    
    [delegate pageControlScrollViewControllerLazyLoadingForPage:page];
}

@end
