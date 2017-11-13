//
//  CustomerFollowDetailViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerFollowDetailViewController.h"
#import "CustAddFollowViewController.h"
#import "CustFollowTableViewCell.h"
//#import "CustomerEmptyView.h"
#import "CustomerDetailViewController.h"
#import "XTUserScheduleViewController.h"
#import "CustFollowSelectView.h"
#import "DataFactory+Customer.h"
#import "CustomerFollowData.h"
#import "UITableView+XTRefresh.h"
#import "CustomerEmptyView.h"

@interface CustomerFollowDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat      _oldOffset;
}

@property (nonatomic, strong) UIWebView           *webView;
@property (nonatomic, strong) UIView               *headerView;
@property (nonatomic, strong) UITableView          *tableView;
@property (nonatomic, strong) CustFollowSelectView *followView;
@property (nonatomic, strong) NSMutableArray       *custFollowInfoArray;

@property (nonatomic, strong) UILabel              *followLabel;
@property (nonatomic, strong) UIImageView          *iconImgView;
@property (nonatomic, strong) UILabel              *buildingLabel;
@property (nonatomic, strong) UIImageView          *buildingImgView;
@property (nonatomic, strong) UIView               *tableBgView;
@property (nonatomic, strong) UITableView          *disTableView;
@property (nonatomic, copy)   NSString             *estateId;//楼盘id
@property (nonatomic, strong) NSMutableArray       *estateArray;
@property (nonatomic, copy)   NSString             *creatorId;//创建跟进记录用户id
@property (nonatomic, strong) NSMutableArray       *creatorArray;
@property (nonatomic, assign) BOOL                 bIsEstate;
@property (nonatomic, assign) BOOL                 bIsCreator;
@property (nonatomic, assign) int                  page;//加载更多时的页码
@property (nonatomic, assign) BOOL                 morePage;//是否有下一页
@property (nonatomic, strong) NSMutableArray       *titleArr;
@property (nonatomic, strong) CustomerEmptyView    *emptyView;
@property (nonatomic, strong) UIView               *followBgView;
@property (nonatomic, assign) NSInteger            creatorSelectedIndex;
@property (nonatomic, assign) NSInteger            buildingSelectedIndex;

@property (nonatomic, assign) BOOL                 bHasReportBuilding;

@end

@implementation CustomerFollowDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"跟进记录";
    self.navigationBar.barBackgroundImageView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7" alpha:1.0];
    _page = 1;
    CGSize itemSize = [@"添加跟进" sizeWithAttributes:@{NSFontAttributeName:FONT(16)}];
    UIButton *rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-itemSize.width, 20, itemSize.width, 44)];
//    [rightBarItem setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
//    [rightBarItem setImage:[UIImage imageNamed:@"icon_edit_h"] forState:UIControlStateHighlighted];
    [rightBarItem setTitle:@"添加跟进" forState:UIControlStateNormal];
    [rightBarItem setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    rightBarItem.titleLabel.font = FONT(16);
    [rightBarItem addTarget:self action:@selector(toggleRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:rightBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCustomerFollowNotification:) name:@"RefreshCustomerFollowList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBarButtonItemClick) name:@"CustFollowLeftBarButtonItemClick" object:nil];
    
    _custFollowInfoArray = [[NSMutableArray alloc] init];
//    _custFollowInfoArray = _customerList.trackArray;
    _creatorArray = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    _estateArray = [[NSMutableArray alloc] init];
    _creatorSelectedIndex = 0;
    _buildingSelectedIndex = 0;
    
    [self hasNetwork];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCustomerFollowView:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view.
}
//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame =CGRectMake(0, _headerView.bottom, self.view.bounds.size.width, self.view.bounds.size.height-_headerView.bottom) ;
    }
}

