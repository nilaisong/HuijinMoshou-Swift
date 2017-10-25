//
//  MapViewController.m
//  MoShouBroker
//
//  Created by admin on 15/6/10.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "CustomAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "UserData.h"
#import "CLLocation+YCLocation.h"
#import "ImageTextButton.h"
#import <MapKit/MapKit.h>
#import "Estate.h"

#import "XTMapPinView.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UIScrollViewDelegate,UIActionSheetDelegate,CallOutNavgationActionDelegate>
{
    BMKMapView *_mapView;
    UIScrollView *_tabScrollView;
    BMKLocationService * _locService;
    BMKPoiSearch * _searcher;
    BMKUserLocation * _myLocation;
    
    UserData *_userDate;
    NSString *_myAddress;  //我当前的地址(根据经纬度反地理编码的出来的地址)
    CLLocationCoordinate2D _myLocationcoor; //自己的经纬度
    CLLocationCoordinate2D _buildLocation;  //楼盘坐标经纬度
    BMKGeoCodeSearch * _geoCodeSearch;
    NSArray *_titleArr;
    NSInteger _chooseIndex;
    BMKPointAnnotation *_buildingPointAnnotation;
    /**
     *  自定义的标注 Callout类
     */
    CustomAnnotationView * _buildCalloutAnnotation;
    
    CalloutMapAnnotation *_callOutAnnotation;
    UIView *barView;
    
    Estate * _estateBuildingMo;
    
    //add by xiaotei  标注图片类型
    XTMapPinViewType _pinType;
    
}
@end

@implementation MapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _locService.delegate =self;
    _searcher.delegate = self;
    _geoCodeSearch.delegate =self;
    self.popGestureRecognizerEnable = NO;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _searcher.delegate = nil;
    _geoCodeSearch.delegate =nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popGestureRecognizerEnable = NO;
self.navigationBar.titleLabel.text = @"位置及周边";
    
    _estateBuildingMo = self.buileding.estate;
    
    self.view.backgroundColor = [UIColor clearColor];
    _titleArr = @[@"公交",@"地铁",@"学校",@"医院",@"银行",@"购物"];
    _chooseIndex = -1;
    
    _userDate = [UserData sharedUserData];
    _myLocationcoor =CLLocationCoordinate2DMake([_userDate.latitude doubleValue], [_userDate.longitude doubleValue]);
    [self loadMapView];   //地图View
    [self startLocation]; //定位 可单独使用
    [self startPoiSearch]; //POI搜索
    [self startGeoCodeSearch];//Geo搜索使用
    [self GetReverseGeocode];
    [self addTabBarView];
    [self addBuildingPointAnnotation]; //添加楼盘标注
    [self addNavigationBar];
    
    if (self.isShouldCallOut) {
        [self addCallOutAnnotation];

    }else{
        [self POISearchWithKeyWord:_titleArr[0]];

    }
    

    
}
-(void)addNavigationBar
{
   
    
    
}


-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (barView.superview) {
        barView.frame =CGRectMake(0, self.view.bounds.size.height-55, self.view.bounds.size.width, 55);
    }
    if (_mapView.superview) {
        _mapView.frame =CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-55-64);
    }
}

-(void)addTabBarView
{
    
    NSArray *normalImageArr = @[@"icon-gongjiaohui.png",@"icon-ditiehui.png",@"icon－xuexiaohui.png",@"icon-yiyuanhui.png",@"icon-yinhanghui.png",@"shangchanghui.png"];
    NSArray *selectedImageArr = @[@"icon-gongjiao.png",@"icon-ditie.png",@"icon－xuexiao.png",@"icon-yiyuan.png",@"icon-yinhang.png",@"shangchang.png"];
   
    barView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-55, kMainScreenWidth, 55)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barView];
    
    for (int i = 0; i <_titleArr.count ; i ++)
    {
        UIButton *BgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        BgBtn.frame = CGRectMake(i*(kMainScreenWidth/_titleArr.count), 0, (kMainScreenWidth/_titleArr.count), 55);
        BgBtn.tag = 5000+i;
        [BgBtn addTarget:self action:@selector(BgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:BgBtn];

        CGFloat  barBtnWith = kMainScreenWidth/_titleArr.count;
        CGFloat barbtnHeight =55;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.frame = CGRectMake(0,0, barBtnWith, barbtnHeight);
        button.tag = 6000+i;
        [button setTitle:_titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
        [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateSelected];
        button.titleLabel.font= FONT(12.f);
        [button setImage:[UIImage imageNamed:normalImageArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImageArr[i]] forState:UIControlStateSelected];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-10, button.imageView.width/2, 0, 0)];
        //上左 负   右下正    上              左                 下             右
//        UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.height+button.titleLabel.height, -button.imageView.width-button.titleLabel.width/2, 0, 0)];
        if (!self.isShouldCallOut && i==0  ) {
            button.selected = YES;
            _chooseIndex = 0;
        }
        
        [BgBtn addSubview:button];
    }
}

