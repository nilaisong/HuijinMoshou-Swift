//
//  ChatListViewController.m
//  MoShou2
//
//  Created by strongcoder on 16/9/20.
//  Copyright © 2016年 5i5j. All rights reserved.
//



#import "ChatListViewController.h"

@interface ChatListViewController ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.navigationBar.titleLabel.text = @"消息列表";
    
    [self tableViewDidTriggerHeaderRefresh];

    [self addSegmentView];
    self.tableView.frame = CGRectMake(0, 64+155/2, kMainScreenWidth, kMainScreenHeight-(64+155/2));
    



}







-(void)addSegmentView
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"通知",@"聊天",nil];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, 64+10, 200*SCALE, 30);
    segment.tintColor = BLUEBTBCOLOR;
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];
    
}
-(void)segmentAction:(UISegmentedControl *)segment
{
    
//    NSInteger Index = segment.selectedSegmentIndex;
    
    //0 通知       1聊天
}

-(void)addSearchView
{



}


-(void)refresh
{
    [self refreshAndSortView];
}
-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
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
