//
//  OverseasEstateViewController.m
//  MoShou2
//
//  Created by Mac on 2017/2/21.
//  Copyright © 2017年 5i5j. All rights reserved.
//
#import "UITableView+XTRefresh.h"

#import "OverseasEstateViewController.h"
#import "BuildingSearchViewController.h"
#import "PriceModel.h"
#import "SelectionView.h"
#import "DataFactory+Building.h"
#import "BuildingListData.h"
#import "BuildingDetailViewController.h"
#import "BuildingCell.h"
#import "XTHomeBuildingCell.h"
#import "AdShowViewController.h"


#define OVERSEASESTATECITYID @"6563"

typedef NS_ENUM(NSInteger, ViewControllerStyle)
{
    NormalViewControllerStyle,    //默认状态
    SerachViewControllerStyle,   //搜索状态
    NoDataViewControllerStyle,  //搜索无数据状态
};
@interface OverseasEstateViewController ()<UITableViewDataSource,UITableViewDelegate,SelectionViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)SelectionView *seleView;

@property (nonatomic,strong)UIView *searchView;

@property (nonatomic,strong)CityFirstResult *cityFirstResult;//根据城市ID  初始化数据
@property (nonatomic,strong)NSMutableArray *tempArr;  //楼盘咱暂存数据 楼盘初始化的数据和楼盘列表的数据都放在这里
@property (nonatomic,strong)NSMutableArray *buildingNameArray;  //

@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger  page;
@property (nonatomic,  copy)NSString *keyword;

@property (nonatomic,assign)ViewControllerStyle viewControllerStyle;

@property (nonatomic,copy)NSString *areaId;   // 等同于 第一列的区域  districtId     区域id
@property (nonatomic,copy)NSString *platId;   //商圈ID  第二列的商圈ID

@property (nonatomic,copy)NSString *featureId; //特色标签:例如：学区房
@property (nonatomic,copy)NSString *acreageId;  //面积 例如：300平以上
@property (nonatomic,copy)NSString *priceId;   //价格 【1.asc价格从小到大排序】

@property (nonatomic, strong)PriceModel *priceModel;

@property (nonatomic,copy)NSString *propertyId;  //物业类型

@property (nonatomic,copy)NSString *bedroomId;   //居室类型ID

@property (nonatomic,copy)NSString *trsyCarId;   //看房约车ID


@property(nonatomic,strong)NSNumber  *buildingNumber;

@property (nonatomic,strong)UIImageView *blankTipImgView;
@property (nonatomic,strong)UIButton *pushButton;



@end

@implementation OverseasEstateViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_seleView setTableViewCloseAndNomalStyle];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barBackgroundImageView.backgroundColor = BLUEBTBCOLOR;
    [self.navigationBar.leftBarButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    self.tempArr = [NSMutableArray array];
     self.buildingNameArray = [NSMutableArray array];
    [self loadUI];
    
    [self getHotBuildingNameArray];
}





-(void)loadUI
{
    self.viewControllerStyle = NormalViewControllerStyle;
    self.page = 1;
    [self searchView];

    [self getBuildingInitializationData];
    
    
}

-(UIButton *)pushButton
{
    if (!_pushButton) {
       _pushButton = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-15-67, kMainScreenHeight-30-67, 67, 67)];
        [_pushButton setImage:[UIImage imageNamed:@"pushGuide.png"] forState:UIControlStateNormal];
        [_pushButton addTarget:self action:@selector(pushButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_pushButton];
    }
    
    return _pushButton;
}


-(void)getHotBuildingNameArray
{
    
    [[DataFactory sharedDataFactory] getBannerBuildingWithPage:@"1" cityID:OVERSEASESTATECITYID callBack:^(DataListResult *result) {
        
        for ( BuildingListData *buildingData in result.dataArray)
        {
            [self.buildingNameArray appendObject:buildingData.name];
        }
        
    }];;
    
}

