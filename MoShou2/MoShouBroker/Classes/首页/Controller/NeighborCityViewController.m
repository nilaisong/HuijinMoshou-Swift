//
//  NeighborCityViewController.m
//  MoShou2
//
//  Created by Mac on 2017/3/15.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "NeighborCityViewController.h"
#import "DataFactory+Building.h"
#import "UITableView+XTRefresh.h"
#import "BuildingListData.h"
#import "BuildingCell.h"
#import "BuildingDetailViewController.h"
@interface NeighborCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger  page;
@property(nonatomic,strong)NSNumber  *buildingNumber;
@property (nonatomic,strong)NSMutableArray *tempArr;  //楼盘暂存数据

@end

@implementation NeighborCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = self.cityName;
    self.tempArr = [NSMutableArray array];
    
    self.page = 1;
    [self getBuildingList];
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-self.navigationBar.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0xefeff4)];
        
        [self.view addSubview:_tableView];
        [self setHeaderPullRefresh:YES FooderPushRefresh:YES];
        
    }
    
    
    return _tableView;
    
}

-(void)getBuildingList
{
    [[DataFactory sharedDataFactory] getBuildingsWithCityId:self.cityId andPage:[NSString stringWithFormat:@"%zd",_page] andKeyword:nil andAreaId:nil andFeatureId:nil andAcreageId:nil andPriceId:nil andPlatId:nil andPriceModel:nil andpropertyId:nil andBedRoomId:nil andTrsyCar:nil withCallBack:^(DataListResult *result, NSNumber *buildingNumber) {
        
        if (result)
        {
            self.buildingNumber = buildingNumber;
            DLog(@"self.buildingNumber===%zd    %@",self.buildingNumber,self.buildingNumber);
            
            if (self.page==1)
            {
                if (_tempArr.count>0)
                {
                    [_tempArr removeAllObjects];
                    
                }
                self.tableView.legendFooter.hidden = NO;
                self.tableView.legendHeader.hidden = NO;
                
            }
            if (result.dataArray.count>0)
            {
                for ( BuildingListData *buildingData in result.dataArray)
                {
                    [_tempArr appendObject:buildingData];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                });
            }else
            {
                
                [self.tableView reloadData];
            }
            if (!result.morePage)
            {
                self.tableView.legendFooter.hidden = YES;
            }else{
                self.tableView.legendFooter.hidden = NO;
                
            }
            
        }else
        {
            self.tableView.legendFooter.hidden = YES;
            self.tableView.legendHeader.hidden = YES;
        }
        
        if (!self.isRefresh) {
            //            [self removeRotationAnimationView:loadingView];
        }
        
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        
    }];
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tempArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingListData *listData;
    if (indexPath.row<_tempArr.count)
    {
        listData =_tempArr[indexPath.row];
    }
    return [BuildingCell buildingCellHeightWithModel:listData WithbuildingStyle:HomeTableViewCellStyle];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        return [self getTotalAllBuildingNumberLabel];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
    
    //    switch (self.viewControllerStyle) {
    //        case NormalViewControllerStyle:
    //        {
    //
    //            return 25;
    //
    //
    //        }
    //            break;
    //
    //        case SerachViewControllerStyle:
    //        {
    //            return 25;
    //
    //
    //        }
    //            break;
    //
    //        case NoDataViewControllerStyle:
    //        {
    //            return 538/2;
    //
    //        }
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    //    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingListData *listData;
    if (indexPath.row<_tempArr.count) {
        listData =_tempArr[indexPath.row];
    }
    BuildingCell *cell = [[BuildingCell alloc]initWithStyle:HomeTableViewCellStyle andBuildListData:listData];
    cell.isShouldStartImage = YES;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingListData *listData =_tempArr[indexPath.row];
    
    if ([listData.status isEqualToString:@"expired"] || [listData.status isEqualToString:@"finished"]) {
        
        AlertShow(@"该楼盘合作已到期，无法查看楼盘详情。");
        return;
        
    }
    BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
    
    VC.buildingId = listData.buildingId;
    //    VC.eventId = @"PAGE_LPLB";
    VC.buildDistance = listData.buildDistance;

    
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(UIView *)getTotalAllBuildingNumberLabel
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * totalAllBuildingNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0, kMainScreenWidth-40, 25)];
    totalAllBuildingNumberLabel.text = @"共有0个楼盘";
    totalAllBuildingNumberLabel.textAlignment = NSTextAlignmentLeft;
    totalAllBuildingNumberLabel.font = FONT(12.f);
    totalAllBuildingNumberLabel.textColor = LABELCOLOR;
    
    id number = _buildingNumber;
    
    if ([number isKindOfClass:[NSNull class]]) {
        
        _buildingNumber = 0;
    }
    if (_buildingNumber>0) {
        totalAllBuildingNumberLabel.text = [NSString stringWithFormat:@"共有%@个楼盘",_buildingNumber];
    }
    [view addSubview:totalAllBuildingNumberLabel];
    
    return view;
}


#pragma mark - MJRefresh刷新和加载
// 添加头部
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        vc.page = 1;
        vc.isRefresh = YES;
        [vc pullRefresh:vc.page];
        vc.isRefresh = NO;
    }];
}

// 添加尾部
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        vc.page ++;
        vc.isRefresh = YES;
        [vc pushRefresh:vc.page];
        vc.isRefresh = NO;
    }];
}

-(void)setHeaderPullRefresh:(BOOL)isPullRefresh FooderPushRefresh:(BOOL)isPushRefresh
{
    if (isPullRefresh) {
        [self addHeader];
    }
    if (isPushRefresh) {
        [self addFooter];
    }
}
-(void)pullRefresh:(NSInteger)page;
{
    [self getBuildingList];
}

-(void)pushRefresh:(NSInteger)page;
{
    [self getBuildingList];
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
