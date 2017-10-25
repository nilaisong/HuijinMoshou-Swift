//
//  RecommendRecordController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/23.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "RecommendRecordController.h"
//#import "RecommendRecordDetailController.h"//delete by wangzz 170317
#import "BuildFollowDetailViewController.h"//add by wangzz 170317

#import "RecommendationRecordView.h"
#import "XTNavigationBarRightButton.h"
#import "FMDBSource+Broker.h"
#import "RecommendRecordOptionModel.h"
#import "CustomerGroup.h"
#import "CustomerCountByGroup.h"

#import "XTQrCodeView.h"

#import "DataFactory+Main.h"

#import "EncodingView.h"

#import "MobileVisible.h"
#import "CustomerReportedRecord.h"
#import "CustomerReportedDetailModel.h"

@interface RecommendRecordController ()<RecommendationRecordViewDelegate,UITextFieldDelegate>

//报备记录视图
@property (nonatomic,weak)RecommendationRecordView* rrView;

//导航栏右侧搜索按钮
@property (nonatomic,weak)UIButton* rightBtn;

//提示文字数组
@property (nonatomic,strong)NSMutableArray* promptArray;


@property (nonatomic,strong)UIView *searchView;

@property (nonatomic,weak)UIImageView* loadingView;

@property (nonatomic,weak)UITextField* searchTextField;
@end

@implementation RecommendRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
// Do any additional setup after loading the view.
// 关闭侧滑返回
//    self.popGestureRecognizerEnable = NO;
    
//    RecommendRecordDetailController* detailVc = [[RecommendRecordDetailController alloc]init];
//    [self.navigationController pushViewController:detailVc animated:true];
    
    [self commonInit];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)commonInit{
    self.navigationBar.titleLabel.text = self.customTitle;
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-37, 20, 40, 44)];
    [searchBtn setImage:[UIImage imageNamed:@"iconfont-sousuo-highlight"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"iconfont-sousuo-down"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:searchBtn];
    _rightBtn = searchBtn;
    
//    if (![self createNoNetWorkViewWithReloadBlock:^{[blockSelf getfirstPage];}]) {
//                    [self getfirstPage];
//    }
//    [self rrView];
    
    [self hasNetwork];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListViewInfo) name:@"ReloadRecommendRecordListInfo" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadListViewInfo{
    self.rrView.keyword = _searchTextField.text;
}

#pragma mark - getter
//报备记录视图懒加载
- (RecommendationRecordView *)rrView{
    if (!_rrView) {
        RecommendationRecordView* rrView = [[RecommendationRecordView alloc]init];
        rrView.delegate = self;
        
        rrView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height);
        rrView.currentIndex = _currentIndex;
        [self.view addSubview:rrView];

        
//        [rrView addObserver:self forKeyPath:@"rrListView.panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];

        _rrView = rrView;
    }
    return _rrView;
}

- (NSString *)customTitle{
    if (!_customTitle || _customTitle.length <= 0) {
        _customTitle = @"报备记录";
    }
    return _customTitle;
}

//- (XTNavigationBarRightButton *)rightBtn{
//    if (!_rightBtn) {
//        XTNavigationBarRightButton* right = [XTNavigationBarRightButton navRightButtonWithNormalImage:@"iconfont-sousuo" selecgtedImage:@"iconfont-sousuo-down"];
//        [right addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        right.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44, 20, 44,44);
//        [self.navigationBar addSubview:right];
//        _rightBtn = right;
//    }
//    return _rightBtn;
//}


-(void)searchBtnClick:(UIButton *)sender
{
    static UITextField *searchTF = nil;
    if (self.searchView==nil)
    {
        self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 63)];
        UIView *bgVIew = [[UIView alloc]initWithFrame:CGRectMake(10, 27.5, kMainScreenWidth-10-50, 29)];
        bgVIew.layer.cornerRadius = 5;
        bgVIew.layer.masksToBounds = YES;
        bgVIew.backgroundColor = UIColorFromRGB(0xd9d9db);
        [self.searchView addSubview:bgVIew];
        
        UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 15, 15)];
        [searchIcon setImage:[UIImage imageNamed:@"iconfont-sousuo-hui"]];
        [bgVIew addSubview:searchIcon];
        
    
//        searchTF = [[UITextField alloc]initWithFrame:CGRectMake(kFrame_XWidth(searchIcon)+5, 0, kFrame_Width(bgVIew)-kFrame_XWidth(searchIcon), 29)];
//        searchTF.placeholder = @"请输入楼盘名/客户名/手机号搜索";
//        searchTF.textAlignment = NSTextAlignmentLeft;
//        searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        searchTF.delegate = self;
//        searchTF.returnKeyType = UIReturnKeySearch;
//        [bgVIew addSubview:searchTF];
        
    
        searchTF = [[UITextField alloc]initWithFrame:CGRectMake(kFrame_XWidth(searchIcon)+5, 0, kFrame_Width(bgVIew)-kFrame_XWidth(searchIcon)-30, 29)];
        searchTF.placeholder = @"请输入楼盘名/客户名/手机号搜索";
        searchTF.textAlignment = NSTextAlignmentLeft;
        searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchTF.delegate = self;
        searchTF.clearsOnBeginEditing = YES;
