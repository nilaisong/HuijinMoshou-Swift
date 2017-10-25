//
//  CustomerEvaluationViewController.m
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerEvaluationViewController.h"
#import "CustomerBaseBuildView.h"
#import "DataFactory+Customer.h"
#import "CustomerEvaluation.h"
#import "CustomerEvaluationTableViewCell.h"
#import "ChatViewController.h"
#import "BuildingDetailViewController.h"
#import "CustomerEmptyView.h"

@interface CustomerEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath    *evaIndexPath;
}
@property (nonatomic, strong) UIScrollView       *scrollView;
@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray     *evaluationArr;
@property (nonatomic, strong) NSMutableDictionary *rowHeightDic;
@property (nonatomic, strong) NSMutableArray     *rowHeightArr;
@property (nonatomic, strong) UIImageView        *evaluationImgView;
@property (nonatomic, strong) UIView             *evaView;
@property (nonatomic, strong) CustomerEmptyView  *emptyView;

@end

@implementation CustomerEvaluationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"客户评级";
    self.view.backgroundColor = BACKGROUNDCOLOR;
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY)];
    _evaluationArr = [[NSMutableArray alloc] init];
    _rowHeightArr = [[NSMutableArray alloc] init];
    _rowHeightDic = [[NSMutableDictionary alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self initHeaderView];
    //判断网络情况，初始化页面
    [self hasNetwork];
    
    // Do any additional setup after loading the view.
}

- (void)hasNetwork
{
    __weak CustomerEvaluationViewController *evaluation = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[evaluation reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    UIImageView * loadingView = [self setRotationAnimationWithView];
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
//    __weak CustomerEvaluationViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getcustomerEvaluationDetailWithCustId:self.customerId withCallBack:^(ActionResult *actionResult, Customer *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (actionResult.success) {
                [self.evaluationArr addObjectsFromArray:result.tradeArray];
            }else
            {
                [self showTips:actionResult.message];
            }
            if (result.tradeArray.count == 0) {
                [self createEmptyViewWithTopY:viewTopY + 100];
            }
            [self.rowHeightArr removeAllObjects];
            [self.tableView reloadData];
        });
    }];
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:[self createLineView:0 withX:0]];
    if ([self isBlankString:self.customerExpect] || [self.customerExpect isEqualToString:@"不限"]) {
        self.customerExpect = @"暂无";
    }
    if ([self isBlankString:self.customerName]) {
        self.customerName = @"";
    }
    if ([self isBlankString:self.customerPhone]) {
        self.customerPhone = @"";
    }
    NSArray *array = @[@"客户姓名:",@"客户电话:",@"购房意向:"];
    NSArray *array1 = [NSArray arrayWithObjects:self.customerName,self.customerPhone,self.customerExpect, nil];
    NSDictionary *attributes = @{NSFontAttributeName:FONT(16)};
    CGSize size = [@"购买意向:" sizeWithAttributes:attributes];
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (size.height + 10)*i, size.width, size.height)];
        label.textColor = NAVIGATIONTITLE;
        label.font = FONT(16);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [array objectForIndex:i];
        [headerView addSubview:label];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 10, label.top, kMainScreenWidth - 15 - label.right  - 10, label.height)];
        contentLabel.textColor = NAVIGATIONTITLE;
        contentLabel.font = FONT(16);
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.text = [array1 objectForIndex:i];
        [headerView addSubview:contentLabel];
        
        if (i==2) {
            CGSize size1 = [self textSize:[array1 objectForIndex:i] withConstraintWidth:kMainScreenWidth - 15 - label.right  - 10 withFont:16];
            contentLabel.height = size1.height;
            contentLabel.numberOfLines = 0;
            [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
            headerView.height = contentLabel.bottom + 15;
        }
    }
    [headerView addSubview:[self createLineView:headerView.height-0.5 withX:0]];
    self.tableView.tableHeaderView = headerView;
}

