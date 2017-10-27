//
//  HomePageController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "HomePageController.h"
#import "RecommendRecordController.h"
//add by wangzz 20151130
#import "QuickReportViewController.h"
#import "CustomerOperationViewController.h"
#import "XTWorkReportingController.h"

#import "XTTopFunctionView.h"
#import "ToolAutoScrView.h"
#import "XTCollectBuildingTips.h"
#import "XTCollectBuildingNoResultView.h"
#import "ProposeNavigationBarLeftButton.h"
#import "MessageCenterNavigationButton.h"

#import "XTUserScheduleViewController.h"//我的日程控制器
#import "XTMineFortuneController.h"
#import "CommonProblemViewController.h"
#import "MessageListViewController.h"
#import "XTSaleRankingController.h"
#import "IQKeyboardManager.h"
#import "UserData.h"
#import "NSString+Extension.h"

#import "ChooseCityViewController.h"

#import "DataFactory+Main.h"
#import "DataFactory+Building.h"
#import "DataFactory+User.h"

#import "BuildingCell.h"
#import "BuildingDetailViewController.h"

//侧滑
#import "UITableViewRowAction+JZExtension.h"

//修改员工编号
#import "ChangeEmplyeeNoViewController.h"

#import "SplashImageView.h"
#import "XTAppointmentCarRecordController.h"

//网页浏览加楼盘跳转控制器
#import "XTContentOperationView.h"
#import "XTWebNavigationControler.h"

#import "XTHomeBuildingCell.h"

#import "XTMapBuildingController.h"

#import "UITableView+XTRefresh.h"

//#import "MJRefresh.h"

#import "XTOperationModelItem.h"

#import "AppDelegate.h"

#import "OverseasEstateViewController.h"
#import "NeighborPropertieViewController.h"
#define offsetNum 4

@interface HomePageController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray* _tempArr;
    BOOL          bIsPopAlert;
}
//顶部功能栏
@property (nonatomic,weak)XTTopFunctionView* topFunctionView;
//未读消息小红点
@property (nonatomic,weak)UIImageView* messageDot;
@property (nonatomic,weak)UILabel* numLabel;
//广告自动滚动视图
@property (nonatomic,weak)ToolAutoScrView* adAutoScrollView;

//
@property (nonatomic,weak)UIButton* leftNavBtn;

@property (nonatomic,weak)UIButton* rightNavBtn;

//首页容器tableview，负责装载广告视图，楼盘列表
@property (nonatomic,weak)UITableView* tableView;

@property (nonatomic,weak)UIButton* selectedCityButton;


@property (nonatomic,assign)BOOL isRefresh;


@property (nonatomic,assign)NSInteger page;
/**
 *  城市选择视图
 */
@property (nonatomic,weak)UIView* cityBgView;

@property (nonatomic,assign)BOOL noResult;//没有热销楼盘

@property (nonatomic,assign)CGFloat topFunctionHeight;

@property (nonatomic,weak)UIView* grayLineView;

//楼盘列表提示语
@property (nonatomic,weak)XTCollectBuildingTips* tipsCell;

/**
 *  内容运营视图
 */
@property (nonatomic,weak)XTContentOperationView* contentOperationView;

/**
 *  运营数据
 */
@property (nonatomic,strong)XTOperationModel* operationModel;

@property (nonatomic,assign)BOOL operateNoResult;

@property (nonatomic,weak)UIImageView* navigationBarBackImageView;

@property (nonatomic,weak)UIView* helpView;//帮助页

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    bIsPopAlert = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self commonInit];
    //    [self reloadBuildingInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadHomePage:) name:@"reloadHomePage" object:nil];
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDot) name:@"reloadHomeDot" object:nil];
    [self reloadDot];
    if ([UserData sharedUserData].isUserLogined) {
        [self showEmployeeAlert];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)showEmployeeAlert
{
    //add by wangzz 160808
    if (!bIsPopAlert) {
        BOOL limit = [UserData sharedUserData].userInfo.limitEmployeeNo;
        NSString *employee = [UserData sharedUserData].userInfo.employeeNo;
        if (limit && [self isBlankString:employee]) {
            bIsPopAlert = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重要提醒" message:@"应贵公司要求，您需要在“我的—头像—个人资料页”填写您的员工编号，以保证魔售的正常使用。" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"马上填写", nil];
            
            [alert show];
        }
    }
    //end
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        ChangeEmplyeeNoViewController *employee = [[ChangeEmplyeeNoViewController alloc] init];
        [self.navigationController pushViewController:employee animated:YES];
    }
}