//        [searchTF becomeFirstResponder];
        searchTF.returnKeyType = UIReturnKeySearch;
        [bgVIew addSubview:searchTF];
        _searchTextField = searchTF;
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-50, 20, 50, 44)];
        [cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [cancelBtn setTitle:@"取消" forState:UIControlStateSelected];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.searchView addSubview:cancelBtn];
    }
    [searchTF becomeFirstResponder];
    self.searchView.backgroundColor = BACKGROUNDCOLOR;
    [self.navigationBar addSubview:self.searchView];
    

    
}

- (NSMutableArray *)promptArray{
    if (!_promptArray) {
        _promptArray = [[NSMutableArray alloc]init];
    }
    return _promptArray;
}

#pragma mark - recommendRecord Delegate
- (void)recommendRecordView:(RecommendationRecordView *)rrView didSelectedCell:(XTCustomerRecordCell *)customerCell{
    [self showDetailWithCustomerRecord:customerCell.customerReportedRecord];
}

- (void)recommendRecordView:(RecommendationRecordView *)rrView didTouchQRBtn:(XTCustomerRecordCell *)customerCell{
    [self showQrCodeWithCustomerRecord:customerCell.customerReportedRecord];
}

- (void)recommendRecordView:(RecommendationRecordView *)rrView netWorkNoConnection:(UITableView *)tableView{
    [self showTips:@"网络连接失败"];
}

- (void)recommendRecordView:(RecommendationRecordView *)rrView startRqeust:(UITableView *)tableView{
    if (_loadingView) {
        return;
    }
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        _loadingView = loadingView;
        self.popGestureRecognizerEnable = NO;
    }

}

- (void)recommendRecordView:(RecommendationRecordView *)rrView stopRequest:(UITableView *)tableView{
    if (_loadingView) {
        [self removeRotationAnimationView:_loadingView];
        _loadingView = nil;
        self.popGestureRecognizerEnable = YES;
    }
}

- (void)recommendRecordView:(RecommendationRecordView *)rrView requestOptionsModels:(NSArray *)optionArray{
    
    __weak typeof(self) weakSelf = self;
//    UIImageView * loadingView = [self setRotationAnimationWithView];
    if (optionArray.count > 0) {
        RecommendRecordOptionModel* model = [optionArray firstObject];
        model.title = @"所有";
    }
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        
        [[DataFactory sharedDataFactory] getCustomerStatusGroupTagWithCallBack:^(NSArray *result) {
            if (!result) {
                return;
            }
            
            RecommendRecordOptionModel* modelFirst = [optionArray firstObject];
            modelFirst.title = @"所有";
            for (int i = 1; i < 10 && result.count >= 9; i++) {
                RecommendRecordOptionModel* model = [optionArray objectForIndex:i];
                CustomerGroup* group = result[i - 1];
                model.title = group.groupName;
                model.groupId = group.groupId;
            }
            weakSelf.rrView.topOptionsView.optionsArray = optionArray;
            self.rrView.hidden = NO;
        } failedCallBack:^(ActionResult *result) {
            [weakSelf showTips:result.message];
        }];
        

        [[DataFactory sharedDataFactory] getCustomerCountByStatusWithKeyword:_searchTextField.text withCallBack:^(NSArray *result) {
            if (!result) {
                return;
            }
            RecommendRecordOptionModel* modelFirst = [optionArray firstObject];
        
            NSInteger total = 0;
            for(int i = 1; i < 10 && result.count >= 9; i++) {
                RecommendRecordOptionModel* model = [optionArray objectForIndex:i];
                CustomerCountByGroup* group = result[i - 1];
                model.dataNumber = group.count;
                total += group.count;
            }
            modelFirst.dataNumber = total;
            weakSelf.rrView.topOptionsView.optionsArray = optionArray;
        }];
        
    }else
    {
//        [self removeRotationAnimationView:loadingView];
    }

}

- (void)requestRecommendListWithKey:(NSString*)keyword{
    
}

#pragma mark - 点击事件响应函数
/**
 *  跳往详情控制器
 */
