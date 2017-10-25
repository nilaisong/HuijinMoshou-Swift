//
//  XTMapBuildingController.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/1.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapBuildingController.h"
#import "MyAnimatedAnnotationView.h"

#import "CityFirstResult.h"
#import "SelectionView.h"
#import "XTMapBuildingParametersModel.h"

#import "DataFactory+Building.h"
#import "DataFactory+Main.h"

#import "XTMapResultModel.h"

//区域标注
#import "XTMapAreaView.h"
//城市标注视图
#import "XTMapCityView.h"
//楼盘标注视图
#import "XTMapBuildView.h"

#import "XTMapBuildingDetailView.h"//地图详情

//点标注对象
#import "XTMapCityPointAnnotation.h"
#import "XTMapDistricPointAnnotation.h"
#import "XTMapBuildPointAnnotation.h"

#import "BuildingDetailViewController.h"

#import "XTBuildingSearchController.h"

#import "XTMapDistricGroupModel.h"

#import "XTMapCityGroupModel.h"
#import "ChooseCityViewController.h"
#import "BuildingListData.h"
@interface XTMapBuildingController ()<BMKMapViewDelegate,XTMapAreaViewDelegate,XTMapCityViewDelegate,XTMapBuildViewDelegate,SelectionViewDelegate,XTMapBuildingDetailViewDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,XTBuildingSearchDelegate,UIGestureRecognizerDelegate>
{
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation2;
    BMKPointAnnotation* animatedAnnotation1;
    BMKPointAnnotation* areaAnnotationView;
    BMKPointAnnotation* cityAnnotationView;
    BMKUserLocation   * _userLocation;//用户当前的位置
    UITapGestureRecognizer* _webTapGesture;//用户单击地图
    NSString* _selectedLatitude;//当前选中纬度
    NSString* _selectedLongitude;//当前选中经度
}

@property (nonatomic,strong)XTMapBuildingParametersModel* parametersModel;

@property (nonatomic,strong)NSArray* cityAnnotationsArray;

@property (nonatomic,strong)CityFirstResult *cityFirstResult;//根据城市ID  初始化数据

@property (nonatomic,weak)BMKMapView* mapView;//地图

@property (nonatomic,weak)SelectionView * selectView;

@property (nonatomic,strong)XTMapResultModel* resultModel;

@property (nonatomic,copy)NSString* cityId;

//城市集合标注数组
@property (nonatomic,strong)NSArray* cityPointAnnotationArray;
@property (nonatomic,strong)NSArray* cityPointAnnotationViewArray;

//区域集合标注数组
@property (nonatomic,strong)NSArray* districPointAnnotationArray;
@property (nonatomic,strong)NSArray* districPointAnnotationViewArray;

//楼盘
@property (nonatomic,strong)NSArray* buildPointAnnotationArray;
@property (nonatomic,strong)NSArray* buildPointAnnotationViewArray;

//操作地图之前的zoomLevel
@property (nonatomic,assign)CGFloat lastZoomLevel;

@property (nonatomic,weak)XTMapBuildingDetailView* selectedBuildingDetailView;//记录选中的楼盘

@property (nonatomic,strong)XTMapBuildInfoModel* selectedBuildingInfoModel;//记录选中楼盘的模型
@property (nonatomic,weak)XTMapBuildView* selectedMapBuildView;//选中的标注

@property (nonatomic,weak)XTButton* searchButton;

/**
 地图管理类
 */
@property (nonatomic,strong)BMKLocationService* locationService;


/**
 定位按钮
 */
@property (nonatomic,weak)XTButton* locationButton;

/**
 展示提示
 */
@property (nonatomic,assign)BOOL showAlertView;

/**
 附近，展示提示
 */
@property (nonatomic,assign)BOOL nearbyShowAlertView;

/**
 搜索是用来控制地图不进行自主搜索
 */
@property (nonatomic,assign)BOOL forbidUpdateMapView;

@property (nonatomic,strong)UIButton *cityBtn;
@property (nonatomic,strong)NSMutableArray *buildingNameArray;  //


@end

@implementation XTMapBuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedLongitude = [UserData sharedUserData].selectedLongitude;
    _selectedLatitude  = [UserData sharedUserData].selectedLatitude;
    self.buildingNameArray = [NSMutableArray array];

    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self commonInit];
        [self commonInitLocation];
    }else{
        [self createNoNetWorkViewWithReloadBlock:^{
            [self commonInit];
            [self commonInitLocation];
        }];
    }
    [self.cityBtn setTitle:[UserData sharedUserData].chooseCityName forState:UIControlStateNormal];

    _cityId = [UserData sharedUserData].chooseCityId;
    [self getHotBuildingNameArray];
}