- (UIView *)createEvaluationViewWithFrame:(CGRect)frame
{
    _evaView = [[UIView alloc] initWithFrame:frame];
    _evaView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    [_evaView.layer setMasksToBounds:YES];
    [_evaView.layer setCornerRadius:4];
    
    NSArray *tempArr = @[@"客户评级分为4级",@"A级:代表客户购买意向很强",@"B级:代表客户购买意向较强",@"C级:代表客户购买意向一般",@"D级:代表客户购买意向较弱"];
    for (int i=0;i<tempArr.count;i++)
    {
        UILabel *tempL = [[UILabel alloc] initWithFrame:CGRectMake(10, 7+(_evaView.height-14)/5*i, _evaView.width-20, (_evaView.height-14)/5)];
        tempL.backgroundColor = [UIColor clearColor];
        tempL.textColor = [UIColor whiteColor];
        tempL.textAlignment = NSTextAlignmentLeft;
        tempL.text = [tempArr objectForIndex:i];
        tempL.font = FONT(12);
        [_evaView addSubview:tempL];
    }
    
    return _evaView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _evaluationArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TradeRecord *trade = nil;
    if (_evaluationArr.count>section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:section];
    }
    return trade.customerEvaluationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    TradeRecord *trade = (TradeRecord*)[_evaluationArr objectForIndex:indexPath.section];
    TradeRecord *trade = nil;
    CustomerEvaluation *data = nil;
    if (_evaluationArr.count>indexPath.section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:indexPath.section];
        if (trade.customerEvaluationList.count>indexPath.row) {
            data = (CustomerEvaluation*)[trade.customerEvaluationList objectForIndex:indexPath.row];
        }
    }
