//
//  PeripheralLocationView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "Estate.h"
#import "PeripheralLocationView.h"
#import "XTMapBuildPointAnnotation.h"
#import "XTMapBuildInfoModel.h"
#import "XTMapBuildView.h"
@interface PeripheralLocationView ()<BMKMapViewDelegate>
{
    Building *_building;
    BMKMapView *_mapView;

    Estate * _estateBuildingMo;
    BMKPointAnnotation *_buildingPointAnnotation;
    CLLocationCoordinate2D _buildLocation;  //楼盘坐标经纬度

    
}
@end


@implementation PeripheralLocationView

-(id)initWithBuilding:(Building *)building;
{
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 255)];
    if (self) {
        
        _building = building;
    
        _estateBuildingMo = _building.estate;
        [self loadUI];
    
    }
    
    return self;
}


-(void)loadUI
{
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 45)];
    titlelabel.text = @"位置及周边";
    titlelabel.textAlignment = NSTextAlignmentLeft;
    titlelabel.textColor = UIColorFromRGB(0x888888);
    titlelabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self addSubview:titlelabel];
    
//    UIButton *arrowImage = [[UIButton alloc]init];
//    [arrowImage setImage:[UIImage imageNamed:@"iconfont-yeguoditu-lan.png"] forState:UIControlStateNormal];
//    [arrowImage setImage:[UIImage imageNamed:@"iconfont-yeguoditu-lan.png"] forState:UIControlStateSelected];
//    arrowImage.frame = CGRectMake(titlelabel.left, titlelabel.bottom+10, 20, 10);
//    [self addSubview:arrowImage];
    
//    UILabel *locationLabel = [[UILabel alloc]init];
////    WithFrame:CGRectMake(arrowImage.right, arrowImage.top-5, kMainScreenWidth-arrowImage.right-20, 20)];
//    locationLabel.textColor = UIColorFromRGB(0x8e8d93);
//    locationLabel.text = _estateBuildingMo.address;
//    locationLabel.numberOfLines= 0;
//    locationLabel.font = FONT(14.f);
//    CGSize size =   [locationLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-arrowImage.right-20, 0)];
//    locationLabel.frame = CGRectMake(arrowImage.right, arrowImage.top-5, size.width, size.height);
//    [self addSubview:locationLabel];
    
    UIButton *rightArrow = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-37 , 0, 45, 45)];
    [rightArrow setImage:[UIImage imageNamed:@"点击三角.png"] forState:UIControlStateNormal];
    [rightArrow setImage:[UIImage imageNamed:@"点击三角.png"] forState:UIControlStateSelected];
  
    [self addSubview:rightArrow];
    
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, titlelabel.bottom, kMainScreenWidth, 200)];
    }
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 13;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    _mapView.userInteractionEnabled = NO;
    CLLocationCoordinate2D coor;
    coor.latitude =[_estateBuildingMo.latitude doubleValue];
    coor.longitude =[_estateBuildingMo.longitude doubleValue];
    
    [_mapView setCenterCoordinate:coor animated:YES];
//    UIImage *mapImage = [_mapView takeSnapshot];
//    UIImageView *mapImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(16, locationLabel.bottom+10, kMainScreenWidth-16-16, 150)];
//    mapImageView.image = mapImage;
    
    [self addSubview:_mapView];
    
    [self addBuildingPointAnnotation];
    
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


-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isEqual:_buildingPointAnnotation]) {
        
        NSString* buildPointAnnotationID = @"BuildPointAnnotation";
        
        XTMapBuildInfoModel *infoModel = [[XTMapBuildInfoModel alloc]init];
        infoModel.name = _estateBuildingMo.name;
        
        XTMapBuildView* annoView = [[XTMapBuildView alloc] initWithAnnotation:annotation reuseIdentifier:buildPointAnnotationID];
       
        annoView.userInteractionEnabled = YES;
        annoView.infoModel = infoModel;
        return annoView;

        
    }
    
    return nil;
    
    
    
    
}



@end
