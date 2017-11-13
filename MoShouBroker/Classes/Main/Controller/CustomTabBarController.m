//
//  CustomTabBarController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomTabBarController.h"
#import "HomePageController.h"
#import "BuildingController.h"
#import "CustomerListViewController.h"
#import "MineController.h"

#import "MSTabBarItemModel.h"
#import "MSTabBar.h"

#import "RecommendRecordController.h"
//#import "LoginViewController.h"
#import "UserData.h"
#import "ChooseCityViewController.h"
#import "MyAlertView.h"

#import "SplashImageView.h"
#import "NSString+Extension.h"
#import "DataFactory+Building.h"
#import "OptionData.h"
//add by xiaotei 2016-2-17
#import "ChangeShopViewController.h"

#import "XTMapBuildingController.h"

#import "XTLogInController.h"
//是否隐藏，默认是NO
#define EyeStatus @"EyeStatus"

@interface CustomTabBarController ()<MSTabBarDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,MyAlertViewDelegate>
{
    BMKGeoCodeSearch * _geoCodeSearch;
    BMKLocationService * _locService;
    CLLocationCoordinate2D _myLocationcoor; //自己的经纬度
    ChooseCityViewController *_chooseCityViewController;
    NSMutableArray * _cityDataArray;
    BOOL _alreadyShow;

}
@property (nonatomic,weak)MSTabBar* msTabBar;



@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCityList];

   
//    初始化tabbar
    [self commonInit];
    

//    [self startSplashView];
}


#pragma mark - MSTabBar初始化
/**
 *  初始化
 */
-(void)commonInit{
    // Do any additional setup after loading the view.
    MSTabBarItemModel* item1 = [self tabBarWithTitle:@"首页" normalImage:@"home-line" selectedImge:@"home-normal" controller:[HomePageController class]];
    MSTabBarItemModel* item2 = [self tabBarWithTitle:@"楼盘" normalImage:@"home-loupan-line" selectedImge:@"home-loupan-normal" controller:[BuildingController class]];
    MSTabBarItemModel* item3 = [MSTabBarItemModel tabBarItemModelWithTitle:@"报备记录" normalImage:@"home-baobei-line" selectedImage:@"home-baobei-normal"];
    MSTabBarItemModel* item4 = [self tabBarWithTitle:@"客户" normalImage:@"home-kehu-line" selectedImge:@"home-kehu-normal" controller:[CustomerListViewController class]];
    MSTabBarItemModel* item5 = [self tabBarWithTitle:@"我的" normalImage:@"home-mine-line" selectedImge:@"home-mine-normal" controller:[MineController class]];
    
    MSTabBar* myTabBar = [[MSTabBar alloc]init];
    _msTabBar = myTabBar;
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    myTabBar.tabBarIetmsArray = @[item1,item2,item3,item4,item5];
    
    myTabBar.frame = CGRectMake(0, kMainScreenHeight - 29 - [UIApplication sharedApplication].statusBarFrame.size.height, kMainScreenWidth, 49);
    [self.view addSubview:myTabBar];
    self.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedHomePageIndex) name:@"SELECTEDHOMEPAGE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedBuildingPageIndex) name:@"SELECTEDBUILDINGPAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];

}

-(MSTabBarItemModel*)tabBarWithTitle:(NSString*)title normalImage:(NSString*)normalImageName selectedImge:(NSString*)selectedImageName controller:(Class)class{
    MSTabBarItemModel* item = [MSTabBarItemModel tabBarItemModelWithTitle:title normalImage:normalImageName selectedImage:selectedImageName];
    
    UIViewController* controller = [[class alloc]init];
    
    [self addChildViewController:controller];
    
    return item;
}




