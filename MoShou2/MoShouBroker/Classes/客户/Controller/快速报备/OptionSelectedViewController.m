//
//  OptionSelectedViewController.m
//  MoShou2
//
//  Created by wangzhenzhen on 15/11/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "OptionSelectedViewController.h"
#import "OptionSelectedTableViewCell.h"
#import "CustomerListViewController.h"
#import "ReportTipViewController.h"
#import "RecommendRecordController.h"
//#import "CustomerVisitInfoViewController.h" @"客户到访信息"
#import "CustomerEmptyView.h"
#import "IQKeyboardManager.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "DataFactory+Customer.h"
#import "UserData.h"
#import "CustomerVisitInfoView.h"
#import "ConfirmUserInfoObject.h"
#import "ConfirmUserListView.h"

@interface OptionSelectedViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomerEmptyView *emptyView;//空白页
@property (nonatomic, strong) UITextField *searchBarTextField;
@property (nonatomic, strong) UILabel     *numberLabel;
@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) NSMutableArray *loupArr;
@property (nonatomic, strong) NSMutableArray  *loupStatusArray;//楼盘是否被选中的状态记录数组，初始状态均为0
@property (nonatomic, strong) NSMutableArray  *loupTotalSeletedArray;
//@property (nonatomic, strong) NSMutableArray *statusArray;//客户是否被选中的状态记录数组，初始状态均为0
@property (nonatomic, strong) NSMutableArray *lastStatusArray;//楼盘是否被选中的状态记录数组，初始状态均为0
@property (nonatomic, assign) NSInteger        page;//加载更多时的页码
@property (nonatomic, assign) BOOL             hasMorePage;//是否有下一页
@property (nonatomic, assign) NSInteger        Index;
@property (nonatomic, assign) BOOL             bIsTouched;
@property (nonatomic, strong) NSMutableDictionary   *visitStatusDic;//客户是否展示到访信息
@property (nonatomic, strong) NSMutableDictionary   *allQuekeDic;//所有点击过的楼盘相关确客信息存储
@property (nonatomic, strong) NSMutableDictionary   *quekeStatusDic;//确客信息展示

@end

@implementation OptionSelectedViewController
@synthesize searchBarTextField;
@synthesize numberLabel;
@synthesize bottomView;
@synthesize loupArr;
@synthesize loupStatusArray;
@synthesize loupTotalSeletedArray;
@synthesize lastStatusArray;
@synthesize visitStatusDic;
@synthesize allQuekeDic;
@synthesize quekeStatusDic;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"选择楼盘";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _page = 1;
    loupArr = [[NSMutableArray alloc] init];
    loupStatusArray = [[NSMutableArray alloc] init];
    lastStatusArray = [[NSMutableArray alloc] init];
    visitStatusDic = [[NSMutableDictionary alloc] init];
    allQuekeDic = [[NSMutableDictionary alloc] init];
    quekeStatusDic = [[NSMutableDictionary alloc] init];
    
    //判断网络情况，初始化页面
    [self hasNetwork];
    
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame = CGRectMake(0, viewTopY+44+10+30+10, self.view.bounds.size.width, self.view.bounds.size.height - (viewTopY+44+10+30+10)-54);
    }
    if (self.bottomView.superview) {
        self.bottomView.frame = CGRectMake(10, self.view.bounds.size.height-54, self.view.bounds.size.width-20, 44);
    }
}

- (void)hasNetwork
{
    __weak OptionSelectedViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    if (_selectedOptions.count>0) {
        for (int i=0; i<_selectedOptions.count; i++) {
            CustomerBuilding *build = (CustomerBuilding*)[_selectedOptions objectForIndex:i];
            //            [lastStatusArray appendObject:build.buildingId];
            [lastStatusArray appendObject:build];
        }
    }
    if (_optionSelType == kCustomerFastVC) {
//        if (_selectedOptions.count>0) {
            visitStatusDic = _visitOptions;
        quekeStatusDic = _confirmOptions;
//        }
    }else
    {
        if (_visitOptions != nil) {
            visitStatusDic = _visitOptions;
            quekeStatusDic = _confirmOptions;
        }
    }
    
    UIImageView * loadingView = [self setRotationAnimationWithView];
    UserData *user = [UserData sharedUserData];
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
//    __weak OptionSelectedViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getFavoriteBuildingsWithPage:@"1" andCustId:_custId andKeyword:searchBarTextField.text andLongitude:user.longitude andLatitude:user.latitude andIsFullPhone:@"1" withCallBack:^(ActionResult *actionResult,DataListResult *result,NSString *count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!actionResult.success) {
                [self showTips:actionResult.message];
            }
            [self.loupArr addObjectsFromArray:result.dataArray];
            self.hasMorePage = result.morePage;
            [self.tableView setFooterViewHidden:!self.hasMorePage];
            self.count =count;
            numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)lastStatusArray.count,count];
            for (int i=0; i<self.loupArr.count; i++) {
                CustomerBuilding *buildingData = (CustomerBuilding*)[self.loupArr objectForIndex:i];
                [self.loupStatusArray appendObject:@"0"];
                //                for (NSString *buildId in weakSelf.lastStatusArray) {
                //                    if ([buildId isEqualToString:buildingData.buildingId]) {
                //                        [weakSelf.loupStatusArray removeLastObject];
                //                        [weakSelf.loupStatusArray appendObject:@"1"];
                //                        break;
                //                    }
                //                }
                for (CustomerBuilding *build in self.lastStatusArray) {
                    if ([build.buildingId isEqualToString:buildingData.buildingId]) {
                        [self.loupStatusArray removeLastObject];
                        [self.loupStatusArray appendObject:@"1"];
                        break;
                    }
                }
            }
            
            [self requestSearchFavoriteDataWithKeybord:searchBarTextField.text withFlag:YES];
            
            if (self.loupArr.count>0) {
                self.emptyView.hidden = YES;
            }else
            {
                self.tableView.hidden = YES;
            }
//            if (weakSelf.hasMorePage)
            {
                
//                [weakSelf.tableView addLegendFooterWithRefreshingTarget:weakSelf refreshingAction:@selector(footerRereshing)];
            }
        });
    }];
    [self createTopView];
    [self createTableView];
    [self createBottomView];
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
}

