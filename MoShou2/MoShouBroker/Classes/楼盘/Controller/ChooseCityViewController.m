//
//  ChooseCityViewController.m
//  MoShouBroker
//
//  Created by caotianyuan on 15/7/9.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "UserData.h"
#import "BuildingsResult.h"
#import "DataFactory+Building.h"
#import "UserData.h"
#import "InitialData.h"
#import "OptionData.h"
#import "ChineseToPinyin.h"
#import "NSString+Extension.h"
@interface ChooseCityViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UITableView *_tableView;
    UIView *_titleView;
    UILabel *_sectionLabel;
    
    UITextField * _searchBarTextField;
     BMKLocationService * _locService;
    BMKGeoCodeSearch * _geoCodeSearch;
    CLLocationCoordinate2D _myLocationcoor; //自己的经纬度
    
    NSMutableArray * _cityDataArray;
    
    BOOL _isSearching;  //是否在搜索中


}

@property(nonatomic,strong)NSMutableArray* cityList;  //所有的数据
//@property(nonatomic,strong)NSArray* indexArray;   //去头的索引

@property(nonatomic,strong)NSMutableArray *tempCityList;
//@property(nonatomic,strong)NSMutableArray *tempIndexarray;


@end

@implementation ChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"选择城市";
    self.view.backgroundColor =UIColorFromRGB(0xdddddd);
    [self addSearchView];
    
    [self createTableView];
    
    [self getCityListData];
    
    _cityDataArray = [NSMutableArray array];

    self.navigationBar.leftBarButton.hidden = _hiddenLeftButton;
}

-(void)addSearchView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 64+8, kMainScreenWidth-8-8, 44-16)];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImageView *searchIconView = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.left+5, (bgView.height-14)/2, 14, 14)];
    searchIconView.image = [UIImage imageNamed:@"icon_search"];
    [bgView addSubview:searchIconView];
    
    _searchBarTextField = [[UITextField alloc]initWithFrame:CGRectMake(searchIconView.right+5, 0, bgView.width-14-bgView.left-5, bgView.height)];
    _searchBarTextField.delegate = self;
    _searchBarTextField.returnKeyType = UIReturnKeySearch;
    _searchBarTextField.placeholder = @"城市名,拼音首字母";
    _searchBarTextField.font = FONT(14.f);
    [_searchBarTextField setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
//    [_searchBarTextField setValue:FONT(10.f) forKeyPath:@"_placeholderLabel.font"];
    _searchBarTextField.textColor = NAVIGATIONTITLE;
    [_searchBarTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];

    _searchBarTextField.textAlignment = NSTextAlignmentLeft;
    _searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [bgView addSubview:_searchBarTextField];

}

#pragma mark- 解析数据
-(void)getCityListData
{
    DataFactory *buildResult=[DataFactory sharedDataFactory];

    [buildResult getCityListWithCallBack:^( NSArray*initialArray,NSArray *cityArray)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             self.cityList = [NSMutableArray arrayWithArray:cityArray];
             self.tempCityList = [NSMutableArray arrayWithArray:cityArray];
             
             for (InitialData *data in cityArray)
             {
                 for (OptionData *listData in data.dataList) {
                     
                     [_cityDataArray appendObject:listData];
                 }
             }
             
             //如果第一次进来  接口问题  没有城市 就暂时显示返回按钮  
             if (self.cityList.count==0 && self.tempCityList.count==0) {
                 self.navigationBar.leftBarButton.hidden = NO;
                 
             }
             
             
             [_tableView reloadData];
         });
    }];

}

#pragma mark - 创建tableView
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kMainScreenWidth, kMainScreenHeight-64-44) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tempCityList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    InitialData* initail = [self.tempCityList objectForIndex:section];
    return initail.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
//    if (cell==nil)
//    {
        UITableViewCell*cell =[ [UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.backgroundColor=[UIColor clearColor];
        
        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(12.0/320*kMainScreenWidth, 15, 100.0/320*kMainScreenWidth, 15)];
        textLabel.font=[UIFont systemFontOfSize:16];
        textLabel.textColor=UIColorFromRGB(0x717171);
        textLabel.tag=100;
        [cell.contentView addSubview:textLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.5,40, kMainScreenWidth, 1)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"d9d9db"];
        [cell.contentView addSubview:lineLabel];
//    }
    if (self.tempCityList.count>indexPath.section)
    {
        InitialData* initail = [self.tempCityList objectForIndex:indexPath.section];
        UILabel *textLabel=(UILabel *)[cell.contentView viewWithTag:100];
        if (initail.dataList.count>indexPath.row)
        {
            OptionData*city =  [initail.dataList objectForIndex:indexPath.row];
             textLabel.text= city.itemName;
        }
    }
    return cell;
}