/**
 初始化操作
 */
- (void)commonInit{
    
//    self.navigationBar.titleLabel.text = @"新房";
    [self searchButton];
    
    
    [self mapView];
    
    _showAlertView = YES;
    [self moveToUserCenter];
    
    
//    [self addAnnotationView];
//    [self addAnimataionView];
//    [self addAreaAnnotationView];
    _parametersModel = [[XTMapBuildingParametersModel alloc] init];
    
    [self setupData];
}

- (void)commonInitLocation{
    _userLocation = [UserData sharedUserData].userLocation;
    
    if (_userLocation) {
        self.locationButton.hidden = NO;
//        return;
    }
    [self.locationService startUserLocationService];
}

- (void)setupData{
    
    [self setupCityFilterWithCityId:nil];
    NSString* cityId = [UserData sharedUserData].cityId;
    if (cityId.length > 0) {
        _parametersModel.cityId = cityId;
    }
}

//-(void)reloadXTMapBuildingController
//{
//    //选择城市通知  修改
//    _selectedLongitude = [UserData sharedUserData].selectedLongitude;
//    _selectedLatitude  = [UserData sharedUserData].selectedLatitude;
//    _cityId = [UserData sharedUserData].chooseCityId;
//    [self.cityBtn setTitle:[UserData sharedUserData].chooseCityName forState:UIControlStateNormal];
//    [self setupCityFilterWithCityId:_cityId];
//    _mapView.zoomLevel = 12;
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_selectedLatitude doubleValue], [_selectedLongitude doubleValue]);
//    [self moveToLocation:coordinate level:_mapView.zoomLevel];
//    [self updateMapViewWithMapView:_mapView];
//
//}

- (void)setupCityFilterWithCityId:(NSString*)cityId{
    UIImageView* rotateView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getCityFirstWithMapCityId:cityId CallBack:^(CityFirstResult *cityResult) {
        [self removeRotationAnimationView:rotateView];
        cityResult.priceTypes = @[];
//        DistrictModel* distModel = [[DistrictModel alloc]init];
//        distModel.name = @"区域";
//        cityResult.districts = distModel;
        
        
        self.cityFirstResult = cityResult;
        [_selectView removeFromSuperview];
        _selectView = nil;
        [self selectView];
        
        self.mapView.frame =CGRectMake(0, CGRectGetMaxY(_selectView.frame), kMainScreenWidth, kMainScreenHeight - CGRectGetMaxY(_selectView.frame));
        
        [self.view setNeedsLayout];
    }];
}

- (void)updateMapViewWithMapView:(BMKMapView*)mapView{
    _parametersModel.modelType = @"1";
    if (mapView.zoomLevel <= 10) {
        _parametersModel.modelType = @"1";
        _parametersModel.maxLatitude = @"90";
        _parametersModel.maxLongitude = @"180";
        _parametersModel.minLatitude = @"0";
        _parametersModel.minLongitude = @"0";
        _parametersModel.cityId = @"";
    }else if(mapView.zoomLevel > 10 && mapView.zoomLevel <= 13){
        _parametersModel.maxLatitude = @"90";
        _parametersModel.maxLongitude = @"180";
        _parametersModel.minLatitude = @"0";
        _parametersModel.minLongitude = @"0";
        _parametersModel.modelType = @"2";
        _parametersModel.cityId = _cityId;
    }else if (mapView.zoomLevel > 13 && mapView.zoomLevel <= 21){
        _parametersModel.modelType = @"4";
    }
   [[DataFactory sharedDataFactory] getMapBuildingWith:_parametersModel callBack:^(ActionResult *result, XTMapResultModel *resultModel) {
       if (result.success) {
           self.resultModel = resultModel;
       }else{
           if (result.message.length > 0) {
               [self showTips:result.message];
           }else{
               [self showTips:@"楼盘数据检索失败"];
           }
           
       }
       
       _showAlertView = NO;
       _nearbyShowAlertView = NO;
   }];
}

