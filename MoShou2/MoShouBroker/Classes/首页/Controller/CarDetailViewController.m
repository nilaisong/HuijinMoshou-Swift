//
//  CarDetailViewController.m
//  MoShou2
//
//  Created by wangzz on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CarDetailViewController.h"
#import "DataFactory+Customer.h"

@interface CarDetailViewController ()//<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) SeeAboutTheCarObject  *carObj;
@property (nonatomic, strong) NSArray        *carArr;
@property (nonatomic, strong) UIWebView      *webView;

@end

@implementation CarDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"约车详情";
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    _carObj = [[SeeAboutTheCarObject alloc] init];
    
    _carArr = [[NSArray alloc] initWithObjects:@"客户姓名:",@"客户电话:",@"约车楼盘:",@"订单编号:",@"约车时间:",@"约车地点:",@"乘车人数:",@"带看司机:",@"司机电话:",@"车  牌  号:", nil];//,@"订单编号:"
    
//    for (int i=0; i<5; i++) {
//    SeeAboutTheCarObject *tempObj = [[SeeAboutTheCarObject alloc] init];
//    NSDate *nowDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    tempObj.subscribeTime = [dateFormatter stringFromDate:nowDate];
//    tempObj.subscribePlace = @"上地七街";
//    tempObj.followStaffCount = @"3人";
//    tempObj.driverName = @"张师傅";
//    tempObj.driverMobile = @"13333333333";
//    tempObj.carNo = @"BT7090";
//    tempObj.orderId = @"drhgyr2";
//    tempObj.customerName = @"应先生";
//    tempObj.customerMobile = @"15525567378";
//    tempObj.estateName = @"首创国际";
//    _carObj = tempObj;
//        [_carArr addObject:tempObj];
//    }
//    [self createUI];
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height - viewTopY)];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
    
    [self hasNetwork];
    
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)hasNetwork
{
    __weak CarDetailViewController *car = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[car reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
    __weak CarDetailViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getTrystCarRecordInfoWithId:_estateAppointCarID withCallBack:^(ActionResult *actionResult, SeeAboutTheCarObject *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![weakSelf removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!actionResult.success) {
                [weakSelf showTips:actionResult.message];
            }
            _carObj = result;
            
            [self createUI];
        });
    }];
    
}

- (void)createUI
{
//    _carObj.driverMobile = @"13312341234";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, 30*3+7*2)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bottom+10, kMainScreenWidth, 0)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(16)};
    CGSize size = [@"客户姓名:" sizeWithAttributes:attributes];
    for (int i=0; i<10; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        if (i==3)
        {
            titleLabel.frame = CGRectMake(16, 7, size.width+5, 30);
        }
        titleLabel.textAlignment = NSTextAlignmentLeft;
        if (_carArr.count > i) {
            titleLabel.text = [_carArr objectForIndex:i];
        }
        titleLabel.font = FONT(16);
        
        
        UILabel *contentL = [[UILabel alloc] init];
        contentL.textColor = NAVIGATIONTITLE;
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.font = FONT(16);
        
        if (i<3) {
            titleLabel.frame = CGRectMake(16, 7+30*i, size.width+5, 30);
            titleLabel.textColor = NAVIGATIONTITLE;
            [headerView addSubview:titleLabel];
            [headerView addSubview:contentL];
        }else
        {
            titleLabel.textColor = LABELCOLOR;
            [bottomView addSubview:titleLabel];
            [bottomView addSubview:contentL];
        }
        UIButton *callBtn = nil;
        switch (i) {
            case 0:
            {
                contentL.text = _carObj.customerName;
            }
                break;
            case 1:
            {
                contentL.text = _carObj.customerMobile;
            }
                break;
            case 2:
            {
                contentL.text = _carObj.estateName;
                [headerView addSubview:[self createLineView:headerView.height - 0.5]];
            }
                break;
            case 3:
            {
                titleLabel.frame = CGRectMake(16, 7, size.width+5, 30);
                contentL.text = _carObj.orderId;
                [bottomView addSubview:[self createLineView:0]];
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+6.5, kMainScreenWidth, 0.5)];
                lineView.backgroundColor = LINECOLOR;
                [bottomView addSubview:lineView];
            }
                break;
            case 4:
            {
                titleLabel.frame = CGRectMake(16, 7+44+30*(i-4), size.width+5, 30);
                contentL.text = _carObj.subscribeTime;
            }
                break;
            case 5:
            {
                titleLabel.frame = CGRectMake(16, 7+44+30*(i-4), size.width+5, 30);
                contentL.text = _carObj.subscribePlace;
            }
                break;
            case 6:
            {
                titleLabel.frame = CGRectMake(16, 7+44+30*(i-4), size.width+5, 30);
                contentL.text = _carObj.followStaffCount;
            }
                break;
            case 7:
            {
                titleLabel.frame = CGRectMake(16, 7+44+10+30*(i-4), size.width+5, 30);
                if ([self isBlankString:_carObj.driverName]) {
                    contentL.textColor = LABELCOLOR;
                    contentL.text = @"待分配";
                }else {
                    contentL.text = _carObj.driverName;
                }
            }
                break;
            case 8:
            {
                titleLabel.frame = CGRectMake(16, 7+44+10+30*(i-4), size.width+5, 30);
                if ([self isBlankString:_carObj.driverMobile]) {
                    contentL.textColor = LABELCOLOR;
                    contentL.text = @"待分配";
                }else {
                    contentL.text = _carObj.driverMobile;
                    if (![_carObj.driverMobile isEqualToString:@"待分配"]) {
                        callBtn = [[UIButton alloc] initWithFrame:CGRectMake(contentL.right + 20, titleLabel.top, 30, 30)];
                        [callBtn setBackgroundColor:[UIColor clearColor]];
                        [callBtn setImage:[UIImage imageNamed:@"button_call"] forState:UIControlStateNormal];
                        [callBtn setImage:[UIImage imageNamed:@"button_call_h"] forState:UIControlStateHighlighted];
                        [callBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [bottomView addSubview:callBtn];
                    }
                }
            }
                break;
            case 9:
            {
                titleLabel.frame = CGRectMake(16, 7+44+10+30*(i-4), size.width+5, 30);
                if ([self isBlankString:_carObj.carNo]) {
                    contentL.textColor = LABELCOLOR;
                    contentL.text = @"待分配";
                }else {
                    contentL.text = _carObj.carNo;
                }
                [bottomView addSubview:[self createLineView:titleLabel.bottom+9.5]];
                bottomView.height = titleLabel.bottom+10;
            }
                break;
                
            default:
                break;
        }
        contentL.frame = CGRectMake(titleLabel.right+10, titleLabel.top, kMainScreenWidth - titleLabel.right - 10 - 16, 30);
        if (i == 8 && callBtn != nil) {
            CGSize size1 = [_carObj.driverMobile sizeWithAttributes:attributes];
            contentL.width = size1.width;
            callBtn.left = contentL.right + 20;
        }
    }
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

- (void)toggleCallBtn:(UIButton*)sender
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    DLog(@"%p", _webView);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_carObj.driverMobile]];
    DLog(@"phoneNumber:%@",_carObj.driverMobile);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _carArr.count;
//}
//
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 6;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    return cell;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
