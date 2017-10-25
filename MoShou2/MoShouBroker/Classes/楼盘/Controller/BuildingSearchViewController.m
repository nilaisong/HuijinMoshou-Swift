//
//  BuildingSearchViewController.m
//  MoShou2
//
//  Created by Mac on 2016/11/30.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BuildingSearchViewController.h"
#import "SelectionView.h"
#import "SearchTableView.h"
#import "UserData.h"
#import "DataFactory+Building.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "BuildingListData.h"
#import "BuildingCell.h"
#import "BuildingDetailViewController.h"

typedef NS_ENUM(NSInteger, ViewControllerStyle)
{
    NormalViewControllerStyle,    //默认状态
    SerachViewControllerStyle,   //搜索状态
    NoDataViewControllerStyle,  //搜索无数据状态
};

@interface BuildingSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SelectionViewDelegate,SearchTableViewDeleagate>

@property (nonatomic,strong)UIView *searchView;

@property (nonatomic,strong)UITextField *searchTF;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)SelectionView *seleView;

@property (nonatomic,strong)SearchTableView *lenovoTableView;  //联想tableView
@property (nonatomic,assign)NSInteger  page;

@property (nonatomic,  copy)NSString *keyword;
@property (nonatomic,strong)NSMutableArray *tempArr;  //楼盘咱暂存数据 楼盘初始化的数据和楼盘列表的数据都放在这里
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




@end

@implementation BuildingSearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.view.backgroundColor = [UIColor whiteColor];

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_seleView setTableViewCloseAndNomalStyle];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempArr = [NSMutableArray array];
    [self loadUI];

}

-(void)loadUI{
   
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.barBackgroundImageView.backgroundColor = BACKGROUNDCOLOR;
//    self.navigationBar.leftBarButton setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    
    UIButton *canCelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-44-10, 20, 44, 44)];
    [canCelBtn setTitle:@"取消" forState:UIControlStateNormal];
    canCelBtn.titleLabel.font = FONT(15.f);
    [canCelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canCelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.navigationBar addSubview:canCelBtn];
    [self searchView];
//    [self tableView];
    
    [self seleView];
    
    [self lenovoTableView];
    
    [self.searchTF becomeFirstResponder];
}
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    
}
- (void)leftBarButtonItemClick;
{
    [_seleView setTableViewCloseAndNomalStyle];

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getter

-(UIView *)searchView;
{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(self.navigationBar.leftBarButton.right+10, 54/2, kMainScreenWidth-(self.navigationBar.leftBarButton.right+10+10)-44-10, 30)];
        _searchView.backgroundColor = UIColorFromRGB(0xe3e3e3);
        _searchView.layer.cornerRadius = 5;
        _searchView.layer.masksToBounds = YES;
        [self.navigationBar addSubview:_searchView];
        
        UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (30-13)/2, 13, 13)];
        searchIconImageView.image = [UIImage imageNamed:@"搜索页放大镜"];
        [_searchView addSubview:searchIconImageView];
        [_searchView addSubview:self.searchTF];
    }
    return _searchView;
}


-(UITextField *)searchTF
{
    
    if (!_searchTF) {
        
        if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, kMainScreenWidth-44-44-20, 30)];
        _searchTF.placeholder = @"请输入楼盘名称";
        _searchTF.font = FONT(14.f);
//        _searchTF.backgroundColor = [UIColor redColor];
        _searchTF.textAlignment = NSTextAlignmentLeft;
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.delegate = self;
        [_searchTF addTarget:self action:@selector(searchTextEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        _searchTF.returnKeyType = UIReturnKeySearch;
            
    }
            }
    return _searchTF;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+74/2, kMainScreenWidth, kMainScreenHeight-64-74/2) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0xefeff4)];
        [self setHeaderPullRefresh:YES FooderPushRefresh:YES];
        [self.view addSubview:_tableView];

    }
    
    return _tableView;
    
}

-(SelectionView *)seleView
{
    if (!_seleView) {
        _seleView = [[SelectionView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 74/2) WithBuildingsResult:self.cityFirstResult WithIsMapSeleView:NO];
        _seleView.delegate =self;
        
        [self.view addSubview:_seleView];
        
    }
    return _seleView;
}

