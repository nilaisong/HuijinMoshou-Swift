//
//  BuildingController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BuildingController.h"
#import "UIView+MJExtension.h"
#import "SelectionView.h"
#import "HotRecommendedView.h"
#import "NSString+Extension.h"
#import "BuildingCell.h"
#import "BuildingDetailViewController.h"
#import "UITableViewRowAction+JZExtension.h"
#import "ChooseCityViewController.h"
#import "CustomerReportViewController.h"
#import "UserData.h"
#import "DataFactory+Building.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "SurroundingBuildingsViewController.h"
#import "SearchTableView.h"
#import "CityFirstResult.h"
#import "PriceModel.h"
#import "BuildingSearchViewController.h"

#import "XTMapBuildingController.h"

#import "AppDelegate.h"
typedef NS_ENUM(NSInteger, ViewControllerStyle)
{
    NormalViewControllerStyle,    //默认状态
    SerachViewControllerStyle,   //搜索状态
    NoDataViewControllerStyle,  //搜索无数据状态
};

@interface BuildingController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SelectionViewDelegate,SearchTableViewDeleagate>
@property (nonatomic,strong)UIView *searchView;
@property (nonatomic,strong)UIButton *cityBtn;

@property (nonatomic,strong)UIView *cityBgView;
@property (nonatomic,strong)SelectionView *seleView;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UITextField *searchTF;

@property (nonatomic,strong)UIButton *searchBtn;

@property (nonatomic,strong)UIButton *mapBtn;

@property (nonatomic,strong)UIAlertView *promptBox;


@property (nonatomic,strong)BuildingListData *tempBuildindData;  //临时的某一个楼盘的数据

//@property (nonatomic,strong)BuildingsResult *firstBuildResult;//该页面初始化的数据

@property (nonatomic,strong)CityFirstResult *cityFirstResult;//根据城市ID  初始化数据


@property (nonatomic,strong)NSMutableArray *tempArr;  //楼盘咱暂存数据 楼盘初始化的数据和楼盘列表的数据都放在这里

@property (nonatomic,strong)SearchTableView *lenovoTableView;  //联想tableView
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

@end

@implementation BuildingController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 双击刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBuildingVC) name:@"reloadMyBuildingList" object:nil];
    
    //重载页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllView) name:@"reloadAllBuildingListVC" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.leftBarButton.hidden = YES;
    self.navigationBar.barBackgroundImageView.backgroundColor = BLUEBTBCOLOR;
    
    self.tempArr = [NSMutableArray array];

    [self checkNetwork];
    
    [self shouldShowBuildingDetailFirstTimeShowImg];
    
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    
}

//刷新全部
 - (void)reloadAllView
{
    [self.seleView setSelectBtnStateNormal];
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
   
    [self reloadBuildingVC];
    [self checkNetwork];

}


//下拉刷新
- (void)reloadBuildingVC
{
    if (!_tableView) {
        
        [self checkNetwork];
        return;
        
    }
    
    [self.tableView.legendHeader beginRefreshing];

//    [self getBuildingList];
    
}


-(void)checkNetwork
{
    __weak typeof(self) blockSelf= self;
    
    if (self.tempArr==nil) {
        
        if (![self createNoNetWorkViewWithReloadBlock:^{
            [blockSelf loadUI];
        }])
        {
            [self loadUI];
        }
        
    }else{
        [self loadUI];

    }
}
-(void)loadUI
{
    self.viewControllerStyle = NormalViewControllerStyle;
    self.page = 1;
    [self addNavBarView];
    [self getBuildingInitializationData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self.cityBtn setTitle:[UserData sharedUserData].chooseCityName forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_seleView setTableViewCloseAndNomalStyle];
    
}
-(void)addNavBarView
{
    [self searchView];

    [self.cityBtn setTitle:[UserData sharedUserData].chooseCityName forState:UIControlStateNormal];

    if (self.mapBtn==nil) {
        self.mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-40, 20, 40, 44)];
        [self.mapBtn setImage:[UIImage imageNamed:@"iconfont-dituweizhi"] forState:UIControlStateNormal];
        [self.mapBtn addTarget:self action:@selector(mapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.navigationBar addSubview:self.mapBtn];
    
}

#pragma  mark - 懒加载  getter

