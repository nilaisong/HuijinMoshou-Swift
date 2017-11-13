//
//  RecommendRecordDetailController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/27.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "RecommendRecordDetailController.h"
#import "XTRecommendRecordDetailView.h"
#import "DataFactory+Main.h"
#import "CustomerEditViewController.h"

#import "CustomerReportedDetailModel.h"

#import "DataFactory+Customer.h"

#import "RemindListViewController.h"
#import "CustAddRemindViewController.h"
#import "BaseNavigationController.h"

#import "ReportDetailBuilding.h"

#import "BuildFollowDetailViewController.h"



@interface RecommendRecordDetailController ()<CustomerRecommendRecordDetailDelegate>

@property (nonatomic,weak)XTRecommendRecordDetailView* detailView;

//报备详情
@property (nonatomic,strong)CustomerReportedDetailModel* detailModel;
@end

@implementation RecommendRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self commonInit];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];    
}

- (void)commonInit{
    self.navigationBar.titleLabel.text = @"报备详情";
    [self detailView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   


#pragma mark - getter

- (XTRecommendRecordDetailView *)detailView{
    if (!_detailView) {
        XTRecommendRecordDetailView* dtailView = [[XTRecommendRecordDetailView alloc]init];
        dtailView.delegate = self;
        dtailView.customerReportedRecord = _customerReportRecord;
        [self.view addSubview:dtailView];
        dtailView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        _detailView = dtailView;
    }
    return _detailView;
}

- (void)setDetailModel:(CustomerReportedDetailModel *)detailModel{
    _detailModel = detailModel;
    self.detailView.detailModel = detailModel;
}

- (void)setCustomerReportRecord:(CustomerReportedRecord *)customerReportRecord{
    _customerReportRecord = customerReportRecord;
    self.detailView.customerReportedRecord = customerReportRecord;
}

#pragma mark - delegate
#pragma mark - 选中了楼盘进度
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedBuilding:(TradeRecord *)trade{
    if (trade) {
        BuildFollowDetailViewController * follVC = [[BuildFollowDetailViewController alloc] init];
        follVC.trade = trade;
        [self.navigationController pushViewController:follVC animated:YES];
    }
}

#pragma mark - 添加提醒
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedAddTrackAction:(CustomerReportedDetailModel *)detailModel{
    CustomerEditViewController *editVC = [[CustomerEditViewController alloc] init];
//    editVC.customerMsgType = kAddFolloMsg;
    __weak typeof(self) weakSelf = self;
    editVC.customerMsdId = [NSString stringWithFormat:@"%ld",(long)_customerReportRecord.buildingCustomerId];
    [editVC returnCustomerEditResultBlock:^() {
        [weakSelf reloadInfo];
    }];
    [self.navigationController pushViewController:editVC animated:YES];
}
#pragma mark - 删除进度（需求已修改）
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedDeleteTrackAction:(NSString *)trackId{
    __weak typeof(self) weakSelf = self;
    [[DataFactory sharedDataFactory]deleteTrackMessageWithTrackId:trackId withCallBack:^(ActionResult *result) {
        [weakSelf showTips:result.message];
    }];
    
    [self reloadInfo];
}

#pragma mark - 二维码
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedQRAction:(NSString *)url{
    DLog(@"点击了二维码按钮");
}

#pragma mark - 点击了跟进提醒
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedClockAction:(CustomerReportedDetailModel *)model{
    Customer* customer = [[Customer alloc]init];
    customer.name = model.customerName;
    customer.sex = model.sex;
    customer.customerId = model.customerId;

    customer.listPhone = model.phone;
    if (model.hasRemind) {
        RemindListViewController *remindVC = [[RemindListViewController alloc] init];
        remindVC.custList = customer;
        [self.navigationController pushViewController:remindVC animated:YES];
    }else{
        CustAddRemindViewController* addRemindVC = [[CustAddRemindViewController alloc]init];
        addRemindVC.custList = customer;
        [self.navigationController pushViewController:addRemindVC animated:YES];
    }
}
#pragma mark - 点击了电话
- (void)CustomerRecommendRecordDetailView:(XTRecommendRecordDetailView *)detailView didSelectedTelAction:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
}

- (void)reloadInfo{
    __weak typeof(self) weakSelf = self;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getReportedDetailWithBuildingCustomerId:_customerReportRecord.buildingCustomerId callBack:^(CustomerReportedDetailModel *result) {
            weakSelf.detailModel = result;
            [weakSelf removeRotationAnimationView:loadingView];
        } failedCallBack:^(ActionResult *result) {
            [weakSelf removeRotationAnimationView:loadingView];
            if (result.message.length > 0) {
                [weakSelf showTips:result.message];
            }
        }];
        
    }
    
}



- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRecommendRecordListInfo" object:nil];
}

@end
