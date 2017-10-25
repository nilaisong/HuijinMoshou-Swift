//
//  MortgageCalculatorViewController.m
//  MoShou2
//
//  Created by strongcoder on 15/12/14.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MortgageCalculatorViewController.h"
#import <UIKit/UIKit.h>
#import "MortgageCalculatorView.h"
#import "IQKeyboardManager.h"
@interface MortgageCalculatorViewController ()<UIScrollViewDelegate,MortgageCalculatorViewDelegate>
{
    UIScrollView *_mainScrollView;
    UISegmentedControl *_segment;
    MortgageCalculatorView *_danMortgageCalculatorView;
    MortgageCalculatorView *_zongMortgageCalculatorView;
}
@end

@implementation MortgageCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"房贷计算器";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = NO;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    
}


-(void)loadUI
{
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    
//    [self addSegmentView];
    [self addmainscrollView];

}
//-(void)addSegmentView
//{
//    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"单位计算",@"总价计算",nil];
//    
//    _segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//    _segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, 64+10, 200*SCALE, 30);
//    _segment.tintColor = BLUEBTBCOLOR;
//    _segment.selectedSegmentIndex = 0;
//    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.view addSubview:_segment];
//}
-(void)addmainscrollView
{
    
//    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-_segment.bottom-5)];
//    _mainScrollVie        //    [self.view addSubview:_mainScrollView];

    
    
    _zongMortgageCalculatorView = [[MortgageCalculatorView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) AndViewStyle:zongJiaStyle];
    _zongMortgageCalculatorView.delegate = self;
    _zongMortgageCalculatorView.area = self.area;
    _zongMortgageCalculatorView.housePrise = self.housePrise;
    [self.view addSubview:_zongMortgageCalculatorView];
    
    
    _danMortgageCalculatorView = [[MortgageCalculatorView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) AndViewStyle:danJiaStyle];
    _danMortgageCalculatorView.delegate = self;
    _danMortgageCalculatorView.area = self.area;
    _danMortgageCalculatorView.housePrise = self.housePrise;
    [self.view addSubview:_danMortgageCalculatorView];
    

  
    
    
}



#pragma mark -  MortgageCalculatorViewDelegate

-(void)select:(MortgageCalculatorView *)view Withindex:(NSInteger)index;
{
    
    DLog(@"  MortgageCalculatorView  index====%zd   ",index);
    
    //9100点了 总价
    if (index==9100) {
        
    [self.view bringSubviewToFront:_zongMortgageCalculatorView];
        
    }else if (index == 9101)
    {
        [self.view bringSubviewToFront:_danMortgageCalculatorView];
    }
    
}

//-(void)segmentAction:(UISegmentedControl *)segment
//{
//    
//    NSInteger Index = segment.selectedSegmentIndex;
//    
//    _mainScrollView.contentSize = CGSizeMake(kMainScreenWidth*(Index+1), _mainScrollView.height);
//    
//    [_mainScrollView setContentOffset:CGPointMake(kMainScreenWidth*Index, 0) animated:YES];
//    
//
//    [_zongMortgageCalculatorView.tableView setContentOffset:CGPointMake(0, 0)];
//    [_danMortgageCalculatorView.tableView setContentOffset:CGPointMake(0, 0)];
//    
////    _indexNum = Index;
//    NSLog(@"Index %zd", Index);
//    //0 单位计算       1 总价计算
//    
////    [_tableView reloadData];
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    DLog(@"scrollView.contentOffset.x==  %f",scrollView.contentOffset.x);
//    
//    
//    if(scrollView.contentOffset.x == 0){
//        
//        _segment.selectedSegmentIndex = 0;
//        
//        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        
//        _mainScrollView.contentSize = CGSizeMake(kMainScreenWidth, _mainScrollView.height);
//        
//        
//    }else
//    {
//        _segment.selectedSegmentIndex = 1;
//
//    }
//    
//}
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