- (void)adjustFrameForHotSpotChange{
    [super adjustFrameForHotSpotChange];
    if (_tableView.superview) {
//        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        _tableView.frame = CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 29);
    }
}

static BOOL firstLoad = YES;
//初始化
-(void)commonInit{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:view];
    
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = NO;
    mage.shouldResignOnTouchOutside = NO;
    mage.shouldToolbarUsesTextFieldTintColor = NO;
    mage.enableAutoToolbar = NO;
    
    UIView* cityBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    [self.navigationBar addSubview:cityBgView];
    _cityBgView = cityBgView;
    
    NSString* cityid = [UserData sharedUserData].cityId;
    
    DLog(@"cityid=====%@",cityid);
    if (cityid.length==0) {
        if ([UserData sharedUserData].isUserLogined) {
            
            [self jumpToChooseCity];
        }
    }
    firstLoad = NO;
    
    
    UIImageView* topImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home-top-jianbian"]];
    topImgV.frame = CGRectMake(0, 0, kMainScreenWidth, 76 * SCALE6);
    [self.navigationBar addSubview:topImgV];
    _navigationBarBackImageView = topImgV;
    
    [self leftNavBtn];
    
    [self rightNavBtn];
    
    [self topFunctionView];
    //懒加载初始化顶部功能视图

    
//    [self reloadAdsInfo];
    
    
//    [self reloadBuildingInfo];
    
    //    [self grayLineView];
//    [self initOperationData];
    
    //初始化顶部视图
    self.navigationBar.titleLabel.hidden = YES;
    self.navigationBar.line.hidden = YES;
    //    self.navigationBar.backgroundColor = [UIColor colorWithHexString:@"37AEFF"];
    self.navigationBar.barBackgroundImageView.backgroundColor = [UIColor colorWithHexString:@"37AEFF" alpha:0.0];
//    UIImageView* topIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home-topicon"]];
//    topIcon.frame = CGRectMake((kMainScreenWidth - 80.5 * SCALE6) / 2.0, 64 - 10 - 24 * SCALE6, 80.5 * SCALE6, 24 * SCALE6);
//    [self.navigationBar addSubview:topIcon];
    [self.view bringSubviewToFront:self.navigationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self tableView];
    
    [self.tableView beganHeaderRefresh];
}





#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        return;
    }
    if (_tempArr.count <= indexPath.row - offsetNum) {
        return;
    }
    
    if (!_noResult) {
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_RXLP" andPageId:@"PAGE_SY"];
    }
    
//    XTMapBuildingController* mapVC = [[XTMapBuildingController alloc]init];
//    [self.navigationController pushViewController:mapVC animated:YES];
//    return;
    [MobClick event:@"sy-rxlp"];
    BuildingListData* data = _tempArr[indexPath.row - offsetNum];
    BuildingDetailViewController* detailVc = [[BuildingDetailViewController alloc]init];
    detailVc.buildingId = data.buildingId;
    detailVc.buildDistance = data.buildDistance;

    detailVc.eventId = @"PAGE_SY";
    if ([data.status isEqualToString:@"expired"] || [data.status isEqualToString:@"finished"]) {        
        AlertShow(@"该楼盘合作已到期，无法查看楼盘详情。你可通过左滑列表取消收藏");
        return;
        
    }
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 4 + ((_tempArr.count <= 0)?1:_tempArr.count);
    return num;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 0) {
    //        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TopFunctionView"];
    //        if (!cell) {
    //            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopFunctionView"];
    //            cell.userInteractionEnabled = YES;
    //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //            [cell.contentView addSubview:self.topFunctionView];
    //        }
    //        return cell;
    //    }else
    if(indexPath.row == 0){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"adCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adCell"];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.adAutoScrollView];
        }
        
        return cell;
    }else if(indexPath.row == 1){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"topFunctionView"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topFunctionView"];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.topFunctionView];
        }
        return cell;
    }else if(indexPath.row == 2){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"contentOpeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentOpeCell"];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
            view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
            
            [cell.contentView addSubview:view];

            self.contentOperationView.frame = CGRectMake(0, 10, kMainScreenWidth, 124 * SCALE6 + 0.5);
            [cell.contentView addSubview:_contentOperationView];