- (SearchTableView *)lenovoTableView
{
    if (!_lenovoTableView) {
        _lenovoTableView = [[SearchTableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        _lenovoTableView.delegate = self;
        if (self.cityId.length>0) {
            _lenovoTableView.dataArray = self.buildingNameArray;
        }else{
            _lenovoTableView.dataArray = [UserData sharedUserData].hotBuildingNameArray;

        }
        _lenovoTableView.isHotRecommendBuildingName = YES;
        [self.view addSubview:_lenovoTableView];
        [self.view bringSubviewToFront:_lenovoTableView];
    }
    
    return _lenovoTableView;
    
}

-(UIView *)getTotalAllBuildingNumberLabel
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * totalAllBuildingNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,0, kMainScreenWidth-40, 25)];
    totalAllBuildingNumberLabel.textAlignment = NSTextAlignmentLeft;
    totalAllBuildingNumberLabel.font = FONT(12.f);
    totalAllBuildingNumberLabel.textColor = LABELCOLOR;
    if (_buildingNumber==0 || _buildingNumber == NULL || _buildingNumber == nil) {
        _buildingNumber = 0;
    }
    totalAllBuildingNumberLabel.text = [NSString stringWithFormat:@"共有%@个楼盘",_buildingNumber];
    [view addSubview:totalAllBuildingNumberLabel];

    return view;
    
}



