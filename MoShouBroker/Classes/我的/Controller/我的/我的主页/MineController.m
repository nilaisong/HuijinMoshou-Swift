//
//  MineController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MineController.h"
#import "HMTool.h"
#import "PointMallViewController.h"
//#import "LoginViewController.h"
#import "CommentsViewController.h"
#import "MessageListViewController.h"
#import "PersonalInfoViewController.h"
#import "SettingViewController.h"
#import "MyBuildingViewController.h"
#import "MortgageCalculatorViewController.h"

//create by xiaotei 2015-12-15
#import "XTUserScheduleViewController.h"
#import "XTWorkReportingController.h"

//create by xiaotei 2015-12-21
#import "XTMineFortuneController.h"
#import "XTSaleRankingController.h"


#import "DataFactory+User.h"
#import "DataFactory+Main.h"

#import "ShareActionSheet.h"
#import "CommonProblemViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UserData.h"
#import "MineTableViewCell.h"
#import "ChangeShopViewController.h"
#import "MineItemButtonView.h"
#import "UsingHelpViewController.h"
#import "MyEvaluationViewController.h"

#define mineBgColor [UIColor colorWithHexString:@"efeff4"]

@interface MineController ()<MineItemButtonViewDelegate>{

    UITableView *_mineTable;
    NSArray *_sectonText;
    NSArray *_iconImages;
    UIButton *_signBtn;
    UILabel *_signedLabel;
    UILabel *_plusLabel;
    UIView *_headView;
    MyImageView *_headImage;
    UILabel *_name;
    UILabel *_shop;
    ShareActionSheet *shareAS;
    UILabel *redDot;
    UIImageView *headArrow;
    BOOL _isnew;
    NSString *_updateMsg;
    BOOL _needUpdate;
    NSString* _newVersion;
    
    //UIVisualEffectView *effectview;
    UIView       *effectview;
//    CGFloat      _oldOffset;
//    UILabel *pointDetail;
//    UILabel *pointTitle;
//    UIView *tbline1;
//    UIView *tbline2;

    
}

@property (nonatomic, strong) UIWebView    *webView;

@end
#define CURRENTVIEWHEIGHT  self.view.bounds.size.height
#define CELLHEIGHT CURRENTVIEWHEIGHT/13

@implementation MineController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setupUnreadMessageCount];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    _sectonText = [NSArray arrayWithObjects: @"我的评价",@"房贷计算器",@"常见问题",@"客服电话",@"意见反馈",@"把APP分享给朋友",@"新版本检测",nil];//,@"新手攻略"
    
    _iconImages = [NSArray arrayWithObjects:@"icon_myevaluation",@"icon_calculate",@"icon_normal",@"icon_customerServiceTel",@"icon_response",@"icon_share",@"icon_newversion",nil];//,@"icon_strategy"
    
    [self createTableView];
//    [self.view bringSubviewToFront:self.navigationBar];

    [self createHeaderViewWithTable];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserData) name:@"REFRESHMINEINFO" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRedDot) name:@"reloadHomeDot" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMineTableView) name:@"REFRESHMINETABLEVIEW" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPoints) name:@"REFRESHMINEPOINTS" object:nil];
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    
//    [self initNavgationBar];
    [self getUserData];
    

}

#pragma mark 检测版本更新
-(void)checkUpdate{
    [[DataFactory sharedDataFactory]checkVersionUpdateWithCallback:^(BOOL isnew, NSString *message, BOOL mustUpdate,NSString* newVersion) {
        _isnew = isnew;
        _needUpdate = mustUpdate;
        _updateMsg = message;
        _newVersion = newVersion;
        [self refreshUI];
    }];
    
}
#pragma mark 刷新用户数据
-(void)getUserData{
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        [[AccountServiceProvider sharedInstance] getUserInfo:^(ResponseResult *result) {
            if (result.success)
            {
                [UserData sharedUserData].userInfo = result.data;
                [self checkUpdate];
                [self refreshUI];
            }
            else
            {
                [TipsView showTips:result.message inView:self.view];
            }
        }];

    }
}