- (void)requestSearchFavoriteDataWithKeybord:(NSString*)keyboard withFlag:(BOOL)flag
{
    UserData *user = [UserData sharedUserData];
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = nil;
    //    if (flag) {
    loadingView = [self setRotationAnimationWithView];
    //    }
//    __weak OptionSelectedViewController *weakSelf = self;
    [self.tableView setFooterViewHidden:NO];
    [[DataFactory sharedDataFactory] getFavoriteBuildingsWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andCustId:_custId andKeyword:keyboard andLongitude:user.longitude andLatitude:user.latitude andIsFullPhone:@"1" withCallBack:^(ActionResult *actionResult,DataListResult *result,NSString*count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            if (flag) {
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            //            }
//            if (!actionResult.success) {
//                [weakSelf showTips:actionResult.message];
//            }
            if (loupArr.count > 0) {
                [self.loupArr removeAllObjects];
            }
            if (loupStatusArray.count > 0) {
                [self.loupStatusArray removeAllObjects];
            }
//            [self.loupArr removeAllObjects];
//            [self.loupStatusArray removeAllObjects];
            [self.loupArr addObjectsFromArray:result.dataArray];
            self.hasMorePage = result.morePage;
            [self.tableView setFooterViewHidden:!self.hasMorePage];
            for (int i=0; i<self.loupArr.count; i++) {
                CustomerBuilding *buildingData = (CustomerBuilding*)[self.loupArr objectForIndex:i];
                [self.loupStatusArray appendObject:@"0"];
                //                for (NSString *buildId in weakSelf.lastStatusArray) {
                //                    if ([buildId isEqualToString:buildingData.buildingId]) {
                //                        [weakSelf.loupStatusArray removeLastObject];
                //                        [weakSelf.loupStatusArray appendObject:@"1"];
                //                        break;
                //                    }
                //                }
                for (CustomerBuilding *build in self.lastStatusArray) {
                    if ([build.buildingId isEqualToString:buildingData.buildingId]) {
                        [self.loupStatusArray removeLastObject];
                        [self.loupStatusArray appendObject:@"1"];
                        break;
                    }
                }
            }
            //            weakSelf.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
            [self.tableView reloadData];
            if (self.loupArr.count>0) {
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
            }else
            {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }
            
            if ([self isBlankString:self.searchBarTextField.text]) {
                self.emptyView.tip.text = @"暂无符合要求楼盘";
            }else {
                if (!flag || ![self isBlankString:self.searchBarTextField.text]) {
                    self.emptyView.tip.text = @"抱歉，没有找到相关楼盘";
                }else
                {
                    self.emptyView.tip.text = @"暂无符合要求楼盘";
                }
            }
        });
    }];
}

- (void)requestSearchFillingDataWithKeybord:(NSString*)keyboard withFlag:(BOOL)flag
{
    UserData *user = [UserData sharedUserData];
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = nil;
    if (flag) {
        loadingView = [self setRotationAnimationWithView];
    }
//    __weak OptionSelectedViewController *weakSelf = self;
    [self.tableView setFooterViewHidden:NO];
    [[DataFactory sharedDataFactory] getFillingBuildingsWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andCustId:_custId andKeyword:keyboard andLongitude:user.longitude andLatitude:user.latitude andIsFullPhone:@"1" withCallBack:^(ActionResult *actionResult,DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (flag) {
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
            }
            if (!actionResult.success) {
                [self showTips:actionResult.message];
            }
            if (loupArr.count > 0) {
                [self.loupArr removeAllObjects];
            }
            if (loupStatusArray.count > 0) {
                [self.loupStatusArray removeAllObjects];
            }
            
            [self.loupArr addObjectsFromArray:result.dataArray];
            self.hasMorePage = result.morePage;
            [self.tableView setFooterViewHidden:!self.hasMorePage];
            for (int i=0; i<self.loupArr.count; i++) {
                CustomerBuilding *buildingData = (CustomerBuilding*)[self.loupArr objectForIndex:i];
                [self.loupStatusArray appendObject:@"0"];
                //                for (NSString *buildId in weakSelf.lastStatusArray) {
                //                    if ([buildId isEqualToString:buildingData.buildingId]) {
                //                        [weakSelf.loupStatusArray removeLastObject];
                //                        [weakSelf.loupStatusArray appendObject:@"1"];
                //                        break;
                //                    }
                //                }
                for (CustomerBuilding *build in self.lastStatusArray) {
                    if ([build.buildingId isEqualToString:buildingData.buildingId]) {
                        [self.loupStatusArray removeLastObject];
                        [self.loupStatusArray appendObject:@"1"];
                        break;
                    }
                }
            }
            //            weakSelf.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
            [self.tableView reloadData];
            if (self.loupArr.count>0) {
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
            }else
            {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }
            if ([self isBlankString:self.searchBarTextField.text]) {
                self.emptyView.tip.text = @"暂无符合要求楼盘";
            }else {
                if (!flag || ![self isBlankString:self.searchBarTextField.text]) {
                    self.emptyView.tip.text = @"抱歉，没有找到相关楼盘";
                }else
                {
                    self.emptyView.tip.text = @"暂无符合要求楼盘";
                }
            }
        });
    }];
}

//上拉加载
- (void)footerRereshing
{
    NSInteger page = _page+1;
    __weak OptionSelectedViewController *weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestNextBuildingWithPage:page];}])
    {
        [self requestNextBuildingWithPage:page];
    }
}

