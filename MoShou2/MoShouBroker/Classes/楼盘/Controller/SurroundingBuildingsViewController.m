//
//  SurroundingBuildingsViewController.m
//  MoShouBroker
//
//  Created by caotianyuan on 15/6/15.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//
/*
 创建人：曹天元
 创建时间：2015.6.15
 用途描述:用来实现周边楼盘这个页面
 */

#import "SurroundingBuildingsViewController.h"
#import "AppDelegate.h"
#import "Building.h"
#import "UserData.h"
#import "MyImageView.h"
#import "TipsView.h"
#import <MapKit/MapKit.h>
#import "DataFactory+Building.h"
#import "BuildingsResult.h"
#import "UserData.h"
#import "CLLocation+YCLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "BuildingDetailViewController.h"
#import "Tool.h"
#import "BuildingDetailViewController.h"

#import "AllBuildingPointAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
@interface SurroundingBuildingsViewController ()<BMKMapViewDelegate>
{
    
    BMKMapView *_mapView;
    
    AllBuildingPointAnnotation *_allBuildAnnotation;
    
    
    BMKAnnotationView *_surroundBuildAnnotationView;
    
    UIButton *_customdAnnotationButton1;

    NSArray *_dataArray;

}

//@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) BMKMapView *mapView;
//@property (nonatomic,strong) AllBuildingPointAnnotation *allBuildAnnotation;   //标注  经纬度   building
//@property (nonatomic,strong) BMKAnnotationView *surroundBuildAnnotationView;
//@property (nonatomic,strong)  UIButton *customdAnnotationButton1;
//
//@property (nonatomic,strong) NSArray *dataArray;


//@property (nonatomic,assign) NSInteger indexArray;
//@property (nonatomic,assign) NSInteger buttonTag;
//@property (nonatomic,assign) NSInteger selectHouses;

@end

@implementation SurroundingBuildingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

        self.navigationBar.hidden = YES;
        [self createBaiduMapView];
        [self addBackBtn];
        [self loadData];
    
}
-(void)addBackBtn
{
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 20, 43, 43);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"地图返回底.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"地图返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}

-(void)loadData
{
//    UIImageView *loadingView = [self setRotationAnimationWithView];
//
//    [[DataFactory sharedDataFactory] getAllBuildingsWithCallBack:^(DataListResult *result) {
//        [self removeRotationAnimationView:loadingView];
//
//        if (result) {
//
//            _dataArray = result.dataArray;
//            [self addPointAnnotation];
//        }else{
//        }
//        
//    }];
    
    
    
}
#pragma mark - 添加地图周边楼盘标注
-(void)addPointAnnotation
{
        [self setMapCenter];
    
        if (_dataArray.count>0)
        {
            for (int i=0; i<_dataArray.count; i++)
            {
                AllBuildingPointAnnotation *allBuildingPointAnnotation=[[AllBuildingPointAnnotation alloc]init];
                BuildingListData *build = _dataArray[i];
                double latitudeInt=[build.saleLatitude doubleValue];
                double longitudeInt=[build.saleLongitude doubleValue];
                CLLocationCoordinate2D coor;
                coor.latitude =latitudeInt;
                coor.longitude =longitudeInt;
                allBuildingPointAnnotation.building = build;
                allBuildingPointAnnotation.coordinate = coor;
                
                [_mapView addAnnotation:allBuildingPointAnnotation];
                
            }

        }
}


-(void)setMapCenter;
{
    
    //设置地图中心位置
    if (self.firstBuildingData.saleLongitude ==nil && self.firstBuildingData.saleLatitude ==nil)
    {
        for (BuildingListData *buildData in _dataArray) {
            
            if (buildData.saleLatitude.length>0 && buildData.saleLongitude.length>0) {
                DLog(@"buildData.saleLatitude====%@",buildData.saleLatitude);

                CLLocationCoordinate2D coor;
                coor.latitude =[buildData.saleLatitude doubleValue];
                coor.longitude =[buildData.saleLongitude doubleValue];
                [_mapView setCenterCoordinate:coor animated:YES];
                break;
                
            }
            
        }

        
    }
    
}