//modify by wangzz 170317
- (void)showDetailWithCustomerRecord:(CustomerReportedRecord*)customerRecord{
    BuildFollowDetailViewController* detailVC = [[BuildFollowDetailViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getReportedDetailWithBuildingCustomerId:customerRecord.buildingCustomerId callBack:^(CustomerReportedDetailModel *result) {
            CustomerReportedDetailModel *detailModel = [[CustomerReportedDetailModel alloc] init];
            detailModel = result;
            [weakSelf removeRotationAnimationView:loadingView];
            ReportDetailBuilding* building = [detailModel.buildingList firstObject];
            TradeRecord* trade = [[TradeRecord alloc] init];
            trade.expiredate = building.expiredate;
            trade.expiredateFlag = [NSString stringWithFormat:@"%ld",(long)building.expiredateFlag];
            trade.buildingName = building.buildingName;
            trade.buildingCustomerId = [NSString stringWithFormat:@"%ld",(long)building.buildingCustomerId];
            
            NSMutableArray* trackList = [NSMutableArray array];
            for (int i = 0; i < building.buildingTrackList.count; i++) {
                ReportBuildingTrack* track = building.buildingTrackList[i];
                MessageData* trackData = [[MessageData alloc] init];
                trackData.content = track.content;
                trackData.datetime = track.datetime;
                trackData.msgId = track.trackId;
                [trackList appendObject:trackData];
            }
            
            trade.confirmUserName = detailModel.quekeName;
            trade.confirmUserMobile = detailModel.quekePhone;
            
            trade.progress = [NSArray arrayWithObjects:[building.progressList objectForIndex:0], nil];
            //                      for (ProgressStatus* status in building.progressList) {
            //                          trade.messages = status.messages;
            //                          trade.expiredate = building.expiredate;
            //                          trade.expiredateFlag = [NSString stringWithFormat:@"%ld",(long)building.expiredateFlag];
            //                      }
            
            trade.track = trackList;
            
            trade.district = building.district;
            detailVC.trade = trade;
            [self.navigationController pushViewController:detailVC animated:YES];
        } failedCallBack:^(ActionResult *result) {
            [weakSelf removeRotationAnimationView:loadingView];
            if (result.message.length > 0) {
                [weakSelf showTips:result.message];
            }
        }];
        
    }
}//modify end
/**
 *  展示二维码
 */
- (void)showQrCodeWithCustomerRecord:(CustomerReportedRecord*)customerRecord{
    NSLog(@"点击了二维码按钮");
//    XTQrCodeView* qrView = [[XTQrCodeView alloc]init];
//    qrView.frame = self.view.bounds;
//    qrView.code = customerRecord.url;
//    [self.view addSubview:qrView];
//    NSString *custStr = [NSString stringWithFormat:@" %@ (%@) 报备有效",customerRecord.customerName,customerRecord.phonenumber];
    
    
    
    NSString* phoneStr = nil;
    if (customerRecord.phoneList.count > 0) {
        MobileVisible* phone = [customerRecord.phoneList firstObject];
        if (phone.totalPhone.length > 0) {
            phoneStr = phone.totalPhone;
        }else if (phone.hidingPhone.length > 0){
            phoneStr = phone.hidingPhone;
        }
    }
    
    if (![self isBlankString:customerRecord.url]) {
        EncodingView *QRCodeView = [[EncodingView alloc] initWithEncodingString:customerRecord.url withCustomerName:customerRecord.name withPhone:phoneStr];
        [self.view addSubview:QRCodeView];
    }
}

//取消按钮的
-(void)cancelBtnClick:(UIButton *)sender
{
    
    DLog(@"取消按钮的");
    _searchTextField.text = nil;
    [self.searchView removeFromSuperview];
    _rrView.keyword = nil;

}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    _rrView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{


    if (textField.text.length > 0) {
        _rrView.keyword =  textField.text;
    }

    [textField endEditing:YES];
//    [self cancelBtnClick:nil];
    return YES;
}


- (void)hasNetwork
{
    __weak typeof(self) blockSelf= self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//        self.popGestureRecognizerEnable = YES;
        self.rightBtn.hidden = NO;
        [self reloadView];
    }else{
        self.rightBtn.hidden = YES;
//        self.popGestureRecognizerEnable = NO;
        [self createNoNetWorkViewWithReloadBlock:^{
            [blockSelf reloadView];
        }];
    }

}

- (void)reloadView{
    
    __weak typeof(self) weakSelf = self;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        self.popGestureRecognizerEnable = YES;
        self.rightBtn.hidden = NO;
        _rrView = nil;
        self.rrView.hidden = YES;
        [weakSelf rrView];
    }else{
//        self.popGestureRecognizerEnable = NO;
        self.rightBtn.hidden = YES;
    }
    
}

- (void)dealloc{
    [_rrView removeFromSuperview];
    _rrView = nil;
    
    _promptArray = nil;
    _loadingView = nil;

    
    //导航栏右侧搜索按钮
    _rightBtn = nil;
    
    
    _searchView = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


