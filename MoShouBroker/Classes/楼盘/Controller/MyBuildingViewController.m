//
//  MyBuildingViewController.m
//  MoShou2
//
//  Created by strongcoder on 15/12/8.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MyBuildingViewController.h"
#import "BuildingCell.h"
#import "UITableViewRowAction+JZExtension.h"
#import "BuildingDetailViewController.h"
#import "CustomerReportViewController.h"
#import "DownloaderManager.h"
#import "DataFactory+Building.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"

@interface MyBuildingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSInteger _indexNum;
//    NSMutableArray *_tempArr;  //building数组
    
    NSMutableArray *_downLoadBuildingArr; //下载数组
    NSMutableArray *_favoriteBuildingArr;  //收藏数组
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger  page;

@end

@implementation MyBuildingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.titleLabel.text = @"我的收藏";
    _indexNum = 1;  // 我的收藏
    _page = 1;
    
    _downLoadBuildingArr = [NSMutableArray array];
    _favoriteBuildingArr = [NSMutableArray array];
    
//    [self loadUI];
    [self getMyFavoriteBuildingsData];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//-(void)loadDataWithIndexNum:(NSInteger)indexNum;
//{
//    [self removeTempView];
//    
//    if (indexNum == 0)
//    {
//        //本地的下载数据
//        DownloaderManager *downloaderManager=[DownloaderManager sharedManager];
//        NSArray *buildArray = [downloaderManager getDownloadItems];
//        
//        if (_downLoadBuildingArr.count>0) {
//            [_downLoadBuildingArr removeAllObjects];
//        }
//        NSMutableArray *array = [NSMutableArray arrayWithArray:buildArray];
//        _downLoadBuildingArr = array;
//        if (_downLoadBuildingArr.count>0) {
//            [self.tableView.header endRefreshing];
//            [self.tableView.footer endRefreshing];
//            self.tableView.footer.hidden = YES;
//            [_tableView reloadData];
//
//        }else{
//            [self tempView];
//        }
//        }else if (indexNum == 1){
//    }
//}


-(void)getMyFavoriteBuildingsData
{
    // 我的收藏列表   dataArray;//数据列表   里面是Building
    UIImageView *loadingView;
    if (!self.isRefresh)
    {
        loadingView = [self setRotationAnimationWithView];
    }
    
    [[DataFactory sharedDataFactory] getFavoriteBuildingsWithPage:[NSString stringWithFormat:@"%zd",_page] andIsHomePage:NO withCallBack:^(DataListResult *result)
     {
         if (result)
         {
             if (self.page==1) {
                 if (_favoriteBuildingArr.count>0) {
                     [_favoriteBuildingArr removeAllObjects];
                 }}
             
             if (result.dataArray.count>0) {
                 
                 for (Building *building in result.dataArray) {
                     [_favoriteBuildingArr appendObject:building];
                 }
                 [self addTableView];

             }
             
             if (!(_favoriteBuildingArr.count>0)) {
                 [self tempView];
             }
             
             if (!result.morePage)
             {
                 self.tableView.legendFooter.hidden = YES;
             }else{
                 self.tableView.legendFooter.hidden = NO;
             }
             
         }else{
             self.tableView.legendFooter.hidden = YES;
             self.tableView.legendHeader.hidden = YES;
             [self tempView];
         }
         
         if (!self.isRefresh) {
             [self removeRotationAnimationView:loadingView];
         }
         
         [self.tableView.legendHeader endRefreshing];
         [self.tableView.legendFooter endRefreshing];
         [_tableView reloadData];
         
     }];

}


-(void)loadUI
{
//    [self addSegmentView];
    [self addTableView];
    
    
}

-(void)addTableView
{
    if (self.tableView==nil)
    {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:_tableView];
    [self setHeaderPullRefresh:YES FooderPushRefresh:YES];
    
    }
    
}


//-(void)addSegmentView
//{
//    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"下载",@"收藏",nil];
//    
//    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//    segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, 64+10, 200*SCALE, 30);
//    segment.tintColor = BLUEBTBCOLOR;
//    segment.selectedSegmentIndex = 0;
//    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.view addSubview:segment];
//    
//}