- (void)leftBarButtonItemClick
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CustomerDetailViewController class]] || [temp isKindOfClass:[XTUserScheduleViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

- (void)toggleCustomerFollowView:(UITapGestureRecognizer*)recognizer
{
    [self dismissFollowSelectedView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
//- (void)leftBarButtonItemClickNotification:(NSNotification*)notification
//{
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[CustomerDetailViewController class]] || [temp isKindOfClass:[XTUserScheduleViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshCustomerFollowList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CustFollowLeftBarButtonItemClick" object:nil];
}

- (void)hasNetwork
{
    __weak CustomerFollowDetailViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    [self layoutUI];
    [self createEmptyView];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:_customerList.customerId]) {
        [dic setValue:_customerList.customerId forKey:@"custProfileId"];
    }
    
    [[DataFactory sharedDataFactory] getReportBuildingWithDic:dic WithCallBack:^(ActionResult *result, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _bHasReportBuilding = NO;
            if (result.success) {
                if (array.count > 0) {
                    _bHasReportBuilding = YES;
                }
            }else
            {
                [self showTips:result.message];
            }
        });
    }];

    [self requestData];
}

- (void)requestData
{
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:_customerList.customerId]) {
        [dic1 setValue:_customerList.customerId forKey:@"custProfileId"];
    }
    
    //    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getFollowCreatorWithDic:dic1 WithCallBack:^(ActionResult *result, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self removeRotationAnimationView:loadingView];
            if (result.success) {
                if (_creatorArray.count>0) {
                    [_creatorArray removeAllObjects];
                }
                CustomerFollowData *followData = [[CustomerFollowData alloc] init];
                followData.userName = @"全部跟进";
                [_creatorArray addObject:followData];
                [_creatorArray addObjectsFromArray:array];
            }else
            {
                [self showTips:result.message];
            }
        });
    }];
    
    [[DataFactory sharedDataFactory] getFollowBuildingWithDic:dic1 WithCallBack:^(ActionResult *result, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self removeRotationAnimationView:loadingView];
            if (result.success) {
                if (_estateArray.count>0) {
                    [_estateArray removeAllObjects];
                }
                CustomerFollowData *followData = [[CustomerFollowData alloc] init];
                followData.estateName = @"全部楼盘";
                [_estateArray addObject:followData];
                [_estateArray addObjectsFromArray:array];
            }else
            {
                [self showTips:result.message];
            }
        });
    }];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:_customerList.customerId]) {
        [dic setValue:_customerList.customerId forKey:@"custProfileId"];
    }
    if (![_buildingLabel.text isEqualToString:@"全部楼盘"]) {
        if (![self isBlankString:_estateId]) {
            [dic setValue:_estateId forKey:@"estateId"];
        }
        if (![self isBlankString:_buildingLabel.text]) {
            [dic setValue:_buildingLabel.text forKey:@"estateName"];
        }
    }
    
    if (![_followLabel.text isEqualToString:@"全部跟进"]) {
        if (![self isBlankString:_creatorId]) {
            [dic setValue:_creatorId forKey:@"creator"];
        }
        if (![self isBlankString:_followLabel.text]) {
            [dic setValue:_followLabel.text forKey:@"creatorName"];
        }
    }
    
    if (![self isBlankString:_customerList.name]) {
        [dic setValue:_customerList.name forKey:@"customerName"];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [dic setValue:PAGESIZE forKey:@"pageSize"];
    
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getTrackMessageWithDic:dic withCallBack:^(ActionResult *result,DataListResult *dataList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (!result.success) {
                [self showTips:result.message];
            }
            if (self.custFollowInfoArray.count>0) {
                [self.custFollowInfoArray removeAllObjects];
            }
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            [tempArr addObjectsFromArray:dataList.dataArray];
            [self sortCustFollowWithArrary:tempArr];
            self.morePage = dataList.morePage;
            [self.tableView setFooterViewHidden:!self.morePage];
            [self.tableView reloadData];
            if (_custFollowInfoArray.count > 0) {
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
            }else
            {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            }
        });
    }];
}