#pragma mark - msTabBar delegate
-(void)didSelectedItem:(UIButton *)item atIndex:(NSInteger)index WithTouchNum:(NSInteger)touchNum{
    if (index == 2) {
//带看扫码
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BBJLTAB" andPageId:@"PAGE_SY"];

        [MobClick event:@"tab_dksm"];
        if ([self isBlankString:[UserData sharedUserData].userInfo.storeName]) {
//            MyAlertView *alert = [[MyAlertView alloc] initWithTitle:nil message:@"绑定门店后功能才可用哦！去绑定门店吧" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"绑门店", nil];
//            
////            alert.delegate = self;
//            alert.tag = 10000;
//            [alert show];
            [TipsView showTips:@"请先绑定门店才能使用功能哦~" inView:self.view];
            return;
        }else{
            RecommendRecordController* baseVC = [[RecommendRecordController alloc]init];
//            baseVC.customTitle = @"带看扫码";
            baseVC.currentIndex = 2;
            [self.navigationController pushViewController:baseVC animated:YES];
            return;
        }
    }else if(index > 2){
        index--;
    }

//    if (self.selectedIndex == index) {
//        return;
//    }
    
    
    if (touchNum == 2) {
        switch (index) {
            case 0:
                [MobClick event:@"tab_shouye"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:nil];
                
                break;
            case 1:
                [MobClick event:@"tab_loupan"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyBuildingList" object:nil];
                
                break;
            case 2:
                [MobClick event:@"tab_kehu"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCustomerListData" object:nil];
                
                break;
            case 3:{
                [MobClick event:@"tab_wode"];
                //检测并更新已下载楼盘数据
                //[[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:nil];
            }
                break;
            default:
                break;
        }
    }else{
        switch (index) {
            case 0:
                [MobClick event:@"tab_shouye"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_SYTAB" andPageId:@"PAGE_SY"];

                
                break;
            case 1:
                [MobClick event:@"tab_loupan"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LPTAB" andPageId:@"PAGE_SY"];

                break;
            case 2:
                [MobClick event:@"tab_kehu"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BBJLTAB" andPageId:@"PAGE_SY"];

                break;
            case 3:{
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WDTAB" andPageId:@"PAGE_SY"];

                [MobClick event:@"tab_wode"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:nil];

            }
                break;
            default:
                break;
        }
    }
    
   
    [self setSelectedIndex:index];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    self.navigationController.navigationBarHidden=YES;
    self.tabBar.hidden=YES;
    [self judgeLogin];
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
//    if([UserData sharedUserData].storeName.length <= 0){
//        [self startLocation];
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    
//    [self startLocation];

    CGRect newStatusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (newStatusBarFrame.size.height==20) {
        self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        _msTabBar.frame = CGRectMake(0, kMainScreenHeight - 49, kMainScreenWidth, 49);
    }
    else if(newStatusBarFrame.size.height==40)
    {
        self.view.frame = CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight-20);
        _msTabBar.frame = CGRectMake(0, kMainScreenHeight - 69, kMainScreenWidth, 49);
    }

}


-(void)getCityList
{
    _cityDataArray = [NSMutableArray array];
    [[DataFactory sharedDataFactory] getCityListWithCallBack:^(NSArray *indexArray, NSArray *dataArray) {
        
        if (dataArray)
        {
            for (InitialData *data in dataArray)
            {
                for (OptionData *listData in data.dataList) {
                    
                    [_cityDataArray appendObject:listData];
                    
                }
            }
           
            [self startLocation];

        }else{
            [self startLocation];

        }
    }];
}


#pragma mark - 判定是否登录，决定是否弹出登陆页
-(void)judgeLogin
{
    if (![UserData sharedUserData].isUserLogined)
    {
        XTLogInController *loginViewController=[[XTLogInController alloc]init];
        
        [self.navigationController pushViewController:loginViewController animated:NO];
//        [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
    }
}



-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


/**
 重新登录 刷新所有页面
 */
-(void)selectedHomePageIndex{
    
    [self.msTabBar setSelectedIndex:0];
    [MobClick event:@"tab_shouye"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCustomer" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:@"0"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyBuildingList" object:nil];
//    初始化我的财富页
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:EyeStatus];
//    NSString* str = [UserData sharedUserData].storeName;
//    if([UserData sharedUserData].storeName.length <= 0){
//            [self startLocation];
//        
//    }
    
}

- (void)selectedBuildingPageIndex{
    [self.msTabBar setSelectedIndex:1];
}

-(void)startLocation
{
//    [BMKLocationService desiredAccuracy];
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//    [BMKLocationService setLocationDistanceFilter:1.f];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy =kCLLocationAccuracyBest;

    [_locService startUserLocationService];
}
-(void)startGeoCodeSearch
{
    if (_geoCodeSearch == nil)
    {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        
    }
    _geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reGeoOptin = [[BMKReverseGeoCodeOption alloc]init];
    reGeoOptin.reverseGeoPoint = _myLocationcoor;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reGeoOptin];
    if(flag)
    {
//        DLog(@"反geo检索发送成功");
    }
    else
    {
//        DLog(@"反geo检索发送失败");
        
    }
    
}


#pragma mark - BMKLocationServiceDelegate

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    UserData *userData = [UserData sharedUserData];
    userData.userLocation = userLocation;
    
    userData.latitude = [NSString stringWithFormat:@"%.14f",userLocation.location.coordinate.latitude];
    userData.longitude = [NSString stringWithFormat:@"%.14f",userLocation.location.coordinate.longitude];;
    _myLocationcoor = userLocation.location.coordinate;
    
    NSString* selectLo = [UserData sharedUserData].selectedLongitude;
    NSString* selectLa = [UserData sharedUserData].selectedLatitude;
    if (selectLo.length <= 0 || selectLa.length <= 0) {
        [UserData sharedUserData].selectedLatitude = [NSString stringWithFormat:@"%.14f",userLocation.location.coordinate.latitude];
        [UserData sharedUserData].selectedLongitude = [NSString stringWithFormat:@"%.14f",userLocation.location.coordinate.longitude];;
    }
    
    [self startGeoCodeSearch];
    
}

//接收和处理热点连接状态栏的变化消息事件
- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
    //    CGRect newStatusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect newStatusBarFrame = [(NSValue*)[notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    
    if (newStatusBarFrame.size.height==20) {
        self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        _msTabBar.frame = CGRectMake(0, kMainScreenHeight - 49, kMainScreenWidth, 49);
    }
    else if(newStatusBarFrame.size.height==40)
    {
        self.view.frame = CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight-20);
        _msTabBar.frame = CGRectMake(0, kMainScreenHeight - 69, kMainScreenWidth, 49);
    }
 
    
}