- (void)requestNextBuildingWithPage:(NSInteger)page
{
    UserData *user = [UserData sharedUserData];
    if (self.Index) {
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getFillingBuildingsWithPage:[NSString stringWithFormat:@"%ld",(long)page] andCustId:self.custId andKeyword:self.searchBarTextField.text andLongitude:user.longitude andLatitude:user.latitude andIsFullPhone:@"1" withCallBack:^(ActionResult *actionResult,DataListResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.legendFooter endRefreshing];
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
                //                if (!actionResult.success) {
                //                    [weakSelf showTips:actionResult.message];
                //                }
                if (result.dataArray.count>0)
                {
                    //更新UI
                    self.page++;//取到数据之后页码再递增，表示当前页
                    [self.loupStatusArray removeAllObjects];
                    [self.loupArr addObjectsFromArray:result.dataArray];
                }
                
                self.hasMorePage = result.morePage;
                [self.tableView setFooterViewHidden:!self.hasMorePage];
                for (int i=0; i<self.loupArr.count; i++) {
                    CustomerBuilding *buildingData = (CustomerBuilding*)[self.loupArr objectForIndex:i];
                    [self.loupStatusArray appendObject:@"0"];
                    //                    for (NSString *buildId in weakSelf.lastStatusArray) {
                    //                        if ([buildId isEqualToString:buildingData.buildingId]) {
                    //                            [weakSelf.loupStatusArray removeLastObject];
                    //                            [weakSelf.loupStatusArray appendObject:@"1"];
                    //                            break;
                    //                        }
                    //                    }
                    for (CustomerBuilding *build in self.lastStatusArray) {
                        if ([build.buildingId isEqualToString:buildingData.buildingId]) {
                            [self.loupStatusArray removeLastObject];
                            [self.loupStatusArray appendObject:@"1"];
                            break;
                        }
                    }
                }
                [self.tableView reloadData];
            });
        }];
    }else
    {
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getFavoriteBuildingsWithPage:[NSString stringWithFormat:@"%ld",(long)page] andCustId:_custId andKeyword:searchBarTextField.text andLongitude:user.longitude andLatitude:user.latitude andIsFullPhone:@"1" withCallBack:^(ActionResult *actionResult,DataListResult *result,NSString*count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.legendFooter endRefreshing];
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
                //                if (!actionResult.success) {
                //                    [weakSelf showTips:actionResult.message];
                //                }
                if (result.dataArray.count>0)
                {
                    [self.loupStatusArray removeAllObjects];
                    [self.loupArr addObjectsFromArray:result.dataArray];
                    self.page++;//取到数据之后页码再递增，表示当前页
                }
                self.hasMorePage = result.morePage;
                [self.tableView setFooterViewHidden:!self.hasMorePage];
                for (int i=0; i<self.loupArr.count; i++) {
                    CustomerBuilding *buildingData = (CustomerBuilding*)[self.loupArr objectForIndex:i];
                    [self.loupStatusArray appendObject:@"0"];
                    //                    for (NSString *buildId in weakSelf.lastStatusArray) {
                    //                        if ([buildId isEqualToString:buildingData.buildingId]) {
                    //                            [weakSelf.loupStatusArray removeLastObject];
                    //                            [weakSelf.loupStatusArray appendObject:@"1"];
                    //                            break;
                    //                        }
                    //                    }
                    for (CustomerBuilding *build in self.lastStatusArray) {
                        if ([build.buildingId isEqualToString:buildingData.buildingId]) {
                            [self.loupStatusArray removeLastObject];
                            [self.loupStatusArray appendObject:@"1"];
                            break;
                        }
                    }
                }
                [self.tableView reloadData];
            });
        }];
    }
}

- (void)createTopView
{
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, 44)];
    searchBgView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [self.view addSubview:searchBgView];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(10, viewTopY+7, kMainScreenWidth-20, 30)];
    searchBarView.backgroundColor = [UIColor whiteColor];
    [searchBarView.layer setCornerRadius:4];
    [searchBarView.layer setMasksToBounds:YES];
    [self.view addSubview:searchBarView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, viewTopY+15, 14, 14)];
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [self.view addSubview:searchImageView];
    
    searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(37, viewTopY+10, kMainScreenWidth - 47, 24)];
    searchBarTextField.delegate = self;
    searchBarTextField.returnKeyType = UIReturnKeySearch;
    searchBarTextField.placeholder = @"请输入楼盘名称";
    [searchBarTextField setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    searchBarTextField.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    searchBarTextField.textColor = NAVIGATIONTITLE;
    searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    [searchBarTextField addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:searchBarTextField];
    
    [self addSegmentView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY+44+10+30+10, kMainScreenWidth, self.view.bounds.size.height - (viewTopY+44+10+30+10)-54) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf performSelector:@selector(footerRereshing) withObject:nil];
    }];
    //判断联系人是否为空，是则显示空空如也图片，否则显示正常数据列表
    _emptyView = [[CustomerEmptyView alloc] initWithFrame:CGRectMake(0, _tableView.top, kMainScreenWidth, _tableView.height)];
    _emptyView.tip.text = @"暂无符合要求楼盘";
    [self.view addSubview:_emptyView];
}

- (void)createBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height-54, kMainScreenWidth-20, 44)];
    bottomView.backgroundColor = BLUEBTBCOLOR;
    [bottomView.layer setCornerRadius:4.0];
    [bottomView.layer setMasksToBounds:YES];
    [self.view addSubview:bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.width/2-55, 7, 60, 30)];
    if (_optionSelType == kCustomerFastVC) {
        titleLabel.text = @"选择";
    }else {
        titleLabel.text = @"报备";
    }
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:titleLabel];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+5, titleLabel.top, 100, 30)];
    numberLabel.textColor = [UIColor whiteColor];
    //    if (lastStatusArray.count>0) {
    numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)lastStatusArray.count,self.count];
    //    }else
    //    {
    //        numberLabel.text = @"0";
    //    }
//    numberLabel.font = [UIFont systemFontOfSize:13];
//    numberLabel.textAlignment = NSTextAlignmentCenter;
//    [numberLabel.layer setCornerRadius:numberLabel.width/2];
//    [numberLabel.layer setMasksToBounds:YES];
//    [numberLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [numberLabel.layer setBorderWidth:1.0];
    numberLabel.font = [UIFont systemFontOfSize:17];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:numberLabel];
    
    
    
//    if (![_bIsFullPhone boolValue]) {
//        titleLabel.top = 0;
//        numberLabel.top = titleLabel.top+6;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.width/2-50, 28, 100, 14)];
//        label.text = @"仅支持隐号楼盘";
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = FONT(11);
//        [bottomView addSubview:label];
//    }
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, bottomView.height)];
    [selectBtn setBackgroundColor:[UIColor clearColor]];
    [selectBtn addTarget:self action:@selector(toggleSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:selectBtn];
}

-(void)addSegmentView
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"收藏",@"全部",nil];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, viewTopY+44+10, 200*SCALE, 30);
    segment.selectedSegmentIndex = 0;
    segment.tintColor = BLUEBTBCOLOR;
    
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _page = 1;
    __weak OptionSelectedViewController *weakSelf = self;
    if (_Index) {
        if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestSearchFillingDataWithKeybord:searchBarTextField.text withFlag:NO];}]) {
            [self requestSearchFillingDataWithKeybord:searchBarTextField.text withFlag:NO];
        }
    }else
    {
        if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestSearchFavoriteDataWithKeybord:searchBarTextField.text withFlag:NO];}]) {
            [weakSelf requestSearchFavoriteDataWithKeybord:searchBarTextField.text withFlag:NO];
        }
    }
    return YES;
}

