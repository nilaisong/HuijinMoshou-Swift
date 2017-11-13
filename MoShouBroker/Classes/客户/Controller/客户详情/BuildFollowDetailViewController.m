//
//  BuildFollowDetailViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BuildFollowDetailViewController.h"
#import "CustomerEditViewController.h"
#import "FollowDetailTableViewCell.h"
#import "MoshouProgressView.h"
#import "EncodingView.h"

#import "DataFactory+Customer.h"

@interface BuildFollowDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIView         *headerView;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *reportInformation;//客户报备信息内容
@property (nonatomic, strong) NSArray        *followInformation;//楼盘跟进信息内容
@property (nonatomic, assign)   BOOL           bIsTouched;//楼盘跟进信息内容

@end

@implementation BuildFollowDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"进度详情";
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
//    UIButton *rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-49, 20, 44, 44)];
//    [rightBarItem setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
//    [rightBarItem setImage:[UIImage imageNamed:@"icon_edit_h"] forState:UIControlStateHighlighted];
//    [rightBarItem addTarget:self action:@selector(toggleRightBarItem) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar addSubview:rightBarItem];
    
    _reportInformation = [[NSArray alloc] init];
    _followInformation = [[NSArray alloc] init];
    if (_trade.progress.count > 0) {
        _reportInformation = ((ProgressStatus*)[_trade.progress objectForIndex:0]).messages;
    }
    _followInformation = _trade.track;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self createTableViewHeaderView];
    
    // Do any additional setup after loading the view.
}
//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame =CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY) ;
    }
}

- (void)setBIsMessageDetail:(BOOL)bIsMessageDetail
{
    if (_bIsMessageDetail != bIsMessageDetail) {
        _bIsMessageDetail = bIsMessageDetail;
    }
    if (_bIsMessageDetail) {
        [self hasNetwork];
    }
}

- (void)hasNetwork
{
    __weak BuildFollowDetailViewController *message = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[message reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
//    __weak typeof(self) weakSelf = self;
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView* loadingView = [self setRotationAnimationWithView];//msgData.custEstateId  @"127971"
        [[DataFactory sharedDataFactory] getReportedDetailByRecordId:self.bizNodeId AndOptType:self.bizType AndBuildingCustomerId:self.waitConfirmId callBack:^(CustomerReportedDetailModel *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CustomerReportedDetailModel *detailModel = [[CustomerReportedDetailModel alloc] init];
                if (result != nil) {
                    detailModel = result;
                }
                
                [self removeRotationAnimationView:loadingView];
                ReportDetailBuilding* building = nil;
                if (detailModel.buildingList.count>0) {
                    building = [detailModel.buildingList firstObject];
                }
                
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
                
                if (building.progressList.count>0) {
                    trade.progress = [NSArray arrayWithObjects:[building.progressList objectForIndex:0], nil];
                }
                
                //                      for (ProgressStatus* status in building.progressList) {
                //                          trade.messages = status.messages;
                //                          trade.expiredate = building.expiredate;
                //                          trade.expiredateFlag = [NSString stringWithFormat:@"%ld",(long)building.expiredateFlag];
                //                      }
                
                trade.track = trackList;
                
                trade.district = building.district;
                self.trade = trade;
                if (self.trade.progress.count >self.row) {
                    self.reportInformation = ((ProgressStatus*)[self.trade.progress objectForIndex:self.row]).messages;
                }
                self.followInformation = self.trade.track;
                
                [_headerView removeAllSubviews];
                [_headerView removeFromSuperview];
                
                [self createTableViewHeaderView];
                
                [self.tableView reloadData];
                
            });
        } failedCallBack:^(ActionResult *result) {
            [self removeRotationAnimationView:loadingView];
            if (result.message.length > 0) {
                [self showTips:result.message];
            }
            
        }];
        
    }
}

//添加楼盘跟进信息
- (void)toggleRightBarItem
{
    [MobClick event:@"khxq_jdxq_tjgj"];
    __weak BuildFollowDetailViewController *detail = self;
    CustomerEditViewController *editVC = [[CustomerEditViewController alloc] init];
//    editVC.customerMsgType = kAddFolloMsg;
    editVC.customerMsdId = _trade.buildingCustomerId;//buildcustomerid
    [editVC returnCustomerEditResultBlock:^() {
        [detail requestTrackMessage];
    }];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)requestTrackMessage
{
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getTrackMessageWithBuildingCustId:self.trade.buildingCustomerId withCallBack:^(ActionResult *result,NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (!result.success) {
                [self showTips:result.message];
            }
            self.followInformation = array;
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestCustomerDetailData" object:nil];
        });
    }];
}

