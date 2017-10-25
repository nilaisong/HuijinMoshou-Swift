//
//  NeighborPropertieViewController.m
//  MoShou2
//
//  Created by Mac on 2017/3/13.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "NeighborPropertieViewController.h"
#import "UITableView+XTRefresh.h"
#import "DataFactory+Building.h"
#import "BuildingListData.h"
#import "BuildingDetailViewController.h"
#import "BuildingCell.h"
#import "OptionData.h"
#import "NeighborCityViewController.h"
@interface NeighborPropertieViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)NSMutableArray *cityArry;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger  page;
@property(nonatomic,strong)NSNumber  *buildingNumber;
@property (nonatomic,strong)NSMutableArray *tempArr;  //楼盘暂存数据

@end

@implementation NeighborPropertieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"领城置业";
    self.tempArr = [NSMutableArray array];
    self.cityArry = [NSMutableArray array];

    self.page = 1;
    [self getBuildingList];
    [self getNotMyCitylist];

}


-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
        _topView.backgroundColor = [UIColor whiteColor];
            NSInteger row = 0 ;
            NSInteger column  = 0;
            NSInteger with  = 0;
            NSInteger height = 0 ;
            NSInteger x = 0;
            NSInteger y = 0;
        for (NSInteger i = 0; i < self.cityArry.count; i ++) {
            OptionData *cityOptionData = self.cityArry[i];
             row = i / 4;
             column = i % 4;
             with = kMainScreenWidth/ 4;
             height = 50;
             x = with * column;
             y = height * row;
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(x, y, with, height);
            [button setTitle:cityOptionData.itemName forState:UIControlStateNormal];
            button.tag = i+5000;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = FONT(13.f);
            [button addTarget:self action:@selector(chooseCityBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:button];
            
        }
        UIButton *lastBtn = (UIButton *)[_topView viewWithTag:self.cityArry.count-1+5000];
        [_topView setHeight:lastBtn.bottom];
        
        UIView *allBuildingNumberLabel = [self getTotalAllBuildingNumberLabel];
        allBuildingNumberLabel.frame = CGRectMake(0, _topView.bottom, kMainScreenWidth, 25);
        [_topView addSubview:allBuildingNumberLabel];
        [_topView setHeight:allBuildingNumberLabel.bottom];
        
            for (NSInteger i = 0; i <= row; i ++) {
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height*(i+1), kMainScreenWidth, 1)];
            lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
            [_topView addSubview:lineLabel];
            
            for (NSInteger j = 0; j <= column; j++) {
                UILabel *shuLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(with*(j+1), height*i+7, 1, height-15)];
                shuLineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
                [_topView addSubview:shuLineLabel];
                
            }
            
            
        }
       
        
    }
    
    return _topView;
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+_topView.height, kMainScreenWidth, kMainScreenHeight-self.navigationBar.height-_topView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0xefeff4)];

        [self.view addSubview:_tableView];
        [self setHeaderPullRefresh:YES FooderPushRefresh:YES];

    }
    
    
    return _tableView;
    
}



-(void)getNotMyCitylist{
    
    [[DataFactory sharedDataFactory] getNotOwnCityListWithCallBack:^(NSArray *indexArray, NSArray *dataArray) {
//    [[DataFactory sharedDataFactory] getCityListWithCallBack:^(NSArray *indexArray, NSArray *dataArray) {

        for (InitialData *data in dataArray)
        {
            for (OptionData *listData in data.dataList) {
                
                [self.cityArry appendObject:listData];
            }
        }
        
        }];
    
    
    
    
    
    
}

-(void)getBuildingList
{
    [[DataFactory sharedDataFactory] getNotOwnCityEstateListWithCityId:nil andPage:[NSString stringWithFormat:@"%zd",_page] andKeyword:nil andAreaId:nil andFeatureId:nil andAcreageId:nil andPriceId:nil andPlatId:nil andPriceModel:nil andpropertyId:nil andBedRoomId:nil andTrsyCar:nil withCallBack:^(DataListResult *result, NSNumber *buildingNumber) {
       
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
                AlertShow(@"你所在城市暂未开通此服务");
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


-(void)chooseCityBtn:(UIButton *)sender
{
    OptionData *cityOptionData = self.cityArry[sender.tag-5000];

    NeighborCityViewController *VC = [[NeighborCityViewController alloc]init];
    
    VC.cityId = cityOptionData.itemValue;
    VC.cityName = cityOptionData.itemName;
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
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
//    return [self getTotalAllBuildingNumberLabel];
    return [self topView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.topView.height;

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
    VC.eventId = @"PAGE_LCZY";
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