//    CustomerEvaluation *data = [[CustomerEvaluation alloc] init];//(CustomerEvaluation*)[trade.customerEvaluationList objectForIndex:indexPath.row];
//    data.intentionalPreference = @"无";//风景区,学区房,三居室,朝阳,面积,新小区,高速,市中心,南北通透,开间
//    data.userName = @"王菲菲";
//    data.evaluation = @"无";
//    data.adviceInformation = @"手机号股份收到过哈萨克十多个符合设计开关和你说肯德基上的概念的数控加工是的噶的故事";
//    data.time = @"2016-08-20 14:50";
    CustomerEvaluationTableViewCell *cell = [[CustomerEvaluationTableViewCell alloc] initWithCustomerEvaluation:data AndIndexPath:indexPath];
    [cell addSubview:[self createLineView:[[((NSArray*)[_rowHeightDic objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]]) objectAtIndex:indexPath.row] floatValue]-0.5 withX:0]];
    [cell.evaluationDesBtn addTarget:self action:@selector(toggleCustomerEvaluationButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chatBtn addTarget:self action:@selector(toggleConfirmChatButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44;
//    TradeRecord *trade = (TradeRecord*)[_evaluationArr objectForIndex:indexPath.section];
    TradeRecord *trade = nil;
    CustomerEvaluation *data = nil;
    if (_evaluationArr.count>indexPath.section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:indexPath.section];
        if (trade.customerEvaluationList.count>indexPath.row) {
            data = (CustomerEvaluation*)[trade.customerEvaluationList objectForIndex:indexPath.row];
        }
    }
//    CustomerEvaluation *data = [[CustomerEvaluation alloc] init];//(CustomerEvaluation*)[trade.customerEvaluationList objectForIndex:indexPath.row];
//    data.intentionalPreference = @"无";//风景区,学区房,三居室,朝阳,面积,新小区,高速,市中心,南北通透,开间
//    data.userName = @"王菲菲";
//    data.evaluation = @"无";
//    data.adviceInformation = @"手机号股份收到过哈萨克十多个符合设计开关和你说肯德基上的概念的数控加工是的噶的故事";
//    data.time = @"2016-08-20 14:50";
    NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
    CGSize size = [@"购买意向:" sizeWithAttributes:attributes];
    
    rowHeight = 15*4+size.height*3;
    if ([data.intentionalPreference isEqualToString:@"无"]) {
        rowHeight += size.height+15;
    }else
    {
        NSArray *tempArr = [data.intentionalPreference componentsSeparatedByString:@","];
        if (tempArr.count > 0) {
            rowHeight += size.height+15+(15+30)*((tempArr.count-1)/5+1);
        }
    }
    
    if (![self isBlankString:data.adviceInformation]) {
        CGSize contentSize = [self textSize:data.adviceInformation withConstraintWidth:kMainScreenWidth - 15 - 10 - 15 - size.width withFont:14];
        rowHeight += 15+contentSize.height;
    }
    rowHeight += 15;
   

    if (![self isBlankString:data.guideState]) {
        CGSize contentSize = [self textSize:data.guideState withConstraintWidth:kMainScreenWidth - 15 - 10 - 15 - size.width withFont:14];
        rowHeight += 15+contentSize.height;
    }
    rowHeight += 15;
    
    if ([[_rowHeightDic allKeys] containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.section]]) {
        [_rowHeightDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
    }else
    {
        [_rowHeightArr removeAllObjects];
    }
    [_rowHeightArr addObject:[NSString stringWithFormat:@"%f",rowHeight]];
    [_rowHeightDic setObject:_rowHeightArr forKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
    return rowHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeadView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 54)];
    sectionHeadView.backgroundColor = BACKGROUNDCOLOR;
//    [sectionHeadView addSubview:[self createLineView:10-0.5 withX:0]];
//    TradeRecord *trade = (TradeRecord*)[_evaluationArr objectForIndex:section];
    TradeRecord *trade = nil;
    if (_evaluationArr.count>section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:section];
    }
    
    NSString *title = [NSString stringWithFormat:@"报备楼盘: %@",trade.buildingName];
    CustomerBaseBuildView *customerFollowInfoView = [[CustomerBaseBuildView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 44) Title:title AndImageName:nil AndBtnImgView:@"arrow-right" WithToBeUsed:5];
    customerFollowInfoView.backgroundColor = [UIColor whiteColor];
    
    [customerFollowInfoView addSubview:[self createLineView:0 withX:0]];
    [customerFollowInfoView addSubview:[self createLineView:customerFollowInfoView.height-0.5 withX:0]];
    
    [sectionHeadView addSubview:customerFollowInfoView];
    NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
    CGSize size = [@"查看详情" sizeWithAttributes:attributes];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8-7-size.width, 7, size.width, 30)];
    label.text = @"查看详情";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = LABELCOLOR;
    label.font = FONT(14);
    
    [customerFollowInfoView addSubview:label];
    
    [customerFollowInfoView addSubview:[self createLineView:customerFollowInfoView.height-0.5 withX:0]];
    
    //    点击跳转至楼盘详情页面的按钮
    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, customerFollowInfoView.width, 44)];
    followBtn.backgroundColor = [UIColor clearColor];
    [followBtn addTarget:self action:@selector(toggleFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [customerFollowInfoView addSubview:followBtn];
    return sectionHeadView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_evaluationImgView != nil) {
        [_evaluationImgView removeAllSubviews];
        [_evaluationImgView removeFromSuperview];
    }
    if (_evaView != nil) {
        [_evaView removeAllSubviews];
        [_evaView removeFromSuperview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_evaluationImgView != nil) {
        [_evaluationImgView removeAllSubviews];
        [_evaluationImgView removeFromSuperview];
    }
    if (_evaView != nil) {
        [_evaView removeAllSubviews];
        [_evaView removeFromSuperview];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)toggleFollowBtn:(UIButton*)sender
{
    CustomerEvaluationTableViewCell *cell = nil;
    if (iOS8) {
        cell = (CustomerEvaluationTableViewCell *)[[sender superview] superview];
    }else
    {
        cell = (CustomerEvaluationTableViewCell *)[[[sender superview] superview] superview];
    }
    
    if (_evaluationImgView != nil) {
        [_evaluationImgView removeAllSubviews];
        [_evaluationImgView removeFromSuperview];
    }
    if (_evaView != nil) {
        [_evaView removeAllSubviews];
        [_evaView removeFromSuperview];
    }
    NSIndexPath *tempIndexPath = [self.tableView indexPathForCell:cell];
    TradeRecord *trade = nil;
    if (_evaluationArr.count>tempIndexPath.section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:tempIndexPath.section];
    }
    [MobClick event:@"khpj_lpxq"];//客户评级-查看楼盘详情
    BuildingDetailViewController *detailVC = [[BuildingDetailViewController alloc] init];
    detailVC.buildingId = trade.buildingId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)toggleConfirmChatButton:(UIButton*)sender
{
  
    
    CustomerEvaluationTableViewCell *cell = nil;
    if (iOS8) {
        cell = (CustomerEvaluationTableViewCell *)[[sender superview] superview];
    }else
    {
        cell = (CustomerEvaluationTableViewCell *)[[[sender superview] superview] superview];
    }
    
    if (_evaluationImgView != nil) {
        [_evaluationImgView removeAllSubviews];
        [_evaluationImgView removeFromSuperview];
    }
    if (_evaView != nil) {
        [_evaView removeAllSubviews];
        [_evaView removeFromSuperview];
    }
    NSIndexPath *tempIndexPath = [self.tableView indexPathForCell:cell];
    TradeRecord *trade = nil;
    CustomerEvaluation *data = nil;
    if (_evaluationArr.count>tempIndexPath.section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:tempIndexPath.section];
        if (trade.customerEvaluationList.count>tempIndexPath.row) {
            data = (CustomerEvaluation*)[trade.customerEvaluationList objectForIndex:tempIndexPath.row];
        }
    }
    
    
    //保存确客信息到本地数据库
    
    UserCacheInfo *user = [UserCacheManager getById:data.easemobUserName];

    if (user.NickName.length<=0) {
        [UserCacheManager saveInfo:data.easemobUserName imgUrl:nil nickName:data.userName];
        
    }
    
    
    
    //    agency_building_url    楼盘图片url
    //    agency_building_name    楼盘名字
    //    agency_building_id    楼盘id
    //    agency_building_area    楼盘区域商圈
    //    agency_building_detail     是否显示楼盘详情的自定义图片view
    //    agency_mobile            经纪人手机号
    //    agency_employeeNo  经纪人员工编号
    //    agency_department 经纪人机构门店
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    //    [extDic setValue:userInfo.Id forKey:kChatUserId];
    //    [extDic setValue:userInfo.AvatarUrl forKey:kChatUserPic];
    //    [extDic setValue:userInfo.NickName forKey:kChatUserNick];
//    EasemobConfirmModel
    [extDic setValue:trade.pathUrl forKey:@"agency_building_url"];
    [extDic setValue:trade.buildingName forKey:@"agency_building_name"];
    
    [extDic setValue:trade.buildingId forKey:@"agency_building_id"];
    [extDic setValue:[NSString stringWithFormat:@"%@-%@",trade.districy,trade.plate] forKey:@"agency_building_area"];
    [extDic setValue:@"1" forKey:@"agency_building_detail"];
    [extDic setValue:[UserData sharedUserData].mobile forKey:@"agency_mobile"];
    [extDic setValue:[UserData sharedUserData].employeeNo forKey:@"agency_employeeNo"];
    [extDic setValue:[NSString stringWithFormat:@"%@ %@",[UserData sharedUserData].orgnizationName,[UserData sharedUserData].storeName] forKey:@"agency_department"];
    

    NSString *str = [NSString stringWithFormat:@"[%@]",trade.buildingName];
    //发送文字消息
    EMMessage *message = [EaseSDKHelper sendTextMessage:str
                                                     to:data.easemobUserName//接收方data.easemobUserName
                                            messageType:EMChatTypeChat//消息类型
                                             messageExt:extDic]; //扩展信息
    
    
    //发送构造成功的消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
        
    } completion:^(EMMessage *message, EMError *error) {
        
        
    }];
    
    //判断确客的环信ID 正常
    if ([self isBlankString:data.easemobUserName]) {
        
        AlertShow(@"确客不正确");

        return;
    }
    
    
    [MobClick event:@"khpj_zxzx"];//客户评级-在线咨询
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:data.easemobUserName conversationType:EMConversationTypeChat];//@"13693211326"  data.easemobUserName
    chatVC.buildingID = trade.buildingId;
    chatVC.nickName = data.userName;
    
    
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)toggleCustomerEvaluationButton:(UIButton*)sender
{
    CustomerEvaluationTableViewCell *cell = nil;
    if (iOS8) {
        cell = (CustomerEvaluationTableViewCell *)[[sender superview] superview];
    }else
    {
        cell = (CustomerEvaluationTableViewCell *)[[[sender superview] superview] superview];
    }

    if (_evaluationImgView != nil) {
        [_evaluationImgView removeAllSubviews];
        [_evaluationImgView removeFromSuperview];
    }
    if (_evaView != nil) {
        [_evaView removeAllSubviews];
        [_evaView removeFromSuperview];
    }
    
        evaIndexPath = [self.tableView indexPathForCell:cell];
//        TradeRecord *trade = (TradeRecord*)[_evaluationArr objectForIndex:evaIndexPath.section];
    TradeRecord *trade = nil;
    if (_evaluationArr.count>evaIndexPath.section) {
        trade = (TradeRecord*)[_evaluationArr objectForIndex:evaIndexPath.section];
    }
    [MobClick event:@"khpj_pjsm"];//客户评级页-评级说明
#pragma mark - 接口调试时需放开
    if (_evaluationArr.count>evaIndexPath.section && trade.customerEvaluationList.count>evaIndexPath.row) {
        
        
        CGRect targetRect = cell.evaluationDesBtn.frame;
    
        [cell.contentView addSubview:[self createEvaluationViewWithFrame:CGRectMake(kMainScreenWidth-15-190, targetRect.origin.y+targetRect.size.height+5+7.9, 190, 120)]];
    
        _evaluationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(targetRect.origin.x+targetRect.size.width/2+10, targetRect.origin.y+targetRect.size.height+5, 10, 8)];
        [_evaluationImgView setImage:[UIImage imageNamed:@"icon_evaluation"]];
        [cell.contentView addSubview:_evaluationImgView];
    
    }

//                [menu setTargetRect:CGRectInset(CGRectMake(targetRect.origin.x/2-5, targetRect.origin.y, targetRect.size.width, targetRect.size.height),0.0f, 0.0f) inView:[cell.telLabel superview]];

}

- (void)createEmptyViewWithTopY:(CGFloat)topY
{
    _emptyView = [[CustomerEmptyView alloc] initWithFrame:CGRectMake(0, topY, kMainScreenWidth, kMainScreenHeight - topY)];
    _emptyView.tip.text = @"暂无数据";
    [self.tableView addSubview:_emptyView];
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth withFont:(NSInteger)textFont{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:textFont];
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
#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
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