-(void)BgBtnClick:(UIButton *)sender
{
    if (sender.tag - 5000 != _chooseIndex)
    {
        UIButton *pastBtn = (UIButton *)[self.view viewWithTag:_chooseIndex+6000];
        pastBtn.selected = !pastBtn.selected;
        
        UIButton *button = (UIButton *)[self.view viewWithTag:(sender.tag-5000)+6000];
        button.selected = !button.selected;
        _chooseIndex = sender.tag -5000;
    }
    
    DLog(@"title %@",_titleArr[sender.tag -5000]);
    
    
    [self setPinTypeIndex:sender.tag - 5000];
    [self POISearchWithKeyWord:_titleArr[sender.tag -5000]];
}

/**
 设置标注枚举的类型
 */
- (void)setPinTypeIndex:(NSInteger)index{
    switch (index) {
        case 0:
            _pinType = XTMapPinViewTypeBus;
            break;
        case 1:
            _pinType = XTMapPinViewTypeSubway;
            break;
        case 2:
            _pinType = XTMapPinViewTypeSchool;
            break;
        case 3:
            _pinType = XTMapPinViewTypeHospital;
            break;
        case 4:
            _pinType = XTMapPinViewTypeBank;
            break;
        case 5:
            _pinType = XTMapPinViewTypeShop;
            break;
        default:
            break;
    }
}

//添加上方呼出框
-(void)addCallOutAnnotation
{
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_estateBuildingMo.latitude doubleValue], [_estateBuildingMo.longitude doubleValue]);
    
    _callOutAnnotation = [[CalloutMapAnnotation alloc]initWithLatitude:coor.latitude andLongitude:coor.longitude];
    [_mapView addAnnotation:_callOutAnnotation];
    
    [_mapView setCenterCoordinate:_callOutAnnotation.coordinate animated:YES];
    
}

-(void)startPoiSearch
{
    _searcher = [[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    
}
-(void)startLocation
{
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//    [BMKLocationService setLocationDistanceFilter:1.f];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy =kCLLocationAccuracyNearestTenMeters;

    [_locService startUserLocationService];
}
-(void)loadMapView
{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, self.navigationBar.bottom, kMainScreenWidth, self.view.bounds.size.height-49-self.navigationBar.bottom)];
    _mapView.delegate =self;
    _mapView.zoomLevel = 14;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {

    }else
    {
        _mapView.showsUserLocation = YES;

    }
    [self.view addSubview:_mapView];
    [_mapView updateLocationData:_userDate.userLocation];
}
-(void)startGeoCodeSearch
{
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
}
-(void)GetReverseGeocode
{
    BMKReverseGeoCodeOption *reGeoOptin = [[BMKReverseGeoCodeOption alloc]init];
    reGeoOptin.reverseGeoPoint = _myLocationcoor;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reGeoOptin];
    if(flag)
    {
        //        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
        
    }
    
}
-(void)addBuildingPointAnnotation
{
    if (_buildingPointAnnotation == nil) {
        _buildingPointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_estateBuildingMo.latitude doubleValue], [_estateBuildingMo.longitude doubleValue]);
        _buildingPointAnnotation.coordinate = coor;
        _buildingPointAnnotation.title = @" ";
        _mapView.centerCoordinate = coor;
            
        _buildLocation.latitude = coor.latitude;
        _buildLocation.longitude = coor.longitude;
    }
    [_mapView addAnnotation:_buildingPointAnnotation];

}