- (void)setResultModel:(XTMapResultModel *)resultModel{
    _resultModel = resultModel;
    switch (resultModel.modelType) {
        case 1:
        {
            if (_mapView.zoomLevel <= 10) {
                [_mapView removeAnnotations:_mapView.annotations];
                NSMutableArray* cityPointAnnotationArray = [NSMutableArray array];
                for (int i = 0; i < resultModel.cityGroupModel.groups.count; i++) {
                    XTMapCityPointAnnotation* cityAnno = [[XTMapCityPointAnnotation alloc] init];
                    cityAnno.mapCityInfoModel = [resultModel.cityGroupModel.groups objectForIndex:i];
                    [_mapView addAnnotation:cityAnno];
                    [cityPointAnnotationArray appendObject:cityAnno];
                }
                if ((resultModel.cityGroupModel.groups.count <= 0 || resultModel
                      .cityGroupModel.groups == nil) && (_showAlertView || _nearbyShowAlertView)) {
                    AlertShow(@"未找到符合条件的楼盘");
                }
                _cityPointAnnotationArray = cityPointAnnotationArray;
            }
        }
            break;
        case 2:
        {
            if (_mapView.zoomLevel > 10 && _mapView.zoomLevel <= 13) {
                [_mapView removeAnnotations:_mapView.annotations];
                NSMutableArray* districPointAnnotationArray = [NSMutableArray array];
                for (int i = 0; i < resultModel.districtGroupModel.groups.count; i++) {
                    XTMapDistricPointAnnotation* districAnn = [[XTMapDistricPointAnnotation alloc] init];
                    districAnn.mapDistricInfoModel = [resultModel.districtGroupModel.groups objectForIndex:i];
                    [_mapView addAnnotation:districAnn];
                    [districPointAnnotationArray appendObject:districAnn];
                }
                if (resultModel.districtGroupModel.groups.count == 1) {
                    XTMapDistricInfoModel* disModel = [resultModel.districtGroupModel.groups objectForIndex:0];
                    [self handleDistricWith:disModel];
                }
                if ((resultModel.districtGroupModel.groups.count <= 0 || resultModel
                      .districtGroupModel.groups == nil) && (_showAlertView || _nearbyShowAlertView)) {
                    AlertShow(@"未找到符合条件的楼盘");
                }
                _districPointAnnotationArray = districPointAnnotationArray;
            }
        }
            break;
        case 3:{
            
        }
            break;
        case 4:
        {
            if (_mapView.zoomLevel > 13 && _mapView.zoomLevel <= 21) {
                [_mapView removeAnnotations:_mapView.annotations];
                NSMutableArray* buildPointAnnotationArray = [NSMutableArray array];
                for (int i = 0; i < resultModel.buildGroupModel.docs.count; i++) {
                    XTMapBuildPointAnnotation* buildAnn = [[XTMapBuildPointAnnotation alloc]init];
                    buildAnn.infoModel = [resultModel.buildGroupModel.docs objectForIndex:i];
                    [_mapView addAnnotation:buildAnn];
                    [buildPointAnnotationArray appendObject:buildAnn];
                }
                if (_userLocation) {
                    BMKPointAnnotation* poi = [[BMKPointAnnotation alloc]init];
                    poi.coordinate = _userLocation.location.coordinate;
                    poi.title = @"当前位置";
                    [_mapView addAnnotation:poi];
                }
                if ((resultModel.buildGroupModel.docs.count <= 0 || resultModel
                .buildGroupModel.docs == nil) && (_showAlertView || _nearbyShowAlertView)) {
                    AlertShow(@"未找到符合条件的楼盘");
                }
                _buildPointAnnotationArray = buildPointAnnotationArray;
            }
        }
            break;
        default:
            break;
    }
}

//当只有一个区域的时候，在这里处理
- (void)handleDistricWith:(XTMapDistricInfoModel*)disModel{
    _forbidUpdateMapView = YES;
    XTMapDistricDoc* doc = [disModel.doclist.docs objectForIndex:0];
    if (doc) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(doc.estateLatitude.doubleValue, doc.estateLongitude.doubleValue);
        [_mapView setCenterCoordinate:coordinate animated:YES];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        self.mapView.delegate = self;
    }
  

}

- (void)viewWillDisappear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_selectView setTableViewCloseAndNomalStyle];
    self.mapView.delegate = nil;
    [self clearMapBuildingDetailView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)addAnnotationView{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"test";
//        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    }
    [_mapView addAnnotation:pointAnnotation];
}

- (void)addAreaAnnotationView{
    if (areaAnnotationView == nil) {
        areaAnnotationView = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 40.115;
        coor.longitude = 116.404;
        areaAnnotationView.coordinate = coor;
        areaAnnotationView.title = @" ";
    }
    [_mapView addAnnotation:areaAnnotationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (BMKMapView *)mapView{
    if (!_mapView) {
        BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        mapView.zoomLevel = 12;
        mapView.delegate = self;
        mapView.zoomEnabledWithTap = YES;
        [self.view addSubview:mapView];
        _mapView = mapView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapTapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        _webTapGesture = tap;
        [mapView addGestureRecognizer:tap];
    }
    return _mapView;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isEqual:_webTapGesture]) {
        [self mapTapAction:gestureRecognizer];
        return NO;
    }
    return YES;
}