//- (void)textFieldDidChanged
//{
//    __weak OptionSelectedViewController *weakSelf = self;
//    if (_Index) {
//        if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestSearchFillingDataWithPage:1 withKeybord:searchBarTextField.text withFlag:NO];}]) {
//            [self requestSearchFillingDataWithPage:1 withKeybord:searchBarTextField.text withFlag:NO];
//        }
//    }else
//    {
//        if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestSearchFavoriteDataWithPage:1 withKeybord:searchBarTextField.text withFlag:NO];}]) {
//            [weakSelf requestSearchFavoriteDataWithPage:1 withKeybord:searchBarTextField.text withFlag:NO];
//        }
//    }
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return loupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"cellIdentifier";
    //    OptionSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CustomerBuilding *_buildingData = nil;
    if (loupArr.count > indexPath.row) {
        _buildingData = (CustomerBuilding*)[loupArr objectForIndex:indexPath.row];
    }
    UIView *lineView = nil;
    //    if (cell == nil) {
    OptionSelectedTableViewCell *cell = [[OptionSelectedTableViewCell alloc] initWithBuildListData:_buildingData AndTableType:0];

    if ([_buildingData.customerVisitEnable boolValue]) {
        if ([visitStatusDic valueForKey:_buildingData.buildingId] != nil) {
            cell.bIsShowVisitInfo = YES;
            if ([_buildingData.mechanismType boolValue]) {
                if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                    lineView = [self createLineView:180-0.5];
                    cell.bIsShowConfirmInfo = YES;
//                    cell.showVisitInfoView.mechanismType = YES;
                    
                }else
                {
                    lineView = [self createLineView:160-0.5];
                }
                
            }else
            {
                lineView = [self createLineView:160-0.5];
            }
            CustomerVisitInfoData *data = (CustomerVisitInfoData*)[visitStatusDic valueForKey:_buildingData.buildingId];
            cell.showVisitInfoView.visitDateLabel.text = [NSString stringWithFormat:@"预计到访时间:%@—%@",data.startDateStr,data.endDateStr];
            cell.showVisitInfoView.visitCountLabel.text = [NSString stringWithFormat:@"预计到访人数:%@",data.visitCount];
            cell.showVisitInfoView.visitFuncLabel.text = [NSString stringWithFormat:@"到访交通方式:%@",data.transfFunc];
            ConfirmUserInfoObject *confirm = (ConfirmUserInfoObject*)[quekeStatusDic valueForKey:_buildingData.buildingId];
            
/*            NSString *confirmMobile = @"";
            if (confirm.confirmUserMobile.length >= 11) {
                confirmMobile = [NSString stringWithFormat:@"%@ %@ %@",[confirm.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[confirm.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[confirm.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
            }*/
            cell.showVisitInfoView.confirmUserLabel.text = [NSString stringWithFormat:@"服务确客专员:%@    %@",confirm.confirmUserName,confirm.confirmUserMobile];
        }else
        {
            lineView = [self createLineView:100-0.5];
            cell.visitLabel.text = _buildingData.customerVisitText;
        }
    }else
    {
        if ([_buildingData.mechanismType boolValue]) {
            if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                cell.bIsShowConfirmInfo = YES;
//                cell.showVisitInfoView.mechanismType = YES;
                lineView = [self createLineView:120-0.5];
                ConfirmUserInfoObject *confirm = (ConfirmUserInfoObject*)[quekeStatusDic valueForKey:_buildingData.buildingId];
/*                NSString *confirmMobile = @"";
                if (confirm.confirmUserMobile.length >= 11) {
                    confirmMobile = [NSString stringWithFormat:@"%@ %@ %@",[confirm.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[confirm.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[confirm.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                }*/
                cell.showVisitInfoView.confirmUserLabel.text = [NSString stringWithFormat:@"服务确客专员:%@    %@",confirm.confirmUserName,confirm.confirmUserMobile];
            }else
            {
                lineView = [self createLineView:100-0.5];
                cell.visitLabel.text = _buildingData.mechanismText;
                
            }
        }else
        {
            lineView = [self createLineView:70-0.5];
        }
        
    }
    
    lineView.tag = 100;
    [cell.contentView addSubview:lineView];
    
    //    }
    if (loupStatusArray.count > indexPath.row) {
        cell.selectedBtn.selected = [[loupStatusArray objectForIndex:indexPath.row] boolValue];
    }
    __weak OptionSelectedViewController *weakSelf = self;
    [cell optionSelectCellBlock:^(OptionSelectedTableViewCell*optionCell,BOOL bIsSelected){
        NSIndexPath *cellIndexPath = [weakSelf.tableView indexPathForCell:optionCell];
        CustomerBuilding *buildingData = nil;
        if (weakSelf.loupArr.count > cellIndexPath.row) {
            buildingData = (CustomerBuilding*)[weakSelf.loupArr objectForIndex:cellIndexPath.row];
        }
        if (bIsSelected) {
            if (weakSelf.lastStatusArray.count>[weakSelf.count integerValue]-1) {
                [optionCell.selectedBtn setSelected:NO];
                [weakSelf showTips:[NSString stringWithFormat:@"最多可选择%@个楼盘",weakSelf.count]];
            }else{
                //手机号是否全部显示 （0全部显示，1部分显示）
                BOOL mobile = [UserData sharedUserData].mobileVisable;
                if (mobile && !optionCell.custTelTypeL.hidden) {
                    [weakSelf showTips:@"该楼盘仅支持全号报备"];
                }
                if ([[weakSelf.visitStatusDic allKeys] containsObject:_buildingData.buildingId] || ![_buildingData.customerVisitEnable boolValue]) {
//                    [weakSelf.loupStatusArray replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                    //                [weakSelf.lastStatusArray appendObject:buildingData.buildingId];
//                    [weakSelf.lastStatusArray appendObject:buildingData];
                    if ([_buildingData.mechanismType boolValue]) {
                        if ([[weakSelf.quekeStatusDic allKeys] containsObject:_buildingData.buildingId]) {
                            if (weakSelf.loupStatusArray.count > cellIndexPath.row) {
                                [weakSelf.loupStatusArray replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                            }
                            [weakSelf.lastStatusArray appendObject:_buildingData];
                        }else
                        {
                            [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.allQuekeDic setValue:array forKey:_buildingData.buildingId];
                                    
                                    ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                                    //                        listView.selectedData = _selectedConfirm;
                                    if ([self.quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                                        listView.selectedData = [self.quekeStatusDic valueForKey:_buildingData.buildingId];
                                    }
                                    if (listView.confirmArray != nil) {
                                        listView.confirmArray = nil;
                                    }
                                    listView.confirmArray = [self.allQuekeDic valueForKey:_buildingData.buildingId];
                                    
                                    [listView concelConfirmUserCellBlock:^{
                                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    }];
                                    [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
                                        for (id key in [weakSelf.quekeStatusDic allKeys])
                                        {
                                            if ([key isEqualToString:_buildingData.buildingId]) {
                                                [weakSelf.quekeStatusDic removeObjectForKey:_buildingData.buildingId];
                                                break;
                                            }
                                        }
                                        if (confirmObj != nil) {
                                            [weakSelf.quekeStatusDic setValue:confirmObj forKey:_buildingData.buildingId];
                                        }
//                                        [weakSelf.quekeStatusDic setValue:confirmObj forKey:_buildingData.buildingId];
                                        
                                        [listView removeFromSuperview];
                                        if (weakSelf.loupStatusArray.count > cellIndexPath.row) {
                                            [weakSelf.loupStatusArray replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                                        }
                                        [weakSelf.lastStatusArray appendObject:_buildingData];
                                        weakSelf.numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)weakSelf.lastStatusArray.count,weakSelf.count];
                                        
                                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    }];
                                    [self.view addSubview:listView];
                                });
                            }];
                        }
                    }else
                    {
                        if (weakSelf.loupStatusArray.count > cellIndexPath.row) {
                            [weakSelf.loupStatusArray replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                        }
                        [weakSelf.lastStatusArray appendObject:buildingData];
                    }
                }else
                {
                    if (mobile && !optionCell.custTelTypeL.hidden) {
                        [TipsView showTips:@"该楼盘仅支持全号报备" inView:[UIApplication sharedApplication].keyWindow];
                    }
                    CustomerVisitInfoView *visitInfoView = [[CustomerVisitInfoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                    if ([weakSelf.visitStatusDic valueForKey:_buildingData.buildingId] != nil) {
                        visitInfoView.visitInfoData = [weakSelf.visitStatusDic valueForKey:_buildingData.buildingId];
                    }
                    visitInfoView.bIsShowConfirm = [_buildingData.mechanismType boolValue];
                    if ([_buildingData.mechanismType boolValue]) {
                        if ([[weakSelf.quekeStatusDic allKeys] containsObject:_buildingData.buildingId]) {
                            visitInfoView.confirmMutArr = [weakSelf.allQuekeDic valueForKey:_buildingData.buildingId];
                            if ([weakSelf.quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                                visitInfoView.confirmInfoData = [weakSelf.quekeStatusDic valueForKey:_buildingData.buildingId];
                            }
                        }else
                        {
                            [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.allQuekeDic setValue:array forKey:_buildingData.buildingId];
                                    
                                    visitInfoView.confirmMutArr = [self.allQuekeDic valueForKey:_buildingData.buildingId];
                                    if ([self.quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                                        visitInfoView.confirmInfoData = [self.quekeStatusDic valueForKey:_buildingData.buildingId];
                                    }
                                });
                            }];
                        }
                    }
                    [visitInfoView seleteEndDateBlock:^{
                        [TipsView showTips:@"请先设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                    }];
                    [visitInfoView seleteCancelButtonBlock:^{
                        
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [visitInfoView seleteSaveButtonBlock:^(CustomerVisitInfoData *visitInfo,ConfirmUserInfoObject *confirmInfo) {
                        if ([visitInfo.startDateStr isEqualToString:@"选择时间"]) {
                            [TipsView showTips:@"请设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                        if ([visitInfo.endDateStr isEqualToString:@"选择时间"] || [visitInfo.endDateStr isEqualToString:@"—"]) {
                            [TipsView showTips:@"请设置结束时间" inView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                        if ([weakSelf isBlankString:visitInfo.transfFunc]) {
                            [TipsView showTips:@"请选择交通方式" inView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                        if ([_buildingData.mechanismType boolValue] && confirmInfo == nil) {
                            [TipsView showTips:@"请选择确客专员" inView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                        for (id key in [weakSelf.visitStatusDic allKeys])
                        {
                            if ([key isEqualToString:_buildingData.buildingId]) {
                                [weakSelf.visitStatusDic removeObjectForKey:_buildingData.buildingId];
                                break;
                            }
                        }
                        for (id key in [weakSelf.quekeStatusDic allKeys])
                        {
                            if ([key isEqualToString:_buildingData.buildingId]) {
                                [weakSelf.quekeStatusDic removeObjectForKey:_buildingData.buildingId];
                                break;
                            }
                        }
                        if (confirmInfo != nil) {
                            [weakSelf.quekeStatusDic setValue:confirmInfo forKey:_buildingData.buildingId];
                        }
                        
                        [weakSelf.visitStatusDic setValue:visitInfo forKey:_buildingData.buildingId];
                        
                        [visitInfoView removeFromSuperview];
                        if (weakSelf.loupStatusArray.count > cellIndexPath.row) {
                            [weakSelf.loupStatusArray replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                        }
                        [weakSelf.lastStatusArray appendObject:buildingData];
                        weakSelf.numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)weakSelf.lastStatusArray.count,weakSelf.count];//[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [weakSelf.view addSubview:visitInfoView];
                }
            }
        }else
        {
            if (weakSelf.loupStatusArray.count > cellIndexPath.row) {
                [weakSelf.loupStatusArray replaceObjectForIndex:cellIndexPath.row withObject:@"0"];
            }
            //            for (NSString *buildId in weakSelf.lastStatusArray) {
            //                if ([buildId isEqualToString:buildingData.buildingId]) {
            //                    [weakSelf.lastStatusArray removeObject:buildingData.buildingId];
            //                    break;
            //                }
            //            }
            for (CustomerBuilding *build in weakSelf.lastStatusArray) {
                if ([build.buildingId isEqualToString:buildingData.buildingId]) {
                    [weakSelf.lastStatusArray removeObject:build];
                    break;
                }
            }
        }
        weakSelf.numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)weakSelf.lastStatusArray.count,weakSelf.count];//[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    CustomerBuilding *_buildingData = nil;
    if (loupArr.count > indexPath.row) {
        _buildingData = (CustomerBuilding*)[loupArr objectForIndex:indexPath.row];
    }
    
//    if (indexPath.row > 2 && indexPath.row < 7) {
    if ([_buildingData.customerVisitEnable boolValue]) {
        if ([visitStatusDic valueForKey:_buildingData.buildingId] != nil) {
            height = 160;
            if ([_buildingData.mechanismType boolValue]) {
                if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                    height = 180;
                }
            }
        }else
        {
            height = 100;
        }
    }else
    {
        height = 70;
        if ([_buildingData.mechanismType boolValue]) {
            if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                height = 120;
            }else
            {
                height = 100;
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerBuilding *_buildingData = nil;
    if (loupArr.count > indexPath.row) {
        _buildingData = (CustomerBuilding*)[loupArr objectForIndex:indexPath.row];
    }
    __weak OptionSelectedViewController *weakSelf = self;
   
//    if (indexPath.row > 2 && indexPath.row < 7) {
    if ([_buildingData.customerVisitEnable boolValue]) {
        if ([[visitStatusDic allKeys] containsObject:_buildingData.buildingId]) {
            CustomerVisitInfoView *visitInfoView = [[CustomerVisitInfoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
            if ([visitStatusDic valueForKey:_buildingData.buildingId] != nil) {
                visitInfoView.visitInfoData = [visitStatusDic valueForKey:_buildingData.buildingId];
            }
            visitInfoView.bIsShowConfirm = [_buildingData.mechanismType boolValue];
            if ([_buildingData.mechanismType boolValue]) {
                if ([[weakSelf.quekeStatusDic allKeys] containsObject:_buildingData.buildingId]) {
//                    visitInfoView.confirmMutArr = [allQuekeDic valueForKey:_buildingData.buildingId];
                    if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                        visitInfoView.confirmInfoData = [quekeStatusDic valueForKey:_buildingData.buildingId];
                    }
                    if ([allQuekeDic valueForKey:_buildingData.buildingId] != nil) {
                        visitInfoView.confirmMutArr = [allQuekeDic valueForKey:_buildingData.buildingId];
                    }else
                    {
                        [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [allQuekeDic setValue:array forKey:_buildingData.buildingId];
                                visitInfoView.confirmMutArr = [allQuekeDic valueForKey:_buildingData.buildingId];
                            });
                        }];
                    }
                }else
                {
                    [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [allQuekeDic setValue:array forKey:_buildingData.buildingId];
                            
                            visitInfoView.confirmMutArr = [allQuekeDic valueForKey:_buildingData.buildingId];
                            if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                                visitInfoView.confirmInfoData = [quekeStatusDic valueForKey:_buildingData.buildingId];
                            }
                        });
                    }];
                }
            }
            [visitInfoView seleteEndDateBlock:^{
                [TipsView showTips:@"请先设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
            }];
            [visitInfoView seleteCancelButtonBlock:^{
            }];
            [visitInfoView seleteSaveButtonBlock:^(CustomerVisitInfoData *visitInfo,ConfirmUserInfoObject *confirmInfo) {
                if ([visitInfo.startDateStr isEqualToString:@"选择时间"]) {
                    [TipsView showTips:@"请设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([visitInfo.endDateStr isEqualToString:@"选择时间"] || [visitInfo.endDateStr isEqualToString:@"—"]) {
                    [TipsView showTips:@"请设置结束时间" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([weakSelf isBlankString:visitInfo.transfFunc]) {
                    [TipsView showTips:@"请选择交通方式" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                if ([_buildingData.mechanismType boolValue] && confirmInfo == nil) {
                    [TipsView showTips:@"请选择确客专员" inView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                for (id key in [weakSelf.visitStatusDic allKeys])
                {
                    if ([key isEqualToString:_buildingData.buildingId]) {
                        [weakSelf.visitStatusDic removeObjectForKey:_buildingData.buildingId];
                        break;
                    }
                }
                for (id key in [weakSelf.quekeStatusDic allKeys])
                {
                    if ([key isEqualToString:_buildingData.buildingId]) {
                        [weakSelf.quekeStatusDic removeObjectForKey:_buildingData.buildingId];
                        break;
                    }
                }
                if (confirmInfo != nil) {
                    [weakSelf.quekeStatusDic setValue:confirmInfo forKey:_buildingData.buildingId];
                }
                
                [weakSelf.visitStatusDic setValue:visitInfo forKey:_buildingData.buildingId];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [visitInfoView removeFromSuperview];
            }];
            [self.view addSubview:visitInfoView];
        }else
        {
            if (self.lastStatusArray.count>[weakSelf.count integerValue]-1) {
                [self showTips:[NSString stringWithFormat:@"最多可选择%@个楼盘",weakSelf.count]];
            }else{
                OptionSelectedTableViewCell *optionCell = (OptionSelectedTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
                //手机号是否全部显示 （0全部显示，1部分显示）
                BOOL mobile = [UserData sharedUserData].mobileVisable;
                if (mobile && !optionCell.custTelTypeL.hidden) {
//                    [weakSelf showTips:@"该楼盘仅支持全号报备"];
                    
                    [TipsView showTips:@"该楼盘仅支持全号报备" inView:[UIApplication sharedApplication].keyWindow];
                }
                
                CustomerVisitInfoView *visitInfoView = [[CustomerVisitInfoView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                if ([visitStatusDic valueForKey:_buildingData.buildingId] != nil) {
                    visitInfoView.visitInfoData = [visitStatusDic valueForKey:_buildingData.buildingId];
                }
                visitInfoView.bIsShowConfirm = [_buildingData.mechanismType boolValue];
                if ([_buildingData.mechanismType boolValue]) {
                    if ([[weakSelf.quekeStatusDic allKeys] containsObject:_buildingData.buildingId]) {
                        visitInfoView.confirmMutArr = [allQuekeDic valueForKey:_buildingData.buildingId];
                        if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                            visitInfoView.confirmInfoData = [quekeStatusDic valueForKey:_buildingData.buildingId];
                        }
                    }else
                    {
                        [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [allQuekeDic setValue:array forKey:_buildingData.buildingId];
                                
                                visitInfoView.confirmMutArr = [allQuekeDic valueForKey:_buildingData.buildingId];
                                if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                                    visitInfoView.confirmInfoData = [quekeStatusDic valueForKey:_buildingData.buildingId];
                                }
                            });
                        }];
                    }
                }
                [visitInfoView seleteEndDateBlock:^{
                    [TipsView showTips:@"请先设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                }];
                [visitInfoView seleteCancelButtonBlock:^{
                }];
                [visitInfoView seleteSaveButtonBlock:^(CustomerVisitInfoData *visitInfo,ConfirmUserInfoObject *confirmInfo) {
                    if ([visitInfo.startDateStr isEqualToString:@"选择时间"]) {
                        [TipsView showTips:@"请设置开始时间" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    if ([visitInfo.endDateStr isEqualToString:@"选择时间"] || [visitInfo.endDateStr isEqualToString:@"—"]) {
                        [TipsView showTips:@"请设置结束时间" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    if ([weakSelf isBlankString:visitInfo.transfFunc]) {
                        [TipsView showTips:@"请选择交通方式" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    if ([_buildingData.mechanismType boolValue] && confirmInfo == nil) {
                        [TipsView showTips:@"请选择确客专员" inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    for (id key in [weakSelf.visitStatusDic allKeys])
                    {
                        if ([key isEqualToString:_buildingData.buildingId]) {
                            [weakSelf.visitStatusDic removeObjectForKey:_buildingData.buildingId];
                            break;
                        }
                    }
                    for (id key in [weakSelf.quekeStatusDic allKeys])
                    {
                        if ([key isEqualToString:_buildingData.buildingId]) {
                            [weakSelf.quekeStatusDic removeObjectForKey:_buildingData.buildingId];
                            break;
                        }
                    }
                    if (confirmInfo != nil) {
                        [weakSelf.quekeStatusDic setValue:confirmInfo forKey:_buildingData.buildingId];
                    }
//                    [weakSelf.quekeStatusDic setValue:confirmInfo forKey:_buildingData.buildingId];
                    [weakSelf.visitStatusDic setValue:visitInfo forKey:_buildingData.buildingId];
                    
                    [visitInfoView removeFromSuperview];
                    
                    if (weakSelf.loupStatusArray.count > indexPath.row) {
                        [weakSelf.loupStatusArray replaceObjectForIndex:indexPath.row withObject:@"1"];
                    }
                    [weakSelf.lastStatusArray appendObject:_buildingData];
                    weakSelf.numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)weakSelf.lastStatusArray.count,weakSelf.count];//[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [self.view addSubview:visitInfoView];
            }
        }
    }else
    {
        if ([_buildingData.mechanismType boolValue]) {
            if ([[self.quekeStatusDic allKeys] containsObject:_buildingData.buildingId]) {
                ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                //                        listView.selectedData = _selectedConfirm;
                if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                    listView.selectedData = [quekeStatusDic valueForKey:_buildingData.buildingId];
                }
                if (listView.confirmArray != nil) {
                    listView.confirmArray = nil;
                }
                if ([allQuekeDic valueForKey:_buildingData.buildingId] != nil) {
                    listView.confirmArray = [allQuekeDic valueForKey:_buildingData.buildingId];
                }else
                {
                    [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [allQuekeDic setValue:array forKey:_buildingData.buildingId];
                             listView.confirmArray = [allQuekeDic valueForKey:_buildingData.buildingId];
                        });
                    }];
                }
                
                
                [listView concelConfirmUserCellBlock:^{
                }];
                [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
                    for (id key in [weakSelf.quekeStatusDic allKeys])
                    {
                        if ([key isEqualToString:_buildingData.buildingId]) {
                            [weakSelf.quekeStatusDic removeObjectForKey:_buildingData.buildingId];
                            break;
                        }
                    }
                    if (confirmObj != nil) {
                        [weakSelf.quekeStatusDic setValue:confirmObj forKey:_buildingData.buildingId];
                    }
//                    [weakSelf.quekeStatusDic setValue:confirmObj forKey:_buildingData.buildingId];
                    
                    [listView removeFromSuperview];
                    
//                    [weakSelf.loupStatusArray replaceObjectForIndex:indexPath.row withObject:@"1"];
//                    [weakSelf.lastStatusArray appendObject:_buildingData];
//                    weakSelf.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
                    
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [self.view addSubview:listView];
            }else
            {
                [[DataFactory sharedDataFactory] getConfirmUserListWithBId:_buildingData.buildingId WithCallBack:^(ActionResult *result, NSArray *array) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [allQuekeDic setValue:array forKey:_buildingData.buildingId];
                        
                        ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
                        //                        listView.selectedData = _selectedConfirm;
                        if ([quekeStatusDic valueForKey:_buildingData.buildingId] != nil) {
                            listView.selectedData = [quekeStatusDic valueForKey:_buildingData.buildingId];
                        }
                        if (listView.confirmArray != nil) {
                            listView.confirmArray = nil;
                        }
                        listView.confirmArray = [allQuekeDic valueForKey:_buildingData.buildingId];
                        
                        [listView concelConfirmUserCellBlock:^{
                        }];
                        [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
                            for (id key in [weakSelf.quekeStatusDic allKeys])
                            {
                                if ([key isEqualToString:_buildingData.buildingId]) {
                                    [weakSelf.quekeStatusDic removeObjectForKey:_buildingData.buildingId];
                                    break;
                                }
                            }
                            if (confirmObj != nil) {
                                [weakSelf.quekeStatusDic setValue:confirmObj forKey:_buildingData.buildingId];
                            }
//                            [weakSelf.quekeStatusDic setValue:confirmObj forKey:_buildingData.buildingId];
                            
                            [listView removeFromSuperview];
                            if (weakSelf.loupStatusArray.count > indexPath.row) {
                                [weakSelf.loupStatusArray replaceObjectForIndex:indexPath.row withObject:@"1"];
                            }
                            [weakSelf.lastStatusArray appendObject:_buildingData];
                            weakSelf.numberLabel.text = [NSString stringWithFormat:@"(%lu/%@)",(unsigned long)weakSelf.lastStatusArray.count,weakSelf.count];//[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.lastStatusArray.count];
                            
                            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        }];
                        [self.view addSubview:listView];
                    });
                }];
            }
        }
    }
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, y, kMainScreenWidth-15, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

-(void)segmentAction:(UISegmentedControl *)segment
{
    _Index = segment.selectedSegmentIndex;
    _page = 1;
    NSLog(@"Index %zd", _Index);
    //0 下载       1 收藏
    __weak OptionSelectedViewController *weakSelf = self;
    if (_Index) {
        if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestSearchFillingDataWithKeybord:searchBarTextField.text withFlag:YES];}])
        {
            [self requestSearchFillingDataWithKeybord:searchBarTextField.text withFlag:YES];
        }
    }else
    {
        if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf requestSearchFavoriteDataWithKeybord:searchBarTextField.text withFlag:YES];}])
        {
            [self requestSearchFavoriteDataWithKeybord:searchBarTextField.text withFlag:YES];
        }
    }
}

- (void)toggleSelectBtn:(UIButton*)sender
{
    if (lastStatusArray.count == 0) {
        [self showTips:@"请先选择楼盘"];
        return;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSString *visitInfo = @"";
    NSString *confirmInfo = @"";
    NSMutableArray *buildArr = [[NSMutableArray alloc] init];
    NSMutableArray *confirmArr = [[NSMutableArray alloc] init];
    for (int i=0; i<lastStatusArray.count; i++) {
        //        for (int j=0; j<lastStatusArray.count; j++) {
        CustomerBuilding *buildingData = (CustomerBuilding*)[lastStatusArray objectForIndex:i];
        [tempArray appendObject:buildingData.buildingId];
        
        CustomerVisitInfoData *visitData = (CustomerVisitInfoData*)[visitStatusDic valueForKey:buildingData.buildingId];
        
        if ([buildingData.customerVisitEnable boolValue]) {
            NSMutableDictionary *buildDic = [[NSMutableDictionary alloc] init];
            [buildDic setValue:buildingData.buildingId forKey:@"id"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *startStr = [dateFormatter stringFromDate:visitData.startDate];
            NSString *endStr = [dateFormatter stringFromDate:visitData.endDate];
            if (![self isBlankString:startStr]) {
                [buildDic setValue:startStr forKey:@"visitTimeBegin"];
            }
            if (![self isBlankString:endStr]) {
                [buildDic setValue:endStr forKey:@"visitTimeEnd"];
            }
            [buildDic setValue:[visitData.visitCount substringToIndex:visitData.visitCount.length-1] forKey:@"numPeople"];
            [buildDic setValue:visitData.transfFunc forKey:@"trafficMode"];
            [buildArr appendObject:buildDic];
        }
        
        ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[quekeStatusDic valueForKey:buildingData.buildingId];
        if ([buildingData.mechanismType boolValue]) {
            NSMutableDictionary *buildDic = [[NSMutableDictionary alloc] init];
            [buildDic setValue:buildingData.buildingId forKey:@"buildingId"];
            [buildDic setValue:confirmData.confirmUserId forKey:@"confirmUserId"];
            [confirmArr appendObject:buildDic];
        }
    }
    if (buildArr.count > 0) {
        NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:buildArr,@"customerList", nil];
        visitInfo = [OptionSelectedViewController dictionaryToJson:phoneListDic];
    }
    if (confirmArr.count > 0) {
        NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:confirmArr,@"confirmUsers", nil];
        confirmInfo = [OptionSelectedViewController dictionaryToJson:phoneListDic];
    }
    switch (_optionSelType) {
        case kCustomerFastVC:
        {
            _optionSelectBlock(lastStatusArray,visitStatusDic,quekeStatusDic);
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"EditFinishRefresh" object:nil];
            __weak OptionSelectedViewController *option = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                //防止多次pop发生崩溃闪退
                if ([self.view superview]) {
                    [option.navigationController popViewControllerAnimated:YES];
                }
            });
        }
            break;
//        case kCustomerListVC:
        case kCustomerDetailVC:
        {
            NSString *buildings = [tempArray componentsJoinedByString:@","];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:_name forKey:@"name"];
            [dic setValue:buildings forKey:@"buildingIds"];
            if ([_sex isEqualToString:@"男"]) {
                [dic setValue:@"male" forKey:@"sex"];
            }else if ([_sex isEqualToString:@"女"])
            {
                [dic setValue:@"female" forKey:@"sex"];
            }
            
            [dic setValue:_phone forKey:@"phone"];
            [dic setValue:_custId forKey:@"customerId"];
            if (![self isBlankString:visitInfo]) {
                [dic setValue:visitInfo forKey:@"customerVisitInfo"];
            }
            if (![self isBlankString:confirmInfo]) {
                [dic setValue:confirmInfo forKey:@"confirmUsers"];
            }
            if (![self isBlankString:_identitycard]) {
                [dic setValue:_identitycard forKey:@"cardId"];
            }
            if (!_bIsTouched) {
                _bIsTouched = YES;
//                if (_optionSelType == kCustomerDetailVC)
//                {
                    if (tempArray.count>1) {
                        [MobClick event:@"khxq_plxzlp"];//客户详情页-批量选择楼盘
                    }
//                }
                //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
                UIImageView * loadingView = [self setRotationAnimationWithView];
//                __weak OptionSelectedViewController *weakSelf = self;
                [[DataFactory sharedDataFactory] fastSaveCustomerWithDict:dic withCallBack:^(ActionResult *result, ReportReturnData *returnData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![self removeRotationAnimationView:loadingView]) {
                            return ;
                        }
                        self.bIsTouched = NO;
                        if (result.success) {
                            //                            for (UIViewController *temp in self.navigationController.viewControllers) {
                            //                                if ([temp isKindOfClass:[CustomerListViewController class]]) {
//                            if (_optionSelType == kCustomerListVC) {
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
//                            }else if (_optionSelType == kCustomerDetailVC)
//                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailBottom" object:nil];
//                            }
                            //                                }
                            //                            }
                            if (returnData.failBuildingList.count>0) {
                                ReportTipViewController *reportTipVC = [[ReportTipViewController alloc] init];
                                reportTipVC.reportFailType = kfailBuilding;
                                reportTipVC.reportData = returnData;
                                reportTipVC.dataArray = self.lastStatusArray;
                                reportTipVC.customerId = self.custId;
                                reportTipVC.custVisitDic = self.visitStatusDic;
                                reportTipVC.confirmDic = self.quekeStatusDic;
//                                if (_optionSelType == kCustomerListVC) {
//                                    reportTipVC.type = 0;
//                                }else if (_optionSelType == kCustomerDetailVC)
//                                {
                                    reportTipVC.type = 4;
//                                }
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //防止多次pop发生崩溃闪退
                                    if ([self.view superview]) {
                                        [self.navigationController pushViewController:reportTipVC animated:YES];
                                    }
                                });
                            }else
                            {
                                [self showTips:result.message];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    self.optionSelectBlock(tempArray,visitStatusDic,quekeStatusDic);
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            }
                        }else
                        {
                            [self showTips:result.message];
                        }
                    });
                }];
            }else
            {
                _bIsTouched = NO;
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchBarTextField resignFirstResponder];
}

#pragma mark - Block回调传参
-(void)returnResultBlock:(optionSelectBlock)ablock
{
    self.optionSelectBlock = ablock;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
