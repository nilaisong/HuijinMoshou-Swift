//
//  MainDoorViewController.m
//  MoShouBroker
//
//  Created by strongcoder on 15/10/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MainDoorViewController.h"
#import "DoorTypeView.h"
#import "RoomLayout.h"
#import "HouseTypeViewController.h"

@interface MainDoorViewController ()<UITableViewDataSource,UITableViewDelegate,DoorTypeViewTapActionDelegate>

@property (nonatomic,strong)UITableView *tableview;
@end

@implementation MainDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"主力户型";
    
    [self loadUI];
}

-(void)loadUI
{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 87.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.roomlayoutArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
      UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
       cell.selectionStyle =UITableViewCellSelectionStyleNone;
        RoomLayout *roomLayout = self.roomlayoutArr[indexPath.row];
        
        DoorTypeView *doorView = [[DoorTypeView alloc]initHorizontalStyleWithRoomlayout:roomLayout];
        doorView.delegate =self;
        doorView.currentIndex = indexPath.row;
        doorView.buildingId = _building.buildingId;

        [cell.contentView addSubview:doorView];
    
    return cell;
    
}

-(void)doorTypeViewTapACtion:(DoorTypeView *)view;

{
    
    HouseTypeViewController *VC = [[HouseTypeViewController alloc]init];
    VC.building = _building;
    VC.currentIndex = view.currentIndex;
    [self.navigationController pushViewController:VC animated:YES];
    
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
