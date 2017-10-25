//
//  MortgageCalculatorViewController.m
//  MoShou2
//
//  Created by strongcoder on 15/12/14.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MortgageCalculatorViewController.h"

@interface MortgageCalculatorViewController ()

@end

@implementation MortgageCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"房贷计算器";

    [self loadUI];

}

-(void)loadUI
{
    
    [self addSegmentView];
}

-(void)addSegmentView
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"单位计算",@"总价计算",nil];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, 64+10, 200*SCALE, 30);
    segment.tintColor = BLUEBTBCOLOR;
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];
}

-(void)segmentAction:(UISegmentedControl *)segment
{
    
    NSInteger Index = segment.selectedSegmentIndex;
    
//    _indexNum = Index;
    NSLog(@"Index %zd", Index);
    //0 单位计算       1 总价计算
    
//    [_tableView reloadData];
}


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