#pragma mark - BMKLocationServiceDelegate

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];

    _myLocation = userLocation;
   
    /**
     *  测试定位成功侯打印
     */
    [self GetReverseGeocode];

    
}
-(void)didFailToLocateUserWithError:(NSError *)error
{
    
    DLog(@"Error   %@",error);
}

#pragma mark - POI搜索方法
-(void)POISearchWithKeyWord:(NSString *)titleString;
{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 50;
    option.location =_buildLocation;
    option.keyword = titleString;
    option.radius = 5000;
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
//        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }

}

#pragma mark - BMKPoiSearchDelegate
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        DLog(@"poiResult   %@",poiResult);
        //得到搜索结果后 把当前屏幕所有的annotation清除掉
        NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        
        [self addBuildingPointAnnotation];
        /**
         *  poiList包含检索出来的周边信息的数组
         */
        NSArray * poiList = poiResult.poiInfoList;
//            NSString* _name;			///<POI名称
//            NSString* _uid;
//            NSString* _address;		///<POI地址
//            NSString* _city;			///<POI所在城市
//            NSString* _phone;		///<POI电话号码
//            NSString* _postcode;		///<POI邮编
//            int		  _epoitype;		///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
//            CLLocationCoordinate2D _pt;	///<POI坐标
//        NSString *polListCount = [NSString stringWithFormat:@"%zd 个玩意",poiList.count];
//        AlertShow(polListCount);
        for (BMKPoiInfo *info in poiList)
        {
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            item.coordinate = info.pt;
            item.title = info.name;
            
            DLog(@"%f    %f",info.pt.latitude  ,info.pt.longitude   );
            [_mapView addAnnotation:item];
        }
        
        //把搜索出来的第一个周边数据的坐标设置为地图中心点 后来不需要这个功能了
//        BMKPoiInfo *firstInfo = poiList[0];
//        _mapView.centerCoordinate = firstInfo.pt;
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        AlertShow(@"抱歉，未找到结果");
        NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];

        [self addBuildingPointAnnotation];

        
    }
}
#pragma mark - 地图 annotationView

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[CustomAnnotationView class]])  //是否为楼盘的annotation
  if (annotation == _buildingPointAnnotation)
    {
        NSString *buildAnnotationViewID = @"buildAnnotation";
        // 检查是否有重用的缓存
        BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:buildAnnotationViewID];
        
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:buildAnnotationViewID];
            // 设置重天上掉下的效果(annotation)
            ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
        }
        // 设置位置