-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AllBuildingPointAnnotation class]])
    {
        AllBuildingPointAnnotation *allannotation = (AllBuildingPointAnnotation*)annotation;
        
//        NSString *customAnnotationViewID = @"CustomAnnotationViewID";
//        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationViewID];
//        if (annotationView==nil)
//        {
//            annotationView = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customAnnotationViewID];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//            label.text = allannotation.building.name;
//            label.backgroundColor = BLUEBTBCOLOR;
//            
//             annotationView.image=[self getImageFromView:label];
//            
//        }
//        
//        return annotationView;
        
        
                NSString *customAnnotationViewID = @"CustomAnnotationViewID";
        
        _surroundBuildAnnotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationViewID];
        if (_surroundBuildAnnotationView== nil)
        {
             _surroundBuildAnnotationView= [[BMKAnnotationView alloc] initWithAnnotation:allannotation reuseIdentifier:@"myAnnotation"];
        }
       
//        _surroundBuildAnnotationView.image=[UIImage imageNamed:@"XXXX"];
        _surroundBuildAnnotationView.annotation=allannotation;
        _surroundBuildAnnotationView.frame=CGRectMake(0, 0, 193.0/2, 40);
        
        _customdAnnotationButton1=[UIButton buttonWithType:UIButtonTypeCustom];
        _customdAnnotationButton1.frame=CGRectMake(0, 0, 193.0/2, 20);
        _customdAnnotationButton1.backgroundColor=BLUEBTBCOLOR;
        _customdAnnotationButton1.alpha = 0.8;
        _customdAnnotationButton1.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:30];
        _customdAnnotationButton1.layer.cornerRadius=5;
        _customdAnnotationButton1.clearsContextBeforeDrawing=UITextFieldViewModeAlways;
        [_customdAnnotationButton1 setTitle:allannotation.building.name forState:UIControlStateNormal];
            
        _customdAnnotationButton1.titleLabel.font=[UIFont systemFontOfSize:12];
        [_customdAnnotationButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_customdAnnotationButton1 addTarget:self action:@selector(customdAnnotationViewTapClick:) forControlEvents:UIControlEventTouchUpInside];
        _customdAnnotationButton1.titleEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 0);
        _customdAnnotationButton1.tag=[allannotation.building.buildingId integerValue];
        [_surroundBuildAnnotationView addSubview:_customdAnnotationButton1];
        
        return _surroundBuildAnnotationView;
        }

    return nil;
}

-(void)customdAnnotationViewTapClick:(UIButton *)sender
{
        BuildingDetailViewController *VC=[[BuildingDetailViewController alloc]init];
        VC.buildingId=[NSString stringWithFormat:@"%zd",sender.tag];
        [self.navigationController pushViewController:VC animated:YES];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{


    
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
//    NSLog(@"paopaoclick");
}

#pragma mark - 创建地图
-(void)createBaiduMapView
{
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, kMainScreenHeight-20)];
    //设置地图缩放等级
    [_mapView setZoomLevel:12];
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];

    [_mapView updateLocationData:[UserData sharedUserData].userLocation];
    
    //设置地图中心位置
    if (self.firstBuildingData.saleLongitude!=nil && self.firstBuildingData.saleLatitude !=nil)
    {
        double latitudeInt=[self.firstBuildingData.saleLatitude doubleValue];
        double longitudeInt=[self.firstBuildingData. saleLongitude doubleValue];
        CLLocationCoordinate2D coor;
        coor.latitude =latitudeInt;
        coor.longitude =longitudeInt;
        [_mapView setCenterCoordinate:coor animated:YES];
    }
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    _mapView.delegate=self;

    self.popGestureRecognizerEnable = NO;

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;

}

-(void)btnClick:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
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
