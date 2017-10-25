//
//  XTAppointmentCarRecordController.m
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTAppointmentCarRecordController.h"
#import "XTSearchTextField.h"
#import "XTAppointmentCarView.h"
#import "XTAppointmentRecordView.h"
#import "DataFactory+Main.h"
#import "DataFactory.h"
#import "CarDetailViewController.h"
#import "CarRecordListModel.h"
#import "SeeAboutTheCarObject.h"
#import "CarReportedRecordModel.h"
#import "SeeAboutCarViewController.h"
#import "AdShowViewController.h"

@interface XTAppointmentCarRecordController ()<UITextFieldDelegate>

//是约车记录
@property (nonatomic,assign)BOOL isRecord;

@property (nonatomic,weak)UISegmentedControl* segment;

@property (nonatomic,weak)XTSearchTextField* searchField;


/**
 *  约车
 */
@property (nonatomic,weak)XTAppointmentCarView* appointCarView;

/**
 *  约车记录
 */
@property (nonatomic,weak)XTAppointmentRecordView* appointRecordView;

@property (nonatomic,weak)UIView* bottomContentView;

/**
 *  动画视图
 */
@property (nonatomic,weak)UIImageView* animationView;

@property (nonatomic,weak)UIView* backView;

@end

@implementation XTAppointmentCarRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"约车看房";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    _isRecord = NO;
//    [self commonInit];
    [self reloadInfo];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

/**
 *  初始化
 */
- (void)commonInit{
//    self.navigationBar.titleLabel.text = @"看房专车";
    [self searchField];
    [self backView];
    self.segment.frame = CGRectMake((kMainScreenWidth-200*SCALE6)/2,_backView.frame.origin.y + 10 * SCALE6, 200*SCALE6,30 * SCALE6);
    CGFloat bottomHeight = 49 * SCALE6;
    if (self.bottomContentView.hidden == YES) {
        bottomHeight = 0.0f;
    }
    self.appointCarView.frame = CGRectMake(0, CGRectGetMaxY(_backView.frame), kMainScreenWidth, self.view.frame.size.height - CGRectGetMaxY(_backView.frame) - bottomHeight);
    self.appointRecordView.frame = CGRectMake(0, CGRectGetMaxY(_backView.frame) - 10 * SCALE6, kMainScreenWidth, self.view.frame.size.height - CGRectGetMaxY(_backView.frame) - bottomHeight +  10 * SCALE6);
    
    [self.view bringSubviewToFront:_appointCarView];
    _appointCarView.keyword = @"";
    _appointRecordView.keyword  = @"";
}

- (UIView *)backView{
    if (!_backView) {
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchField.frame) + 8 *SCALE6, kMainScreenWidth, 50 * SCALE6)];
        [self.view addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        _backView = backView;
    }
    return _backView;
}


#pragma mark - getter
- (UISegmentedControl *)segment{
    if (!_segment) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"即刻约车",@"约车记录",nil];
        
        UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        [seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//        seg.frame =CGRectMake((kMainScreenWidth-200*SCALE6)/2,, 200*SCALE6,30);
        seg.tintColor = BLUEBTBCOLOR;
        seg.selectedSegmentIndex = 0;
        seg.userInteractionEnabled = YES;
        [self.view addSubview:seg];
        _segment = seg;
    }
    return _segment;
}

- (XTSearchTextField *)searchField{
    if (!_searchField) {
        XTSearchTextField* field = [[XTSearchTextField alloc]init];
        field.frame = CGRectMake(10, 64+8* SCALE6, kMainScreenWidth - 20, 30);
        field.placeHolderString = @"客户姓名/手机号/楼盘名称";
        [field addTarget:self action:@selector(searchFieldChange:) forControlEvents:UIControlEventEditingChanged];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:field];
        field.keyboardType = UIKeyboardTypeDefault;
        field.delegate = self;
        _searchField = field;
    }
    return _searchField;
}

- (void)searchFieldChange:(UITextField*)field{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [MobClick event:@"yckf_ssxw"];
    if (!_isRecord) {
        _appointCarView.keyword = textField.text;
    }else{
        _appointRecordView.keyword = textField.text;
    }
    [textField endEditing:YES];
    return YES;
}


- (void)segmentAction:(UISegmentedControl*)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            _isRecord = NO;
            //即刻约车
            [self.view bringSubviewToFront:_appointCarView];
            
        }
            break;
        case 1:
        {
            //约车记录
            _isRecord = YES;
            [self.view bringSubviewToFront:_appointRecordView];
        }
            break;
        default:
            break;
    }
}