//楼盘列表接口
-(void)getBuildingList
{
    DLog(@"   %@   %@   %@  %@   %@   %zd  %@ ",_keyword,_areaId,_featureId,_acreageId,_priceId,_page,_platId);
    
    [_lenovoTableView removeFromSuperview];
    _lenovoTableView = nil;
 
    [[DataFactory sharedDataFactory] getBuildingsWithCityId:self.cityId andPage:[NSString stringWithFormat:@"%zd",_page] andKeyword:_keyword andAreaId:_areaId andFeatureId:_featureId andAcreageId:_acreageId andPriceId:_priceId andPlatId:_platId andPriceModel:_priceModel andpropertyId:_propertyId andBedRoomId:_bedroomId andTrsyCar:_trsyCarId withCallBack:^(DataListResult *result,NSNumber *buildingNumber) {
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
                [self.searchTF resignFirstResponder];

//                [self getfindRecommendEstate];
                
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
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-74/2-64)];
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
            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake((kMainScreenWidth-105)/2, titleLabel2.bottom+15, 105, 56/2);
//            button.backgroundColor = BLUEBTBCOLOR;
//            button.titleLabel.font = FONT(13.f);
//            [button setTitle:@"返回楼盘列表" forState:UIControlStateNormal];
//            button.layer.cornerRadius = 5;
//            button.layer.masksToBounds = YES;
//            [button addTarget:self action:@selector(setSearchNomalStateBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:button];
//            
//            
//            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, button.bottom+37, kMainScreenWidth, 44)];
//            bgView.backgroundColor =BACKGROUNDCOLOR;
//            
//            [view addSubview:bgView];
//            
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (44-14)/2, 16, 14)];
//            imageView.image = [UIImage imageNamed:@"为您推荐.png"];
//            
//            [bgView addSubview:imageView];
//            
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+15/2, 0, 100, 44)];
//            label.textColor = NAVIGATIONTITLE;
//            label.font = [UIFont boldSystemFontOfSize:15.f];
//            label.text = @"为您推荐";
//            label.textAlignment =NSTextAlignmentLeft;
//            
//            [bgView addSubview:label];
//            
            self.tableView.backgroundColor = [UIColor whiteColor];

            
            
            return view;
        }
            break;
            
            
        default:
            break;
    }
    
    
    UIView *view;
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (self.viewControllerStyle) {
        case NormalViewControllerStyle:
        {
            //            if (self.cityFirstResult.banners.count > 0) {
            //
            //                return kMainScreenWidth*0.75+45+56/2;
            //            }else{
            //                return 56/2;
            //            }
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
            return kMainScreenWidth-74/2-74;
            
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
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingListData *listData =_tempArr[indexPath.row];
    
     BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
    
    VC.buildingId = listData.buildingId;
    VC.buildDistance = listData.buildDistance;

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


#pragma mark - SearchTableViewDeleagate

-(void)didSelectWith:(SearchTableView*)searchTableView andKeyword:(NSString *)keyWord;
{    _page = 1;
    self.searchTF.text = keyWord;
    self.keyword = keyWord;
    [self.searchTF resignFirstResponder];
    [self getBuildingList];
    
}
-(void)didCanCelSelect;
{
    [self.searchTF resignFirstResponder];

}

#pragma mark - 取消

- (void)cancelBtnClick
{
//    if (self.searchTF.text.length>0 ) {
//        
//
//    }else{
//        
//        [_seleView setTableViewCloseAndNomalStyle];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [self.searchTF resignFirstResponder];
    [_seleView setTableViewCloseAndNomalStyle];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)searchTextEventEditingChanged:(UITextField*)textField
{
    DLog(@"textField.text = %@ ",textField.text);
    
    [self getBuildingLenovoNameWithKeyWord:textField.text];
    
    
}

-(void)getBuildingLenovoNameWithKeyWord:(NSString *)keyWord
{

    
    if (keyWord.length>0) {
        [[DataFactory sharedDataFactory] getBuildingKeywordsWithKeyword:keyWord WithCallback:^(NSArray *array) {
            
            if (array.count > 0)
            {
                for (NSString *title in array) {
                    DLog(@"title ==== %@",title);
                }
                
                self.lenovoTableView.isHotRecommendBuildingName = NO;
                self.lenovoTableView.dataArray = array;
                self.lenovoTableView.delegate = self;
            }
        }];

    }else{
        
        self.lenovoTableView.isHotRecommendBuildingName = YES;
        if (self.cityId.length>0) {
            self.lenovoTableView.dataArray = self.buildingNameArray;
        }else{
            self.lenovoTableView.dataArray = [UserData sharedUserData].hotBuildingNameArray;
            
        }
        self.lenovoTableView.delegate = self;

        
    }
    
   }

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    _keyword = textField.text;
    _page = 1;
//    [textField resignFirstResponder];
    [self getBuildingList];
    
    DLog(@"搜索  %@  ",textField.text);
    
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.searchTF resignFirstResponder];
    [self removeLenovoTableView];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    
    DLog(@"begin11111isFirstResponder===  %d",self.searchTF.isFirstResponder);

    [self setSearchTextFieldFrame];

    [_seleView setTableViewCloseAndNomalStyle];

    
    [self lenovoTableView];
    
    return YES;
    
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    
    DLog(@"end  11111isFirstResponder===  %d",self.searchTF.isFirstResponder);
    [self setSearchTextFieldFrame];
//    [self removeLenovoTableView];
    
    return YES;
}

-(void)setSearchTextFieldFrame
{
    
//    self.navigationBar.leftBarButton.right+10, 54/2, kMainScreenWidth-(self.navigationBar.leftBarButton.right+10+10)-44-10, 30)];
    
    if (!self.searchTF.isFirstResponder) {
        
        [self.searchView setFrame:CGRectMake(10, 54/2, kMainScreenWidth-10-10-10-44, 30)];
        
    }else{
        
        [self.searchView setFrame:CGRectMake(self.navigationBar.leftBarButton.right+10, 54/2, kMainScreenWidth-(self.navigationBar.leftBarButton.right+10)-10, 30)];
    }
    
    
}

// 移除联想词数据

-(void)removeLenovoTableView
{
    if (_lenovoTableView) {

        [_lenovoTableView removeAllSubviews];
        [_lenovoTableView removeFromSuperview];
        _lenovoTableView = nil;
    }
    
    
}

#pragma mark - MJRefresh刷新和加载
// 添加头部
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        vc.page = 1;
        [vc pullRefresh:vc.page];
    }];
}

// 添加尾部
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        vc.page ++;
        [vc pushRefresh:vc.page];
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