#pragma mark - 顶部按钮ui
-(void)initNavgationBar{
    self.navigationBar.hidden = YES;
    
/*    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
    [self.view addSubview:effectview];
    effectview.alpha = 0; */
    
    effectview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    effectview.backgroundColor = [UIColor colorWithHexString:@"37AEFF" alpha:0.0];
    [self.view addSubview:effectview];
    
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 22, 40, 40)];
    [settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];
    [settingBtn setTag:SETTINGBTNTAG];
    UIButton *msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-40, 22,  40, 40)];
    [self.view addSubview:msgBtn];
    [msgBtn setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    //    [msgBtn setImage:[UIImage imageNamed:@"咨询蓝按下.png"] forState:UIControlStateSelected];
    [msgBtn setTag:MSGBTNTAG];
    
    redDot =[[UILabel alloc]initWithFrame:CGRectMake(kFrame_Width(msgBtn)-20, 0, 16, 16)];
    redDot.backgroundColor = ORIGCOLOR;
    redDot.layer.cornerRadius = redDot.width/2;
    redDot.layer.masksToBounds = YES;
    redDot.textAlignment = NSTextAlignmentCenter;
    redDot.text = @"";
    redDot.font = FONT(11.f);
    redDot.userInteractionEnabled = YES;
    redDot.textColor = [UIColor whiteColor];
    redDot.hidden = YES;
    [msgBtn addSubview:redDot];
    
    [settingBtn addTarget:self action:@selector(mineAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [msgBtn addTarget:self action:@selector(mineAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = _mineTable.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    _mineTable.contentOffset = offset;
//    //CGFloat offsetY = scrollView.contentOffset.y + _mineTable.contentInset.top;//注意
//    if (scrollView.contentOffset.y <= 0) {
//        effectview.alpha = 0;
//    }else if (scrollView.contentOffset.y+_mineTable.height>_mineTable.contentSize.height) {
//        effectview.alpha = 1;
//    }else {
//        if (scrollView.contentOffset.y > _oldOffset) {
//            //如果当前位移大于缓存位移，说明scrollView向上滑动
//            if (effectview.alpha < 1) {
//                effectview.alpha += 0.05;
//            }
//        }else
//        {
//            if (effectview.alpha != 0) {
//                effectview.alpha -= 0.02;
//            }
//        }
//    }
//    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}
#pragma mark 刷新ui
-(void)refreshUI{
    if ([UserData sharedUserData].userInfo.avatar.length>0) {
        [_headImage setImageWithUrlString:[UserData sharedUserData].userInfo.avatar placeholderImage:[UIImage imageNamed:@"icon_header"]];
    }else{
     [_headImage setImage:[UIImage imageNamed:@"icon_header"]];//我线-拷贝
    }
    if([self isBlankString:[UserData sharedUserData].userInfo.userName]){
        [_name setText:@"请取一个响亮的名号"];

    }else{
        [_name setText:[UserData sharedUserData].userInfo.userName];

    }

    CGSize nameSize = [HMTool getTextSizeWithText:_name.text andFontSize:16];
    [_name setFrame:CGRectMake(20, _headImage.bottom+17, kMainScreenWidth-40, nameSize.height)];
    
    if([self isBlankString:[UserData sharedUserData].userInfo.storeName]){
        [_shop setText:@"请先绑定门店"];
        
    }else{
        [_shop setText:[UserData sharedUserData].userInfo.storeName];
    }
//    CGSize shopSize = [HMTool getTextSizeWithText:_shop.text andFontSize:12];
//    [_shop setFrame:CGRectMake(105, _name.bottom+10, kMainScreenWidth-210, _headImage.bottom-_name.bottom-10)];//CGRectMake((shopSize.width>(kMainScreenWidth-210))?20:(kMainScreenWidth-shopSize.width)/2, _name.bottom+10,((shopSize.width>(kMainScreenWidth-210))?kMainScreenWidth-125:shopSize.width), shopSize.height)
//    if (shopSize.width>(kMainScreenWidth-220)) {
//        _shop.textAlignment = NSTextAlignmentRight;
//    }else
//    {
//        _shop.textAlignment = NSTextAlignmentCenter;
//    }
//    headArrow.left = _shop.right+10;
    CGSize size = [HMTool getTextSizeWithText:_shop.text andFontSize:12];
    CGSize shopSize = [self textSize:_shop.text withConstraintWidth:kMainScreenWidth-60];
    _shop.frame = CGRectMake(MAX(30, (kMainScreenWidth-size.width)/2), _name.bottom+5, MIN(kMainScreenWidth-60, size.width), shopSize.height);
    headArrow.left = _shop.right+10;
    headArrow.centerY = _shop.top + shopSize.height/2;
    if ([UserData sharedUserData].userInfo.isSignIn) {
        [_signedLabel setHidden:NO];
        [_signBtn setHidden:YES];
    }else{
        [_signedLabel setHidden:YES];
        [_signBtn setHidden:NO];
    }
    [_mineTable reloadData];
    [self refreshRedDot];//刷新消息红点
}
#pragma mark 刷新红点
-(void)refreshRedDot{
    [[DataFactory sharedDataFactory] getUnreadCntWithCallBack:^(NSNumber *num) {
        NSInteger allNum = [num integerValue]+[self getUnreadMessageCount]+[[UserData sharedUserData].userInfo.offlineMsgCount integerValue];
        
        if(allNum > 0)
        {
            if (allNum <= 99) {
                redDot.text = [NSString stringWithFormat:@"%zd",allNum];
                [redDot setFont:[UIFont systemFontOfSize:11]];
            }else{
                [redDot setText:@"99+"];
                [redDot setFont:[UIFont systemFontOfSize:8]];
            }
            redDot.hidden = NO;
        }else{
            redDot.hidden = YES;
        }
        
    } faildCallBack:^(ActionResult *result) {
    }];
}

-(NSInteger)getUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}

-(void)setupUnreadMessageCount
{
    [self refreshRedDot];
}

#pragma mark - tableView-UI
- (void)createTableView
{
    _mineTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height-self.tabBarController.tabBar.height-0.5) style:UITableViewStyleGrouped];
    [_mineTable setDelegate:self];
    [_mineTable setDataSource:self];
    _mineTable.showsVerticalScrollIndicator = NO;
    [_mineTable setBackgroundColor:mineBgColor];
    _mineTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mineTable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _mineTable.bottom, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = mineBgColor;
    [self.view addSubview:lineView];
}

- (void)createHeaderViewWithTable
{
    float scale = kMainScreenWidth/375.0;
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    [_headView setBackgroundColor:[UIColor clearColor]];
    
    UIView *headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    headBgView.backgroundColor = [UIColor clearColor];//colorWithPatternImage:[UIImage imageNamed:@"mine_background"]
    [_headView addSubview:headBgView];
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_background"]];
    [headBgView addSubview:bgImgView];
    
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 22, 40, 40)];
    [settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
    [_headView addSubview:settingBtn];
    [settingBtn setTag:SETTINGBTNTAG];
    UIButton *msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-40, 22,  40, 40)];
    [_headView addSubview:msgBtn];
    [msgBtn setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    //    [msgBtn setImage:[UIImage imageNamed:@"咨询蓝按下.png"] forState:UIControlStateSelected];
    [msgBtn setTag:MSGBTNTAG];
    
    redDot =[[UILabel alloc]initWithFrame:CGRectMake(kFrame_Width(msgBtn)-20, 0, 16, 16)];
    redDot.backgroundColor = ORIGCOLOR;
    redDot.layer.cornerRadius = redDot.width/2;
    redDot.layer.masksToBounds = YES;
    redDot.textAlignment = NSTextAlignmentCenter;
    redDot.text = @"";
    redDot.font = FONT(11.f);
    redDot.userInteractionEnabled = YES;
    redDot.textColor = [UIColor whiteColor];
    redDot.hidden = YES;
    [msgBtn addSubview:redDot];
    
    [settingBtn addTarget:self action:@selector(mineAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [msgBtn addTarget:self action:@selector(mineAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _headImage =[[MyImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth/2-(kMainScreenWidth>320?37*scale:37), 50, kMainScreenWidth>320?74*scale:74, kMainScreenWidth>320?74*scale:74)];
    [_headImage setImage:[UIImage imageNamed:@"icon_header"]];//我线-拷贝
    if ([UserData sharedUserData].userInfo.avatar.length>0) {
        [_headImage setImageWithUrlString:[UserData sharedUserData].userInfo.avatar placeholderImage:[UIImage imageNamed:@"icon_header"]];
    }
    _headImage.layer.cornerRadius = kMainScreenWidth>320?37*scale:37;
    _headImage.layer.masksToBounds = YES;
    [headBgView addSubview:_headImage];
    
    
    _name = [[UILabel alloc]init];
    if([self isBlankString:[UserData sharedUserData].userInfo.userName]){
        [_name setText:@"请取一个响亮的名号"];
    }else{
        [_name setText:[UserData sharedUserData].userInfo.userName];
        
    }
    [_name setFont:[UIFont boldSystemFontOfSize:16]];
    CGSize nameSize = [_name.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    [_name setFrame:CGRectMake(20, _headImage.bottom+17, kMainScreenWidth-40, nameSize.height)];
    _name.textColor = [UIColor whiteColor];
    _name.textAlignment = NSTextAlignmentCenter;
    [headBgView addSubview:_name];
    
    _shop = [[UILabel alloc]init];
    
    if([self isBlankString:[UserData sharedUserData].userInfo.storeName]){
        [_shop setText:@"请先绑定门店"];
        
    }else{
        [_shop setText:[UserData sharedUserData].userInfo.storeName];
    }
    [_shop setFont:[UIFont systemFontOfSize:12]];
    _shop.numberOfLines = 0;
    _shop.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [HMTool getTextSizeWithText:_shop.text andFontSize:12];
    CGSize shopSize = [self textSize:_shop.text withConstraintWidth:kMainScreenWidth-60];
    _shop.frame = CGRectMake(MAX(30, (kMainScreenWidth-size.width)/2), _name.bottom+5, MIN(kMainScreenWidth-60, size.width), shopSize.height);
//    [_shop setFrame:CGRectMake((shopSize.width>(kMainScreenWidth-210))?20:(kMainScreenWidth-shopSize.width)/2, _name.bottom+10,((shopSize.width>(kMainScreenWidth-210))?kMainScreenWidth-125:shopSize.width), shopSize.height)];
    _shop.textColor = [UIColor whiteColor];
//    if (shopSize.width>(kMainScreenWidth-220)) {
//        _shop.textAlignment = NSTextAlignmentRight;
//    }else
//    {
        _shop.textAlignment = NSTextAlignmentCenter;
//    }
    [headBgView addSubview:_shop];
    
    headArrow =[[UIImageView alloc]initWithFrame:CGRectMake(_shop.right+10, _shop.top+3, (size.height-6)*5/8, size.height-6)];
    headArrow.centerY = _shop.top + shopSize.height/2;
    [headArrow setImage:[UIImage imageNamed:@"icon_modify"]];
    [headBgView addSubview:headArrow];
    
    headBgView.height = _shop.bottom+25;
    bgImgView.frame = CGRectMake(0, 0, kMainScreenWidth, headBgView.height);
    UIButton *headBtn = [[UIButton alloc]init];
    [headBtn setFrame:CGRectMake(0, viewTopY, kMainScreenWidth,headBgView.height-viewTopY)];
    [headBtn setTag:MINEHEADTAG];
    [headBtn addTarget: self action:@selector(mineAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [headBgView addSubview:headBtn];
    
    _signBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-70,55+(headBgView.height-64)/2-14, 70, 28)];
    [_signBtn setTag:MINESIGNTAG];
    [_signBtn setBackgroundColor:[UIColor whiteColor]];
    [_signBtn setImage:[UIImage imageNamed:@"icon_sign"] forState:UIControlStateNormal];
    [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [_signBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2.5)];
    [_signBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, 0)];
    _signBtn.titleLabel.font = FONT(12);
    [_signBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_signBtn.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(14.0, 14.0)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    shape.frame = _signBtn.bounds;
    [shape setPath:rounded.CGPath];
    _signBtn.layer.mask = shape;
    
    [_signBtn.layer setMasksToBounds:YES];
    [headBgView addSubview:_signBtn];
    
    _signedLabel = [[UILabel alloc] initWithFrame:_signBtn.frame];
    [_signedLabel setFont:[UIFont systemFontOfSize:12]];
    [_signedLabel setHidden:YES];
    if ([UserData sharedUserData].userInfo.isSignIn) {
        [_signedLabel setHidden:NO];
        [_signBtn setHidden:YES];
    }else{
        [_signedLabel setHidden:YES];
        [_signBtn setHidden:NO];
    }
    _signedLabel.backgroundColor = [UIColor colorWithHexString:@"ff6600"];
    _signedLabel.textColor = [UIColor whiteColor];
    _signedLabel.textAlignment = NSTextAlignmentCenter;
    _signedLabel.text = @"已签到+3";
    UIBezierPath* rounded2 = [UIBezierPath bezierPathWithRoundedRect:_signedLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(14.0, 14.0)];
    CAShapeLayer* shape2 = [[CAShapeLayer alloc] init];
    shape2.frame = _signedLabel.bounds;
    [shape2 setPath:rounded2.CGPath];
    _signedLabel.layer.mask = shape2;
    [_signedLabel.layer setMasksToBounds:YES];
    [headBgView addSubview:_signedLabel];
    [_signBtn addTarget:self action:@selector(mineAllBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, headBgView.bottom+10, kMainScreenWidth, 0)];
    itemView.backgroundColor = [UIColor whiteColor];
    
    [_headView addSubview:itemView];
    
    NSArray *temp1 = @[@"icon_achievement",@"icon_favourite",@"icon_schedule",@"icon_report",@"icon_pointshop",@"icon_rankinglist"];
    NSArray *temp2 = @[@"我的业绩",@"我的收藏",@"我的日程",@"工作报表",@"积分商城",@"排行榜"];
    for (int i=0; i<6; i++) {
        MineItemButtonView *itemBtnView = [[MineItemButtonView alloc] initViewWithImgName:[temp1 objectForIndex:i] WithTitle:[temp2 objectForIndex:i] WithFrame:CGRectMake((i%3)*(kMainScreenWidth-1)/3+0.5*(i%3-1), i/3*(90*scale+0.5), (kMainScreenWidth-1)/3, 90*scale)];
        itemBtnView.tag = 2000+i;
        itemBtnView.delegate = self;
        [itemView addSubview:itemBtnView];
        UILabel *verline = [[UILabel alloc] init];
        verline.backgroundColor = mineBgColor;
        [itemView addSubview:verline];
        if (i==1 || i==4) {
            verline.frame = CGRectMake((i%3)*(kMainScreenWidth-1)/3, 30*scale+i/3*90*scale, 0.5, 30*scale);
        }else if (i==2 || i==5)
        {
            verline.frame = CGRectMake((i%3)*(0.5+(kMainScreenWidth-1)/3), 30*scale+i/3*90*scale, 0.5, 30*scale);
        }
    }
    UILabel *horline = [[UILabel alloc] initWithFrame:CGRectMake(10, 90*scale, kMainScreenWidth-20, 0.5)];
    horline.backgroundColor = mineBgColor;
    [itemView addSubview:horline];
    
    itemView.height = 180*scale+0.5;
    _headView.height = itemView.bottom+10;
    
    _mineTable.tableHeaderView = _headView;
}

#pragma  mark 设置每个section的row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 2;
    
    if (section==0) {
        if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
            rowNum = 2;
        }else{
            rowNum = 3;
 
        }
    }
    if (section==1) {
        if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
            rowNum = 1;
        }
    }
    if (section==2 && !_isnew) {
        rowNum = 1;
    }
    /*switch (section) {
        case 0:
        {
            rowNum = 3;
        }
            break;
        case 1:
        {
            rowNum = 2;
        }
            break;
        case 2:
        {
            if (_isnew) {//是否需要更新版本
                rowNum = 2;
            }
        }
            break;
            
        default:
            break;
    }*/
    return rowNum;
}
#pragma mark 设置tableview头行高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
#pragma mark 设置section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MineTableViewCell *cell =[[MineTableViewCell alloc]init];

    switch (indexPath.section) {
        case 0:
        {
            
            if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum])
            {
                [cell.iconImage setImage:[UIImage imageNamed:[_iconImages objectForIndex:indexPath.row+1]]];
                [cell.titleLabel setText:[_sectonText objectForIndex:indexPath.row+1]];
            }else{
                
                [cell.iconImage setImage:[UIImage imageNamed:[_iconImages objectForIndex:indexPath.row]]];
                [cell.titleLabel setText:[_sectonText objectForIndex:indexPath.row]];

            }
            
                   //                        NSLog(@"**********%@",[_sectonText objectForIndex:indexPath.row]);
            if (indexPath.row == 0) {
                cell.iconImage.left = 10+1;
                cell.iconImage.width = 15;
            }else if(indexPath.row == 1){
                [cell.line setHidden:YES];
//                cell.iconImage.top = 22-7.5;
//                cell.iconImage.height = 15;
            }
        }
            break;
        case 1:
        {
            if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum])
            {
                [cell.iconImage setImage:[UIImage imageNamed:[_iconImages objectForIndex:4+indexPath.row]]];
                [cell.titleLabel setText:[_sectonText objectForIndex:4+indexPath.row]];
            }else
            {
                [cell.iconImage setImage:[UIImage imageNamed:[_iconImages objectForIndex:3+indexPath.row]]];
                [cell.titleLabel setText:[_sectonText objectForIndex:3+indexPath.row]];
                if (indexPath.row == 0) {
    //                cell.arrowImage.hidden = YES;
                    [cell.detailLabel setText:[UserData sharedUserData].userInfo.customerServiceTel];
                    CGSize detailSize =[HMTool getTextSizeWithText:cell.detailLabel.text andFontSize:12];
                    [cell.detailLabel setFrame:CGRectMake(MAX(cell.titleLabel.right+10, cell.arrowImage.left-10-detailSize.width) , 22-detailSize.height/2, detailSize.width, detailSize.height)];
                }else if(indexPath.row == 1){
                    [cell.line setHidden:YES];
                }
            }
        }
            break;
        case 2:
        {
            [cell.iconImage setImage:[UIImage imageNamed:[_iconImages objectForIndex:5+indexPath.row]]];
            
            [cell.titleLabel setText:[_sectonText objectForIndex:5+indexPath.row]];
            if (_isnew) {
                if(indexPath.section == 2&&indexPath.row == 1){
                    [cell.line setHidden:YES];
                }
            }else
            {
                if(indexPath.section == 2&&indexPath.row == 0){
                    [cell.line setHidden:YES];
                }
            }
        }
            break;
        
        default:
            break;
    }
    CGSize titleSize =[cell.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [cell.titleLabel setFrame:CGRectMake(kFrame_XWidth(cell.iconImage)+10, 22-titleSize.height/2, titleSize.width, titleSize.height)];
    if (_isnew) {
        if (indexPath.section == 2 && indexPath.row== 1) {
            [cell.detailLabel setText:[NSString stringWithFormat:@"当前版本 V%@",kAppVersion]];
            CGSize detailSize =[HMTool getTextSizeWithText:cell.detailLabel.text andFontSize:12];
            [cell.detailLabel setFrame:CGRectMake(kFrame_X(cell.arrowImage)-10-detailSize.width, 22-detailSize.height/2, detailSize.width, detailSize.height)];
            if (kFrame_X(cell.detailLabel)<=kFrame_Width(cell.titleLabel)) {
                [cell.detailLabel setFrame:CGRectMake(kFrame_X(cell.arrowImage)-10-detailSize.width+5, 22-detailSize.height/2, kFrame_X(cell.arrowImage)-kFrame_XWidth(cell.titleLabel), detailSize.height)];
            }
        }
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark - tebleview页面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        
        if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum])
        {
        
            switch (indexPath.row) {

                case 0://房贷计算器
            {
                [MobClick event:@"wode_fdjsq"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_FDJSQ" andPageId:@"PAGE_WD"];
                MortgageCalculatorViewController *VC = [[MortgageCalculatorViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
                case 1://常见问题
            {
                [MobClick event:@"wode_cjwt"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_CJWT" andPageId:@"PAGE_WD"];
                CommonProblemViewController *co =[[CommonProblemViewController alloc]init];
                [self.navigationController pushViewController:co animated:YES];
            }
            break;
            
            default:
                break;}
            
            }else{
           
            switch (indexPath.row) {

        case 0: //我的评价
            {
                MyEvaluationViewController *VC = [[MyEvaluationViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
        case 1://房贷计算器
            {
                [MobClick event:@"wode_fdjsq"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_FDJSQ" andPageId:@"PAGE_WD"];
                MortgageCalculatorViewController *VC = [[MortgageCalculatorViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
        case 2://常见问题
            {
                [MobClick event:@"wode_cjwt"];
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_CJWT" andPageId:@"PAGE_WD"];
                CommonProblemViewController *co =[[CommonProblemViewController alloc]init];
                [self.navigationController pushViewController:co animated:YES];
            }
            break;
            
        default:
            break;

        }
            
                  }
    }else if (indexPath.section == 1){
        if(![self isBlankString:[UserData sharedUserData].userInfo.storeNum])
        {
            switch (indexPath.row) {
                case 0://咨询问题拨打客户电话
                {
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BDKFDH" andPageId:@"PAGE_WD"];
                    if (_webView == nil) {
                        _webView = [[UIWebView alloc] init];
                    }
                    NSString *phone = [UserData sharedUserData].userInfo.customerServiceTel;
                    DLog(@"%p,phone is %@", _webView,phone);
                    if (![self isBlankString:phone]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        
                        [_webView loadRequest:request];
                        [self.view addSubview:_webView];
                    }
                }
                    break;
                case 1://意见反馈
                {
                    [MobClick event:@"wode_yjfk"];
                    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_YJFK" andPageId:@"PAGE_WD"];
                    CommentsViewController *com =[[CommentsViewController alloc]init];
                    [self.navigationController pushViewController:com animated:YES];
                }
                    break;
                default:
                    break;
            }
        }else
        {
            [MobClick event:@"wode_yjfk"];
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_YJFK" andPageId:@"PAGE_WD"];
            CommentsViewController *com =[[CommentsViewController alloc]init];
            [self.navigationController pushViewController:com animated:YES];
        }
    }else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0://APP分享
            {
                [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_FXAPP" andPageId:@"PAGE_WD"];
                if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
                    UIImageView *ima =[self setRotationAnimationWithView];
                    //                        [self setUserInteractionWithEnabel:NO];
                    if (shareAS) {
                        [shareAS removeFromSuperview];
                    }
                    
                    [[DataFactory sharedDataFactory]getShareAppModelWithCallback:^(ShareModel *model) {
                        [self removeRotationAnimationView:ima];
                        shareAS = [[ShareActionSheet alloc]initWithShareType:APP andModel:model andParent:self.view];
                    }];
                }
            }
                break;
            case 1://新版本检查
            {
                if (_isnew) {
                    [[DataFactory sharedDataFactory] updateVersionWithMessage:_updateMsg mustUpdate:_needUpdate newVersion:_newVersion];
                    
                }
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark -按钮点击事件
-(void)mineAllBtnClickedAction:(UIButton *)button{
    if (button.tag == MINESIGNTAG) {
        [MobClick event:@"wode_yhqd"];
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_QDGN" andPageId:@"PAGE_WD"];
        _signBtn.userInteractionEnabled = NO;

        if(![self isBlankString:[UserData sharedUserData].userInfo.storeNum]){
            [[DataFactory sharedDataFactory]signWithCallback:^(ActionResult *result) {
                if (result.success) {
                    
                    [self signedAnimation];
//                    [self refreshPoints];
                    _signBtn.userInteractionEnabled = YES;

                }else{
                    
                    [TipsView showTipsCantClick:result.message inView:self.view];
                    _signBtn.userInteractionEnabled = YES;

                }
            }];

        }else{
//            UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"对不起，您还没有绑定门店，请先到【个人信息】绑定门店。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定门店", nil];
//            [av show];
            [self showTips:@"请先绑定门店才能使用功能哦~"];
            _signBtn.userInteractionEnabled = YES;

        
        }
        
    }else if (button.tag == MINEHEADTAG){
        [MobClick event:@"wode_yhzl"];
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GRZL" andPageId:@"PAGE_WD"];
        PersonalInfoViewController *per = [[PersonalInfoViewController alloc]init];
        [self.navigationController pushViewController:per animated:YES];
    
    }else if (button.tag ==SETTINGBTNTAG){
        [MobClick event:@"wode_shezhi"];
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_SZ" andPageId:@"PAGE_WD"];
        SettingViewController *log =[[SettingViewController alloc]init];
        log.needUpdate = _needUpdate;
        log.isNew = _isnew;
        log.updateMsg = _updateMsg;
        log.version = _newVersion;
        
        [self.navigationController pushViewController:log animated:YES];
    }else if(button.tag ==MSGBTNTAG){
        [MobClick event:@"wode_xxzx"];
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_XXZX" andPageId:@"PAGE_WD"];
        MessageListViewController *mine= [[MessageListViewController alloc]init];
        [self.navigationController pushViewController:mine animated:YES];
        
        }
}

- (void)itemViewTapClick:(MineItemButtonView*)itemBtnView
{
    switch (itemBtnView.tag-2000) {
        case 0:
        {
            //我的业绩
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WDYJ" andPageId:@"PAGE_WD"];
            if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
                [self showTips:@"请先绑定门店才能使用功能哦~"];
                return;
            }
            [MobClick event:@"wode_caifu"];
            XTMineFortuneController* mineFortune = [[XTMineFortuneController alloc]init];
            [self.navigationController pushViewController:mineFortune animated:YES];
        }
            break;
        case 1:
        {
            //我的收藏
            [MobClick event:@"wode_wdlp"];
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WDSC" andPageId:@"PAGE_WD"];
            MyBuildingViewController *my =[[MyBuildingViewController alloc]init];
            [self.navigationController pushViewController:my animated:YES];
        }
            break;
        case 2:
        {
            //我的日程
            [MobClick event:@"wode_wdrc"];
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WDRC" andPageId:@"PAGE_WD"];
            XTUserScheduleViewController* scheduleVC = [[XTUserScheduleViewController alloc]init];
            [self.navigationController pushViewController:scheduleVC animated:YES];
        }
            break;
        case 3:
        {
            //工作报表
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_GZBB" andPageId:@"PAGE_WD"];
            if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
                [self showTips:@"请先绑定门店才能使用功能哦~"];
                return;
            }
            [MobClick event:@"wode_gzbb"];
            XTWorkReportingController* reportVC = [[XTWorkReportingController alloc]init];
            [self.navigationController pushViewController:reportVC animated:YES];
        }
            break;
        case 4:
        {
            //积分商城
            [MobClick event:@"wode_jfsc"];
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_JFSC" andPageId:@"PAGE_WD"];
            PointMallViewController *po =[[PointMallViewController alloc]init];
            [self.navigationController pushViewController:po animated:YES];
        }
            break;
        case 5:
        {
            //排行榜
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_PHB" andPageId:@"PAGE_WD"];
            if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
                [self showTips:@"请先绑定门店才能使用功能哦~"];
                return;
            }
            [MobClick event:@"wode_phb"];
            XTSaleRankingController* rankingVC = [[XTSaleRankingController alloc]init];
            [self.navigationController pushViewController:rankingVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 签到动画
-(void)signedAnimation{
    if(_plusLabel){
        [_plusLabel removeFromSuperview];
    }
    _plusLabel = [[UILabel alloc]init];
    [_plusLabel setText:@"+3"];
    [_plusLabel setFont:[UIFont systemFontOfSize:12]];
    [_plusLabel setTextColor:[UIColor colorWithHexString:@"fc6c33"]];
    CGSize size = [HMTool getTextSizeWithText:_plusLabel.text andFontSize:12];
    [_plusLabel setFrame:CGRectMake(_signBtn.centerX, _signBtn.centerY-size.height/2, size.width, size.height)];
    [_headView addSubview:_plusLabel];
    [UIView animateWithDuration:5 animations:^{
        CABasicAnimation *anima=[CABasicAnimation animation];
        anima.keyPath=@"position";
        anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(kFrame_X(_plusLabel) ,kFrame_Y(_plusLabel))];
        anima.toValue=[NSValue valueWithCGPoint:CGPointMake(kFrame_X(_plusLabel) ,kFrame_Y(_signBtn)-kFrame_Height(_signBtn)-10)];
        //1.2设置动画执行完毕之后不删除动画
        anima.removedOnCompletion=NO;
        //1.3设置保存动画的最新状态
        anima.fillMode=kCAFillModeForwards;
        //2.添加核心动画到layer
        [_plusLabel.layer addAnimation:anima forKey:nil];
    } completion:^(BOOL finished) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        _plusLabel.alpha =0.0;
        [UIView commitAnimations];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_signBtn setHidden:YES];
       } completion:^(BOOL finished) {
        [_signedLabel setHidden:NO];

       }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    _mineTable.frame = CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height-self.tabBarController.tabBar.height-0.5);
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:12];
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
