//
//  InstructionView.m
//  AuctionCatalog
//
//  Created by Laison on 12-5-9.
//  Copyright (c) 2012年 . All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "sys/utsname.h"
#import "InstructionView.h"
#import "Functions.h"
#import "UIColor+Hex.h"

#define kRunInstruction  [NSString stringWithFormat:@"%@_%@",@"runInstruction",kAppVersion]
#define kCurrentPageIndicatorTintColor [UIColor colorWithRed:0.38f green:0.75f blue:0.96f alpha:1.00f]
#define kPageIndicatorTintColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];

@interface InstructionView() 

@property(nonatomic,copy)NSString *interfacePrefix;

//- (void)prefixValueAccordingOrientation:(UIInterfaceOrientation)orientation;
//- (void)changeImgsWhileOrientationWillChange;

@end

@implementation InstructionView
@synthesize interfacePrefix;

//帮助手册
+ (instancetype)showHelpImagesWithCount:(int)count andInView:(UIView*)theView
{
    //    NSLog(@"kRunInstruction:%@",kRunInstruction);
    NSString *runInstruction = [[NSUserDefaults standardUserDefaults] objectForKey:kRunInstruction];
    if (!runInstruction)
    {
        InstructionView *instructionView = [[InstructionView alloc] initWithFrame:theView.bounds withPageCount:count];
        instructionView.backgroundColor = [UIColor clearColor];
        instructionView.tag = 999;
        instructionView.userInteractionEnabled = YES;
        //        self.helpView = instructionView;
        [theView addSubview:instructionView];
//        [instructionView release];
        return instructionView;
       
    }
    return nil;
}

+ (instancetype)showHelpImagesAgainWithCount:(int)count andInView:(UIView*)theView
{
    //    NSLog(@"kRunInstruction:%@",kRunInstruction);
//    NSString *runInstruction = [[NSUserDefaults standardUserDefaults] objectForKey:kRunInstruction];
    InstructionView *instructionView = [[InstructionView alloc] initWithFrame:theView.bounds withPageCount:count];
    instructionView.backgroundColor = [UIColor clearColor];
    instructionView.tag = 999;
    instructionView.userInteractionEnabled = YES;
    //        self.helpView = instructionView;
    [theView addSubview:instructionView];
//    [instructionView release];
    return instructionView;
}

-(void)adjustFrameForHotSpotChange
{
    _scrollView.frame = CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height);
    for (int i=1; i<=pageCount; i++)
    {
        NSUInteger width = kMainScreenWidth;
        NSUInteger height = self.bounds.size.height;
        CGRect frame = CGRectMake(width*(i-1), 0, width, height);
        UIImageView *imgView = (UIImageView *)[_scrollView viewWithTag:i];
        imgView.frame =frame;
    }
    _pageControl.frame = CGRectMake((kMainScreenWidth - 100)/2, self.bounds.size.height - 70, 100, 30);
}

- (id)initWithFrame:(CGRect)frame withPageCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        pageCount = count;
        CGRect buttonFrame;
        UIImage *btnImg;
        NSString *imgName = [NSString stringWithFormat:@"%@",@"first_enter_app"];
        btnImg = [UIImage imageNamed:imgName];
//        NSLog(@"btn %@",NSStringFromCGSize(btnImg.size));

        int pageControlDiameter;
        int pageControlSpace;
        CGFloat sizeScale = 1.0;
        {
            if(iPhone4 ||  CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)))
            {
                interfacePrefix = [[NSString alloc] initWithFormat:@"phone4"];
                buttonFrame = CGRectMake((kMainScreenWidth - 102)/2,self.bounds.size.height - 85,200,80);
                sizeScale = 0.6;
            }
            else
            {
                interfacePrefix = [[NSString alloc] initWithFormat:@"phone"];
                buttonFrame = CGRectMake((kMainScreenWidth - 102)/2,self.bounds.size.height - 85,200,80);
            }

            pageControlDiameter = 6;
            pageControlSpace = 6.5;
        }
        //重设frame  上面的frame 不对
        buttonFrame = CGRectMake(0, kMainScreenHeight/2, kMainScreenWidth, kMainScreenHeight/2);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.bounds.size.height)];
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kMainScreenWidth * pageCount, self.bounds.size.height);
        _scrollView.delegate = self;
        
        [self addSubview:_scrollView];
        
        NSUInteger width = kMainScreenWidth;
        NSUInteger height = self.bounds.size.height;
        
        for (int i=1; i<=pageCount; i++)
        {
            NSString *imgName = [[NSString alloc ]initWithFormat:@"%@_info%d.jpg",interfacePrefix,i];
            NSLog(@"%@",imgName);
            NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imgName];
//            [imgName release];
            
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgPath]; 
            CGRect frame = CGRectMake(width*(i-1), 0, width, height);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.image = img;
//            [img release]; 
            
            imgView.tag = i;
            [_scrollView addSubview:imgView];
//            [imgView release];
        }
            
        UIImageView *imgView = (UIImageView *)[_scrollView viewWithTag:pageCount];
        imgView.userInteractionEnabled = YES;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:btnImg forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [UIColor clearColor];
        button.clipsToBounds = YES;
//        button.layer.cornerRadius = 10.0;
//        button.layer.borderWidth = 1.0;
//        button.layer.borderColor = [UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f].CGColor;
//        [button setTitle:@"立即体验" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor whiteColor]];
//        button.showsTouchWhenHighlighted = YES;
        
        button.tag = 911;
        button.frame = buttonFrame;
        [button addTarget:self action:@selector(removeInstruction:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:button];
        if (pageCount>1)
        {
            //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
            _pageControl = [[GrayPageControl alloc] initWithFrame:CGRectZero];
            _pageControl.dotWidth = 20 * sizeScale;
            [_pageControl setNumberOfPages:pageCount];
            [_pageControl setCurrentPage:0];
    //        _pageControl.currentPageIndicatorTintColor = kCurrentPageIndicatorTintColor;
    //        _pageControl.pageIndicatorTintColor = kPageIndicatorTintColor;
            
            
            [_pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
            
            _pageControl.userInteractionEnabled = NO;
            _pageControl.frame = CGRectMake((kMainScreenWidth - 100)/2, self.bounds.size.height - 70, 100, 30);//CGRectMake(x, self.bounds.size.height - size.height + 12, size.width, size.height);
//            [self addSubview:_pageControl];
        }
    }
    
    return self;
}


- (void)removeInstruction:(id)sender
{
//  CATransition *animation = [CATransition animation];
//	[animation setDuration:1.0];
//	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//	[animation setType:@"rippleEffect"];
//	[self.superview.layer addAnimation:animation forKey:@"rippleEffect"];
	
	[self removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kRunInstruction];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{ 
    curIndex = scrollView.contentOffset.x / kMainScreenWidth;
    _pageControl.currentPage = curIndex;
    [_pageControl updateCurrentPageDisplay];
}
#pragma mark -
#pragma mark DDPageControl triggered actions

- (void)pageControlClicked:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	
	[_scrollView setContentOffset: CGPointMake(_scrollView.bounds.size.width * thePageControl.currentPage, _scrollView.contentOffset.y) animated: YES] ;
}


@end