//楼盘初始化数据
-(void)getBuildingInitializationData
{
    [[DataFactory sharedDataFactory] getCityFirstWithMapCityId:OVERSEASESTATECITYID CallBack:^(CityFirstResult *cityResult) {
        if (cityResult) {
            self.cityFirstResult = cityResult;
            [self addTableView];
            [self addSelectionView];
            [self getBuildingList];
            [self pushButton];
        }
        
    }];
    
}
//楼盘列表接口
-(void)getBuildingList
{
    DLog(@"   %@   %@   %@  %@   %@   %zd  %@ ",_keyword,_areaId,_featureId,_acreageId,_priceId,_page,_platId);
    
    //    UIImageView *loadingView;
    if (!self.isRefresh)
    {
        //        loadingView = [self setRotationAnimationWithView];
    }
    [[DataFactory sharedDataFactory] getBuildingsWithCityId:OVERSEASESTATECITYID andPage:[NSString stringWithFormat:@"%zd",_page] andKeyword:_keyword andAreaId:_areaId andFeatureId:_featureId andAcreageId:_acreageId andPriceId:_priceId andPlatId:_platId andPriceModel:_priceModel andpropertyId:_propertyId andBedRoomId:_bedroomId andTrsyCar:_trsyCarId withCallBack:^(DataListResult *result,NSNumber *buildingNumber) {
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
                if (_keyword.length > 0 || _areaId.length > 0 ||_featureId.length>0 || _acreageId.length>0 || _priceId.length>0 || _platId.length>0 || _priceModel.priceMin.length>0 || _priceModel.priceMax.length >0 || _propertyId.length>0 || _bedroomId.length>0 || _trsyCarId.length>0)
                {
                    self.viewControllerStyle = SerachViewControllerStyle;
                    
                }
                if (_keyword.length == 0 && _areaId.length == 0 && _featureId.length==0 && _acreageId.length==0 && _priceId.length==0 && _page==1 && _platId.length == 0 && _priceModel.priceMin.length==0 && _priceModel.priceMax.length ==0&&_propertyId.length==0 && _bedroomId.length==0 &&_trsyCarId.length==0)
                {
                    self.viewControllerStyle = NormalViewControllerStyle;
                    
                }
                for ( BuildingListData *buildingData in result.dataArray)
                {
                    [_tempArr appendObject:buildingData];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                });
            }else
            {
                self.viewControllerStyle = NoDataViewControllerStyle;
                [self getfindRecommendEstate];
                
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
//无数据展示推荐楼盘
-(void)getfindRecommendEstate
{
    [[DataFactory sharedDataFactory] findRecommendEstateWithNumber:@"3" andIsHomePage:NO AndCityId:OVERSEASESTATECITYID withCallBack:^(DataListResult *result) {
        
        if (result)
        {
            if (_tempArr.count > 0)
            {
                [_tempArr removeAllObjects];
            }
            if (result.dataArray.count >0)
            {
                for ( BuildingListData *buildingData in result.dataArray)
                {
                    [_tempArr appendObject:buildingData];
                }
                [_tableView reloadData];
            }else{
                [_tableView reloadData];
            }
        }
    }];
    
}

-(void)addSelectionView
{
    if (self.seleView) {
        [self.seleView removeFromSuperview];
        self.seleView = nil;
    }
    
    self.seleView = [[SelectionView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 74/2) WithBuildingsResult:self.cityFirstResult WithIsMapSeleView:NO];
    self.seleView.delegate = self;
    [self.view addSubview:self.seleView];
    [self.view bringSubviewToFront:self.seleView];
    
}

-(void)addTableView
{
    if (self.tableView==nil)
    {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+74/2, kMainScreenWidth, kMainScreenHeight-64-74/2) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView setSeparatorColor:UIColorFromRGB(0xefeff4)];
        [self.view addSubview:self.tableView];
        [self setHeaderPullRefresh:YES FooderPushRefresh:YES];
    }
}

-(UIView *)getTotalAllBuildingNumberLabel
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
//    view.backgroundColor = [UIColor whiteColor];
    
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