-(UIButton *)cityBtn;
{
    if (!_cityBtn) {
        _cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/2-30, 20, 60, 44)];
        [_cityBtn setImage:[UIImage imageNamed:@"城市切换"] forState:UIControlStateNormal];
        [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        [_cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = FONT(14.f);
        [_cityBtn addTarget:self action:@selector(jumpToChooseCity) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:_cityBtn];
    }
    return _cityBtn;
}
#pragma mark - 城市选择  搜索  点击地图跳转
-(void)jumpToChooseCity
{
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_QHCS" andPageId:@"PAGE_DTZF"];

    __weak XTMapBuildingController *weakSelf = self;

    ChooseCityViewController *VC = [[ChooseCityViewController alloc]init];
    VC.NotShouldWriteToPlist = YES;
    VC.getChooseCityNameAndId = ^(NSString *cityName,NSString *cityId,NSString *selectedLongitude,NSString *selectedLatitude){

        _selectedLongitude = selectedLongitude;
        _selectedLatitude  = selectedLatitude;
        _cityId = cityId;
        [weakSelf.cityBtn setTitle:cityName forState:UIControlStateNormal];
        [weakSelf setupCityFilterWithCityId:_cityId];
        _mapView.zoomLevel = 12;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_selectedLatitude doubleValue], [_selectedLongitude doubleValue]);
        [weakSelf moveToLocation:coordinate level:_mapView.zoomLevel];
        [weakSelf updateMapViewWithMapView:_mapView];
  
        [weakSelf getHotBuildingNameArray];
        
        
    };
    
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}


-(void)getHotBuildingNameArray
{
    if (self.buildingNameArray.count>0) {
        [self.buildingNameArray removeAllObjects];
    }
    
    [[DataFactory sharedDataFactory] getBannerBuildingWithPage:@"1" cityID:_cityId callBack:^(DataListResult *result) {
        
        for ( BuildingListData *buildingData in result.dataArray)
        {
            [self.buildingNameArray appendObject:buildingData.name];
        }
    }];

}

#pragma mark - function

/**
 跳转至用户选择城市中心的
 */
- (void)moveToUserCenter{
    CLLocationCoordinate2D geoPt = CLLocationCoordinate2DMake(_selectedLatitude.doubleValue, _selectedLongitude.doubleValue);
    if(CLLocationCoordinate2DIsValid(geoPt)){
        BMKMapStatus* status = [[BMKMapStatus alloc]init];
        status.fLevel = 12;
        status.targetGeoPt =geoPt;
        [self.mapView setMapStatus:status withAnimation:YES];
    }
   
}

- (void)moveToLocation:(CLLocationCoordinate2D)coordinate level:(float)lelel{
    if(CLLocationCoordinate2DIsValid(coordinate)){
        BMKMapStatus* status = [[BMKMapStatus alloc]init];
        status.fLevel = lelel;
        status.targetGeoPt =coordinate;
        [self.mapView setMapStatus:status withAnimation:NO];
    }
}


/**
 定位服务
 */
- (BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc]init];
        [_locationService setDelegate:self];
        _locationService.desiredAccuracy =kCLLocationAccuracyBest;
    }
    return _locationService;
}

- (XTButton *)locationButton{
    if (!_locationButton) {
        XTButton* btn = [[XTButton alloc]initWithNormalImage:@"map-location" selectedImage:@"map-location" imageFrame:CGRectMake(0, 0, 39, 39)];
        btn.frame = CGRectMake(10, kMainScreenHeight - 39 - 30, 39, 30);
        [btn addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.hidden = YES;
        _locationButton = btn;
    }
    return _locationButton;
}

- (void)locationButtonClick:(UIButton*)btn{
    if (_userLocation.location) {
        BMKMapStatus* status = [[BMKMapStatus alloc]init];
        _parametersModel.cityId = @"";
        status.targetGeoPt = _userLocation.location.coordinate;
        status.fLevel = 14;
        _nearbyShowAlertView = YES;
        [_mapView setMapStatus:status withAnimation:YES];
    }
    
}

#pragma mark - LocatinServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location) {
        self.locationButton.hidden = NO;
        _userLocation = userLocation;
    }else{
        self.locationButton.hidden = YES;
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    
}

#pragma mark - 地图点击事件
- (void)mapTapAction:(UIGestureRecognizer*)gest{
    CGPoint point = [gest locationInView:self.mapView];
    
    if (_selectedMapBuildView || _selectedBuildingDetailView) {
       BOOL isOnMapView = CGRectContainsPoint(_selectedMapBuildView.frame, point);
        if (!isOnMapView) {
            [self clearMapBuildingDetailView];    
        }
        
    }
    
}