//            [cell.contentView addSubview:grayLineView];
        }
        
        cell.contentView.hidden = _operateNoResult;
        return cell;
    }else if (indexPath.row == 3){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"shoucangCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoucangCell"];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XTCollectBuildingTips* tip = [[XTCollectBuildingTips alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
            tip.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
            self.tipsCell = tip;

            [cell.contentView addSubview:tip];
//            [cell.contentView addSubview:grayLineView];
        }

        if (!self.noResult) {
            self.tipsCell.type = XTBuildingTipsTypeHot;
        }else if(self.noResult && _tempArr.count > 0){
            self.tipsCell.type = XTBuildingTipsTypeRecommend;
        }else{
            self.tipsCell.type = XTBuildingTipsTypeNoResult;
        }

        return cell;

    }else {
        if (_tempArr.count > indexPath.row - offsetNum) {
            BuildingListData *listData = _tempArr[indexPath.row - offsetNum];
            //            listData.isTop = NO;
      
            XTHomeBuildingCell* cell = [XTHomeBuildingCell buildingCellWithTableView:tableView];
            cell.listData = listData;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"noResultCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noResultCell"];
                cell.selectionStyle = UITableViewCellSeparatorStyleNone
                ;
            }
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView removeAllSubviews];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return 225 * SCALE6;
    }else if(indexPath.row == 1){
        return self.topFunctionHeight;
    }else if (indexPath.row == 2){
        if (_operateNoResult) {
            return 0.1f;
        }
        return 124 * SCALE6 + 10.5;
    }else if(indexPath.row == 3){
        return 45.0f;
    }
    if (_tempArr.count <= 0) {
        return 0.1f;
    }
    
    return [XTHomeBuildingCell buildingCellHeight];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.navigationBarBackImageView.hidden = offsetY==0?NO:YES;
    self.leftNavBtn.hidden = offsetY<0?YES:NO;
    self.rightNavBtn.hidden = offsetY<0?YES:NO;
    CGFloat alpha = 0.0f;
    CGFloat minOffset = 0;
    CGFloat maxOffset =  225 * SCALE6 - 64 - 20;
    if (offsetY <= minOffset) {
        offsetY = 0.0f;
    }else if(offsetY >= maxOffset){
        offsetY = maxOffset;
    }
    DLog(@"--%f--",offsetY);
    alpha = offsetY / maxOffset;
    self.navigationBar.barBackgroundImageView.backgroundColor = [UIColor colorWithHexString:@"37AEFF" alpha:alpha];
    
}

#pragma mark - getter
- (CGFloat)topFunctionHeight{
    
    return (45 + 40 + 10) * SCALE6*2;
}

- (UIView *)grayLineView{
    if (!_grayLineView) {
        UIView* grayLineView = [[UIView alloc]init];
        [self.topFunctionView addSubview:grayLineView];
        grayLineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
        _grayLineView = grayLineView;
        grayLineView.frame = CGRectMake(0, kMainScreenWidth / 375.0 * 102 - 0.5, kMainScreenWidth, 0.5);
    }
    return _grayLineView;
}

- (UIButton *)selectedCityButton{
    if (!_selectedCityButton) {
        UIButton *cityBtn = [[UIButton alloc]init];
        cityBtn.frame = CGRectMake((kMainScreenWidth-100)/2, 20, 100, 44);
//        NSString *title = [UserData sharedUserData].cityName;
//        if ([UserData sharedUserData].storeName.length > 0) {
            [cityBtn setTitle:@"首页" forState:UIControlStateNormal];
//        }else{
//            [cityBtn setTitle:title forState:UIControlStateNormal];
//            [cityBtn addTarget:self action:@selector(jumpToChooseCity) forControlEvents:UIControlEventTouchUpInside];
//        }
        
//        [cityBtn setTitle:title forState:UIControlStateNormal];
//        [cityBtn addTarget:self action:@selector(jumpToChooseCity) forControlEvents:UIControlEventTouchUpInside];

        [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cityBgView addSubview:cityBtn];
        _selectedCityButton = cityBtn;
    }
    return _selectedCityButton;
}