//上拉加载
- (void)footerRereshing
{
    _page++;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:_customerList.customerId]) {
        [dic setValue:_customerList.customerId forKey:@"custProfileId"];
    }
    if (![_buildingLabel.text isEqualToString:@"全部楼盘"]) {
        if (![self isBlankString:_estateId]) {
            [dic setValue:_estateId forKey:@"estateId"];
        }
        if (![self isBlankString:_buildingLabel.text]) {
            [dic setValue:_buildingLabel.text forKey:@"estateName"];
        }
    }
    
    if (![_followLabel.text isEqualToString:@"全部跟进"]) {
        if (![self isBlankString:_creatorId]) {
            [dic setValue:_creatorId forKey:@"creator"];
        }
        if (![self isBlankString:_followLabel.text]) {
            [dic setValue:_followLabel.text forKey:@"creatorName"];
        }
    }
    
    if (![self isBlankString:_customerList.name]) {
        [dic setValue:_customerList.name forKey:@"customerName"];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [dic setValue:PAGESIZE forKey:@"pageSize"];
    
    __weak CustomerFollowDetailViewController *weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{
        UIImageView* loadingView = [weakSelf setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getTrackMessageWithDic:dic withCallBack:^(ActionResult *result,DataListResult *dataList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeRotationAnimationView:loadingView];
                if (!result.success) {
                    [weakSelf showTips:result.message];
                }
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (int i=0; i<_custFollowInfoArray.count; i++) {
                    [tempArr addObjectsFromArray:[((NSArray*)_custFollowInfoArray) objectForIndex:i]];
                    [_custFollowInfoArray removeAllObjects];
                }
                [tempArr addObjectsFromArray:dataList.dataArray];
                [weakSelf sortCustFollowWithArrary:tempArr];
//                [weakSelf.custFollowInfoArray addObjectsFromArray:dataList.dataArray];
                weakSelf.morePage = dataList.morePage;
                [weakSelf.tableView setFooterViewHidden:!weakSelf.morePage];
                [weakSelf.tableView reloadData];
            });
        }];
    }])
    {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getTrackMessageWithDic:dic withCallBack:^(ActionResult *result,DataListResult *dataList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeRotationAnimationView:loadingView];
                if (!result.success) {
                    [self showTips:result.message];
                }
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (int i=0; i<_custFollowInfoArray.count; i++) {
                    [tempArr addObjectsFromArray:[((NSArray*)_custFollowInfoArray) objectForIndex:i]];
                    [_custFollowInfoArray removeAllObjects];
                }
                [tempArr addObjectsFromArray:dataList.dataArray];
                [self sortCustFollowWithArrary:tempArr];
//                [self.custFollowInfoArray addObjectsFromArray:dataList.dataArray];
                self.morePage = dataList.morePage;
                [self.tableView setFooterViewHidden:!self.morePage];
                [self.tableView reloadData];
            });
        }];
    }
    
}

- (void)createEmptyView
{
    _emptyView = [[CustomerEmptyView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kMainScreenWidth, kMainScreenHeight - _headerView.bottom)];
    _emptyView.tip.text = @"暂无数据";
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
}