//        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.image = [UIImage imageNamed:@"pin-2"];
        annotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        annotationView.canShowCallout = NO;
        // 设置是否可以拖拽
        annotationView.draggable = NO;
        return annotationView;
    }else if([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        
        NSString *customAnnotationViewID = @"CustomAnnotationViewID";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationViewID];
        if (annotationView==nil)
        {
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customAnnotationViewID];
            annotationView.selected = YES;
            CustomCalloutView *callView = [[CustomCalloutView alloc]initWithFrame:CGRectMake(1, 0.5, 300-1, 53.5)];
            callView.delegate = self;
            callView.buildTitleLabel.text = [NSString stringWithFormat:@"%@",self.buileding.name];
            callView.buildLocationLabel.text = [NSString stringWithFormat:@"%@",_estateBuildingMo.address];

            [annotationView.contentView addSubview:callView];
        }
        return annotationView;
    }else
    {
        NSString *AnnotationViewID = @"myAnnotation";
        switch (_pinType) {
            case XTMapPinViewTypeShop:
                AnnotationViewID = @"XTMapPinViewTypeShop";
                break;
            case XTMapPinViewTypeBank:
                AnnotationViewID = @"XTMapPinViewTypeBank";
                break;
            case XTMapPinViewTypeBus:
                AnnotationViewID = @"XTMapPinViewTypeBus";
                break;
            case XTMapPinViewTypeHospital:
                AnnotationViewID = @"XTMapPinViewTypeHospital";
                break;
            case XTMapPinViewTypeSchool:
                AnnotationViewID = @"XTMapPinViewTypeSchool";
                break;
            case XTMapPinViewTypeSubway:
                AnnotationViewID = @"XTMapPinViewTypeSubway";
                break;
            default:
                break;
        }
        // 检查是否有重用的缓存
        BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            annotationView = [[XTMapPinView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID type:_pinType];
            // 设置重天上掉下的效果(annotation)
            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        }
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        annotationView.paopaoView.backgroundColor = BLUEBTBCOLOR;
        annotationView.paopaoView.tintColor = [UIColor whiteColor];
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        annotationView.canShowCallout = YES;
        // 设置是否可以拖拽
        annotationView.draggable = NO;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if (view.annotation == _buildingPointAnnotation)
    {
      
        if (_callOutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _callOutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        if (_callOutAnnotation)
        {
            [_mapView removeAnnotation:_callOutAnnotation];
            _callOutAnnotation = nil;
        }
        
        _callOutAnnotation = [[CalloutMapAnnotation alloc]initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        [_mapView addAnnotation:_callOutAnnotation];
        
        [_mapView setCenterCoordinate:_callOutAnnotation.coordinate animated:YES];
        }
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (_callOutAnnotation && ![view isKindOfClass:[CustomAnnotationView class]])
    {
        if (_callOutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _callOutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_callOutAnnotation];
            _callOutAnnotation = nil;
        }

    }
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
}

#pragma mark - 导航

-(void)CallOutNavgationAction;
{
    [MobClick event:@"lpxq_dzdh"];

#warning 这里要把百度坐标转换成火星坐标
    
//    _buildLocation.latitude;
//    _buildLocation.longitude;

    CLLocation *Location = [[CLLocation alloc]initWithLatitude:_buildLocation.latitude longitude:_buildLocation.longitude];
    
  CLLocation * transformLocation = [Location locationMarsFromBaiduWithLat:_buildLocation.latitude andLng:_buildLocation.longitude];
    
    DLog(@"transformLocation ====%F    %F",transformLocation.coordinate.latitude,transformLocation.coordinate.longitude);
    
    MKMapItem *navgastionMap = [MKMapItem mapItemForCurrentLocation];

    MKPlacemark *placeMark = [[MKPlacemark alloc]initWithCoordinate:transformLocation.coordinate addressDictionary:nil];
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:placeMark];
    toLocation.name = _estateBuildingMo.address;
    NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    
    [MKMapItem openMapsWithItems:@[navgastionMap,toLocation] launchOptions:options];
    
    
    

//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择地图来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度地图导航",@"百度网页导航", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [actionSheet showInView:self.view];
    

}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //0  地图   1  web    2取消
//    switch (buttonIndex) {
//        case 0:  //地图
//        {
//               BOOL CanOpen =  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
//            
//                if (CanOpen)
//                {
//                    DLog(@"装的有导航");
//                    //初始化调启导航时的参数管理类
//                    
//                    BMKNaviPara *para = [[BMKNaviPara alloc]init];
//                    
//                    para.naviType = BMK_NAVI_TYPE_NATIVE;
//                    BMKPlanNode *end = [[BMKPlanNode alloc]init];
//                    end.pt = _buildLocation;
//                    end.name = self.buileding.address;
//                    para.endPoint = end;
//                    para.appScheme = @"moshou://";
//                    [BMKNavigation openBaiduMapNavigation:para];
//                    
//                }else
//                {
//                    DLog(@"没有装导航");
//                    AlertShow(@"您没有安装百度地图,可以使用网页导航~");
//                }
//            
//        }
//            break;
//            
//            case 1: //WEB
//        {
//            BMKNaviPara *para = [[BMKNaviPara alloc]init];
//            para.naviType = BMK_NAVI_TYPE_WEB;
//            
//            BMKPlanNode *start = [[BMKPlanNode alloc]init];
//            start.pt = _myLocation.location.coordinate;
//            start.name = _myAddress;
//            para.startPoint = start;
//            
//            
//            BMKPlanNode *end = [[BMKPlanNode alloc]init];
//            end.pt = _buildLocation;
//            end.name = self.buileding.address;
//            para.endPoint = end;
//            
////            para.appName = [NSString stringWithFormat:@"%@", @"魔售经纪人"];
//            para.appScheme = @"moshou://";
//
//            [BMKNavigation openBaiduMapNavigation:para];
//
//            
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
//    
//    
//}




#pragma mark - Geo搜索
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
//        DLog(@"当前位置信息 %@",result.address);
        _myAddress = result.address;
    }
}


-(void)btnClick:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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