- (SelectionView *)selectView{
    if (!_selectView) {
        SelectionView* selectV = [[SelectionView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 74 * 0.5) WithBuildingsResult:self.cityFirstResult WithIsMapSeleView:YES];
        [self.view addSubview:selectV];
        selectV.delegate = self;
        _selectView = selectV;
    }
    return _selectView;
}

#pragma mark - getter
- (XTButton *)searchButton{
    if (!_searchButton) {
        XTButton* searchBtn = [[XTButton alloc]initWithNormalImage:@"mapbuild-search" selectedImage:@"mapbuild-search" imageFrame:CGRectMake(44 - 22 - 10, (44 - 22) * 0.5, 22, 22)];
        searchBtn.frame = CGRectMake(kMainScreenWidth - 44, 20, 44, 44);
        [self.navigationBar addSubview:searchBtn];
        [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton = searchBtn;
    }
    return _searchButton;
}


#pragma mark - 搜索按钮点击
- (void)searchButtonClick:(XTButton*)btn{

    XTBuildingSearchController* searchVC = [[XTBuildingSearchController alloc] init];
    searchVC.delegate = self;
    [_selectView setTableViewCloseAndNomalStyle];
    searchVC.searchCityId = _cityId;
    searchVC.buildingNameArray = self.buildingNameArray;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
}

#pragma mark - XTBuildingSearchController
- (void)searchViewController:(XTBuildingSearchController *)searchVC didSelecteBuildings:(NSArray *)buildInfoArray{
    if (buildInfoArray.count <= 0) {
        return;
    }
    XTMapBuildInfoModel* model = [buildInfoArray firstObject];
    BMKMapStatus* status = [[BMKMapStatus alloc]init];
    status.fLevel = 14;
    status.targetGeoPt = CLLocationCoordinate2DMake([model.estateLatitude doubleValue], [model.estateLongitude doubleValue]);
    _mapView.delegate = self;
    _forbidUpdateMapView = YES;
    [_mapView setMapStatus:status withAnimation:YES];
    
    NSMutableArray* buildPointAnnotationArray = [NSMutableArray array];
    XTMapBuildPointAnnotation* buildAnn = [[XTMapBuildPointAnnotation alloc]init];
//        buildAnn.infoModel = [resultModel.buildGroupModel.docs objectForIndex:i];
    buildAnn.infoModel = model;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:buildAnn];
    [buildPointAnnotationArray appendObject:buildAnn];
    
    _buildPointAnnotationArray = buildPointAnnotationArray;
 
    
}

//- (void)cancelBtnClick:(XTButton*)btn{
//    btn.hidden = YES;
//    self.searchView.hidden = YES;
//    self.searchButton.hidden = NO;
//    self.searchTF.text = @"";
//    _parametersModel.keywords = nil;
//    [self updateMapViewWithMapView:_mapView];
//    [self.searchTF resignFirstResponder];
//}