- (void)layoutUI
{
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, kMainScreenHeight-viewTopY)];
//    _scrollView.delegate = self;
//    _scrollView.backgroundColor = [UIColor clearColor];
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:_scrollView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, 122*SCALE6)];
    _headerView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:_headerView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20*SCALE6, kMainScreenWidth-72-50-10, 25)];
    nameLabel.textColor = NAVIGATIONTITLE;
    nameLabel.text = _customerList.name;
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:nameLabel];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 20)];
    telLabel.textColor = NAVIGATIONTITLE;
    telLabel.text = _customerList.listPhone;
    telLabel.font = FONT(12);
    telLabel.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:telLabel];
    
    UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-72-10, nameLabel.top+10, 72, 25)];
    [telButton setTag:1000];
    [telButton setBackgroundColor:[UIColor clearColor]];
    [telButton setTitle:@"电话" forState:UIControlStateNormal];
    [telButton setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [telButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    telButton.titleLabel.font = FONT(12);
    [telButton setImage:[UIImage imageNamed:@"button_follow_call"] forState:UIControlStateNormal];
    [telButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [telButton.layer setMasksToBounds:YES];
    [telButton.layer setCornerRadius:12.5];
    [telButton.layer setBorderWidth:0.5];
    [telButton.layer setBorderColor:BLUEBTBCOLOR.CGColor];
    [telButton addTarget:self action:@selector(toggleFollowListButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:telButton];
    
    UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 84*SCALE6-0.5, kMainScreenWidth, 0.5)];
    lineL.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [_headerView addSubview:lineL];
    
    _followLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineL.bottom, 150, 38*SCALE6)];
    _followLabel.textColor = NAVIGATIONTITLE;
    _followLabel.text = @"全部跟进";
    _followLabel.font = FONT(13);
    [_headerView addSubview:_followLabel];
    
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_followLabel.right+10, _followLabel.top+_followLabel.height/2-3, 9, 6)];
    [_iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
    [_headerView addSubview:_iconImgView];
    
    [self setLabel:_followLabel WithText:_followLabel.text WithImage:_iconImgView];
    
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineL.bottom, kMainScreenWidth/2, 38*SCALE6)];
    [followBtn setTag:1001];
    [followBtn setBackgroundColor:[UIColor clearColor]];
    [followBtn addTarget:self action:@selector(toggleFollowListButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:followBtn];
    
    UILabel *herLineL = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, lineL.bottom+10*SCALE6, 0.5, 18*SCALE6)];
    herLineL.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [_headerView addSubview:herLineL];
    
    _buildingLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2+20, lineL.bottom, 150, 38*SCALE6)];
    _buildingLabel.textColor = NAVIGATIONTITLE;
    _buildingLabel.text = @"全部楼盘";
    _buildingLabel.font = FONT(13);
    [_headerView addSubview:_buildingLabel];
    
    _buildingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_buildingLabel.right+10, _followLabel.top+_followLabel.height/2-3, 9, 6)];
    [_buildingImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
    [_headerView addSubview:_buildingImgView];
    
    [self setLabel:_buildingLabel WithText:_buildingLabel.text WithImage:_buildingImgView];
    
    UIButton *fbuildingBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, lineL.bottom, kMainScreenWidth/2, 38*SCALE6)];
    [fbuildingBtn setTag:1002];
    [fbuildingBtn setBackgroundColor:[UIColor clearColor]];
    [fbuildingBtn addTarget:self action:@selector(toggleFollowListButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:fbuildingBtn];
    
    UILabel *lineL2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 122*SCALE6-0.5, kMainScreenWidth, 0.5)];
    lineL2.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [_headerView addSubview:lineL2];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kMainScreenWidth, self.view.bounds.size.height-_headerView.bottom) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf performSelector:@selector(footerRereshing) withObject:nil];
    }];

//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 102*SCALE6)];
//    tableHeaderView.backgroundColor = BACKGROUNDCOLOR;
//    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < scrollView.contentSize.height - self.tableView.height) {
        CGFloat minOffset = 0;
        CGFloat maxOffset =  84 * SCALE6;
        if (offsetY <= minOffset) {
            offsetY = minOffset;
        }else if(offsetY >= maxOffset){
            offsetY = maxOffset;
        }
        CGFloat headerY = _headerView.top;
        _headerView.top = viewTopY-offsetY;
        if (scrollView.contentOffset.y>minOffset && scrollView.contentOffset.y<_oldOffset) {
            _headerView.top = MIN(headerY-(scrollView.contentOffset.y-_oldOffset), viewTopY);
        }
        else if (scrollView.contentOffset.y>maxOffset && scrollView.contentOffset.y>_oldOffset)
        {
            _headerView.top = MAX(headerY-(scrollView.contentOffset.y-_oldOffset), viewTopY-maxOffset);
        }
        _tableView.top = _headerView.bottom;
        _tableView.height = self.view.bounds.size.height-_headerView.bottom;
    }
//    self.navigationBarBackImageView.hidden = offsetY==0?NO:YES;
//    self.leftNavBtn.hidden = offsetY<0?YES:NO;
//    self.rightNavBtn.hidden = offsetY<0?YES:NO;
//    CGFloat alpha = 0.0f;
    
    
    DLog(@"--%f--",offsetY);
//    alpha = offsetY / maxOffset;
//    _headerView.top = offsetY-minOffset;
    
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

