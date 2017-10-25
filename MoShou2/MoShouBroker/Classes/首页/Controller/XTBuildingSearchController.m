//
//  XTBuildingSearchController.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTBuildingSearchController.h"
#import "SearchTableView.h"
#import "DataFactory+Main.h"
#import "XTMapBuildInfoModel.h"
#import "XTMapBuildingParametersModel.h"
#import "DataFactory+Building.h"
#import "XTMapResultModel.h"
#import "XTMapBuildInfoModel.h"

@interface XTBuildingSearchController ()<UITextFieldDelegate,SearchTableViewDeleagate>

@property (nonatomic,strong)UIView *searchView;

@property (nonatomic,strong)UITextField* searchTF;

@property (nonatomic,strong)SearchTableView* lenovoTableView;

@property (nonatomic,strong)NSNumber* buildingNumber;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NSArray* buildingArray;

@property (nonatomic,strong)XTMapResultModel *resultModel;

@property (nonatomic,copy)NSString* keyword;

@property (nonatomic,weak)UIView* noResultView;

@end

@implementation XTBuildingSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self commonInit];
    }else{
        [self createNoNetWorkViewWithReloadBlock:^{
            [self commonInit];
        }];
    }
}



- (void)commonInit{
    UIButton *canCelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-44-10, 20, 44, 44)];
    [canCelBtn setTitle:@"取消" forState:UIControlStateNormal];
    canCelBtn.titleLabel.font = FONT(15.f);
    [canCelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [canCelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.navigationBar addSubview:canCelBtn];
    [self searchView];
    
    [self lenovoTableView];
    
    self.noResultView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-74/2-64);
    [self.searchTF becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (_buildingArray.count > 0) {
        if ([_delegate respondsToSelector:@selector(searchViewController:didSelecteBuildings:)]) {
            [_delegate searchViewController:self didSelecteBuildings:_buildingArray];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
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
            self.navigationBar.titleLabel.hidden = YES;
        }
    }
    return _searchTF;
}


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

- (SearchTableView *)lenovoTableView
{
    if (!_lenovoTableView) {
        _lenovoTableView = [[SearchTableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-265)];
        _lenovoTableView.delegate = self;
        _lenovoTableView.dataArray =self.buildingNameArray;
        _lenovoTableView.isHotRecommendBuildingName = YES;
        [self.view addSubview:_lenovoTableView];
        [self.view bringSubviewToFront:_lenovoTableView];
    }
    
    return _lenovoTableView;
    
}

-(void)getBuildingLenovoNameWithKeyWord:(NSString *)keyWord
{
    if (keyWord.length>0) {
        XTMapBuildingParametersModel* _parametersModel= [[XTMapBuildingParametersModel alloc] init];
        _parametersModel.cityId = [UserData sharedUserData].cityId;
        _parametersModel.modelType = @"4";
        _parametersModel.keywords = keyWord;
        [[DataFactory sharedDataFactory] getMapBuildingWith:_parametersModel callBack:^(ActionResult *result, XTMapResultModel *resultModel) {
            if (result.success && _keyword.length > 0) {
                self.noResultView.hidden = resultModel.buildGroupModel.docs.count > 0;
                _buildingArray = resultModel.buildGroupModel.docs;
                self.resultModel = resultModel;
                NSMutableArray* arrayM = [NSMutableArray array];
                for (XTMapBuildInfoModel* buildModel in resultModel.buildGroupModel.docs) {
                    [arrayM appendObject:buildModel.name];
                }
                self.lenovoTableView.isHotRecommendBuildingName = NO;
                self.lenovoTableView.dataArray = arrayM;
            }else{
                if (result.message.length > 0) {
                    [self showTips:result.message];
                }else{
                    [self showTips:@"楼盘数据检索失败"];
                }
                
            }
        }];
        
    }else{
        self.noResultView.hidden = YES;
        self.lenovoTableView.isHotRecommendBuildingName = YES;
        self.lenovoTableView.dataArray = self.buildingNameArray;
        
        
        
    }
    
}