-(UIButton *)cityBtn;
{
    if (!_cityBtn) {
        _cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 20, 60, 44)];
        [_cityBtn setImage:[UIImage imageNamed:@"城市切换"] forState:UIControlStateNormal];
        [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [_cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = FONT(13.f);
        [_cityBtn addTarget:self action:@selector(jumpToChooseCity) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:_cityBtn];
    }
    return _cityBtn;
}

-(UIView *)searchView;
{
    
    if (!_searchView) {
        
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 54/2, kMainScreenWidth-10-10-12-20, 30)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.layer.cornerRadius = 5;
        _searchView.layer.masksToBounds = YES;
        _searchView.userInteractionEnabled = YES;
        [self.navigationBar addSubview:_searchView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptoThebuildingSeachingVC)];
        [_searchView addGestureRecognizer:tap];
        
        
    
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(60+10, 0, 1, 30)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        [_searchView addSubview:lineLabel];
        
        UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(lineLabel.right+10, (30-13)/2, 13, 13)];
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
    
    [_seleView setTableViewCloseAndNomalStyle];

    [self.navigationController pushViewController:VC animated:YES];
    
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
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+74/2, kMainScreenWidth, kMainScreenHeight-64-74/2-49) style:UITableViewStyleGrouped];
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

-(void)addLenovoTableViewWithListArray:(NSArray*)dataArray
{
    
    [self.lenovoTableView removeFromSuperview];
    self.lenovoTableView = [[SearchTableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-240)];
    self.lenovoTableView.dataArray= dataArray;
    self.lenovoTableView.delegate = self;
    [self.view addSubview:self.lenovoTableView];
    
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tempArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BuildingListData *listData;
    if (indexPath.row<_tempArr.count) {
        listData =_tempArr[indexPath.row];
    }
    
    return [BuildingCell buildingCellHeightWithModel:listData WithbuildingStyle:HomeTableViewCellStyle];
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
    DLog(@"_tempArr.count====%zd",_tempArr.count);
    BuildingListData *listData;
    if (indexPath.row<_tempArr.count) {
        listData =_tempArr[indexPath.row];
    }
    else
    {
//        NSLog(@"indexPath:%zd,%zd",indexPath.row,_tempArr.count);
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
    VC.eventId = @"PAGE_LPLB";
    [_seleView setTableViewCloseAndNomalStyle];
    VC.buildDistance = listData.buildDistance;

    
    [self.navigationController pushViewController:VC animated:YES];
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self setEditing:false animated:true];
//}
//
//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [MobClick event:@"lp_zuohua"];
//    
//    
//    ///BtnType   1取消置顶   2置顶   3下载    4  报备
//    
//    BuildingListData *listData = _tempArr[indexPath.row];
//    _tempBuildindData = listData;
//    UITableViewRowAction *action1;
//    if (listData.isTop){
//        action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"取消置顶.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//            [self UITableViewRowActionBtnClickWithindex:indexPath.row AndBtnType:1];
//            
//        }];
//        
//    }else
//    {
//        action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"置顶.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//            
//            [MobClick event:@"lp_zhiding"];
//            
//            [self UITableViewRowActionBtnClickWithindex:indexPath.row AndBtnType:2];
//            
//        }];
//    }
//    
////    kNoDownload = 0,//未开始下载
////    kDownloading = 1,//正在下载
////    kDownloadFinished = 2//已完成下载
//    UITableViewRowAction *action2;
//    if (listData.downloadState == kDownloadFinished)  //
//    {
//        action2= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"已下载.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//            
//            [self showTips:@"您已下载过该楼盘!"];
//            
//        }];
//        
//    }else if (listData.downloadState == kDownloading){ //正在下载
//        
//        action2= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"正在下载.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//            
//            [self showTips:@"正在下载该楼盘!"];
//        }];
//        
//    }else{  //未下载
//        
//        action2= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"下载.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//            
//            [MobClick event:@"lp_xiazai"];
//            
//            [self UITableViewRowActionBtnClickWithindex:indexPath.row AndBtnType:3];
//            
//        }];
//    }
//    
//    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"loupan报.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//        
//        [MobClick event:@"lp_bbkh"];
//        
//        [self UITableViewRowActionBtnClickWithindex:indexPath.row AndBtnType:4];
//        
//    }];
//    
//    if ([self verifyTheRulesWithShouldJump:NO]) {
//        return @[action3,action2,action1];
//        
//    }else{
//        return @[action2,action1];
//        
//    }
//    return @[action3,action2,action1];
//    
//}

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

//-(void)UITableViewRowActionBtnClickWithindex:(NSInteger)indexPathRow AndBtnType:(NSInteger)btnType;
//{
//    ///BtnType   1取消置顶   2置顶   3下载    4  报备
//    
//    BuildingListData *listData = _tempArr[indexPathRow];
//    
//    
//    switch (btnType) {
//        case 1:
//        {
//            [self cancelTopForBuildingWithBuildingId:listData.buildingId];
//        }
//            break;
//            
//        case 2:
//        {
//            [self setTopForBuildingWithBuildingId:listData.buildingId];
//        }
//            break;
//            
//        case 3:
//        {
//            
//            _promptBox = [[UIAlertView alloc]initWithTitle:@"点击下载楼盘全部图片,以便离线查看。建议您在WIFI环境下载" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [_promptBox show];
//        }
//            break;
//            
//        case 4:
//        {
//            CustomerReportViewController *reportVC = [[CustomerReportViewController alloc] init];
//            reportVC.buildingID = listData.buildingId;
//            reportVC.type = 1;
//            // 全号  隐号报备 (0 :全号隐号均可     1:仅全号)
//            reportVC.bIsShowVisitInfo = listData.customerVisitEnable;
//            reportVC.customerTelType = listData.customerTelType;
//            reportVC.mechanismType = listData.mechanismType;
//            reportVC.mechanismText = listData.mechanismText;
//          
//            [_seleView setTableViewCloseAndNomalStyle];
//
//            [self.navigationController pushViewController:reportVC animated:YES];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self setEditing:NO animated:YES];
//    [self.tableView reloadData];
//}

#pragma mark - 下载数据
-(void)startDownloadWith:(BuildingListData *)buildlistData;
{
    NSString *showTipString = [NSString stringWithFormat:@"您正在下载%@楼盘",buildlistData.name];
    [self showTips:showTipString];
    DownloaderManager *downloaderManager=[DownloaderManager sharedManager];
    [downloaderManager addRequestWithItemId:buildlistData.buildingId andName:buildlistData.name];
    [downloaderManager resourceRequestWithItemId:buildlistData.buildingId];
    [downloaderManager getDownloadStateWithItemId:buildlistData.buildingId];
}

#pragma mark -   楼盘初始化数据  置顶  取消置顶和 楼盘搜索列表的接口

//楼盘初始化数据
-(void)getBuildingInitializationData
{
    [[DataFactory sharedDataFactory] getCityFirstWithMapCityId:nil CallBack:^(CityFirstResult *cityResult) {
        if (cityResult) {
            self.cityFirstResult = cityResult;
            [self addTableView];
            [self addSelectionView];
            [self getBuildingList];
        }
        
    }];
    
}

//-(void)setTopForBuildingWithBuildingId:(NSString *)buildingID;
//{
//    [[DataFactory sharedDataFactory] getestateTopNumberCountWithCallback:^(NSString *number) {
//        if (number) {
//            NSInteger topNumber = [number integerValue];
//            if (topNumber<5) {
//                
//                [[DataFactory sharedDataFactory] setTopForBuilding:buildingID withCallBack:^(ActionResult *result) {
//                    
//                    if (result.success)
//                    {
//                        [TipsView showTips:@"置顶成功" inView:self.view];
//                        _page = 1;
//                        [self getBuildingList];
//                    }else
//                    {
//                        [TipsView showTips:result.message inView:self.view];
//                    }
//                    
//                }];
//                
//            }else if(topNumber>=5){
//                
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定将此楼盘置顶,替换现有置顶楼盘?" message:@"置顶楼盘已达上限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"置顶", nil];
//                alert.tag = [buildingID integerValue];
//                [alert show];
//                
//            }
//            
//        }
//        
//        
//    }];
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
//{
//    if (alertView == _promptBox)
//    {
//        if (buttonIndex==1)
//        {
//            [self startDownloadWith:_tempBuildindData];
//        }
//        
//    }else{
//        
//        switch (buttonIndex) {
//            case 0:
//            {
//            }
//                break;
//            case 1:
//            {
//                [[DataFactory sharedDataFactory] setTopForBuilding:[NSString stringWithFormat:@"%zd",alertView.tag] withCallBack:^(ActionResult *result) {
//                    
//                    if (result.success)
//                    {
//                        [TipsView showTips:@"置顶成功" inView:self.view];
//                        _page = 1;
//                        [self getBuildingList];
//                    }else
//                    {
//                        [TipsView showTips:result.message inView:self.view];
//                    }
//                    
//                }];
//                
//                
//            }
//                break;
//            default:
//                break;
//        }
//        
//    }
//    
//}