//添加客户跟进信息
- (void)toggleRightBarItem
{
    [MobClick event:@"khxq_tjgj"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_TJGJ" andPageId:@"PAGE_KHGJ"];
    [self dismissFollowSelectedView];
    if (_bHasReportBuilding) {
        //    __weak CustomerFollowDetailViewController *detail = self;
        CustAddFollowViewController *editVC = [[CustAddFollowViewController alloc] init];
        //    editVC.customerMsgType = kAddCustomerFollowMsg;
        editVC.customerId = _customerList.customerId;
        
        [self.navigationController pushViewController:editVC animated:YES];
    }else
    {
        [self showTips:@"报备客户后才能添加跟进信息"];
    }
}

- (void)refreshCustomerFollowNotification:(NSNotification*)notification
{
    [self requestData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _custFollowInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = ((NSArray*)[_custFollowInfoArray objectForIndex:section]).count;
    return count;//_custFollowInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"cellIdentifier";
    CustomerFollowData *data = (CustomerFollowData*)[((NSArray*)[_custFollowInfoArray objectForIndex:indexPath.section]) objectForIndex:indexPath.row];
    CustFollowTableViewCell *cell = [[CustFollowTableViewCell alloc] init];
    NSDate *date = getNSDateWithDateTimeString(data.createTime);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    cell.dateLabel.text = dateStr;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    NSString *dateStr1 = [dateFormatter1 stringFromDate:date];
    cell.timeLabel.text = dateStr1;
    cell.nameLabel.text = data.creatorName;
    cell.roleLabel.text = data.roleName;
    CGSize nameSize = [cell.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    CGSize roleSize = [cell.roleLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT(10)}];
    cell.nameLabel.width = nameSize.width;
    cell.roleLabel.left = cell.nameLabel.right+10;
    cell.roleLabel.width = roleSize.width+10;
    
    if (cell.nameLabel.left+nameSize.width+20+roleSize.width+10>kMainScreenWidth) {
        cell.nameLabel.width = kMainScreenWidth-cell.nameLabel.left-10;
        if (nameSize.width>kMainScreenWidth-cell.nameLabel.left-10) {
            cell.nameLabel.numberOfLines = 0;
            cell.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [self setLabelSpace:cell.nameLabel withValue:cell.nameLabel.text withFont:FONT(15)];
            cell.nameLabel.height = [self getSpaceLabelHeight:cell.nameLabel.text withFont:FONT(15) withWidth:kMainScreenWidth-cell.nameLabel.left-10];
        }
        cell.roleLabel.left = cell.nameLabel.left;
        cell.roleLabel.top = cell.nameLabel.bottom+10;
        cell.roleLabel.height = roleSize.height+4;
        if (roleSize.width+10 > cell.nameLabel.width) {
            cell.roleLabel.numberOfLines = 0;
            cell.roleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [self setLabelSpace:cell.roleLabel withValue:cell.roleLabel.text withFont:FONT(10)];
            cell.roleLabel.height = [self getSpaceLabelHeight:cell.roleLabel.text withFont:FONT(10) withWidth:kMainScreenWidth-cell.nameLabel.left-10]+4;
        }
        cell.contentLabel.top = cell.roleLabel.bottom+10;
    }
    
    cell.contentLabel.text = data.content;
    cell.buildingLabel.text = [NSString stringWithFormat:@"报备楼盘：%@",data.estateName];
    CGSize contentSize = [cell.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    cell.contentLabel.height = contentSize.height;
    if (contentSize.width > kMainScreenWidth-cell.nameLabel.left-10) {
        [self setLabelSpace:cell.contentLabel withValue:cell.contentLabel.text withFont:FONT(13)];
        CGFloat contentHeight = [self getSpaceLabelHeight:cell.contentLabel.text withFont:FONT(13) withWidth:kMainScreenWidth-10-cell.contentLabel.left];
        cell.contentLabel.height = contentHeight;
    }
    cell.buildingLabel.top = cell.contentLabel.bottom+10;
    CGSize buildingSize = [cell.buildingLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    cell.buildingLabel.height = buildingSize.height;
    if (buildingSize.width > kMainScreenWidth-cell.nameLabel.left-10) {
        cell.buildingLabel.numberOfLines = 0;
        cell.buildingLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self setLabelSpace:cell.buildingLabel withValue:cell.buildingLabel.text withFont:FONT(13)];
        cell.buildingLabel.height = [self getSpaceLabelHeight:cell.buildingLabel.text withFont:FONT(13) withWidth:kMainScreenWidth-10-cell.contentLabel.left];
    }
    
    cell.lineLabel.top = cell.buildingLabel.bottom+20-0.5;
    if (indexPath.row == ((NSArray*)[_custFollowInfoArray objectForIndex:indexPath.section]).count-1) {
        cell.lineLabel.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    CustomerFollowData *data = (CustomerFollowData*)[((NSArray*)[_custFollowInfoArray objectForIndex:indexPath.section]) objectForIndex:indexPath.row];
    CGSize dateSize = [@"88-88" sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    NSString *str = [NSString stringWithFormat:@"报备楼盘：%@",data.estateName];
    CGFloat labelWidth = kMainScreenWidth-10-10-25-dateSize.width;
    CGFloat nameHeight = dateSize.height;
    CGSize nameSize = [data.creatorName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    CGSize roleSize = [data.roleName sizeWithAttributes:@{NSFontAttributeName:FONT(10)}];
    if (nameSize.width+roleSize.width+20>labelWidth) {
        if (nameSize.width>labelWidth) {
            nameHeight = [self getSpaceLabelHeight:data.creatorName withFont:FONT(15) withWidth:labelWidth];
        }
        if (roleSize.width+10 > labelWidth) {
            nameHeight += [self getSpaceLabelHeight:data.roleName withFont:FONT(10) withWidth:labelWidth]+4+10;
        }else
        {
            nameHeight += roleSize.height+4+10;
        }
    }
    
    CGSize contentSize = [data.content sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    CGFloat contentHeight = contentSize.height;
    if (contentSize.width > labelWidth) {
        contentHeight  =[self getSpaceLabelHeight:data.content withFont:FONT(13) withWidth:labelWidth];
    }
    
    CGSize buildingSize = [str sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    CGFloat buildingHeight = buildingSize.height;
    if (buildingSize.width > labelWidth) {
        buildingHeight  =[self getSpaceLabelHeight:str withFont:FONT(13) withWidth:labelWidth];
    }
    
    height = 20+nameHeight+10+contentHeight+10+buildingHeight+20;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.00001;
    }
    return 30*SCALE6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30*SCALE6)];
    headerV.backgroundColor = BACKGROUNDCOLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, headerV.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = NAVIGATIONTITLE;
    label.font = FONT(12);
    label.text = [_titleArr objectForIndex:section];
    if (section) {
        [headerV addSubview:label];
        return headerV;
    }
    return nil;
}

- (void)toggleFollowListButton:(UIButton*)sender
{
    __weak CustomerFollowDetailViewController *weakSelf = self;
    switch (sender.tag-1000) {
        case 0://点击电话按钮
        {
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BDDH" andPageId:@"PAGE_KHGJ"];
            [self dismissFollowSelectedView];
            if (_webView == nil) {
                _webView = [[UIWebView alloc] init];
            }
            NSString *phone = _customerList.listPhone;
            DLog(@"%p,phone is %@", _webView,phone);
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [_webView loadRequest:request];
            [self.view addSubview:_webView];
        }
            break;
        case 1://是否展示添加跟进者列表
        {
            if (_followView == nil) {
                _bIsCreator = YES;
                _bIsEstate = NO;
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GJRSX" andPageId:@"PAGE_KHGJ"];
                [_iconImgView setImage:[UIImage imageNamed:@"icon_blackArrowUp"]];
                _followBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kMainScreenWidth, kMainScreenHeight - _headerView.bottom)];
                [_followBgView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.3]];
                [self.view addSubview:_followBgView];
                _followView = [[CustFollowSelectView alloc] initWithFrame:CGRectMake(10, _headerView.bottom, kMainScreenWidth-20, MIN(33*_creatorArray.count+11, 260))];
                _followView.bIsEstate = NO;
                _followView.selctedRowIndex = _creatorSelectedIndex;
                _followView.dataArray = _creatorArray;
                [self.view addSubview:_followView];
                [_followView selectedFollowBlock:^(NSString *userId,NSString *userName,NSInteger index) {
                    weakSelf.creatorId = userId;
                    weakSelf.followLabel.text = userName;
                    [weakSelf.iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                    [weakSelf setLabel:weakSelf.followLabel WithText:weakSelf.followLabel.text WithImage:weakSelf.iconImgView];
                    [weakSelf.followBgView removeFromSuperview];
                    [weakSelf.followView removeAllSubviews];
                    [weakSelf.followView removeFromSuperview];
                    weakSelf.followView = nil;
                    weakSelf.page = 1;
                    weakSelf.creatorSelectedIndex = index;
                    [weakSelf requestData];
                }];
            }else
            {
                if (!_bIsEstate && _bIsCreator) {
                    [_followBgView removeFromSuperview];
                    [_followView removeAllSubviews];
                    [_followView removeFromSuperview];
                    _followView = nil;
                    [_iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                }else
                {
                    [_iconImgView setImage:[UIImage imageNamed:@"icon_blackArrowUp"]];
                    [_buildingImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                    _bIsCreator = YES;
                    _bIsEstate = NO;
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GJRSX" andPageId:@"PAGE_KHGJ"];
                    _followView.height = MIN(33*_creatorArray.count+11, 260);
                    _followView.tableView.height = _followView.height;
                    _followView.bIsEstate = NO;
                    _followView.selctedRowIndex = _creatorSelectedIndex;
                    _followView.dataArray = _creatorArray;
                    [_followView selectedFollowBlock:^(NSString *userId,NSString *userName,NSInteger index) {
                        weakSelf.creatorId = userId;
                        weakSelf.followLabel.text = userName;
                        [weakSelf.iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                        [weakSelf setLabel:weakSelf.followLabel WithText:weakSelf.followLabel.text WithImage:weakSelf.iconImgView];
                        [weakSelf.followBgView removeFromSuperview];
                        [weakSelf.followView removeAllSubviews];
                        [weakSelf.followView removeFromSuperview];
                        weakSelf.followView = nil;
                        weakSelf.page = 1;
                        weakSelf.creatorSelectedIndex = index;
                        [weakSelf requestData];
                    }];
                }
                
            }
        }
            break;
        case 2://是否展示已添加跟进的楼盘列表
        {
            if (_followView == nil) {
                [_buildingImgView setImage:[UIImage imageNamed:@"icon_blackArrowUp"]];
                _bIsCreator = NO;
                _bIsEstate = YES;
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GJLPSX" andPageId:@"PAGE_KHGJ"];
                _followBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kMainScreenWidth, kMainScreenHeight - _headerView.bottom)];
                [_followBgView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.3]];
                [self.view addSubview:_followBgView];
                _followView = [[CustFollowSelectView alloc] initWithFrame:CGRectMake(10, _headerView.bottom, kMainScreenWidth-20, MIN(33*_estateArray.count+11, 260))];
                _followView.bIsEstate = YES;
                _followView.selctedRowIndex = _buildingSelectedIndex;
                _followView.dataArray = _estateArray;
                [self.view addSubview:_followView];
               
                [_followView selectedFollowBlock:^(NSString *userId,NSString *userName,NSInteger index) {
                    weakSelf.estateId = userId;
                    weakSelf.buildingLabel.text = userName;
                    [weakSelf.buildingImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                    [weakSelf setLabel:weakSelf.buildingLabel WithText:weakSelf.buildingLabel.text WithImage:weakSelf.buildingImgView];
                    [weakSelf.followBgView removeFromSuperview];
                    [weakSelf.followView removeAllSubviews];
                    [weakSelf.followView removeFromSuperview];
                    weakSelf.followView = nil;
                    weakSelf.page = 1;
                    weakSelf.buildingSelectedIndex = index;
                    [weakSelf requestData];
                }];
            }else
            {
                if (_bIsEstate && !_bIsCreator) {
                    [_followBgView removeFromSuperview];
                    [_followView removeAllSubviews];
                    [_followView removeFromSuperview];
                    _followView = nil;
                    [_buildingImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                }else
                {
                    [_iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                    [_buildingImgView setImage:[UIImage imageNamed:@"icon_blackArrowUp"]];
                    _bIsCreator = NO;
                    _bIsEstate = YES;
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GJLPSX" andPageId:@"PAGE_KHGJ"];
                    _followView.height = MIN(33*_estateArray.count+11, 260);
                    _followView.tableView.height = _followView.height;
                    _followView.bIsEstate = YES;
                    _followView.selctedRowIndex = _buildingSelectedIndex;
                    _followView.dataArray = _estateArray;
                    [_followView selectedFollowBlock:^(NSString *userId,NSString *userName,NSInteger index) {
                        weakSelf.estateId = userId;
                        weakSelf.buildingLabel.text = userName;
                        [weakSelf.buildingImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
                        [weakSelf setLabel:weakSelf.buildingLabel WithText:weakSelf.buildingLabel.text WithImage:weakSelf.buildingImgView];
                        [weakSelf.followBgView removeFromSuperview];
                        [weakSelf.followView removeAllSubviews];
                        [weakSelf.followView removeFromSuperview];
                        weakSelf.followView = nil;
                        weakSelf.page = 1;
                        weakSelf.buildingSelectedIndex = index;
                        [weakSelf requestData];
                    }];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)dismissFollowSelectedView
{
    if (!_bIsEstate && _bIsCreator) {
        [_followBgView removeFromSuperview];
        [_followView removeAllSubviews];
        [_followView removeFromSuperview];
        _followView = nil;
        [_iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
    }else if (_bIsEstate && !_bIsCreator) {
        [_followBgView removeFromSuperview];
        [_followView removeAllSubviews];
        [_followView removeFromSuperview];
        _followView = nil;
        [_buildingImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
    }
}

- (void)setLabel:(UILabel*)label WithText:(NSString*)text WithImage:(UIImageView*)imageView
{
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    label.width = MIN(kMainScreenWidth/2-40,textSize.width);
    if (label.left>kMainScreenWidth/2) {
        label.left = kMainScreenWidth*3/4-(label.width+10+9)/2;
    }else{
        label.left = (kMainScreenWidth/2-(label.width+10+9))/2;
    }
    imageView.left = label.right+10;
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
}

#define UILABEL_LINE_SPACE 5
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
    //                          };
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
//    [attributeStr addAttribute:NSForegroundColorAttributeName
//                         value:[UIColor colorWithHexString:@"888888"]
//                         range:NSMakeRange(0, 5)];
    label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (void)sortCustFollowWithArrary:(NSMutableArray*)array
{
    /*for (int i=0; i<20; i++) {
        CustomerFollowData *data = [[CustomerFollowData alloc] init];
        data.creatorName = @"那小谁";
        data.estateName = @"中海寰宇天下";
        data.createTime = @"2017-02-16 17:54:44";
        data.roleName = @"经纪人模板";
        data.content = @"测试，这只是一个测试数据。。。真哒，真的只是一条测试数据。。。仅此而已！~~";
        if (i>3 && i<8) {
            data.createTime = @"2016-09-16 10:54:44";
        }else if (i>=8)
        {
            data.createTime = @"2015-12-24 14:32:44";
        }
        [array addObject:data];
    }*/
    NSString *year = @"";
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<array.count; i++) {
        CustomerFollowData *data = (CustomerFollowData*)[array objectForIndex:i];
        NSDate *date = getNSDateWithDateTimeString(data.createTime);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        if ([self isBlankString:year]) {
            [tempArr addObject:data];
        }
        if ([year isEqualToString:dateStr]) {
            [tempArr addObject:data];
        }else
        {
            if ([year integerValue] > [dateStr integerValue]) {
                if (tempArr.count>0) {
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:tempArr];
                    [_custFollowInfoArray addObject:arr];
                    [tempArr removeAllObjects];
                }
                [tempArr addObject:data];
            }
        }
        if (i==array.count-1) {
            if (tempArr.count>0) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:tempArr];
                [_custFollowInfoArray addObject:arr];
                [tempArr removeAllObjects];
            }
        }
        year = dateStr;
        if (![_titleArr containsObject:year]) {
            [_titleArr addObject:year];
        }
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