-(void)getBuildingList
{
    
//    [[DataFactory sharedDataFactory] getBuildingsWithPage:[NSString stringWithFormat:@"%zd",_page] andKeyword:_searchTF.text andAreaId:nil andFeatureId:nil andAcreageId:nil andPriceId:nil andPlatId:nil andPriceModel:nil andpropertyId:nil andBedRoomId:nil andTrsyCar:nil withCallBack:^(DataListResult *result,NSNumber *buildingNumber) {
//        if (result)
//        {
//            self.buildingNumber = buildingNumber;
//            DLog(@"self.buildingNumber===%zd    %@",self.buildingNumber,self.buildingNumber);
//            NSMutableArray* arrayM = [NSMutableArray array];
//            for (BuildingListData* lData in result.dataArray) {
//                XTMapBuildInfoModel* infoModel = [[XTMapBuildInfoModel alloc]init];
//                infoModel.buildingListData = lData;
//                [arrayM appendObject:infoModel];
//            }
//            _buildingArray = arrayM;
//            if ([_delegate respondsToSelector:@selector(searchViewController:didSelecteBuildings:)]) {
//                [_delegate searchViewController:self didSelecteBuildings:arrayM];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
//        
//    }];
    UIImageView* loading = [self setRotationAnimationWithView];
    XTMapBuildingParametersModel* _parametersModel= [[XTMapBuildingParametersModel alloc] init];
    NSString* cityID = [UserData sharedUserData].cityId;
    if (_searchCityId.length > 0) {
        cityID = _searchCityId;
    }else if ([UserData sharedUserData].chooseCityId.length > 0) {
        cityID = [UserData sharedUserData].chooseCityId;
    }
    _parametersModel.cityId = cityID;
    _parametersModel.modelType = @"4";
    _parametersModel.keywords = _keyword;
    [[DataFactory sharedDataFactory] getMapBuildingWith:_parametersModel callBack:^(ActionResult *result, XTMapResultModel *resultModel) {
        [self removeRotationAnimationView:loading];
        if (result.success) {
            if ([_delegate respondsToSelector:@selector(searchViewController:didSelecteBuildings:)] && resultModel.buildGroupModel.docs.count > 0) {
                [_delegate searchViewController:self didSelecteBuildings:resultModel.buildGroupModel.docs];
                [self.navigationController popViewControllerAnimated:YES];
            }
            _noResultView.hidden = resultModel.buildGroupModel.docs.count > 0;
        }else{
            if (result.message.length > 0) {
                [self showTips:result.message];
            }else{
                [self showTips:@"楼盘数据检索失败"];
            }
            
        }
    }];
    
}

- (UIView *)noResultView{
    if (!_noResultView) {
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
        _noResultView = view;
        view.hidden = YES;
        [self.view addSubview:view];
    }
    return _noResultView;
}


- (void)didSelectWith:(SearchTableView *)searchTableView andKeyword:(NSString *)keyWord index:(NSInteger)index{
    
    if (_buildingArray.count > index && !searchTableView.isHotRecommendBuildingName) {
        if ([_delegate respondsToSelector:@selector(searchViewController:didSelecteBuildings:)]) {
            NSArray* subArray = [NSArray arrayWithObjects:[_buildingArray objectForIndex:index], nil];
            [_delegate searchViewController:self didSelecteBuildings:subArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    self.searchTF.text = keyWord;
    _keyword = keyWord;
    [self getBuildingList];
//    [self getBuildingLenovoNameWithKeyWord:keyWord];
//    [self searchTextEventEditingChanged:_searchTF];
    
}

- (void)didCanCelSelect{
    
}


- (void)searchTextEventEditingChanged:(UITextField*)textField{
    DLog(@"%@",textField.text);
    if (textField.text.length <= 0) {
        _noResultView.hidden = NO;
    }
    _keyword = textField.text;
    if(textField.markedTextRange == nil){
        [self getBuildingLenovoNameWithKeyWord:textField.text];
    }
    
}

- (void)cancelBtnClick:(UIButton*)btn{
    self.searchTF.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

@end