- (XTAppointmentCarView *)appointCarView{
    if (!_appointCarView) {
        __weak typeof(self) weakSelf = self;
        XTAppointmentCarView* carView = [[XTAppointmentCarView alloc] initWithCallBack:^(XTAppointmentCarView *view, XTAppointmentCarViewEvent event, CarReportedRecordModel *model) {
            switch (event) {
                case XTAppointmentCarViewEventScroll:{
                    [weakSelf.searchField endEditing:YES];
                }
                    break;
                case XTAppointmentCarViewEventTrystCar:{
                    [MobClick event:@"yckf_quyc"];
                    SeeAboutTheCarObject* obj = [[SeeAboutTheCarObject alloc] init];
                    obj.estateName = model.buildingName;
                    obj.customerName = model.name;
                    if (model.phoneList.count > 0) {
                        MobileVisible* mobile = [model.phoneList firstObject];
                        obj.customerMobile = mobile.hidingPhone;
                    }
                    obj.buildingId = model.buildingId;
                    obj.estateCustomerId = model.buildingCustomerId;
                    obj.trystCarTime = model.trystCarTime;
                    obj.trystTimeType = model.trystTimeType;
                    SeeAboutCarViewController* seeVc = [[SeeAboutCarViewController alloc]init];
                    seeVc.carObject = obj;
                    [weakSelf.navigationController pushViewController:seeVc animated:YES];
                }
                    break;
                case XTAppointmentCarViewEventSelected:{
                    
                }
                    break;
                case XTAppointmentCarViewBegainAnimation:{
                    [weakSelf begainAnimation];
                }
                    break;
                case XTAppointmentCarViewEndAnimation:{
                    [weakSelf endAnimation];
                }
                    break;
                default:
                    break;
            }
        }];
        [self.view addSubview:carView];
        _appointCarView = carView;
    }
    return _appointCarView;
}


/**
 *  约车记录
 */
- (XTAppointmentRecordView *)appointRecordView{
    if (!_appointRecordView) {
        __weak typeof(self) weakSelf = self;
        XTAppointmentRecordView* recordView = [[XTAppointmentRecordView alloc] initWithCallBack:^(XTAppointmentRecordView *view, XTAppointmentRecordViewEvent event, CarRecordListModel *model) {
            switch (event) {
                case XTAppointmentRecordViewEventScroll:{
                    [weakSelf.searchField endEditing:YES];
                }
                    break;
                case XTAppointmentRecordViewEventSelected:{//选中了某行
//                    estateAppointCarID
                    [MobClick event:@"ycjl_ycxq"];
                    CarDetailViewController* detailVc =[[CarDetailViewController alloc]init];
                    detailVc.estateAppointCarID = model.estateAppointCarID;
                    [weakSelf.navigationController pushViewController:detailVc animated:YES];
                }
                    break;
                case XTAppointmentRecordViewEventBegainAnimation:{//开始动画
                    [weakSelf begainAnimation];
                }
                    break;
                case XTAppointmentRecordViewEventEndAnimation:{//结束动画
                    [weakSelf endAnimation];
                }
                    break;
                default:
                    break;
            }
        }];
        [self.view addSubview:recordView];
        _appointRecordView = recordView;
    }
    return _appointRecordView;
}


- (void)begainAnimation{
    if (self.animationView) {
        return;
    }
    self.animationView = [self setRotationAnimationWithView];
}

- (void)endAnimation{
    [self removeRotationAnimationView:self.animationView];
    self.animationView = nil;
}

- (UIView *)bottomContentView{
    if (!_bottomContentView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 * SCALE6, kMainScreenWidth, 49 * SCALE6)];
        view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        UILabel* tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, (49 * SCALE6 - 15)/2.0, kMainScreenWidth / 2.0, 15)];
        tipsLabel.font = [UIFont systemFontOfSize:15];
        tipsLabel.textColor = [UIColor colorWithHexString:@"1d9fea"];
        tipsLabel.text = @"如何玩转约车看房？";
        [view addSubview:tipsLabel];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth - 76* SCALE6 - 8, (49 * SCALE6 - 25 * SCALE6)/2.0, 76 * SCALE6, 25 * SCALE6)];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 4.0f;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.layer.borderColor = [UIColor colorWithHexString:@"1d9fea"].CGColor;
        [btn setTitleColor:[UIColor colorWithHexString:@"1d9fea"] forState:UIControlStateNormal];
        [btn setTitle:@"了解详情" forState:UIControlStateNormal];
        btn.layer.borderWidth = 1.0f;
        [btn addTarget:self action:@selector(readMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"d9d9db"];
        [view addSubview:line];
        
        [self.view addSubview:view];
        _bottomContentView = view;
    }
    return _bottomContentView;
}

- (void)readMoreBtnClick:(UIButton*)btn{
    AdShowViewController* showVc = [[AdShowViewController alloc]init];
    showVc.name = @"如何玩转约车看房";
    [MobClick event:@"yckf_help"];
    if (![[[LocalFileSystem sharedManager].baseURL lastPathComponent] isEqualToString:@"/"]) {
        showVc.adUrl = [NSString stringWithFormat:@"%@/admin/module/EstateHtml/houseCar.html",[LocalFileSystem sharedManager].baseURL ];
    }else{
        showVc.adUrl = [NSString stringWithFormat:@"%@admin/module/EstateHtml/houseCar.html",[LocalFileSystem sharedManager].baseURL ];
    }
    
    [self.navigationController pushViewController:showVc animated:YES];
}

- (void)reloadInfo{
    __weak typeof(self) weakSelf = self;
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self createNoNetWorkViewWithReloadBlock:^{
            [weakSelf reloadInfo];
        }];
    }else{
//        [self.view removeAllSubviews];
        [self commonInit];
    }
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