//将选中的城市名和id传到userData中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserData *userData=[UserData sharedUserData];
    InitialData* initial = [self.tempCityList objectForIndex:indexPath.section];
    OptionData* city = [initial.dataList objectForIndex:indexPath.row];
   
    if (self.NotShouldWriteToPlist) {
//        不存入本地 block返回
        self.getChooseCityNameAndId(city.itemName,city.itemValue,city.longitude,city.latitude);
     
        [self dismissViewControllerAnimated:YES completion:nil];

        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadXTMapBuildingController" object:nil];

    }else{
        
        userData.chooseCityName= city.itemName;
        userData.chooseCityId=city.itemValue;
        [UserData sharedUserData].selectedLongitude = city.longitude;
        [UserData sharedUserData].selectedLatitude  = city.latitude;
        [self dismissViewControllerAnimated:YES completion:nil];
 
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadAllBuildingListVC" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:nil];

        
        
    }
   

    NSLog(@"&&&&&&  %@",userData.cityName);
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self verifyTheRulesWithShouldJump:NO]) {
       
        /**
         绑定过门店的
         */
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
        headView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        UILabel *sectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, 20, 20)];
        sectionLabel.textColor=UIColorFromRGB(0X000000);
        sectionLabel.font=[UIFont systemFontOfSize:14];
        sectionLabel.textAlignment=NSTextAlignmentLeft;
        //        sectionLabel.text=self.tempIndexarray[section];
        InitialData *data =self.tempCityList[section];
        sectionLabel.text =data.initial;
        [headView addSubview:sectionLabel];
        
        return headView;

        
    }else{
        
        if (section==0)
        {
            UIView *dingWeiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
    
            UIImageView *dingweiImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, (60-25)/2, 25, 25)];
            dingweiImage.image =[UIImage imageNamed:@"iconfont-dingwei.png"];
            [dingWeiView addSubview:dingweiImage];
    
            UILabel *dingWeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(25+16+10, 0, kMainScreenWidth-25-16, 60)];
            dingWeiLabel.font =FONT(17.f);
            dingWeiLabel.tag = 9701;
            dingWeiLabel.textAlignment = NSTextAlignmentLeft;
            dingWeiLabel.textColor =UIColorFromRGB(0x333333);
            if ([UserData sharedUserData].locationCityName.length>0) {
                dingWeiLabel.text =[UserData sharedUserData].locationCityName;
            }else{
                dingWeiLabel.text = @"定位至当前位置" ;
            }
            [dingWeiView addSubview:dingWeiLabel];
    
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
            [button addTarget:self action:@selector(dingweiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [dingWeiView addSubview:button];
    
            UIView *ziMuView = [[UIView alloc]initWithFrame:CGRectMake(0, button.bottom, kMainScreenWidth, 20)];
            ziMuView.backgroundColor = UIColorFromRGB(0xf7f7f7);
            [dingWeiView addSubview:ziMuView];
    
    
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 50, 20)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = FONT(14.f);
            InitialData* initial = [self.tempCityList objectForIndex:section];
            label.text=initial.initial;
            [ziMuView addSubview:label];
    
            return dingWeiView;
        }
        else
        {
            UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
            headView.backgroundColor = UIColorFromRGB(0xf7f7f7);
            UILabel *sectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, 20, 20)];
            sectionLabel.textColor=UIColorFromRGB(0X000000);
            sectionLabel.font=[UIFont systemFontOfSize:14];
            sectionLabel.textAlignment=NSTextAlignmentLeft;
    //        sectionLabel.text=self.tempIndexarray[section];
            InitialData *data =self.tempCityList[section];
            sectionLabel.text =data.initial;
            [headView addSubview:sectionLabel];
            
            return headView;
        }
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if ([self verifyTheRulesWithShouldJump:NO]) {
            return 20;

        }else{
            return 80;

        }
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
//键盘搜索点击
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchBarTextField resignFirstResponder];
    
}