//-(void)cancelTopForBuildingWithBuildingId:(NSString *)buildingID;
//{
//    [[DataFactory sharedDataFactory] cancelTopForBuilding:buildingID withCallBack:^(ActionResult *result) {
//        
//        if (result.success)
//        {
//            [TipsView showTips:@"取消置顶成功" inView:self.view];
//            [self getBuildingList];
//            
//        }else{
//            [TipsView showTips:result.message inView:self.view];
//            [self getBuildingList];
//
//        }
//        
//    }];
//    
//}
//楼盘列表接口
-(void)getBuildingList
{
    DLog(@"   %@   %@   %@  %@   %@   %zd  %@ ",_keyword,_areaId,_featureId,_acreageId,_priceId,_page,_platId);
    
    [self.lenovoTableView removeFromSuperview];
//    UIImageView *loadingView;
    if (!self.isRefresh)
    {
//        loadingView = [self setRotationAnimationWithView];
    }
    [[DataFactory sharedDataFactory] getBuildingsWithCityId:nil andPage:[NSString stringWithFormat:@"%zd",_page] andKeyword:_keyword andAreaId:_areaId andFeatureId:_featureId andAcreageId:_acreageId andPriceId:_priceId andPlatId:_platId andPriceModel:_priceModel andpropertyId:_propertyId andBedRoomId:_bedroomId andTrsyCar:_trsyCarId withCallBack:^(DataListResult *result,NSNumber *buildingNumber) {
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
    [[DataFactory sharedDataFactory] findRecommendEstateWithNumber:@"3" andIsHomePage:NO AndCityId:nil withCallBack:^(DataListResult *result) {
        
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


-(void)getBuildingLenovoNameWithKeyWord:(NSString *)keyWord
{
    
    [[DataFactory sharedDataFactory] getBuildingKeywordsWithKeyword:keyWord WithCallback:^(NSArray *array) {
        
        if (array.count > 0)
        {
            for (NSString *title in array) {
                DLog(@"title ==== %@",title);
            }
            
            [self addLenovoTableViewWithListArray:array];
        }
    }];
}

//-(void)getBuildingTopNumber
//{
//    [[DataFactory sharedDataFactory] getestateTopNumberCountWithCallback:^(NSString *number) {
//        
//        DLog(@"number=====%@",number);
//        
//    }];
//    
//}
#pragma mark - 城市选择  搜索  点击地图跳转
-(void)jumpToChooseCity
{
    [_seleView setTableViewCloseAndNomalStyle];

    ChooseCityViewController *VC = [[ChooseCityViewController alloc]init];
    VC.NotShouldWriteToPlist = NO;
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}

//-(void)searchBtnClick:(UIButton *)sender
//{
//    [MobClick event:@"lp_sousuo"];
//    
//    [self.seleView setSelectBtnStateNormal];
//    
//    if (self.searchView==nil)
//    {
//        self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 63)];
//        self.searchView.backgroundColor = BACKGROUNDCOLOR;
//        [self.view addSubview:self.searchView];
//        
//        UIView *bgVIew = [[UIView alloc]initWithFrame:CGRectMake(10, 25, kMainScreenWidth-10-50, 29)];
//        bgVIew.layer.cornerRadius = 5;
//        bgVIew.layer.masksToBounds = YES;
//        bgVIew.backgroundColor = UIColorFromRGB(0xd9d9db);
//        [self.searchView addSubview:bgVIew];
//        
//        UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 15, 15)];
//        [searchIcon setImage:[UIImage imageNamed:@"search-icon.png"]];
//        [bgVIew addSubview:searchIcon];
//        
//        if (!_searchTF) {
//            _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(kFrame_XWidth(searchIcon)+5, 0, kFrame_Width(bgVIew)-kFrame_XWidth(searchIcon)-30, 29)];
//            _searchTF.placeholder = @"请输入楼盘名称";
//            _searchTF.font = FONT(14.f);
//            _searchTF.textAlignment = NSTextAlignmentLeft;
//            _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//            _searchTF.delegate = self;
//            [_searchTF addTarget:self action:@selector(searchTextEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//            [_searchTF becomeFirstResponder];
//            _searchTF.returnKeyType = UIReturnKeySearch;
//        }
//        [bgVIew addSubview:_searchTF];
//        
//        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-50, 20, 50, 44)];
//        [cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateSelected];
//        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.searchView addSubview:cancelBtn];
//        
//    }
//    
//    
//}

-(void)mapBtnClick:(UIButton *)sender
{
    
    DLog(@"地图");
    [MobClick event:@"lp_dtzf"];

    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_DTZF" andPageId:@"PAGE_LPLB"];

    XTMapBuildingController* VC = [[XTMapBuildingController alloc]init];
    
    [_seleView setTableViewCloseAndNomalStyle];

    
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

-(void)searchTextEventEditingChanged:(UITextField*)textField
{
    DLog(@"textField.text = %@ ",textField.text);
    
    [self getBuildingLenovoNameWithKeyWord:textField.text];
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    _keyword = textField.text;
    _page = 1;
    [textField resignFirstResponder];
    [self getBuildingList];
    
    DLog(@"搜索  %@  ",textField.text);
    
    return YES;
}


//判断是否为列表添加无数据图片
- (void) shouldBlankTipImg:(NSInteger)count
{
    if (count == 0)
    {
        [self.view addSubview:_blankTipImgView];
        //        [_blankTipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.center.equalTo(self.tableView);
        //        }];
    }
    else
    {
        [_blankTipImgView removeFromSuperview];
    }
}

#pragma mark - SearchTableViewDeleagate

-(void)didSelectWith:(SearchTableView*)searchTableView andKeyword:(NSString *)keyWord;
{
    self.searchTF.text = keyWord;
    self.keyword = keyWord;
    [self.searchTF resignFirstResponder];
    [self getBuildingList];
    
}

#pragma mark 空白也没有数据
-(void)tempView{
    [self.tableView setHidden:YES];
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, 64+44+(kMainScreenWidth-64-44-30)/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
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


#pragma mark - 新装app首次打开引导页 begin
//是否展示 使用帮助 引导图（新装app 首次打开展示）
- (void) shouldShowBuildingDetailFirstTimeShowImg
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"buildingList_FirstTimeShow"])
    {
        [self showFirstTimeDisplayImg];
    }
}
//展示引导图
- (void) showFirstTimeDisplayImg
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIButton *imgBtn_manage = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn_manage.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    imgBtn_manage.tag = 5000;
    [imgBtn_manage addTarget:self action:@selector(removeFirstTimeDisplayImg:) forControlEvents:UIControlEventTouchUpInside];
    if (iPhone4) {
        
        [imgBtn_manage setImage:[UIImage imageNamed:@"map960"] forState:UIControlStateNormal];
        [imgBtn_manage setImage:[UIImage imageNamed:@"map960"] forState:UIControlStateHighlighted];
 
    }else{
        [imgBtn_manage setImage:[UIImage imageNamed:@"map1080"] forState:UIControlStateNormal];
        [imgBtn_manage setImage:[UIImage imageNamed:@"map1080"] forState:UIControlStateHighlighted];
    }
    [delegate.window addSubview:imgBtn_manage];

}

//移除引导图
- (void) removeFirstTimeDisplayImg:(UIButton *) btn
{
    if (btn.tag == 5000) {
       
        [btn removeFromSuperview];
        
        UIButton *imgBtn_detail = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn_detail.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        [imgBtn_detail addTarget:self action:@selector(removeFirstTimeDisplayImg:) forControlEvents:UIControlEventTouchUpInside];
        imgBtn_detail.tag = 5001;
        if (iPhone4) {
            [imgBtn_detail setImage:[UIImage imageNamed:@"building960"] forState:UIControlStateNormal];
            [imgBtn_detail setImage:[UIImage imageNamed:@"building960"] forState:UIControlStateHighlighted];
            
        }else{
            [imgBtn_detail setImage:[UIImage imageNamed:@"building1080"] forState:UIControlStateNormal];
            [imgBtn_detail setImage:[UIImage imageNamed:@"building1080"] forState:UIControlStateHighlighted];
        }
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

        [delegate.window addSubview:imgBtn_detail];
        
    }else if (btn.tag == 5001){
      
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"buildingList_FirstTimeShow"];

        [btn removeFromSuperview];
    }
   
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