#pragma mark - SelectionViewDelegate
//列表数据
-(void)select:(SelectionView *)selectView withchooseIndex:(NSInteger)chooseindex AndOptionData:(ItemData *)optionData AndPriceModel:(PriceModel *)priceModel{
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
                    _parametersModel.districtId = optionData.itemID;
                    _parametersModel.platId = @"";
                }else{
                    _parametersModel.districtId = @"";
                    _parametersModel.platId = @"";
                }
                _parametersModel.km = @"";
                _parametersModel.location = @"";
                _showAlertView = YES;
                _nearbyShowAlertView = YES;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_selectedLatitude.doubleValue, _selectedLongitude.doubleValue);
                [self moveToLocation:coordinate level:_mapView.zoomLevel];
                return;
            }else{
                _parametersModel.districtId = @"";
                _parametersModel.platId = optionData.itemID;
            }
            
        }
            break;
        case 1:  //价格
        {
            if ([optionData.itemName isEqualToString:@"不限"]) {
                _parametersModel.priceMax = @"";
                _parametersModel.priceMin = @"";
            }else if(priceModel){
                _parametersModel.priceMax = priceModel.priceMax;
                _parametersModel.priceMin = priceModel.priceMin;
            }
            
        }
            break;
        case 2:   //面积
        {
            if ([optionData.itemName isEqualToString:@"不限"]) {
                _parametersModel.acreageId = @"";
            }else{
                _parametersModel.acreageId = optionData.itemID;
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
//    [self moveToUserCenter];
    _showAlertView = YES;
    _parametersModel.maxLatitude = @"90";
    _parametersModel.maxLongitude = @"180";
    _parametersModel.minLatitude = @"0";
    _parametersModel.minLongitude = @"0";
    [self updateMapViewWithMapView:_mapView];
    
}

-(void)select:(SelectionView *)selectView WithMoreChooseDic:(NSDictionary *)moreDic WithCommitType:(CommitType)commitTpye{
    if (commitTpye == CommitTypeStyle) {
        
        if ([moreDic valueForKey:@"featureId"]) {
            _parametersModel.featureId = [moreDic valueForKey:@"featureId"];
            
        }else{
            _parametersModel.featureId = @"";
        }
        if ([moreDic valueForKey:@"propertyId"]) {
            _parametersModel.propertyId =[moreDic valueForKey:@"propertyId"];
            
        }else{
            _parametersModel.propertyId = @"";
        }
        if ([moreDic valueForKey:@"bedroomId"]) {
            _parametersModel.bedroomId = [moreDic valueForKey:@"bedroomId"];
        }else{
            _parametersModel.bedroomId = @"";
        }
        
        
        if ([moreDic valueForKey:@"trystCarId"]){
            _parametersModel.trsyCar =[moreDic valueForKey:@"trystCarId"];
        }else{
            _parametersModel.trsyCar = @"";
        }
        
    }else if(commitTpye == CleanTypeStyle ){
        
        _parametersModel.featureId = @"";
        
        _parametersModel.propertyId = @"";
        
        _parametersModel.bedroomId = @"";
        
        _parametersModel.trsyCar = @"";
    }

//    [self moveToUserCenter];
    _showAlertView = YES;
    [self updateMapViewWithMapView:_mapView];
}

/**
 距离的  代理
 
 @param selectView <#selectView description#>
 @param chooseString <#chooseString description#>
 @param optionData <#optionData description#>
 */
-(void)select:(SelectionView *)selectView withchooseString:(NSString *)chooseString AndOptionData:(ItemData *)optionData{
    if (chooseString.length <= 0) {
        return;
    }
    _showAlertView = YES;
    _parametersModel.districtId = @"";
    _parametersModel.km = @"";
    _parametersModel.location = @"";
    if (_parametersModel.cityId.length <= 0) {
        if (_cityId.length > 0) {
            _parametersModel.cityId = _cityId;
        }else if ([UserData sharedUserData].cityId.length > 0){
            _parametersModel.cityId = [UserData sharedUserData].cityId;
        }
    }
    if ([chooseString isEqualToString:@"区域"]) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(optionData.latitude.doubleValue, optionData.longitude.doubleValue);
        if ([optionData.itemName isEqualToString:@"不限"]) {
            coordinate = CLLocationCoordinate2DMake(_selectedLatitude.doubleValue, _selectedLongitude.doubleValue);
        }
        _parametersModel.districtId = optionData.itemID;
        
        [self moveToLocation:coordinate level:13];
    }else if ([chooseString isEqualToString:@"附近"]){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([UserData sharedUserData].latitude.doubleValue, [UserData sharedUserData].longitude.doubleValue);
        if (!CLLocationCoordinate2DIsValid(coordinate)) {
            coordinate = CLLocationCoordinate2DMake(_selectedLatitude.doubleValue, _selectedLongitude.doubleValue);
            _parametersModel.location = [NSString stringWithFormat:@"%@,%@",[UserData sharedUserData].selectedLatitude,[UserData sharedUserData].selectedLongitude];
        }else{
            _parametersModel.location = [NSString stringWithFormat:@"%@,%@",[UserData sharedUserData].latitude,[UserData sharedUserData].longitude];
        }
        
        
        _parametersModel.km = optionData.itemID;
        _cityId = _parametersModel.cityId;
        _parametersModel.cityId = @"";
        
        _forbidUpdateMapView = YES;
        [self moveToLocation:coordinate level:14];
        _nearbyShowAlertView = YES;
    }else{
//        _parametersModel.km = optionData.itemID;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_selectedLatitude.doubleValue, _selectedLongitude.doubleValue);
        [self moveToLocation:coordinate level:_mapView.zoomLevel];
        
    }
    
    [self updateMapViewWithMapView:_mapView];
    
}

#pragma mark - MapViewDelegate
/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    _lastZoomLevel = mapView.zoomLevel;
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    if (mapView.zoomLevel <= 13 && (_selectedBuildingInfoModel || _selectedBuildingDetailView || _selectedMapBuildView)) {
        [self clearMapBuildingDetailView];
    }
    
    CLLocationCoordinate2D northEast = [mapView convertPoint:CGPointMake(mapView.width, 0) toCoordinateFromView:mapView];
    CLLocationCoordinate2D southWest = [mapView convertPoint:CGPointMake(0, mapView.height) toCoordinateFromView:mapView];
    
    _parametersModel.maxLatitude = [NSString stringWithFormat:@"%.14f",northEast.latitude];
    _parametersModel.minLatitude = [NSString stringWithFormat:@"%.14f",southWest.latitude];
    _parametersModel.maxLongitude = [NSString stringWithFormat:@"%.14f",northEast.longitude];
    _parametersModel.minLongitude = [NSString stringWithFormat:@"%.14f",southWest.longitude];
    
    if (!_forbidUpdateMapView) {//判断是否禁止地图刷新
        [self updateMapViewWithMapView:mapView];
    }
    _forbidUpdateMapView = NO;//将禁止打开
}