- (XTContentOperationView *)contentOperationView{
    if (!_contentOperationView) {
        __weak typeof(self) weakSelf = self;
        XTContentOperationView* contentV = [[XTContentOperationView alloc]initWithCallBack:^(XTContentOperationView *view, ContentOperationType type) {
            XTWebNavigationControler* rxV = [[XTWebNavigationControler alloc] initWithURLString:@"http://10.1.2.248/drag.html"];
            switch (type) {
                case ContentOperationTypeNews:{
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_NRZX_ZXZX" andPageId:@"PAGE_SY"];
                    rxV.itemModel = weakSelf.operationModel.recd_news;
                    rxV.titleString = weakSelf.operationModel.recd_news.title;
                }
                    break;
                case ContentOperationTypeNewFunction:{
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_NRZX_MSXGN" andPageId:@"PAGE_SY"];
                    rxV.itemModel = weakSelf.operationModel.recd_features;
                    rxV.titleString = @"魔售新功能";
                }
                    break;
                case ContentOperationTypeProjecRecommendation:{
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_NRZX_XMTJ" andPageId:@"PAGE_SY"];
                    rxV.itemModel = weakSelf.operationModel.recd_project;
                    rxV.titleString = @"项目推荐";
                }
                    break;
                case ContentOperationTypeHeadlines:{
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_NRZX_TTJJR" andPageId:@"PAGE_SY"];
                    rxV.itemModel = weakSelf.operationModel.recd_agency;
                    rxV.titleString = @"头条经纪人";
                }
                    break;
                    
                default:
                    break;
            }
            rxV.showTitleAndMore = YES;
            rxV.isSecondLoad = NO;
            [weakSelf.navigationController pushViewController:rxV animated:YES];
            
        }];
        [self.tableView addSubview:contentV];
        _contentOperationView = contentV;
    }
    return _contentOperationView;
}

/**
 *  初始化运营数据
 */
- (void)initOperationData{
    

    [[DataFactory sharedDataFactory] getContentOperationListWithCityID:[UserData sharedUserData].chooseCityId callBack:^(XTOperationModel *result) {
        if (result) {
            _operateNoResult = NO;
            self.operationModel = result;
            
        }else{
            _operateNoResult = YES;
            self.operationModel = nil;
        }
    } faildCallBack:^(ActionResult *result) {
        if (result.message.length > 0) {
            [self showTips:result.message];
        }
    }];
    
    
}