- (void)createTableViewHeaderView
{
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *loupImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    [loupImgView setImage:[UIImage imageNamed:@"mine_loupan"]];
    [_headerView addSubview:loupImgView];
    
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize size2 = [self textSize:_trade.buildingName withConstraintWidth:kMainScreenWidth-60-loupImgView.right withFontSize:17];//[_trade.buildingName sizeWithAttributes:attributes];
    UILabel *loupanName = [[UILabel alloc] initWithFrame:CGRectMake(loupImgView.right+5, 10, size2.width, MAX(size2.height,30))];//MIN(size2.width, kMainScreenWidth-5-5-50-loupImgView.right)
    loupanName.textColor = NAVIGATIONTITLE;
    loupanName.font = [UIFont systemFontOfSize:17];
    loupanName.text = _trade.buildingName;
    loupanName.numberOfLines = 0;
    loupanName.lineBreakMode = NSLineBreakByWordWrapping;
    [_headerView addSubview:loupanName];
    
    [_headerView addSubview:[self createLineView:loupanName.bottom+9.5]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, loupanName.bottom+15, kMainScreenWidth-15-15, 20)];
    label.font = FONT(14);
    if (_trade.progress.count > 0) {
        label.text = ((ProgressStatus*)[_trade.progress objectForIndex:0]).descriptionText;
    }
    label.textColor = [UIColor colorWithHexString:@"fc6c33"];
    label.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:label];
    
    MoshouProgressView *progressView = [[MoshouProgressView alloc] initWithFrame:CGRectMake(0, label.bottom+5, kMainScreenWidth, 90)];
    ProgressStatus *progress = nil;
    if (_trade.progress.count > 0) {
        progress = (ProgressStatus*)[_trade.progress objectForIndex:0];
    }
    progressView.progressDataSource = progress;
    [_headerView addSubview:progressView];
    
    _headerView.height = progressView.bottom+15;
    
    if ([_trade.expiredateFlag boolValue]) {
        NSString *str = [NSString stringWithFormat:@"客户有效期 %@ 天",_trade.expiredate];
        NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGSize size3 = [str sizeWithAttributes:attributes1];
        UILabel *validityPeriodLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, progressView.bottom+5, size3.width, size3.height+10)];
        validityPeriodLabel.text = str;
        validityPeriodLabel.textColor = ORIGCOLOR;
        validityPeriodLabel.textAlignment = NSTextAlignmentLeft;
        validityPeriodLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithHexString:@"f8cc57"];
        validityPeriodLabel.font = [UIFont systemFontOfSize:13];
        [_headerView addSubview:validityPeriodLabel];
        if ([progress.can_revokeRecommendation boolValue]) {
            NSString *str1 = @"撤销报备";
            NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGSize size4 = [str1 sizeWithAttributes:attributes1];
            UIButton *revertBtn = [[UIButton alloc] initWithFrame:CGRectMake(validityPeriodLabel.right+20, validityPeriodLabel.top, size4.width+15, size4.height+8)];
            [revertBtn setTitle:str1 forState:UIControlStateNormal];
            [revertBtn setTitleColor:ORIGCOLOR forState:UIControlStateNormal];
            revertBtn.backgroundColor = [UIColor clearColor];
            [revertBtn.titleLabel setFont:FONT(12)];
            [revertBtn.layer setMasksToBounds:YES];
            [revertBtn.layer setCornerRadius:3];
            [revertBtn.layer setBorderColor:ORIGCOLOR.CGColor];
            [revertBtn.layer setBorderWidth:0.5];
            [revertBtn addTarget:self action:@selector(toggleRevertBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:revertBtn];
        }
        _headerView.height = validityPeriodLabel.bottom+25;
    }else
    {
        if ([progress.can_revokeRecommendation boolValue]) {
            NSString *str1 = @"撤销报备";
            NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGSize size4 = [str1 sizeWithAttributes:attributes1];
            UIButton *revertBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, progressView.bottom+5, size4.width+15, size4.height+8)];
            [revertBtn setTitle:str1 forState:UIControlStateNormal];
            [revertBtn setTitleColor:ORIGCOLOR forState:UIControlStateNormal];
            revertBtn.backgroundColor = [UIColor clearColor];
            [revertBtn.titleLabel setFont:FONT(12)];
            [revertBtn.layer setMasksToBounds:YES];
            [revertBtn.layer setCornerRadius:3];
            [revertBtn.layer setBorderColor:ORIGCOLOR.CGColor];
            [revertBtn.layer setBorderWidth:0.5];
            [revertBtn addTarget:self action:@selector(toggleRevertBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:revertBtn];
            _headerView.height = revertBtn.bottom+25;
        }
    }
    