/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[XTMapCityPointAnnotation class]]) {
        NSString *cityPointAnnotationID = @"CityPointAnnotation";
        XTMapCityPointAnnotation* cityPoint = (XTMapCityPointAnnotation*)annotation;
        XTMapCityView* annoView = [[XTMapCityView alloc]initWithAnnotation:annotation reuseIdentifier:cityPointAnnotationID];
        annoView.delegate = self;
        if (cityPoint.cityModel) {
            annoView.cityModel = cityPoint.cityModel;
        }else if (cityPoint.mapCityInfoModel){
            annoView.mapCityInfoModel = cityPoint.mapCityInfoModel;
        }
        return annoView;
    }else if ([annotation isKindOfClass:[XTMapDistricPointAnnotation class]]){
        NSString* districPointAnnotationID = @"DistricPointAnnotation";
        XTMapDistricPointAnnotation* districPoint = (XTMapDistricPointAnnotation*)annotation;
        XTMapAreaView* annoView = [[XTMapAreaView alloc]initWithAnnotation:annotation reuseIdentifier:districPointAnnotationID];
        annoView.delegate = self;
        if (districPoint.districModel) {
            annoView.districModel = districPoint.districModel;
        }else if (districPoint.mapDistricInfoModel){
            annoView.mapDistricInfoModel = districPoint.mapDistricInfoModel;
        }
        return annoView;
    }else if ([annotation isKindOfClass:[XTMapBuildPointAnnotation class]]){
        NSString* buildPointAnnotationID = @"BuildPointAnnotation";
        XTMapBuildPointAnnotation* buildPoint = (XTMapBuildPointAnnotation*)annotation;
        
        XTMapBuildView* annoView = [[XTMapBuildView alloc]initWithAnnotation:annotation reuseIdentifier:buildPointAnnotationID];
        if ([_selectedBuildingInfoModel.estateId isEqualToString:buildPoint.infoModel.estateId]) {
            buildPoint.infoModel.isSelected = YES;
            _selectedMapBuildView = annoView;
        }else{
            buildPoint.infoModel.isSelected = NO;
        }
        
        annoView.userInteractionEnabled = YES;
        annoView.delegate = self;
        annoView.infoModel = buildPoint.infoModel;
        return annoView;
    }
    
    if (annotation == areaAnnotationView) {
        XTMapAreaView* areaView = nil;
        if (areaView == nil) {
            areaView = [[XTMapAreaView alloc]initWithAnnotation:annotation reuseIdentifier:@"AreaView"];
            areaView.coordinate = areaAnnotationView.coordinate;
            areaView.draggable  = NO;
            areaView.userInteractionEnabled = YES;
            areaView.enabled = YES;
            areaView.delegate = self;
            return  areaView;
        }
    }
    
    BMKAnnotationView* anno = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"locationAnnotation"];
    anno.image = [UIImage imageNamed:@"icon_center_point"];
    return anno;
//    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
}

- (XTMapBuildInfoModel*)xtModelWithBuildingModel:(BuildingListData*)listData{
    XTMapBuildInfoModel* mModel = [[XTMapBuildInfoModel alloc]init];
    mModel.buildingListData = listData;
    return mModel;
}

#pragma mark - XTMapAreaViewDelegate
- (void)mapAreaView:(XTMapAreaView *)areaView didSelected:(XTMapDistricAnnotationModel *)districModel{
    
    if(CLLocationCoordinate2DIsValid(districModel.coordinate)){
        BMKMapStatus*  status = [[BMKMapStatus alloc] init];
        status.targetGeoPt = districModel.coordinate;
        status.fLevel = 14;
        [_mapView setMapStatus:status withAnimation:YES];
    }
}