//-(void)segmentAction:(UISegmentedControl *)segment
//{
//    
//    NSInteger Index = segment.selectedSegmentIndex;
//    
//    _indexNum = Index;
//    NSLog(@"Index %zd", Index);
//    //0 下载       1 收藏
//    
//    [self loadDataWithIndexNum:_indexNum];
//
//
//    
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_indexNum) {
        case 0:
        {
            return _downLoadBuildingArr.count;
        }
            break;
            
            case 1:
        {
            return _favoriteBuildingArr.count;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BuildingListData *building = _favoriteBuildingArr[indexPath.row];

    return [BuildingCell buildingCellHeightWithModel:building WithbuildingStyle:MyBuildingTableViewCellFavoriteStyle];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    BuildingListData
    /**
     *  这里的Building   都要替换成 BuildingListData   cell  里面实现的地方也要  修改
     */
    if (_indexNum==0) {
        
//        BuildingListData *building = _downLoadBuildingArr[indexPath.row];
//
//        
//        BuildingCell *cell = [[BuildingCell alloc]initWithStyle:MyBuildingTableViewCellDownLoadStyle andBuilding:building];
//        return cell;
    }else if (_indexNum == 1){
        
        BuildingListData *building = _favoriteBuildingArr[indexPath.row];

        BuildingCell *cell = [[BuildingCell alloc]initWithStyle:MyBuildingTableViewCellFavoriteStyle andBuildListData:building];
        return cell;
    }
    
    UITableViewCell *cellcell;
    return cellcell;
   
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setEditing:false animated:true];
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_indexNum == 0) {
        
        // 我的楼盘删除.png
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"loupan删除.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
            
            Building *building = _downLoadBuildingArr[indexPath.row];
            
            DownloaderManager *downloaderManager=[DownloaderManager sharedManager];
            [downloaderManager deleteDownloadItemWithIndex:(int)indexPath.row];
            [downloaderManager deleteDownloadItemWithId:building.buildingId];
            
            [self showTips:@"楼盘删除成功"];
//            [self loadDataWithIndexNum:_indexNum];
        }];
        
        return @[action];
    }else if (_indexNum == 1){
        
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"取消收藏big.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
         
            BuildingListData *listData = _favoriteBuildingArr[indexPath.row];

            Building *building = [[Building alloc]init];
            building.buildingId = listData.buildingId;
            //调用取消收藏的接口
            
            [[DataFactory sharedDataFactory] cancelFavoriteWithBuilding:building withCallBack:^(ActionResult *result) {
                
                if (result.success) {
                    [self getMyFavoriteBuildingsData];
                    [self showTips:@"取消收藏成功!"];
                    [MobClick event:@"sclb_qxsc"];

                    //刷新首页通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBuildingData" object:nil];
                    
                }else{
                    [self showTips:result.message];
                }
            }];
            
        }];
        
        return @[action];
            
    }
    
    return NULL;
    
    }

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
//    if (_indexNum==0)
//    {
//        return YES;
//    }else
//    {
//        return NO;
//    }
//
//    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BuildingDetailViewController *VC =[[BuildingDetailViewController alloc]init];

    if (_indexNum==0){
    
        BuildingListData *listData = _downLoadBuildingArr[indexPath.row];
        DownloaderManager *downloaderManager=[DownloaderManager sharedManager];
        VC.caCheBuildingMo = [downloaderManager getBuildingDetailWithBuildingId:listData.buildingId];
        if ([listData.status isEqualToString:@"expired"] || [listData.status isEqualToString:@"finished"]) {
            
            AlertShow(@"该楼盘合作已到期，无法查看楼盘详情。你可通过左滑列表删除楼盘");
            return;
            
        }

        
    }else if(_indexNum==1){
        
      
        
        BuildingListData *listData = _favoriteBuildingArr[indexPath.row];
        
        if ([listData.status isEqualToString:@"expired"] || [listData.status isEqualToString:@"finished"]) {
            
            AlertShow(@"该楼盘合作已到期，无法查看楼盘详情。你可通过左滑列表取消收藏");
            return;
            
        }
        
        VC.buildingId = listData.buildingId;
        VC.eventId = @"PAGE_SCLP";
        VC.buildDistance = listData.buildDistance;

    }
    
    [self.navigationController pushViewController:VC animated:YES];
    
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
    [self getMyFavoriteBuildingsData];
}

-(void)pushRefresh:(NSInteger)page;
{
    [self getMyFavoriteBuildingsData];
}


#pragma mark 空白也没有数据
-(void)tempView{
    [self.tableView setHidden:YES];
    UIImageView *tempImage =[[UIImageView alloc]init];
    tempImage.tag = 8000;
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, 64+44+(kMainScreenWidth-64-44-30)/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    tip.tag = 8001;
    //    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc]initWithString:@"没有数据"];
    //    [tipText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 11)];
    CGSize ss = [@"没有数据" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setText:@"没有数据"];
    [self.view addSubview:tip];
}

-(void)removeTempView
{
    [self.tableView setHidden:NO];

    UIImageView *tempView = (UIImageView *)[self.view viewWithTag:8000];
    UILabel *tip = (UILabel *)[self.view viewWithTag:8001];
    
    [tempView removeFromSuperview];
    [tip removeFromSuperview];
    
    
    
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