-(UIView *)searchView;
{
    
    if (!_searchView) {
        
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(50, 54/2, kMainScreenWidth-50-10, 30)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.layer.cornerRadius = 5;
        _searchView.layer.masksToBounds = YES;
        _searchView.userInteractionEnabled = YES;
        [self.navigationBar addSubview:_searchView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptoThebuildingSeachingVC)];
        [_searchView addGestureRecognizer:tap];
        
        
        UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, (30-13)/2, 13, 13)];
        [searchIcon setImage:[UIImage imageNamed:@"搜索.png"]];
        [_searchView addSubview:searchIcon];
        
        UILabel *pleasehoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(searchIcon.right+5, 0, 150, 30)];
        pleasehoderLabel.text = @"请输入楼盘名称";
        pleasehoderLabel.textColor = UIColorFromRGB(0x888888);
        pleasehoderLabel.font = FONT(13.f);
        
        [_searchView addSubview:pleasehoderLabel];
    }
    return _searchView;
}
-(void)jumptoThebuildingSeachingVC
{
    
    BuildingSearchViewController *VC = [[BuildingSearchViewController alloc]init];
    
    VC.cityFirstResult = self.cityFirstResult;
    VC.cityId = OVERSEASESTATECITYID;
    VC.buildingNameArray = self.buildingNameArray;
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(void)pushButtonClick
{
    
    AdShowViewController *VC = [[AdShowViewController alloc]init];
    
    VC.name = @"推客指南";
    VC.adUrl = kFullUrlWithSuffix(@"/admin/module/EstateHtml/twitterGuide.html");
    
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - SelectionViewDelegate

-(void)select:(SelectionView *)selectView withchooseIndex:(NSInteger)chooseindex AndOptionData:(ItemData *)optionData AndPriceModel:(PriceModel *)priceModel;
{
    //    _priceModel =[[PriceModel alloc]init];
    NSArray  * titleArr = @[@"区域",@"价格",@"面积",@"更多"];
    DLog(@"%@    %@   %@",titleArr[chooseindex],optionData.itemName,optionData.itemID);
    //    @property (nonatomic,copy)NSString *areaId;   //  districtId  区域id  朝阳  海淀
    
    //    @property (nonatomic,copy)NSString *platId;   //商圈ID  第二列的商圈ID  五彩城   科技园 等商圈类似的
    
    //    @property (nonatomic,copy)NSString *featureId; //特色标签:例如：学区房
    //    @property (nonatomic,copy)NSString *acreageId;  //面积 例如：300平以上
    //    @property (nonatomic,copy)NSString *priceId;    //价格
    
    switch (chooseindex) {
        case 0:   //区域
        {
            
            if ([optionData.itemName rangeOfString:@"不限"].location != NSNotFound) {
                //含有不限
                if (optionData.itemID.length>0 ) {
                    _areaId =optionData.itemID ;
                    _platId = @"";
                }else{
                    _areaId = @"";
                    _platId = @"";
                }
            }else{
                
                _areaId = @"";
                _platId = optionData.itemID;
                
            }
            
        }
            break;
        case 1:  //价格
        {
            if ([optionData.itemName isEqualToString:@"不限"]) {
                _priceId = @"";
                _priceModel = nil;
                _priceModel.priceMax = @"";
                _priceModel.priceMax = @"";
                
            }else if(priceModel != nil) {
                
                _priceModel = priceModel;
                _priceId = @"";
                
            }else{
                _priceId = optionData.itemID;
                _priceModel = nil;
                _priceModel.priceMax = @"";
                _priceModel.priceMax = @"";
                
            }
            
        }
            break;
        case 2:   //面积
        {
            if ([optionData.itemName isEqualToString:@"不限"]) {
                _acreageId = @"";
            }else{
                _acreageId = optionData.itemID;
            }
        }
            break;
        case 3:  //更多
        {
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    [self getBuildingList];
    
    
}

-(void)select:(SelectionView *)selectView WithMoreChooseDic:(NSDictionary *)moreDic WithCommitType:(CommitType)commitTpye;
{
    
    if (commitTpye == CommitTypeStyle) {
        
        if ([moreDic valueForKey:@"featureId"]) {
            _featureId = [moreDic valueForKey:@"featureId"];
        }else{
            _featureId = @"";
        }
        if ([moreDic valueForKey:@"propertyId"]) {
            _propertyId =[moreDic valueForKey:@"propertyId"];
        }else{
            _propertyId = @"";
        }
        if ([moreDic valueForKey:@"bedroomId"]) {
            _bedroomId = [moreDic valueForKey:@"bedroomId"];
        }else{
            _bedroomId = @"";
        }
        
        
        if ([moreDic valueForKey:@"trystCarId"]){
            _trsyCarId =[moreDic valueForKey:@"trystCarId"];
        }else{
            _trsyCarId = @"";
        }
        
        [self getBuildingList];
        
    }else if(commitTpye == CleanTypeStyle ){
        
        
        _featureId = @"";
        
        _propertyId = @"";
        
        _bedroomId = @"";
        
        _trsyCarId = @"";
    }
    
}
#pragma mark - 恢复筛选状态
-(void)setSearchNomalStateBtnClick
{
    _keyword=@"";
    _areaId = @"";
    _acreageId=@"";
    _featureId=@"";
    _priceId = @"";
    _platId = @"";
    _page=1;
    _priceModel = nil;
    _priceModel.priceMax = @"";
    _priceModel.priceMax = @"";
    _propertyId = @"";
    _bedroomId = @"";
    _trsyCarId = @"";
    [_seleView removeAllSubviews];
    [_seleView removeFromSuperview];
    
    [self addSelectionView];
    [self getBuildingList];
    
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tempArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XTHomeBuildingCell buildingCellHeight];

//    if (self.viewControllerStyle == NormalViewControllerStyle || self.viewControllerStyle == SerachViewControllerStyle) {
//      
//        return [XTHomeBuildingCell buildingCellHeight];
//        
//    }else if(self.viewControllerStyle == NoDataViewControllerStyle){
//
//        BuildingListData *listData;
//        if (indexPath.row<_tempArr.count) {
//            listData =_tempArr[indexPath.row];
//        }
//        return [BuildingCell buildingCellHeightWithModel:listData WithbuildingStyle:HomeTableViewCellStyle];
//    }
//    return [XTHomeBuildingCell buildingCellHeight];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (self.viewControllerStyle) {
        case NormalViewControllerStyle:
        {
            return [self getTotalAllBuildingNumberLabel];
        }
            break;
            
        case SerachViewControllerStyle:
        {
            
            return [self getTotalAllBuildingNumberLabel];
            
        }
            break;
        case NoDataViewControllerStyle:
        {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 150)];
            view.backgroundColor = [UIColor whiteColor];
            UIButton *noDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 33, kMainScreenWidth, 133/2)];
            [noDataBtn setImage:[UIImage imageNamed:@"notFound.png"] forState:UIControlStateNormal];
            [view addSubview:noDataBtn];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, noDataBtn.bottom+10, kMainScreenWidth, 13)];
            titleLabel.text = @"没有找到楼盘";
            titleLabel.font = FONT(12.f);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = NAVIGATIONTITLE;
            [view addSubview:titleLabel];
            
            UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, 13)];
            titleLabel2.text = @"请换个筛选条件试试";
            titleLabel2.font = FONT(12.f);
            titleLabel2.textAlignment = NSTextAlignmentCenter;
            titleLabel2.textColor = NAVIGATIONTITLE;
            [view addSubview:titleLabel2];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((kMainScreenWidth-105)/2, titleLabel2.bottom+15, 105, 56/2);
            button.backgroundColor = BLUEBTBCOLOR;
            button.titleLabel.font = FONT(13.f);
            [button setTitle:@"返回楼盘列表" forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(setSearchNomalStateBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, button.bottom+37, kMainScreenWidth, 44)];
            bgView.backgroundColor =BACKGROUNDCOLOR;
            
            [view addSubview:bgView];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (44-14)/2, 16, 14)];
            imageView.image = [UIImage imageNamed:@"为您推荐.png"];
            
            [bgView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+15/2, 0, 100, 44)];
            label.textColor = NAVIGATIONTITLE;
            label.font = [UIFont boldSystemFontOfSize:15.f];
            label.text = @"为您推荐";
            label.textAlignment =NSTextAlignmentLeft;
            
            [bgView addSubview:label];
            
            if (_tempArr.count>0) {
                imageView.hidden = NO;
                label.hidden = NO;
                bgView.hidden = NO;
                self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];


            }else{
                imageView.hidden = YES;
                label.hidden = YES;
                bgView.hidden = YES;
                self.tableView.backgroundColor = [UIColor whiteColor];

            }
            
            
            return view;
        }
            break;
            
            
        default:
            break;
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (self.viewControllerStyle) {
        case NormalViewControllerStyle:
        {
            
            return 25;
            
            
        }
            break;
            
        case SerachViewControllerStyle:
        {
            return 25;
            
            
        }
            break;
            
        case NoDataViewControllerStyle:
        {
            return 538/2;
            
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DLog(@"_tempArr.count====%zd",_tempArr.count);

    
    BuildingListData *listData = _tempArr[indexPath.row];
    XTHomeBuildingCell* cell = [XTHomeBuildingCell buildingCellWithTableView:tableView];
    cell.listData = listData;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
    
    
//    if (self.viewControllerStyle == NormalViewControllerStyle || self.viewControllerStyle == SerachViewControllerStyle) {
//        BuildingListData *listData = _tempArr[indexPath.row];
//        XTHomeBuildingCell* cell = [XTHomeBuildingCell buildingCellWithTableView:tableView];
//        cell.listData = listData;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return cell;
//
//        
//    }else if(self.viewControllerStyle == NoDataViewControllerStyle){
//            BuildingListData *listData;
//            if (indexPath.row<_tempArr.count) {
//                listData =_tempArr[indexPath.row];
//            }
//            else
//            {
//                //        NSLog(@"indexPath:%zd,%zd",indexPath.row,_tempArr.count);
//            }
//        
//        BuildingCell *cell = [[BuildingCell alloc]initWithStyle:HomeTableViewCellStyle andBuildListData:listData];
//            cell.isShouldStartImage = YES;
//        
//        return cell;
//    }
//    
//    UITableViewCell *cell;
//    return cell;
    
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
    VC.eventId = @"PAGE_HWFC";
    [_seleView setTableViewCloseAndNomalStyle];
    VC.buildDistance = listData.buildDistance;

    
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