#pragma mark - XTMapBuildViewDelegate
- (void)mapBuildView:(XTMapBuildView *)mapBuildView didSelected:(XTMapBuildInfoModel *)infoModel{
    CGFloat height = [XTMapBuildingDetailView heightWith:infoModel];
    _selectedMapBuildView.highted = NO;
    [_selectedMapBuildView setNeedsDisplay];
    if ([infoModel.estateId isEqualToString:_selectedBuildingInfoModel.estateId] && _selectedBuildingDetailView) {
        [self clearMapBuildingDetailView];
        return;
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([infoModel.estateLatitude doubleValue], [infoModel.estateLongitude doubleValue]);
    CGPoint cPoint = [_mapView convertCoordinate:coordinate toPointToView:self.view];
    cPoint.y += height - self.mapView.height/2.0 + 10;//计算详情view与地图中心点的差值，在加10
    coordinate = [_mapView convertPoint:cPoint toCoordinateFromView:self.view];
    _forbidUpdateMapView = YES;
    [_mapView setCenterCoordinate:coordinate animated:YES];
    [_selectedBuildingDetailView removeFromSuperview];
    _selectedBuildingDetailView = nil;
    XTMapBuildingDetailView* detailView = [[XTMapBuildingDetailView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight - height, kMainScreenWidth, height)];
    detailView.delegate = self;
    detailView.infoModel = infoModel;
    [self.view addSubview:detailView];
    _selectedBuildingInfoModel = infoModel;
    _selectedBuildingDetailView = detailView;
    _selectedMapBuildView = mapBuildView;
    mapBuildView.highted = YES;
}

#pragma mark - XTMapBuildingDetailViewDelegate
- (void)mapBuildingDetailView:(XTMapBuildingDetailView *)detailView didSelectedImageView:(XTMapBuildInfoModel *)infoModel{
    BuildingDetailViewController* detailVc= [[BuildingDetailViewController alloc]init];
    detailVc.buildingId = infoModel.estateId;
    detailVc.eventId = @"PAGE_DTZF_LP";
    [self.navigationController pushViewController:detailVc animated:YES];
}



#pragma mark - XTMapCityViewDelegate
- (void)mapCityView:(XTMapCityView *)areaView didSelected:(XTMapCityAnnotationModel *)cityModel{
    _parametersModel.cityId = cityModel.cityId;
    _selectedLatitude = [NSString stringWithFormat:@"%15f",cityModel.coordinate.latitude];
    _selectedLongitude = [NSString stringWithFormat:@"%15f",cityModel.coordinate.longitude];
    if (![_cityId isEqualToString:cityModel.cityId]) {
        [self setupCityFilterWithCityId:cityModel.cityId];
        [self.cityBtn setTitle:cityModel.cityName forState:UIControlStateNormal];
    }
    if (cityModel.cityId.length > 0) {
        _cityId = cityModel.cityId;
    }
    
    [self mapView:_mapView moveTo:cityModel.coordinate zoomLevel:12 animated:YES];
    
//算距离
//    BMKMapPoint point1 = BMKMapPointForCoordinate(cityModel.coordinate);
//    BMKMapPoint point2 = BMKMapPointForCoordinate(_mapView.centerCoordinate);
//    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
}


#pragma mark - 地图跳转方法
- (void)mapView:(BMKMapView*)mapView moveTo:(CLLocationCoordinate2D)coordinate zoomLevel:(CGFloat)zoomLevel animated:(BOOL)animated{
    BMKMapStatus* status = [[BMKMapStatus alloc]init];
    status.targetGeoPt = coordinate;
    status.fLevel = zoomLevel;
    [mapView setMapStatus:status withAnimation:animated];
}

- (void)clearMapBuildingDetailView{
    if (_selectedBuildingDetailView) {
        [_selectedBuildingDetailView removeFromSuperview];
        _selectedBuildingDetailView = nil;
    }
    if (_selectedMapBuildView) {
        _selectedMapBuildView.highted = NO;
        [_selectedMapBuildView setNeedsDisplay];
        _selectedMapBuildView = nil;
    }
    if (_selectedBuildingInfoModel) {
        _selectedBuildingInfoModel = nil;
    }
}



//time 单位秒
- (void)mapView:(BMKMapView*)mapView moveTo:(CLLocationCoordinate2D)coordinate zoomLevel:(CGFloat)zoomLevel animationTime:(int)time{
    BMKMapStatus* status = [[BMKMapStatus alloc]init];
    status.targetGeoPt = coordinate;
    status.fLevel = zoomLevel;
    [mapView setMapStatus:status withAnimation:YES withAnimationTime:time * 1000];
}

- (BMKCoordinateRegion)adjustRegionWith:(CLLocationCoordinate2D)coordinate zoomLevel:(CGFloat)level{
    //    169.712514  224.919907   max
    //    0.001155    0.000862
    
//    BMKMapPointForCoordinate()
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.0,0.02));
//    [self.mapView setCenterCoordinate:coordinate animated:YES];
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    return adjustedRegion;
}

@end