- (void)setOperationModel:(XTOperationModel *)operationModel{
    _operationModel = operationModel;
    self.contentOperationView.operationModel = operationModel;
    
    [self.tableView reloadData];
//    NSIndexPath* path = [NSIndexPath indexPathWithIndex:2];
//    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 选择城市按钮

//顶部功能视图懒加载,在这里处理点击回调
- (XTTopFunctionView *)topFunctionView{
    if (!_topFunctionView) {
        __weak typeof(self) weakSelf = self;
        XTTopFunctionView* topFunctionV = [XTTopFunctionView topFunctionViewWith:^(XTTopFunctionButton *funcBtn, XTTopFunctionType event) {
            switch (event) {
                case XTTopFunctionTypeQuickRecommend:{
                    [MobClick event:@"sy_ksbb"];
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_KSBB" andPageId:@"PAGE_SY"];
                    if ([weakSelf verifyTheRulesWithShouldJump:NO]) {
                        QuickReportViewController *quickVC = [[QuickReportViewController alloc] init];
                        [weakSelf.navigationController pushViewController:quickVC animated:YES];
                    }
                    else{
                        [weakSelf showTips:@"请先绑定门店才能使用功能哦~"];
                    }
                }
                    break;
                case XTTopFunctionTypeAddCustomer:{
                    [MobClick event:@"sy_tjkh"];
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_TJKH" andPageId:@"PAGE_SY"];
                    CustomerOperationViewController *operationVC = [[CustomerOperationViewController alloc] init];
                    operationVC.customerViewCtrlType = kAddNewCustomer;
                    [weakSelf.navigationController pushViewController:operationVC animated:YES];
                }   break;
                case XTTopFunctionTypeWorkReport:{
                    [MobClick event:@"sy_gzbb"];
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GZBB" andPageId:@"PAGE_SY"];
                    if ([weakSelf verifyTheRulesWithShouldJump:NO]) {
                        XTWorkReportingController* workReporting = [[XTWorkReportingController alloc]init];
                        [weakSelf.navigationController pushViewController:workReporting animated:YES];
                                            }
                    else{
                        [weakSelf showTips:@"请先绑定门店才能使用功能哦~"];
                    }
                }   break;
                case XTTopFunctionTypeRecommendRecord:{
                    [MobClick event:@"sy_bbjl"];
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BBJL" andPageId:@"PAGE_SY"];
                    if ([weakSelf verifyTheRulesWithShouldJump:NO]) {
                        RecommendRecordController* rrVC = [[RecommendRecordController alloc]init];
                        [weakSelf.navigationController pushViewController:rrVC animated:YES];
                    }
                    else{
                        [weakSelf showTips:@"请先绑定门店才能使用功能哦~"];
                    }
                }
                    break;

                case XTTopFunctionTypeMapFindRoom:{
                  
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_DTZF" andPageId:@"PAGE_SY"];

                    XTMapBuildingController* VC = [[XTMapBuildingController alloc]init];
                    
                    [self.navigationController pushViewController:VC animated:YES];
                    

                    
                }
                    break;
                case XTTopFunctionTypeOverseasEasteBtn:{
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_HWFC" andPageId:@"PAGE_SY"];

                    OverseasEstateViewController *VC = [[OverseasEstateViewController alloc]init];
                    
                    [self.navigationController pushViewController:VC animated:YES];
                    
                }
                    break;
                    
                    
                case XTTopFunctionTypeCar:{
//                    [MobClick event:@"sy_bbjl"];
//                    if ([weakSelf verifyTheRulesWithShouldJump:NO]) {
                    [MobClick event:@"sy_yckf"];
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_YCKF" andPageId:@"PAGE_SY"];
                        XTAppointmentCarRecordController* apprecord  = [[XTAppointmentCarRecordController alloc]init];
                        [weakSelf.navigationController pushViewController:apprecord animated:YES];

//                    }
//                    else{
//                        [weakSelf showTips:@"请先绑定门店才能使用功能哦~"];
//                    }
                }
                    break;
                    
                case XTTopFunctionTypeNeighborPropertie:{
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LCZY" andPageId:@"PAGE_SY"];

                    NeighborPropertieViewController *VC = [[NeighborPropertieViewController alloc]init];
                    
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        //        [self.tableView addSubview:topFunctionV];
        [self.tableView addSubview:topFunctionV];
        _topFunctionView = topFunctionV;
        _topFunctionView.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, self.topFunctionHeight);
    }
    return _topFunctionView;
}
//广告自动滚动视图懒加载
- (ToolAutoScrView *)adAutoScrollView{
    if (!_adAutoScrollView) {
        ToolAutoScrView* tooView = [[ToolAutoScrView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 225 * SCALE6)];
        [self.tableView addSubview:tooView];
        _adAutoScrollView = tooView;
    }
    return _adAutoScrollView;
}

- (UIButton *)leftNavBtn{
    if (!_leftNavBtn) {
        ProposeNavigationBarLeftButton * button = [ProposeNavigationBarLeftButton proposeButtonWithNormalImage:@"home-quesion" selecgtedImage:@"home-quesion"];// iconfont-yijianfankui-4   @"iconfont-yijianfankui-4-firstdown"
        button.frame = CGRectMake(0, 20,44, 44);
        [self.navigationBar addSubview:button];
        [button addTarget:self action:@selector(proposeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationBar.leftBarButton.hidden = YES;
        _leftNavBtn = button;
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn{
    if (!_rightNavBtn) {
        MessageCenterNavigationButton* button = [MessageCenterNavigationButton messageCenterButtonWithNormalImage:@"home-message" selecgtedImage:@"home-message"];
        button.frame = CGRectMake(self.view.frame.size.width - 44, 20,44,44);
        [button addTarget:self action:@selector(messageCenterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:button];
        _rightNavBtn = button;
        self.messageDot.hidden = YES;
    }
    return _rightNavBtn;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIImageView *)messageDot{
    if (!_messageDot) {
        UIImageView* dotView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot-7"]];
        dotView.frame = CGRectMake(self.view.frame.size.width - 14 - 8, 26, 16, 16);
        [self.navigationBar addSubview:dotView];
        dotView.backgroundColor = [UIColor redColor];
        dotView.clipsToBounds = YES;
        dotView.layer.cornerRadius = dotView.frame.size.width/2;
        dotView.hidden = YES;
        UILabel* numLabel = [[UILabel alloc]init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.font = [UIFont systemFontOfSize:11];
        numLabel.frame = dotView.bounds;
        [dotView addSubview:numLabel];
        _numLabel = numLabel;
        _numLabel.text = @"";
        _messageDot = dotView;
        dotView.hidden = YES;
    }
    return _messageDot;
    
}

- (UITableView *)tableView{
    if (!_tableView) {
//        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        UITableView* tableView = [[UITableView alloc]init];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        tableView.frame = CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 49);
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        _tableView = tableView;
        __weak typeof(self) weakSelf = self;
        [tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf reloadAdsInfo];
            [weakSelf reloadDot];
            [weakSelf reloadBuildingInfo];
            [weakSelf initOperationData];
        }];
        
//        [tableView headerRefresh:^{
//            [weakSelf reloadBuildingInfo];
//            [weakSelf initOperationData];
//        }];
        
        
        [tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf requestMorePage];
        }];
        
//        [tableView footerRefresh:^{
//            [weakSelf requestMorePage];
//        }];
        
//        [tableView setFooterViewHidden:YES];
        
        tableView.legendFooter.hidden = YES;
        tableView.contentOffset = CGPointMake(0, 0);
    }
//    _tableView.contentInset = UIEdgeInsetsZero;
    return _tableView;
}

#pragma mark - 常见问题按钮点击
- (void)proposeBtnClick:(UIButton*)btn{
    [MobClick event:@"sy_cjwt"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_CJWT" andPageId:@"PAGE_SY"];
    CommonProblemViewController* baseVC = [[CommonProblemViewController alloc]init];
//    XTWebNavigationControler* baseVC = [[XTWebNavigationControler alloc]initWithURLString:kFullUrlWithSuffix(@"/admin/module/EstateHtml/qalist.html")];

//    baseVC.navTitle = @"常见问题";
    [self.navigationController pushViewController:baseVC animated:YES];
}

#pragma mark - 消息中心按钮点击
- (void)messageCenterBtnClick:(UIButton*)btn{
    [MobClick event:@"sy_xxzx"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_XXZX" andPageId:@"PAGE_SY"];
    MessageListViewController* baseVC = [[MessageListViewController alloc]init];
    [self.navigationController pushViewController:baseVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择城市按钮点击
- (void)jumpToChooseCity{
    ChooseCityViewController* chooseCityVC = [[ChooseCityViewController alloc]init];
    chooseCityVC.hiddenLeftButton = [UserData sharedUserData].cityId.length > 0?NO:YES;
    [self presentViewController:chooseCityVC animated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* cityid = [UserData sharedUserData].cityId;
    if (cityid.length==0 && !firstLoad) {
        if ([UserData sharedUserData].isUserLogined) {
            
            [self jumpToChooseCity];
        }
    }

    UIViewController* topVc = self.navigationController.topViewController;
    if ([UserData sharedUserData].isUserLogined) {
        
        [self shouldShowHomePageFirstTimeShowImg];
       
    }
    //_operateNoResult = ![NetworkSingleton sharedNetWork].isNetworkConnection || !_operationModel;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self reloadBuildingInfo];
//    [self reloadAdsInfo];
//    [self initOperationData];
    [self reloadDot];
    //    NSString* userCity = [UserData sharedUserData].theCityName;
    //    if (userCity.length > 0 && userCity.class != [NSString class]) {
    //    }else{
    //        if ([UserData sharedUserData].isSignIn) {
    //            [self jumpToChooseCity];
    //        }
    //    }
    [[AccountServiceProvider sharedInstance] getUserInfo:^(ResponseResult *result) {
        if (result.success) {
            [UserData sharedUserData].userInfo = result.data;
        }
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)reloadBuildingInfo{
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self.tableView.legendHeader endRefreshing];
        //return;
    }
    // 我的收藏列表   dataArray;//数据列表   里面是Building
//    UIImageView *loadingView;
    //if (!self.isRefresh)
    //{
//        loadingView = [self setRotationAnimationWithView];
    //}else return;
    _page = 1;
    __weak typeof(self) weakSelf = self;
    
    [[DataFactory sharedDataFactory] getBannerBuildingWithPage:@"1" cityID:[UserData sharedUserData].chooseCityId callBack:^(DataListResult* result){
        NSMutableArray* arrayM = [NSMutableArray arrayWithArray:result.dataArray];
        result.dataArray = arrayM;
        
        if (arrayM.count > 0) {
            [_tableView.legendHeader endRefreshing];
        }
        
        if(arrayM.count <= 0){
            [_tempArr removeAllObjects];
        }
        if (result)
        {
            
            if (weakSelf.page==1) {
                [_tempArr removeAllObjects];
            }
            
            if (result.dataArray.count > 0) {
                _tempArr = [NSMutableArray arrayWithArray:result.dataArray];
                //保存热销楼盘名称到userdata
                NSMutableArray *buildingNameArray = [NSMutableArray array];
                
                for ( BuildingListData *buildingData in result.dataArray)
                {
                    [buildingNameArray appendObject:buildingData.name];
                }
                
                [UserData sharedUserData].hotBuildingNameArray = buildingNameArray;
            }else if([UserData sharedUserData].hotBuildingNameArray.count>0){
                [[UserData sharedUserData].hotBuildingNameArray removeAllObjects];

            }
            
            
            [weakSelf.tableView.legendFooter setHidden:!result.morePage];

        }else{
            [weakSelf.tableView.legendFooter setHidden:YES];
        }
        weakSelf.noResult = _tempArr.count <= 0;
        
        weakSelf.isRefresh = NO;
        if(result.dataArray.count <= 0 && result.morePage == NO){
            [weakSelf requestRecommendedBuildingList];
        }else if(_tempArr.count > 0){
            
            [weakSelf.tableView reloadData];
        }
    }];
    
    self.isRefresh = YES;
    
    //    [self reloadAdsInfo];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.adAutoScrollView stopScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.adAutoScrollView beginScroll];
}

#pragma mark - 请求楼盘列表推荐楼盘
- (void)requestRecommendedBuildingList{
    [[DataFactory sharedDataFactory] findRecommendEstateWithNumber:nil andIsHomePage:YES AndCityId:nil withCallBack:^(DataListResult *result) {
        self.isRefresh = NO;
        [_tableView.legendHeader endRefreshing];
        _tempArr = [NSMutableArray arrayWithCapacity:5];
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
                if ( [UserData sharedUserData].hotBuildingNameArray.count > 0 ) {
                    [[UserData sharedUserData].hotBuildingNameArray removeAllObjects];
                }
                [_tableView reloadData];
            }
        }
    }];
    self.isRefresh = YES;
}

- (void)requestMorePage{
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self.tableView.legendFooter endRefreshing];
        return;
    }
    // 我的收藏列表   dataArray;//数据列表   里面是Building
//    UIImageView *loadingView;
    if (!self.isRefresh)
    {
//        loadingView = [self setRotationAnimationWithView];
    }else return;
    _page += 1;
    __weak typeof(self) weakSelf = self;
    
    if (!_noResult) {
        [[DataFactory sharedDataFactory] getBannerBuildingWithPage:[NSString stringWithFormat:@"%ld",(long)_page] cityID:[UserData sharedUserData].chooseCityId callBack:^(DataListResult* result){
            NSMutableArray* arrayM = [NSMutableArray arrayWithArray:result.dataArray];
            result.dataArray = [result.dataArray arrayByAddingObjectsFromArray:arrayM];
            
            [_tableView.legendHeader endRefreshing];
            if(arrayM.count <= 0){
                [_tempArr removeAllObjects];
            }
            if (result)
            {
                
                if (weakSelf.page==1) {
                    [_tempArr removeAllObjects];
                    //                self.tableView.footer.hidden = NO;
                    //                self.tableView.header.hidden = NO;
                }
                
                if (result.dataArray.count > 0) {
                    _tempArr = [NSMutableArray arrayWithArray:result.dataArray];
                    //保存热销楼盘名称到userdata
                    NSMutableArray *buildingNameArray = [NSMutableArray array];
                    
                    for ( BuildingListData *buildingData in result.dataArray)
                    {
                        [buildingNameArray appendObject:buildingData.name];
                    }
                    
                    [UserData sharedUserData].hotBuildingNameArray = buildingNameArray;
                }
                
                
                [weakSelf.tableView.legendFooter setHidden:!result.morePage];
                
            }else{
                [weakSelf.tableView.legendFooter setHidden:YES];
            }
            weakSelf.noResult = _tempArr.count <= 0;
            
            weakSelf.isRefresh = NO;
            if(result.dataArray.count <= 0 && result.morePage == NO){
                //[weakSelf requestRecommendedBuildingList];
            }else if(_tempArr.count > 0){
                
                [weakSelf.tableView reloadData];
            }
        }];
        return;
    }
}

- (void)reloadAdsInfo{
//    if([NetworkSingleton sharedNetWork].isNetworkConnection)  
    {
        [[DataFactory sharedDataFactory] getHomeAdvertisementsWithCallback:^(NSArray *result) {
            [self.adAutoScrollView refreshAdsWithAdsArray:[NSMutableArray arrayWithArray:result] andVC:self];
        } failedCallBack:^(ActionResult *result) {
            if(result != nil){
            [self showTips:result.message];
            }
        }];
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [weakSelf.tableView setEditing:false animated:true];
        
        
        if (_tempArr.count > indexPath.row - 4) {
            [MobClick event:@"sy_qxsc"];
            BuildingListData *listData = [_tempArr objectForIndex:indexPath.row - 4];
            Building* build = [[Building alloc]init];
            build.buildingId =listData.buildingId;
            [[DataFactory sharedDataFactory] cancelFavoriteWithBuilding:build withCallBack:^(ActionResult *result) {
                if (result.success) {
//                    [weakSelf showTips:@"取消收藏成功"];
                    [weakSelf reloadBuildingInfo];
                }else{
//                    [weakSelf showTips:@"取消收藏失败"];
                }
            }];
        }
       
        
    };
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"取消收藏"] handler:rowActionHandler];
    
    return @[action1];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
static int msgNum = 0;
- (void)reloadDot{
    __weak typeof(self) weakSelf = self;
   
    
    self.numLabel.text = @"";
    msgNum = 0;
    [[DataFactory sharedDataFactory] getUnreadCntWithCallBack:^(NSNumber *num) {
        if (num.intValue > 0) {
            msgNum += num.intValue;
        }
        self.numLabel.text = [NSString stringWithFormat:@"%d",msgNum];
        if (msgNum > 0 ){
            [weakSelf.messageDot setHidden:NO];
        }else{
            [weakSelf.messageDot setHidden:YES];
        }
            [weakSelf setupUnreadMessageCount];
    } faildCallBack:^(ActionResult *result) {
        self.numLabel.text = @"";
    }];
}

/**
 刷新未读消息数
 */
- (void)setupUnreadMessageCount{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
     }
    unreadCount += msgNum + [[UserData sharedUserData].userInfo.offlineMsgCount integerValue];
    NSString* numStr = [NSString stringWithFormat:@"%ld",unreadCount];

    if (unreadCount > 0 ){
        if (unreadCount <= 99) {
            
            [self.numLabel setFont:[UIFont systemFontOfSize:11]];
        }else{
            numStr = @"99+";
            [self.numLabel setFont:[UIFont systemFontOfSize:8]];
        }
        [self.numLabel setText:numStr];
        [self.messageDot setHidden:NO];
    }else{
        [self.messageDot setHidden:YES];
    }
    [self.view setNeedsDisplay];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber: unreadCount];
}

- (void)reloadHomePage:(NSNotification*)noti{
    
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        
        return;
    }
    if ([UserData sharedUserData].isUserLogined) {
        if (![self isBlankString:noti.object]) {
            bIsPopAlert = [noti.object boolValue];
            [self showEmployeeAlert];
        }
    }
    [self reloadHomePage];
    
    [[DataFactory sharedDataFactory] getCityListWithCallBack:^(NSArray *indexArray, NSArray *dataArray) {
        
    }];
}


- (void)reloadHomePage{
    
    [self.tableView.legendHeader beginRefreshing];
    
//    [self reloadAdsInfo];
//    [self reloadBuildingInfo];
//    [self reloadDot];
//    [self initOperationData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 新装app首次打开引导页 begin
//是否展示 使用帮助 引导图（新装app 首次打开展示）
- (void) shouldShowHomePageFirstTimeShowImg
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"homePage_FirstTimeShow"])
    {
        [self showFirstTimeDisplayImg];
    }
}
//展示引导图
- (void) showFirstTimeDisplayImg
{
    if (_helpView) {
        [_helpView removeFromSuperview];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIButton *imgBtn_manage = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn_manage.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    imgBtn_manage.tag = 5000;
    [imgBtn_manage addTarget:self action:@selector(removeFirstTimeDisplayImg:) forControlEvents:UIControlEventTouchUpInside];
    _helpView = imgBtn_manage;
    if (iPhone4) {
        
        [imgBtn_manage setImage:[UIImage imageNamed:@"960mine"] forState:UIControlStateNormal];
        [imgBtn_manage setImage:[UIImage imageNamed:@"960mine"] forState:UIControlStateHighlighted];
        
    }else{
        [imgBtn_manage setImage:[UIImage imageNamed:@"1080mine"] forState:UIControlStateNormal];
        [imgBtn_manage setImage:[UIImage imageNamed:@"1080mine"] forState:UIControlStateHighlighted];
    }
    [self.tabBarController.view addSubview:imgBtn_manage];
    
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
            [imgBtn_detail setImage:[UIImage imageNamed:@"960homePage"] forState:UIControlStateNormal];
            [imgBtn_detail setImage:[UIImage imageNamed:@"960homePage"] forState:UIControlStateHighlighted];
            
        }else{
            [imgBtn_detail setImage:[UIImage imageNamed:@"1080homePage"] forState:UIControlStateNormal];
            [imgBtn_detail setImage:[UIImage imageNamed:@"1080homePage"] forState:UIControlStateHighlighted];
        }
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [self.tabBarController.view addSubview:imgBtn_detail];
        
    }else if (btn.tag == 5001){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"homePage_FirstTimeShow"];
        
        [btn removeFromSuperview];
        
        
    }
    
}






@end