-(void)didFailToLocateUserWithError:(NSError *)error
{
    
    DLog(@"Error 定位失败  %@",error);
    _chooseCityViewController = nil;
//    [UserData sharedUserData].locationCityName = nil;
    if ([self isBlankString:[UserData sharedUserData].cityName])
    {
        if (![self verifyTheRulesWithShouldJump])
        {
            
            [self pushChooseCityViewController];
        }
    }
    
}

#pragma mark - Geo搜索
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //    /// 街道号码
    //    @property (nonatomic, strong) NSString* streetNumber;
    //    /// 街道名称
    //    @property (nonatomic, strong) NSString* streetName;
    //    /// 区县名称
    //    @property (nonatomic, strong) NSString* district;
    //    /// 城市名称
    //    @property (nonatomic, strong) NSString* city;
    //    /// 省份名称
    //    @property (nonatomic, strong) NSString* province;
    if (error == BMK_SEARCH_NO_ERROR)
    {
//        DLog(@"当前位置信息 %@  %@  %@ ",result.address,result.addressDetail.city,result.addressDetail.province);
        
        //这里两个地方  主要注意  等以后完善绑定门店权限侯区分
        [UserData sharedUserData].locationCityName = result.addressDetail.city;

//
        if ([UserData sharedUserData].isUserLogined && ![self verifyTheRulesWithShouldJump] && [UserData sharedUserData].chooseCityId.length== 0)
        {
            if(_cityDataArray.count>0)
            {
                [UserData sharedUserData].chooseCityId = [self getCityIdFromeGeoResultCityName:result.addressDetail.city];
                [UserData sharedUserData].chooseCityName = result.addressDetail.city;
                if ([UserData sharedUserData].chooseCityId.length>0) {
                    if (_chooseCityViewController)
                    {
                        [_chooseCityViewController dismissViewControllerAnimated:YES completion:^{
                        }];
                        _chooseCityViewController = nil;
                    }
                    //刷新首页
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:nil];
                    //刷新楼盘列表页数据
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyBuildingList" object:nil];
                    //刷新闪屏数据
                    [[DataFactory sharedDataFactory] performSelectorInBackground:@selector(downloadSplashsData) withObject:nil];

                    return;
                }else{
                    
                    UIAlertView *alertView = nil;
                    
                    if (!alertView && !_alreadyShow) {
                        alertView  = [[UIAlertView alloc]initWithTitle:@"" message:@"您当前定位的城市暂未开通魔售，请选择已开通功能城市" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        [alertView show];
                        _alreadyShow = YES;
                    }
                }
            }
            
            //如果遍历不出来就 弹出城市选择页面来搞定  防止多次调用

            [self pushChooseCityViewController];
            DLog(@"[UserData sharedUserData].cityId=====%@",[UserData sharedUserData].chooseCityId);
        }
    }
}


-(NSString *)getCityIdFromeGeoResultCityName:(NSString *)cityName;
{
    NSString *cityId;
    NSString *newCityName = cityName;       //[NSString DeleteStringFromeCityNameString:cityName];
    if (_cityDataArray) {
        
        for (OptionData *data in _cityDataArray) {
            
            if ([data.itemName isEqualToString:newCityName]) {
                cityId = data.itemValue;
                return cityId;
                
            }
        }
        
    }
    
    return @"";
}


#pragma mark - myalartViewDelegate
- (void)myAlertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (alertView.tag == 10000)
        {
            switch (buttonIndex) {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    ChangeShopViewController *VC = [[ChangeShopViewController alloc]init];
//                    VC.jumpType = 3;
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
}

#pragma mark - 弹出城市选择页
-(void)pushChooseCityViewController
{
    if ([UserData sharedUserData].chooseCityId.length==0 &&[UserData sharedUserData].isUserLogined && !_chooseCityViewController)
    {
        _chooseCityViewController=[[ChooseCityViewController alloc]init];
        _chooseCityViewController.hiddenLeftButton = YES;
        
        [self presentViewController:_chooseCityViewController animated:NO completion:^{
        }];
    }
}

- (BOOL)verifyTheRulesWithShouldJump
{
    
    UserData *user = [UserData sharedUserData];
    if ([self isBlankString:user.userInfo.storeId])
    {
        //如果门店为空
    
            return NO;
    }else
    {
        //有门店
        return YES;
    }
    return NO;
    
}
- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