//    if ([_trade.showURL boolValue]) {
//        UIButton *QRCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(loupanName.right+5, 13, 24, 24)];
//        [QRCodeBtn setImage:[UIImage imageNamed:@"iconfont_erweima"] forState:UIControlStateNormal];
//        [QRCodeBtn addTarget:self action:@selector(toggleQRCodeButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_headerView addSubview:QRCodeBtn];
//    }
    
    [_headerView addSubview:[self createLineView:_headerView.height-0.5]];
    self.tableView.tableHeaderView = _headerView;
}

//生成二维码
- (void)toggleQRCodeButton:(UIButton*)sender
{
    if (![self isBlankString:_trade.url]) {
        EncodingView *QRCodeView = [[EncodingView alloc] initWithEncodingString:_trade.url withCustomerName:_customerName withPhone:_customerPhone];
        [self.view addSubview:QRCodeView];
    }
}
//点击楼盘的撤销报备按钮
- (void)toggleRevertBtn:(UIButton*)sender
{
    if (!_bIsTouched)
    {
        _bIsTouched = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要撤销报备？撤销后需要重新报备客户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        [[DataFactory sharedDataFactory] revokeRecommendationWithTrackId:_trade.buildingCustomerId withCallBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.success) {
                    [self showTips:result.message];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailBottom" object:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRecommendRecordListInfo" object:nil];

                        //防止多次pop发生崩溃闪退
                        if ([self.view superview]) {
                            self.bIsTouched = NO;
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }else{
                    self.bIsTouched = NO;
                    [self showTips:result.message];
                }
            });
        }];
    }else
    {
        self.bIsTouched = NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//2
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
//    if (section) {
//        count = _followInformation.count;
//    }else
//    {
        count = _reportInformation.count;
//    }
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = nil;
    if (section) {
        str = @"跟进记录";
    }
    return str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"cellIdentifier";
    FollowDetailTableViewCell *cell = nil;
    if (indexPath.section) {
        MessageData *data = nil;
        if (_followInformation.count > indexPath.row) {
            data = (MessageData*)[_followInformation objectForIndex:indexPath.row];
        }
        cell = [[FollowDetailTableViewCell alloc] initWithMessageData:data TrackType:1 AndIndexPath:1];
    }else
    {
        MessageData *data = nil;
        if (_reportInformation.count > indexPath.row) {
            data = (MessageData*)[_reportInformation objectForIndex:indexPath.row];
        }
        cell = [[FollowDetailTableViewCell alloc] initWithMessageData:data TrackType:1 AndIndexPath:0];
//        if (indexPath.row==_reportInformation.count-1) {
//            data.numPeople = @"2";
//            data.visitTimeBegin = @"2016-07-15 15:00";
//            data.visitTimeEnd = @"2016-07-15 17:00";
//            data.trafficMode = @"自驾";
//        }
        if (indexPath.row==_reportInformation.count-1) {
            if (![self isBlankString:data.numPeople]) {
                cell.bIsShowVisitInfo = YES;
                NSDate *startDate = [self dateFromString:data.visitTimeBegin withFormat:@"yyyy-MM-dd HH:mm"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"MM月dd日 HH:mm";
                NSString *str = [dateFormatter stringFromDate:startDate];
                if ([str hasPrefix:@"0"]) {
                    str = [str substringFromIndex:1];
                }
                NSDate *endDate = [self dateFromString:data.visitTimeEnd withFormat:@"yyyy-MM-dd HH:mm"];
                NSString *str1 = [dateFormatter stringFromDate:endDate];
                if ([str1 hasPrefix:@"0"]) {
                    str1 = [str1 substringFromIndex:1];
                }
                NSString *confirmName = @"";
                NSString *confirmMobile = @"";
                if (![self isBlankString:_trade.confirmUserName]) {
                    cell.bIsShowConfirmInfo = YES;
                    confirmName = _trade.confirmUserName;
                    confirmMobile = _trade.confirmUserMobile;//[NSString stringWithFormat:@"%@ %@ %@",[_trade.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[_trade.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[_trade.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                }else if (![self isBlankString:data.confirmUserName])
                {
                    cell.bIsShowConfirmInfo = YES;
                    confirmName = data.confirmUserName;
                    confirmMobile = data.confirmUserMobile;//[NSString stringWithFormat:@"%@ %@ %@",[data.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[data.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[data.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                }
                
                cell.showVisitInfoView.visitDateLabel.text = [NSString stringWithFormat:@"预计到访时间:%@—%@",str,str1];
                cell.showVisitInfoView.visitCountLabel.text = [NSString stringWithFormat:@"预计到访人数:%@人",data.numPeople];
                cell.showVisitInfoView.visitFuncLabel.text = [NSString stringWithFormat:@"到访交通方式:%@",data.trafficMode];
                cell.showVisitInfoView.confirmUserLabel.text = [NSString stringWithFormat:@"服务确客专员:%@    %@",confirmName,confirmMobile];
                
                
            }else
            {
                NSString *confirmName = @"";
                NSString *confirmMobile = @"";
                if (![self isBlankString:_trade.confirmUserName]) {
                    cell.bIsShowConfirmInfo = YES;
                    confirmName = _trade.confirmUserName;
                    confirmMobile = _trade.confirmUserMobile;//[NSString stringWithFormat:@"%@ %@ %@",[_trade.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[_trade.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[_trade.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                }else if (![self isBlankString:data.confirmUserName])
                {
                    cell.bIsShowConfirmInfo = YES;
                    confirmName = data.confirmUserName;
                    confirmMobile = data.confirmUserMobile;//[NSString stringWithFormat:@"%@ %@ %@",[data.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[data.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[data.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                }
                cell.showVisitInfoView.confirmUserLabel.text = [NSString stringWithFormat:@"服务确客专员:%@    %@",confirmName,confirmMobile];
            }
            
        }
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section) {
        MessageData *data = nil;
        if (_followInformation.count > indexPath.row) {
            data = (MessageData*)[_followInformation objectForIndex:indexPath.row];
        }
        NSString *str = data.content;
        CGFloat labelWidth = kMainScreenWidth-30;
        CGSize strSize = [self textSize:str withConstraintWidth:labelWidth withFontSize:14];
        NSString *str1 = data.datetime;
        CGSize str1Size = [self textSize:str1 withConstraintWidth:labelWidth withFontSize:14];
        
        height = 12+strSize.height+str1Size.height+12+5;
    }else
    {
        MessageData *data = nil;
        if (_reportInformation.count > indexPath.row) {
            data = (MessageData*)[_reportInformation objectForIndex:indexPath.row];
        }
        NSString *str = data.content;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize strSize = [str sizeWithAttributes:attributes];
        
        height = 7+strSize.height+7;
        
        if (indexPath.row==_reportInformation.count-1) {
            if (![self isBlankString:data.numPeople]) {
                height = 7+strSize.height+7+ 70 + 7;
                if (![self isBlankString:_trade.confirmUserName] || ![self isBlankString:data.confirmUserName]) {
                    height = 7+strSize.height+7+ 90 + 7;
                }
            }else
            {
                if (![self isBlankString:_trade.confirmUserName] || ![self isBlankString:data.confirmUserName]) {
                    height = 7+strSize.height+7+ 30 + 7;
                }
            }
        }
    }
    
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle=[self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle==nil) {
        UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 7)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        return sectionView;
    }
    
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(15, 7, kMainScreenWidth-30, 30);
    label.backgroundColor=[UIColor clearColor];
    label.textColor=NAVIGATIONTITLE;
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.text=sectionTitle;
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    
    [sectionView addSubview:[self createLineView:0]];
    
    [sectionView addSubview:label];
    
    [sectionView addSubview:[self createLineView:43.5]];
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView=nil;
    if (section == 0) {
        sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 7)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 7;
    if (section) {
        height = 44;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    if (section == 0) {
        height = 7;
    }
    return height;
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, y, kMainScreenWidth-15, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth withFontSize:(CGFloat)fontsize{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:fontsize];
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

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
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