-(void)dingweiBtnClick:(UIButton *)sender
{
    UILabel *dingweiLabel = (UILabel *)[self.view viewWithTag:9701];
    if ([dingweiLabel.text isEqualToString: @"定位至当前位置"])
    {
        [self startLocation];
    }else{
        
            UserData *userData=[UserData sharedUserData];
            userData.chooseCityName= dingweiLabel.text;
            userData.chooseCityId = [self getCityIdFromeGeoResultCityName:dingweiLabel.text];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyBuildingList" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadHomePage" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadXTMapBuildingController" object:nil];

            [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
}
-(void)startLocation
{
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy =kCLLocationAccuracyNearestTenMeters;
    _locService.delegate = self;
    [_locService startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate

-(void) didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    UserData *userData = [UserData sharedUserData];
    userData.userLocation = userLocation;
    _myLocationcoor = userLocation.location.coordinate;
    
    [self startGeoCodeSearch];
    
}
-(void)didFailToLocateUserWithError:(NSError *)error
{
    
    DLog(@"Error 定位失败  %@",error);
    AlertShow(@"定位失败,请您检查下APP 定位权限是否打开");
    
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
        DLog(@"反geo检索发送成功");

    }
    else
    {
        DLog(@"反geo检索发送失败");
        
    }
    
}

#pragma mark - Geo搜索
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        DLog(@"当前位置信息 %@  %@  %@ ",result.address,result.addressDetail.city,result.addressDetail.province);
        [UserData sharedUserData].locationCityName = result.addressDetail.city;
        
        UILabel *dingweiLebel =(UILabel *)[self.view viewWithTag:9701];
        dingweiLebel.text =result.addressDetail.city;
       
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}


#pragma mark -  UITextField

-(void)textFieldDidChanged:(UITextField *)textField;
{
//    @interface InitialData : NSObject
//    
//    @property (nonatomic,strong) NSString* initial;//大写首字母
//    @property (nonatomic,strong) NSArray* dataList;//数组元素OptionData

    
//    @property(nonatomic,copy) NSString* itemValue;//编号
//    @property(nonatomic,copy) NSString* itemName;//名称
//    
//    @property(nonatomic,assign) BOOL isSelect;//是否选中
    DLog(@"textField.text=====%@",textField.text);
    
    if (![textField.text isEqualToString:@""])
    {
        if (self.tempCityList.count>0) {
            [self.tempCityList removeAllObjects];
        }

        DLog(@"self.cityList.count===%zd",self.cityList.count);
        
         for (InitialData *data in self.cityList) {
             
            if ([self isChinese:[textField.text substringToIndex:1]]) //中文
            {
                InitialData *tempInitialData = [[InitialData alloc]init];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (OptionData *optionData in data.dataList)
                {
                    NSRange range1=[[optionData.itemName uppercaseString] rangeOfString:textField.text];
                    if (range1.location!=NSNotFound)
                    {
                        tempInitialData.initial = data.initial;
                        OptionData *tempOptionData = [[OptionData alloc]init];
                        tempOptionData.itemName =  optionData.itemName;
                        tempOptionData.itemValue = optionData.itemValue;
                        [tempArr appendObject:tempOptionData];
                        tempInitialData.dataList = tempArr;
                    }

                }
                if (tempInitialData.dataList.count>0) {
                    [_tempCityList appendObject:tempInitialData];
   
                }

                [_tableView reloadData];
            }//英文  拼音搜索
            else{
                    InitialData *tempInitialData = [[InitialData alloc]init];
                    NSMutableArray *tempArr = [NSMutableArray array];
                
                for (OptionData *optionData1 in data.dataList)
                {
                    DLog(@"%@",[textField.text uppercaseString]);
                    DLog(@"%@",[ChineseToPinyin pinyinFromChiniseString:optionData1.itemName]);
                    
                    NSRange range1=[[ChineseToPinyin pinyinFromChiniseString:optionData1.itemName]rangeOfString:[textField.text uppercaseString]];
                    if (range1.location!=NSNotFound)
                    {
                        tempInitialData.initial = data.initial;

                        OptionData *tempOptionData = [[OptionData alloc]init];
                        tempOptionData.itemName =  optionData1.itemName;
                        tempOptionData.itemValue = optionData1.itemValue;
                        [tempArr appendObject:tempOptionData];
                        tempInitialData.dataList = tempArr;
                        DLog(@"tempInitialData.initial===%@   %@",tempInitialData.initial,  tempOptionData.itemName);
                    
                    }

                }
                if (tempInitialData.dataList.count>0) {
                    [_tempCityList appendObject:tempInitialData];
                    
                }
                  [_tableView reloadData];
                
            }
    }
        
    }else{
        
        [self getCityListData];
    }
    
    
}



-(BOOL)isChinese:(NSString*)c{
//    int strlength = 0;
//    char* p = (char*)[c cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i=0 ; i<[c lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        }
//        else {
//            p++;
//        }
//    }
//    return ((strlength/2)==1)?YES:NO;
    int length = [c length];
    
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [c substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            NSLog(@"汉字:%s", cString);
        }else
        {
            return NO;
        }
    }
    return YES;
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





- (void)leftBarButtonItemClick;
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
