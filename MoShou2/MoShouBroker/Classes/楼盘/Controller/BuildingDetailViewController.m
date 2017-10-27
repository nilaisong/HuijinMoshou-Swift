//
//  BuildingDetailViewController.m
//  MoShou2
//
//  Created by strongcoder on 15/12/2.
//  Copyright © 2015年 5i5j. All rights reserved.
//
#import "BuildingDetailViewController.h"
#import "Building.h"
#import "BuildingBigImageView.h"
#import "BuildingImageView.h"
#import "AutoLabel.h"
#import "IntentionView.h"
#import "PeripheralLocationView.h"
#import "MainDoorTypeView.h"
#import "UIView+YR.h"
#import "UILabel+StringFrame.h"
#import "MainDoorViewController.h"
#import "DataFactory+Building.h"
#import "DataFactory+Customer.h"
#import "CustomerReportViewController.h"
#import "MyCustomersViewController.h"
#import "MapViewController.h"
#import "HouseAlbumViewController.h"
#import "AlbumData.h"
#define EMPTYSTRING @""
#import "ShareActionSheet.h"
#import "UserData.h"
#import "Estate.h"
#import "Discount.h"
#import "CustomIOSAlertView.h"
#import "Tool.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
#import "CaseTelView.h"
#import "ImageTextButton.h"
#import "EaseSDKHelper.h"
#import "GSTagView.h"
#import "EstateDynamicMsgModel.h"
#import "SpecialHouseView.h"
#import "BuildingDetailView.h"
#import "PopView.h"
#import "BuildingDynamicMsgListViewController.h"
#import "HouseTypeListViewController.h"  //add by wangzz 161215
#import "MortgageCalculatorViewController.h"
#import "YRImageView.h"

#import "XTAlbumTitleView.h"
#import "XTButton.h"
#import "ShowBigImageViewController.h"
#import "XTImageCountTipsView.h"
#import "BaseNavigationController.h"

//如果报错 就把它打开
//#define ORIGCOLOR   [UIColor colorWithHexString:@"ff6600"]

#define IMGVIEWHEIGHT (kMainScreenWidth * 0.75)
//上下拉保护值
#define PULLUPGUARDVALUE 35
#define PULLDOWNGUARDVALUE 35

typedef NS_ENUM(NSUInteger,PULLSTATE) {//滑动状态
    PULLSTATENORMAL,//默认状态
    PULLSTATEDOWN,  //下滑
    PULLSTATEUP,    //上滑
};
@interface BuildingDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CustomIOSAlertViewDelegate,PopViewDelegate,UIScrollViewDelegate>

{
    
    
    CGFloat _buildingBaseDetailViewCellHeight;//  楼盘基本信息  高度
    CGFloat _youHuiRenChouHeight; //优惠 认筹活动
    CGFloat _recentNewsCellHeight;  // 最新动态
    //    CGFloat _speciaHouseCellHeight;  //特价房
    
    
    
    CGFloat _AllHouseCellHeight;  //现在是全部户型
    
    CGFloat _muBiaoCellHeight; //目标客户
    CGFloat _tuoKeCellHeight; //拓客技巧
    CGFloat _renChouHeight; //认筹活动
    CGFloat _youHuiHeight; //优惠活动
    
    CGFloat _buildDetailHeight;  //楼盘详情高度
    
    
    //    BOOL _openStyle;  //特价房是否打开
    BOOL _buildingDetailOpenStyle; //楼盘详情是否打开
    
    
    ShareActionSheet * _shareView;
    BOOL isIOS7Reloadate;;
    BOOL _secondIn;
    
    UIButton *_shareButton;
    
    UIVisualEffectView *effectView;
    
    UIView * _maskView;
    
    PopView *_popView;
    
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)Building *buildingMo;
@property (nonatomic,strong)Estate *estateBuildingMo;
@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,copy)NSString * buildingCustomerCount;  //意向客户

@property (nonatomic,strong)UIButton *backTopBtn;

@property (nonatomic,weak)UIButton* downloadButton;//下载按钮

@property (nonatomic,weak)UIButton* startButton;//星星按钮



@property (nonatomic,weak)UIView* bottomContentView;

@property (nonatomic,weak)UIScrollView* contentScrollView;

@property (nonatomic,weak)UIScrollView* albumScrollView;//相册视图

@property (nonatomic,weak)UIView* topContentView;

@property (nonatomic,weak)XTAlbumTitleView* titleView;//相册标题视图

@property (nonatomic,weak)XTImageCountTipsView* numbTipsView;

@property (nonatomic,weak)XTImageCountTipsView* onImageTipsView;

@property (nonatomic,assign)CGFloat startY; //起始值

@property (nonatomic,assign)CGFloat maxY; //最值

@property (nonatomic,assign)CGFloat endY; //终值

@property (nonatomic,assign)PULLSTATE pullState;//滑动状态

@property (nonatomic,strong)NSArray* imageViewArray;//相册图片数组

@property (nonatomic,strong)NSArray* imageContentArray;//图片链接数组

@property (nonatomic,strong)NSArray* imageViewUrlArray;//相册图片url数组

@property (nonatomic,assign)CGFloat speciaHouseCellHeight;//特价房

@property (nonatomic,assign)BOOL openStyle;  //特价房是否打开

@property (nonatomic,assign)CGFloat buildDetailHeight;

@property (nonatomic,assign)BOOL buildingDetailOpenStyle;

@property (nonatomic,assign)BuildingDetailViewStyle buildingDetailViewStyle;

@property (nonatomic,strong)PeripheralLocationView *peripheralLocationView;


@end

@implementation BuildingDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (_pullState == PULLSTATEDOWN) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    if (_buildingMo.estateDynamicMsgList.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewUrlArray = [NSMutableArray array];
    
    _pullState = PULLSTATENORMAL;
    UIView* maskView = [[UIView alloc]init];
    maskView.frame = CGRectMake(0, 0, self.view.width, 1.0);
    maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maskView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [MobClick event:@"lp_lpxq"];
    _buildingCustomerCount = @"0";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedDownload:) name:kDidFinishedDownloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailedDownload:) name:kDidFailedDownloadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBuildingDetail) name:@"reloadBuildingDetail" object:nil];
    self.navigationBar.line.hidden = YES;
    
    if (self.caCheBuildingMo)
    {
        _buildingMo = _caCheBuildingMo;
        _estateBuildingMo = _buildingMo.estate;
        self.buildingId = _caCheBuildingMo.buildingId;
        [self loadUI];
        [self getBuildingCustomerCount];
        
    }else{
        [self checkNetwork];
    }
    //是否展示 使用帮助 引导图（新装app 首次打开展示）
    [self shouldShowBuildingDetailFirstTimeShowImg];
}
//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    CGFloat tableViewHeight = 0;
    if ([self verifyTheRulesWithShouldJump:NO]){
        tableViewHeight = self.view.bounds.size.height-49;
    }else{
        tableViewHeight = self.view.bounds.size.height;
    }
    
    if (self.tableView.superview) {
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, tableViewHeight);
    }
    
    if(self.bottomView.superview){
        
        self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-49, kMainScreenWidth, 49);
    }
    
}

- (void)leftBarButtonItemClick{
    if (_pullState == PULLSTATEDOWN) {
        _contentScrollView.backgroundColor = [UIColor colorWithHexString:@"3a434d"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                [_contentScrollView setContentInset:UIEdgeInsetsZero];
                [_contentScrollView setContentOffset:CGPointZero];
                [self pullUpAction];
            }];
        });
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//接受通知刷新数据
-(void)reloadBuildingDetail
{
    [self getBuildingCustomerCount];
    
}

-(void)didFinishedDownload:(NSNotification*)notification
{
    DLog(@"notification===%@",notification);
    
    NSString *buildingId = [notification object];
    if ([buildingId  isEqualToString:_buildingMo.buildingId])
    {
        DLog(@"是当前页面的下载");
        UIButton *downLoadBtn = (UIButton *)[self.view viewWithTag:9800];
        downLoadBtn.selected = YES;
    }
    
    DLog(@"buildingId==%@",buildingId);
}

-(void)didFailedDownload:(NSNotification*)notification
{
    DLog(@"%@",notification);
}


-(void)checkNetwork
{
    __weak typeof(self) blockSelf= self;
    if (![self createNoNetWorkViewWithReloadBlock:^{
        [blockSelf loadData];
    }])
    {
        [self loadData];
    }
}
-(void)getBuildingCustomerCount
{
    [[DataFactory sharedDataFactory] getBuildingCustomerCount:self.buildingId WithCallback:^(NSString *number) {
        
        if (number) {
            _buildingCustomerCount =number;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        
        
    }];
}

-(void)loadData
{
    UIImageView *loadingView = [self setRotationAnimationWithView];
    
    [[DataFactory sharedDataFactory] getBuildingDetailWithId:self.buildingId andeventId:self.eventId  WithCallback:^(Building *result, NSString *msg)
     
     {
         [self removeRotationAnimationView:loadingView];
         if (result!=nil)
         {
             _buildingMo = result;
             _estateBuildingMo = _buildingMo.estate;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self loadUI];
             });
         }else{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self tempView];
                 
                 if (msg.length>0) {
                     
                     AlertShow(msg);
                 }
             });
         }
     }];
    
    //    [self getBuildingCustomerCount];
    
}

-(void)loadUI
{
    self.topContentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, IMGVIEWHEIGHT);
    self.onImageTipsView.frame = CGRectMake(kMainScreenWidth - 47.5 - 10, _topContentView.height - 35, 47.5, 25);
    
    if ([self verifyTheRulesWithShouldJump:NO])
    {
        [self addBottomView];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height-49) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //self.tableView.
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        [self.bottomContentView addSubview:self.tableView];
        
        [self addNavItem];
        
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        [self.bottomContentView addSubview:self.tableView];
        [self addNavItem];
        
    }
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.contentInset = UIEdgeInsetsZero;
    [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    _tableView.scrollEnabled = NO;
    DLog(@"%f",_tableView.contentSize.height);
    self.bottomContentView.frame = CGRectMake(0, IMGVIEWHEIGHT, kMainScreenWidth, _tableView.contentSize.height);
    _tableView.frame = CGRectMake(0, 0, kMainScreenWidth, _tableView.contentSize.height + 300);
    self.contentScrollView.contentSize = CGSizeMake(0, _tableView.contentSize.height + IMGVIEWHEIGHT + 300);
    _contentScrollView.backgroundColor = [UIColor colorWithHexString:@"3a434d"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = _tableView.contentSize;
        CGFloat sizeHeight = size.height;
        self.bottomContentView.frame = CGRectMake(0, IMGVIEWHEIGHT, kMainScreenWidth, sizeHeight);
        _tableView.frame = CGRectMake(0, 0, kMainScreenWidth, sizeHeight);
        if ([self verifyTheRulesWithShouldJump:NO]){
            self.contentScrollView.contentSize = CGSizeMake(0,sizeHeight + IMGVIEWHEIGHT + 49);
        }else{
            self.contentScrollView.contentSize = CGSizeMake(0,sizeHeight + IMGVIEWHEIGHT);
        }
        
    }
    
    DLog(@"height=======%f",_tableView.contentSize.height);
    
}

-(UIButton *)backTopBtn
{
    if (!_backTopBtn) {
        _backTopBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-45, kMainScreenHeight-49-25-45, 45, 45)];
        [_backTopBtn setImage:[UIImage imageNamed:@"backtop"] forState:UIControlStateNormal];
        [_backTopBtn setImage:[UIImage imageNamed:@"backtop"] forState:UIControlStateSelected];
        
        [_backTopBtn addTarget:self action:@selector(backTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _backTopBtn.hidden = YES;
        
        [self.view addSubview:_backTopBtn];
        
    }
    
    return _backTopBtn;
}



-(void)backTopBtnClick
{
    
    self.contentScrollView.contentInset = UIEdgeInsetsZero;
    //    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
            [self pullUpAction];
        }];
    });
    
    
}


-(void)addNavItem
{
    self.navigationBar.hidden = NO;
    [self.navigationBar.leftBarButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    
    //add by wangzz 将navigationbar底部的线隐藏掉
    self.navigationBar.line.hidden = YES;
    self.navigationBar.titleLabel.text = _buildingMo.name;
    self.navigationBar.titleLabel.textColor = [UIColor whiteColor];;
    self.navigationBar.titleLabel.alpha = 0;
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.barBackgroundImageView.backgroundColor = [UIColor clearColor];
    self.navigationBar.barBackgroundImageView.contentMode =  UIViewContentModeScaleAspectFill;
    if (_buildingMo.albumArray.count>0) {
        AlbumData *albuData = _buildingMo.albumArray[0];
        if (albuData.images.count>0) {
            
            [self.navigationBar.barBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:albuData.images[0]] placeholderImage:[UIImage imageNamed:@"列表默认图"]];
        }
        
    }
    self.navigationBar.barBackgroundImageView.alpha = 0;
    self.navigationBar.barBackgroundImageView.clipsToBounds  = YES;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, kMainScreenWidth, self.navigationBar.height);
    
    [self.navigationBar addSubview:effectView];
    
    effectView.alpha = 0;
    
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-44-([UserData sharedUserData].shareRangeArray.count>0?40:0), 20, 44, 44)];
    [startBtn setImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"收藏后.png"] forState:UIControlStateSelected];
    startBtn.selected = self.buildingMo.favorite;
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _startButton = startBtn;
    [self.navigationBar  addSubview:startBtn];
    
    
    
    if ([UserData sharedUserData].shareRangeArray.count>0) {
        if (_shareButton==nil) {
            _shareButton = [[UIButton alloc]init];
            _shareButton.frame = CGRectMake(kMainScreenWidth-44, 20, 44, 44);
            [_shareButton setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
            [_shareButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationBar addSubview:_shareButton];
        }
        
    }
    
    [self.view bringSubviewToFront:self.navigationBar];
    
    
    
    
}


-(void)addBottomView //底部的三个按钮View
{
    if (_bottomView==nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, kMainScreenWidth, 49)];
        
        [self.view addSubview:_bottomView];
        
        UILabel *lineLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0,kMainScreenWidth , 0.5)];
        lineLabel.backgroundColor = LINECOLOR;
        [_bottomView addSubview:lineLabel];
        
        CGFloat BtnWith = (0.66*kMainScreenWidth)/3;
        CGFloat BlueBtnWith = 0.34*kMainScreenWidth;
        NSArray *ImageArr = @[@"联系案场.png",@"在线咨询.png",@"我的客户.png"];
        NSArray *titleArr = @[@"联系驻场",@"在线咨询",@"我的客户"];
        
        for (NSInteger i  = 0;  i < 3; i ++)
        {
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(i*BtnWith, 0, BtnWith, _bottomView.height);
            [button setImage:[UIImage imageNamed:ImageArr[i]] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = FONT(13);
            [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, (button.width-button.imageView.width)/2, 0, 0)];
            if (i==0)
            {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.height+8, (button.width-button.titleLabel.width)/2-button.imageView.width, -6, 0)];
                [button addTarget:self action:@selector(ContactFieldClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *verticallabel = [[UILabel alloc]initWithFrame:CGRectMake(button.width, 0, 0.5, button.height)];
                verticallabel.backgroundColor = LINECOLOR;
                [_bottomView addSubview:verticallabel];
            }else if (i==1)
            {
                
                if (kMainScreenWidth== 320) {
                    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.height+8, (button.width-button.titleLabel.width)/2-button.imageView.width-2, -6, 0)];
                }else{
                    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.height+8, (button.width-button.titleLabel.width)/2-button.imageView.width, -6, 0)];
                }
                
                UILabel *verticallabel = [[UILabel alloc]initWithFrame:CGRectMake(button.width*2, 0, 0.5, button.height)];
                verticallabel.backgroundColor = LINECOLOR;
                [_bottomView addSubview:verticallabel];
                
                [button addTarget:self action:@selector(onLineChat:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }else if (i==2){
                if (kMainScreenWidth== 320) {
                    
                    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.height+10, (button.width-button.titleLabel.width)/2-button.imageView.width-2, -6, 0)];
                }else{
                    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.height+10, (button.width-button.titleLabel.width)/2-button.imageView.width, -8, 0)];
                }
                [button addTarget:self action:@selector(myCustomerClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            [_bottomView addSubview:button];
            [_bottomView sendSubviewToBack:button];
        }
        UIButton *baoBeiBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth*0.66, 0, BlueBtnWith, _bottomView.height)];
        
        if (_estateBuildingMo.agencyReportType) {
            
            [baoBeiBtn setTitle:@"暂停报备" forState:UIControlStateNormal];
            baoBeiBtn.backgroundColor = UIColorFromRGB(0xbababa);
        }else{
            
            [baoBeiBtn setTitle:@"报备客户" forState:UIControlStateNormal];
            baoBeiBtn.backgroundColor = BLUEBTBCOLOR;
            [baoBeiBtn addTarget:self action:@selector(baoBeiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [baoBeiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        baoBeiBtn.titleLabel.font =[UIFont boldSystemFontOfSize:16.f];
        
        [_bottomView addSubview:baoBeiBtn];
        [_bottomView sendSubviewToBack:baoBeiBtn];
        
    }
    
    
}

#pragma mark 空白也没有数据
-(void)tempView{
    [self.tableView setHidden:YES];
    self.navigationBar.backgroundColor = [UIColor grayColor];
    self.navigationBar.hidden = NO;
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, 64+44+(kMainScreenWidth-64-44-30)/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    //    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc]initWithString:@"没有数据"];
    //    [tipText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 11)];
    CGSize ss = [@"没有数据" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setText:@"没有数据"];
    [self.view addSubview:tip];
}


#pragma mark - tableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_albumScrollView == scrollView) {
        YRImageView* imgV = [_imageViewArray objectForIndex:_albumScrollView.contentOffset.x/kMainScreenWidth];
        NSString *url = [_imageViewUrlArray objectForIndex:_albumScrollView.contentOffset.x/kMainScreenWidth];
        [imgV setImageWithUrlString:url placeholderImage:[UIImage imageNamed:@"楼盘详情页默认图"]];
        
        [_titleView setCurrentIndex:imgV.groupIndex];
        _numbTipsView.titleString = imgV.titleString;
        _numbTipsView.currentIndex = imgV.currentIndex;
        _numbTipsView.totalNumber   = imgV.totalNumber;
        _onImageTipsView.totalNumber = _albumScrollView.contentSize.width/kMainScreenWidth>0?scrollView.contentSize.width/kMainScreenWidth:1;
        _onImageTipsView.titleString = @"";
        
        self.navigationBar.barBackgroundImageView.image = imgV.image;
        
        //         sd_setImageWithURL:[NSURL URLWithString:_estateBuildingMo.imgUrl] placeholderImage:[UIImage imageNamed:@"列表默认图"]];
        
        return;
    }
    //DLog(@"%f",scrollView.contentOffset.y);
    CGFloat minAlphaOffset = (kMainScreenWidth*0.75)/2;
    CGFloat maxAlphaOffset = kMainScreenWidth*0.75-64;
    CGFloat offset = self.contentScrollView.contentOffset.y;
    
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    {
        
        self.navigationBar.barBackgroundImageView.alpha = alpha;
        
        //DLog(@"alpha====%f",alpha);
        if (_pullState != PULLSTATEDOWN) {
            self.navigationBar.titleLabel.alpha = alpha;
        }
        
        
        
        effectView.alpha = alpha;
        
        
        [self.navigationBar bringSubviewToFront:self.navigationBar.titleLabel];
        [self.navigationBar bringSubviewToFront:self.navigationBar.leftBarButton];
        
    }
    
    if (_buildingMo.albumArray.count <= 0) {
        return;
    }
    //顶端按钮
    [self handleBackTopBtnStatusWith:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (_pullState != PULLSTATEDOWN) {
        _maxY = _maxY < fabs(offsetY)?fabs(offsetY):_maxY;
    }else{
        _maxY = _maxY > fabs(offsetY)?fabs(offsetY):_maxY;
    }
    
    CGFloat imgY = 0.0f;
    imgY = (offsetY)/2.0;
    self.topContentView.frame = CGRectMake(0, imgY, self.view.bounds.size.width, IMGVIEWHEIGHT);
    self.numbTipsView.frame = CGRectMake(10, _topContentView.height + 15 * SCALE6, kMainScreenWidth, 17);
    if (offsetY > IMGVIEWHEIGHT) {//如果图片消失，将背景色设置为白色，防止用力上滑导致的颜色无法改变
        self.contentScrollView.backgroundColor = [UIColor whiteColor];
    }else{
        self.contentScrollView.backgroundColor = [UIColor colorWithHexString:@"3a434d"];
        //        self.navigationBar.titleLabel.alpha = 1.0;
    }
    //DLog(@"_startY:%f,_maxY:%f,_endY:%f",_startY,_maxY,_endY);
    //当视图是下方状态，且在
    CGFloat maxY = -self.view.height + IMGVIEWHEIGHT;
    CGFloat minY = -self.view.height + 49 + IMGVIEWHEIGHT;
    if (_pullState == PULLSTATEDOWN && offsetY >= maxY && offsetY <= minY) {
        //        self.bottomView.frame = CGRectMake(0, fabs(offsetY - IMGVIEWHEIGHT), kMainScreenWidth, 49.0);
    }
    
    //NSLog(@"bootomY:%f,offsetY:%f,IMGVH:%f",_bottomContentView.frame.origin.y,offsetY,IMGVIEWHEIGHT);
    //偏移量在底部视图的时候，取出用来偏移底部视图
    
    //计算底部相册标题与功能栏frame
    [self handleBottomViewFrame:offset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_buildingMo.albumArray.count <= 0) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    _endY = fabs(offsetY);
    
    [self handleScrollView:scrollView willDecelerate:decelerate];
    [self handleBackTopBtnStatusWith:scrollView];
    if (!decelerate) {
        _onImageTipsView.currentIndex = _albumScrollView.contentOffset.x/kMainScreenWidth;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_buildingMo.albumArray.count <= 0) {
        return;
    }
    [self handleBackTopBtnStatusWith:scrollView];
    _onImageTipsView.currentIndex = _albumScrollView.contentOffset.x/kMainScreenWidth;
}

/**
 判断返回顶部按钮是否显示
 */
- (void)handleBackTopBtnStatusWith:(UIScrollView*)scrollView{
    if (scrollView.contentOffset.y>kMainScreenHeight && !scrollView.decelerating) {
        
        self.backTopBtn.hidden = NO;
    }else{
        self.backTopBtn.hidden = YES;
    }
}
/**
 记录初始值
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startY = scrollView.contentOffset.y;
    _maxY = fabs(scrollView.contentOffset.y);
}

- (void)handleBottomViewFrame:(CGFloat)offsetY{
    _bottomView.userInteractionEnabled = YES;
    if (offsetY >= -(_contentScrollView.height - IMGVIEWHEIGHT) && offsetY <= -(_contentScrollView.height - IMGVIEWHEIGHT ) + 49) {
        CGFloat offsetValue = (_contentScrollView.height - fabs(offsetY) - IMGVIEWHEIGHT);
        DLog(@"bottom:%f",offsetValue);
        _bottomView.frame = CGRectMake(0, self.view.height - (offsetValue - 0.25), kMainScreenWidth, 49.0f);
        self.titleView.frame  = CGRectMake(0, self.view.height - (49.0f - offsetValue), kMainScreenWidth, 49.0f);
        _bottomView.userInteractionEnabled = NO;
    }else if (offsetY <= -(_contentScrollView.height - IMGVIEWHEIGHT )){
        _bottomView.frame = CGRectMake(0, self.view.height + 0.5, kMainScreenWidth, 49.0f);
        NSLog(@"--->%f",self.view.height);
        _titleView.frame  = CGRectMake(0, self.view.height - 49.0f, kMainScreenWidth, 49.0f);
    }else if(offsetY >= -(_contentScrollView.height - IMGVIEWHEIGHT ) + 49){
        _bottomView.frame = CGRectMake(0, self.view.height - 49.0f, kMainScreenWidth, 49.0f);
        _titleView.frame  = CGRectMake(0, self.view.height, kMainScreenWidth, 49.0f);
        
    }
}

/*
 处理滚动距离
 */
- (void)handleScrollView:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != _contentScrollView) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0 ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            if (_pullState == PULLSTATEDOWN) {
                [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            [self pullUpAction];
        });
        
        return;
    }
    //fabs(_startY) >= 0 && fabs(_startY) <= PULLDOWNGUARDVALUE
    if (_pullState != PULLSTATEDOWN) {
        if ((_maxY == _endY && fabs(_maxY) > PULLDOWNGUARDVALUE) || fabs(_endY) > PULLDOWNGUARDVALUE + 10) {
            _contentScrollView.contentInset = UIEdgeInsetsMake((self.view.height - IMGVIEWHEIGHT), 0, 0, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_contentScrollView setContentOffset:CGPointMake(0, -(self.view.frame.size.height - IMGVIEWHEIGHT)) animated:YES];
                [self pullDownAction];
            });
            
        }
        
    }else{
        if (_maxY == _endY && _endY < (self.view.frame.size.height - IMGVIEWHEIGHT) - PULLUPGUARDVALUE) {
            [UIView animateWithDuration:0.25 animations:^{
                _contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                [self pullUpAction];
            }];
            if (decelerate) {
                //            scrollView.decelerationRate = 0.0f;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_contentScrollView setContentOffset:CGPointMake(0, -(self.view.frame.size.height - IMGVIEWHEIGHT)) animated:YES];
                [self pullDownAction];
            });
            
        }
        
        
    }
}

/**
 下拉动作
 */
- (void)pullDownAction{
    
    if (_pullState != PULLSTATEDOWN) {
        self.navigationBar.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.0];
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationBar.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:1.0   ];
        }];
        //EVENT_LPXC
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LPXC" andPageId:@"PAGE_LPXQ"];
    }
    
    _pullState = PULLSTATEDOWN;
    
    if (_buildingMo.albumArray.count > 0) {
        self.onImageTipsView.hidden = YES;
    }else{
        
    }
    [UIView animateWithDuration:0.25 animations:^{
        //_bottomView.frame = CGRectMake(0, self.view.height, kMainScreenWidth, 49.0f);
        self.numbTipsView.hidden = NO;
    }];
    self.titleView.hidden = NO;
    self.downloadButton.userInteractionEnabled = YES;
    _shareButton.hidden = YES;
    _startButton.hidden = YES;
    self.contentScrollView.backgroundColor = [UIColor colorWithHexString:@"3a434d"];
    
    
    
    [self.navigationBar.leftBarButton setImage:[UIImage imageNamed:@"base-leftBarButton.png"] forState:UIControlStateNormal];
    self.navigationBar.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.navigationBar.titleLabel.alpha = 1.0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.downloadButton.hidden = NO;
    
}

/**
 上拉动作
 */
- (void)pullUpAction{
    if (_pullState != PULLSTATEUP) {
        self.navigationBar.titleLabel.alpha = 0.0f;
    }
    _pullState = PULLSTATEUP;
    [UIView animateWithDuration:0.25 animations:^{
        // _bottomView.frame = CGRectMake(0, self.view.height - 49.0f, kMainScreenWidth, 49.0f);
        //        if (_buildingMo.albumArray.count > 0) {
        self.onImageTipsView.hidden = NO;
        //        }
    }];
    //_titleView.hidden = YES;
    self.downloadButton.userInteractionEnabled = NO;
    _shareButton.hidden = NO;
    _startButton.hidden = NO;
    self.numbTipsView.hidden = YES;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationBar.leftBarButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    self.navigationBar.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.downloadButton.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//点击事件
- (void)tapAction:(UIGestureRecognizer*)gest{
    _contentScrollView.contentInset = UIEdgeInsetsMake(self.view.frame.size.height - IMGVIEWHEIGHT, 0, 0, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_contentScrollView setContentOffset:CGPointMake(0, -(self.view.frame.size.height - IMGVIEWHEIGHT)) animated:YES];
        [self pullDownAction];
    });
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 10;
            
        }
            break;
            
        case 1:
        {
            return 10;
        }
            break;
            
        case 2:
        {
            return _buildingMo.estateDynamicMsgList.count>0?10:0.1f;
            
        }
            break;
        case 3:
        {
            return  _buildingMo.specialHouseList.count>0?10:0.1f;
            
        }
            break;
        case 4:
        {
            return _buildingMo.roomLayoutArray.count>0?10:0.1f;
            
        }
            break;
        case 5:
        {
            return 40;
            
        }
            break;
            
        default:
            break;
    }
    
    
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.1f;
    }else{
        return 0.1f;
        
    }
    
    return 0.1f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    if (section==0) {
        
        
        
        BuildingImageView *buildImage = [[BuildingImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*0.75) andBuildingId:self.buildingId];
        [buildImage setImageWithUrlString:_estateBuildingMo.imgUrl placeholderImage:[UIImage imageNamed:@"列表默认图.png"]];
        
        
        UIImageView *backBlackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 152/2)];
        backBlackImageView.image = [UIImage imageNamed:@"blackhead"];
        [buildImage addSubview:backBlackImageView];
        
        
        buildImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildingImageTap)];
        
        [buildImage addGestureRecognizer:tap];
        
        return buildImage;
    }else{
        return nil;
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 5) {
        
        UILabel *label = [UILabel createLabelWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40) text:@"    免责声明: 楼盘信息由开发商提供,最终以政府部门登记备案为准,请谨慎核查." textAlignment:NSTextAlignmentLeft fontSize:10.f textColor:UIColorFromRGB(0x888888)];
        label.backgroundColor = UIColorFromRGB(0xefeff4);
        
        return label;
        
        
    }else{
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
        label.backgroundColor = UIColorFromRGB(0xefeff4);
        return label;
        
    }
    
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return 0;
                    break;
                    
                case 1:
                    return _buildingBaseDetailViewCellHeight;   //
                    break;
                    
                case 2:
                    return _youHuiRenChouHeight;   //  优惠认筹
                    break;
                    
                case 3:
                    return 124/2;    // 五个数字条
                    break;
                default:
                    break;
            }
            
        }
            break;
            
            
        case 1:    //佣金和合作规则
        {
            switch (indexPath.row) {
                case 0:
                    return 45;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2:   //最新动态
        {
            
            switch (indexPath.row) {
                case 0:
                    
                    return  _buildingMo.estateDynamicMsgList.count>0?_recentNewsCellHeight:0;
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 3:  // //特价房
        {
            switch (indexPath.row) {
                case 0:
                    if (_speciaHouseCellHeight<=0) {
                        
                        if (_buildingMo.specialHouseList.count>1) {
                            _speciaHouseCellHeight = 366/2+10;
                            
                        }else if (_buildingMo.specialHouseList.count==1){
                            _speciaHouseCellHeight = 160;
                        }
                    }
                    return _buildingMo.specialHouseList.count>0?_speciaHouseCellHeight:0;       //366/2;
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
            
        case 4:{   //全部户型
            
            return  _buildingMo.roomLayoutArray.count>0?_AllHouseCellHeight:0;
        }
            break;
            
        case 5:   //位置和周边
        {
            switch (indexPath.row) {
                case 0:
                {
                    return 490/2;
                    
                }
                    break;
                    
                case 1:   //楼盘特色
                {
                    return _buildDetailHeight>0?_buildDetailHeight:[BuildingDetailView buildingDetailHeightWith:_buildingMo];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return 60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
        case 4:
            return 1;
            break;
            
        case 5:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

#pragma mark - UITableViewCell cellForRowAtIndexPath

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self EditNullValue];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:   //楼盘大图
                {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return cell;
                }
                    break;
                case 1:  //基本楼盘信息
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell.contentView addSubview:[self creatBuildingBaseDetailView]];
                    
                    return cell;
                    
                }
                    break;
                case 2:  //优惠   认筹
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (_buildingMo.renChouLists.count>0 || _buildingMo.youHuiLists.count>0) {
                        [cell.contentView addSubview:[self creatYouHuiRenChouView]];
                        
                        
                        
                    }
                    return cell;
                }
                    break;
                    
                case 3:  //报备客户的  5个参数
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    IntentionView *view = [[IntentionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 124/2) AndBuilding:_buildingMo AndBuildingCustomerCount:0];
                    
                    [cell.contentView addSubview:view];
                    
                    
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
            break;
            
        case 1:
        {
            
            switch (indexPath.row) {
                case 0:  //佣金和合作规则
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *shuTiaoLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 4, 25)];
                    shuTiaoLineLabel.backgroundColor = ORIGCOLOR;
                    [cell.contentView addSubview:shuTiaoLineLabel];
                    
                    UILabel *yongjingLabel = [UILabel createLabelWithFrame:CGRectMake(shuTiaoLineLabel.right+6, shuTiaoLineLabel.top, kMainScreenWidth-30, shuTiaoLineLabel.height) text:@"佣金及合作规则" textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:ORIGCOLOR];
                    yongjingLabel.font = [UIFont boldSystemFontOfSize:16.f];
                    [cell.contentView addSubview:yongjingLabel];
                    
                    
                    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-7, (45-14)/2, 7, 14)];
                    arrowImageView.image = [UIImage imageNamed:@"点击三角"];
                    [cell.contentView addSubview:arrowImageView];
                    
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2:   //最新动态
        {
            
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_buildingMo.estateDynamicMsgList.count>0) {
                UILabel *newLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth/2, 16) text:[NSString stringWithFormat:@"最新动态(共%zd条)",_buildingMo.estateDynamicMsgList.count] textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x888888)];
                [cell.contentView addSubview:newLabel];
                
                UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-7, newLabel.top, 7, 14)];
                arrowImageView.image = [UIImage imageNamed:@"点击三角"];
                [cell.contentView addSubview:arrowImageView];
                
                UILabel *unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-arrowImageView.width-10-7-kMainScreenWidth/2, arrowImageView.top, kMainScreenWidth/2, 14)];
                unReadLabel.font = FONT(13.f);
                unReadLabel.textColor = UIColorFromRGB(0x37aeff);
                unReadLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:unReadLabel];
                
                NSString *key = [NSString stringWithFormat:@"%@-%@",[UserData sharedUserData].userInfo.userId,_buildingMo.buildingId];
                NSString *string = [Tool getCache:key];
                NSInteger unreadNum = _buildingMo.estateDynamicMsgList.count - [string integerValue];
                if (unreadNum>0) {
                    unReadLabel.text =[NSString stringWithFormat:@"%zd条未读",unreadNum];
                    unReadLabel.hidden = NO;
                }else{
                    unReadLabel.hidden = YES;
                }
                
                EstateDynamicMsgModel *model = _buildingMo.estateDynamicMsgList[0];
                UILabel *contentLabel = [UILabel createLabelWithFrame:CGRectMake(newLabel.left, newLabel.bottom+15, kMainScreenWidth-20, 0) text:model.info textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x333333)];
                contentLabel.numberOfLines = 2;
                CGSize size = [contentLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-20, 0)];
                contentLabel.height = size.height;
                if (contentLabel.height > 40) {
                    contentLabel.height = 40;
                }
                
                [cell.contentView addSubview:contentLabel];
                _recentNewsCellHeight = contentLabel.bottom+15;
                
                if (_recentNewsCellHeight > 182/2) {
                    
                    _recentNewsCellHeight = 182/2;
                }
                
                return cell;
            }
            break;
        }
            break;
            
        case 3:  //特价房:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    __weak BuildingDetailViewController *weakSelf = self;
                    
                    if (_buildingMo.specialHouseList.count>0) {
                        SpecialHouseView *view = [[SpecialHouseView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 366/2) WithSpeciaHouseArray:_buildingMo.specialHouseList AndOpenStyle:_openStyle];
                        view.building = _buildingMo;
                        view.openAndCloseSpeciaHouseViewBlock = ^(CGFloat height, BOOL openStyle){
                            
                            weakSelf.speciaHouseCellHeight = height;
                            
                            weakSelf.openStyle = openStyle;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                        };
                        
                        [cell.contentView addSubview:view];
                    }
                    
                    return cell;
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 4:  //全部户型
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_buildingMo.roomLayoutArray.count>0) {
                MainDoorTypeView *mainView = [[MainDoorTypeView alloc]initBuilding:_buildingMo];
                
                [cell.contentView addSubview:mainView ];
                
                _AllHouseCellHeight = mainView.bottom;
            }
            return cell;
            
        }
            break;
            
        case 5:   //位置和周边
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewMapCell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewMapCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        [cell.contentView addSubview:[self peripheralLocationView]];
                        
                        UIButton *mapTopbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
                        [mapTopbutton addTarget:self action:@selector(mapTopClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:mapTopbutton];
                    }
                    return cell;
                }
                    break;
                    
                case 1:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    __weak BuildingDetailViewController *weakSelf = self;
                    
                    BuildingDetailView *view = [[BuildingDetailView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0) WithBuildingDetailViewStyle:_buildingDetailViewStyle AndBuildingMo:_buildingMo AndOpenStyle:YES];
                    
                    view.buildingDetailViewStyleChangeBlock = ^(CGFloat height, BOOL openStyle ,BuildingDetailViewStyle buildingDetailViewStyle){
                        
                        weakSelf.buildDetailHeight = height;
                        
                        //                        DLog(@"_buildDetailHeight  === %f",_buildDetailHeight);
                        weakSelf.buildingDetailOpenStyle = openStyle;
                        weakSelf.buildingDetailViewStyle = buildingDetailViewStyle;
                        //                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:5];
                        //[weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView reloadData];
                        
                    };
                    
                    [cell.contentView addSubview:view];
                    
                    
                    
                    
                    
                    
                    return cell;
                    
                }
                    break;
                default:
                    break;
            }
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
    
    
}

- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    DLog(@"tableView indexPath====section ==%zd /////>>> row === %zd",indexPath.section,indexPath.row);
    if (indexPath.section==0 && indexPath.row==0)
    {
        if (_buildingMo.albumArray.count > 0)
        {
            HouseAlbumViewController *VC = [[HouseAlbumViewController alloc]init];
            VC.building = _buildingMo;
            [self.navigationController pushViewController:VC animated:NO];
        }
    }
    
    ///认筹 优惠活动
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        _popView = [[PopView alloc]initWithType:kRenChouHuoDong AndBuilding:_buildingMo];
        _popView.delegate =self;
        
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_YHHD" andPageId:@"PAGE_LPXQ"];
        
        [self showWithPopView:_popView];
        
        
    }
    
    
    //佣金 和  合作规则
    if (indexPath.section==1 && indexPath.row==0)
    {
        //        DLog(@"佣金 和  合作规则");
        //        lpxq_yjgz
        [MobClick event:@"lpxq_yjhzgz"];
        
        if ([self verifyTheRulesWithShouldJump:YES])
        {
            [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_YJ-HZGZ" andPageId:@"PAGE_LPXQ"];
            _popView = [[PopView alloc]initWithType:kCommissionRuleCooperationRule AndBuilding:_buildingMo];
            _popView.delegate = self;
            [self showWithPopView:_popView];
        }
    }
    
    //最新动态
    if (indexPath.section==2 && indexPath.row==0)
    {
        [MobClick event:@"lpxq_zxdt"];
        
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_ZXDT" andPageId:@"PAGE_LPXQ"];
        BuildingDynamicMsgListViewController *VC = [[BuildingDynamicMsgListViewController alloc]init];
        VC.building = _buildingMo;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
    
    
    //位置 周边
    if (indexPath.section == 5 && indexPath.row== 0)
    {
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WZJZB" andPageId:@"PAGE_LPXQ"];
        
        [MobClick event:@"lpxq_wzjzb"];
        
        
        DLog(@"地图");
        MapViewController *VC = [[MapViewController alloc]init];
        VC.buileding = _buildingMo;
        VC.isShouldCallOut = NO;
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
    //全部户型
    if (indexPath.section==4 && indexPath.row==0)
    {
        DLog(@"主力户型列表");
        if (_buildingMo.roomLayoutArray.count > 0) //大于0个才能有打开楼盘主力户型列表
        {
            HouseTypeListViewController *VC = [[HouseTypeListViewController alloc] init];
            VC.building = _buildingMo;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
}

-(void)mapTopClick:(UIButton *)sender
{
    MapViewController *VC = [[MapViewController alloc]init];
    
    VC.buileding = _buildingMo;
    VC.isShouldCallOut = YES;
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
//收藏
-(void)startBtnClick:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [MobClick event:@"lpxq_soucang"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_SCLP" andPageId:@"PAGE_LPXQ"];
    
    if (sender.selected) //已收藏
    {
        //调用取消收藏的接口
        
        [[DataFactory sharedDataFactory] cancelFavoriteWithBuilding:_buildingMo withCallBack:^(ActionResult *result) {
            
            if (result.success) {
                
                sender.userInteractionEnabled = YES;
                
                sender.selected = !sender.selected;
                [self showTips:@"取消收藏成功!"];
                //刷新首页通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBuildingData" object:nil];
                
            }else{
                sender.userInteractionEnabled = YES;
                
                [self showTips:result.message];
            }
        }];
        
    }else
    {
        /**
         *  调用收藏接口
         */
        [[DataFactory sharedDataFactory] addFavoriteWithBuilding:_buildingMo withCallBack:^(ActionResult *result) {
            if (result.success) {
                sender.userInteractionEnabled = YES;
                
                sender.selected = !sender.selected;
                [self showTips:@"收藏成功!"];
                //刷新首页通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBuildingData" object:nil];
                
            }else{
                sender.userInteractionEnabled = YES;
                
                [self showTips:result.message];
                
            }
            
        }];
        
    }
    
}

//下载
-(void)downLoadBtnClick:(UIButton *)sender
{
    
    if ([_estateBuildingMo.status isEqualToString:@"finished"]) {
        
        [self showTips:@"该楼盘已下线"];
        
    }else{
        if (sender.selected)
        {
            [self showTips:@"您已下载过该楼盘!"];
            
        }else{
            
            UIAlertView *promptBox = [[UIAlertView alloc]initWithTitle:@"点击下载楼盘全部图片,以便离线查看。建议您在WIFI环境下载" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [promptBox show];
        }
        
    }
    
}
#pragma mark -用户点击开始下载
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        {
            [self startDownloadWith:_buildingMo];
        }
    }
}

#pragma mark - 下载数据
-(void)startDownloadWith:(Building *)buildlistData;
{
    NSString *showTipString = [NSString stringWithFormat:@"您正在下载%@楼盘",_buildingMo.name];
    
    [self showTips:showTipString];
    DownloaderManager *downloaderManager=[DownloaderManager sharedManager];
    [downloaderManager addRequestWithItemId:buildlistData.buildingId andName:buildlistData.name];
    [downloaderManager resourceRequestWithItemId:buildlistData.buildingId];
    [downloaderManager getDownloadStateWithItemId:buildlistData.buildingId];
    
}

#pragma mark - 下方三个按钮的方法
//联系案场
-(void)ContactFieldClick:(UIButton *)sender
{
    [MobClick event:@"lpxq_lxac"];
    
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LXAC" andPageId:@"PAGE_LPXQ"];
    __weak BuildingDetailViewController *weakSelf = self;
    
    if (self.buildingMo.caseTelList.count>0) {
        
        _popView = [[PopView alloc]initWithType:kConnectionsSquare AndBuilding:_buildingMo];
        _popView.delegate = self;
        
        _popView.DidSelectOneCaseTelViewBlock = ^(CaseTelList * caseTelListMo){
            
            [weakSelf callTelPhoneWithCaseTelListMo:caseTelListMo];
            
        };
        
        
        [self showWithPopView:_popView];
    }else{
        
        AlertShow(@"没有设置联系驻场电话");
    }
    
    
    return;
    
    /*  __weak BuildingDetailViewController *weakSelf = self;
     
     if (_buildingMo.caseTelList.count>0) {
     
     CaseTelView *telView = [[CaseTelView alloc]initWithBuilding:_buildingMo AndCaseTelViewStyle:ContactFieldStyle];
     
     telView.DidSelectOneCaseTelViewBlock = ^(CaseTelList * caseTelListMo){
     
     [weakSelf callTelPhoneWithCaseTelListMo:caseTelListMo];
     
     };
     [self.view addSubview:telView];
     }else{
     AlertShow(@"没有设置联系案场电话");
     }*/
    
    
    
    
    
}

//在线咨询

-(void)onLineChat:(UIButton *)sender
{
    //    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithText:self.buildingMo.shareUrl];
    //    NSString *from = [[EMClient sharedClient] currentUsername];
    //    UserCacheInfo *userInfo = [UserCacheManager getCurrUser];
    //    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    //    [extDic setValue:userInfo.Id forKey:kChatUserId];
    //    [extDic setValue:userInfo.AvatarUrl forKey:kChatUserPic];
    //    [extDic setValue:userInfo.NickName forKey:kChatUserNick];
    //
    //    EMMessage *message = [[EMMessage alloc]initWithConversationID:@"13693211326" from:from to:@"13693211326" body:body ext:nil];;
    //    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //    message.ext = extDic;
    //
    //    [EaseSDKHelper sendTextMessage:self.buildingMo.shareUrl to:@"13693211326" messageType:EMChatTypeChat messageExt:extDic];
    //
    
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_ZXZX" andPageId:@"PAGE_LPXQ"];
    
    __weak BuildingDetailViewController *weakSelf = self;
    if (self.buildingMo.easemobConfirmList.count>0)
    {
        _popView = [[PopView alloc]initWithType:kOnLineChat AndBuilding:_buildingMo];
        _popView.delegate = self;
        _popView.DidSelectOneEasemobConfirmBlock = ^(EasemobConfirmModel *easemobConfirmMo){
            [weakSelf pushToChatVCWithEasemobConfirmModel:easemobConfirmMo];
        };
        [self showWithPopView:_popView];
        
    }else if (self.buildingMo.easemobConfirmList.count== 1)
    {
        
        [self pushToChatVCWithEasemobConfirmModel:self.buildingMo.easemobConfirmList[0]];
        
    }else{
        AlertShow(@"没有设置在线咨询确客");
    }
    
    //
    //    __weak BuildingDetailViewController *weakSelf = self;
    //
    //    if (self.buildingMo.easemobConfirmList.count>0) {
    //
    //        CaseTelView *telView = [[CaseTelView alloc]initWithBuilding:_buildingMo AndCaseTelViewStyle:OnLineChatStyle];
    //
    //        telView.DidSelectOneEasemobConfirmBlock = ^(EasemobConfirmModel *easemobConfirmMo){
    //
    //            [weakSelf pushToChatVCWithEasemobConfirmModel:easemobConfirmMo];
    //
    //        };
    //        [self.view addSubview:telView];
    //
    //    }else if (self.buildingMo.easemobConfirmList.count== 1){
    //
    //        [self pushToChatVCWithEasemobConfirmModel:self.buildingMo.easemobConfirmList[0]];
    //
    //    }else{
    //
    //        AlertShow(@"没有设置在线咨询确客");
    //    }
    
}

-(void)pushToChatVCWithEasemobConfirmModel:(EasemobConfirmModel *)easemobConfirmMo
{
    if (easemobConfirmMo.username.length>0) {
        
        [UserCacheManager saveInfo:easemobConfirmMo.username imgUrl:easemobConfirmMo.headPic nickName:easemobConfirmMo.nickname];
        
        DLog(@"self.buildingMo.shareUrl=====%@",self.buildingMo.shareUrl)
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
        
        [extDic setValue:_estateBuildingMo.imgUrl forKey:@"agency_building_url"];
        [extDic setValue:_buildingMo.name forKey:@"agency_building_name"];
        
        [extDic setValue:_buildingMo.buildingId forKey:@"agency_building_id"];
        [extDic setValue:[NSString stringWithFormat:@"%@-%@",_estateBuildingMo.district,_estateBuildingMo.plate] forKey:@"agency_building_area"];
        [extDic setValue:@"1" forKey:@"agency_building_detail"];
        [extDic setValue:[UserData sharedUserData].userInfo.mobile forKey:@"agency_mobile"];
        [extDic setValue:[UserData sharedUserData].userInfo.employeeNo forKey:@"agency_employeeNo"];
        [extDic setValue:[NSString stringWithFormat:@"%@ %@",[UserData sharedUserData].userInfo.orgnizationName,[UserData sharedUserData].userInfo.storeName] forKey:@"agency_department"];
        //对方环信ID
        //    easemobConfirmMo.username
        //@"test_confirm_15344444444"
        NSString *sendMsg =  [NSString stringWithFormat:@"[%@]",self.buildingMo.name];
        //发送文字消息
        EMMessage *message = [EaseSDKHelper sendTextMessage:sendMsg
                                                         to:easemobConfirmMo.username//接收方
                                                messageType:EMChatTypeChat//消息类型
                                                 messageExt:extDic]; //扩展信息
        //        发送构造成功的消息
        __weak BuildingDetailViewController *weakSelf = self;
        
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        } completion:^(EMMessage *message, EMError *error) {
            
            if (!error) {
                ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:easemobConfirmMo.username conversationType:EMConversationTypeChat];
                
                chatVC.buildingID = weakSelf.buildingMo.buildingId;
                chatVC.nickName = easemobConfirmMo.nickname;
                chatVC.title =easemobConfirmMo.nickname;
                
                [weakSelf.navigationController pushViewController:chatVC animated:YES];
                
            }
            
            
        }];
        
        
        
    }else{
        
        AlertShow(@"确客不正确");
        
    }
    
    
}



-(void)callTelPhoneWithCaseTelListMo:(CaseTelList *)caseTelListMo

{
    
    
    NSString *telStr = [NSString stringWithFormat:@"tel:%@",caseTelListMo.caseTel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telStr]]];
    [self.view addSubview:callWebview];
    
    
}



//我的客户
-(void)myCustomerClick:(UIButton *)sender
{
    [MobClick event:@"lpxq_wdkh"];
    
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WDBB" andPageId:@"PAGE_LPXQ"];
    
    
    sender.userInteractionEnabled = NO;
    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:_buildingMo.buildingId WithCallBack:^(ActionResult *result,NSArray *array) {
        
        sender.userInteractionEnabled = YES;
        if (array.count >0)
        {
            MyCustomersViewController *reportVC = [[MyCustomersViewController alloc] init];
            reportVC.buildingId = _buildingMo.buildingId;
            reportVC.customerArr = array;
            [self.navigationController pushViewController:reportVC animated:YES];
            
        }else{
            sender.userInteractionEnabled = YES;
            [self showTips:@"您还没有报备过客户，请先报备!"];
        }
        
    }];
    
}
//报备客户
-(void)baoBeiBtnClick:(UIButton *)sender
{
    [MobClick event:@"lpxq_bbkh"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_BBKH" andPageId:@"PAGE_LPXQ"];
    
    //    HouseTypeListViewController *VC = [[HouseTypeListViewController alloc] init];
    //    VC.building = _buildingMo;
    //    [self.navigationController pushViewController:VC animated:YES];
    if ([_estateBuildingMo.status isEqualToString:@"expired"]) {
        
        AlertShow(@"该楼盘合作已到期");
        return;
    }
    
    if ([_estateBuildingMo.status isEqualToString:@"finished"]) {
        
        [self showTips:@"该楼盘已下线"];
        
    }else{
        
        CustomerReportViewController *reportVC = [[CustomerReportViewController alloc] init];
        reportVC.buildingID = _buildingMo.buildingId;
        reportVC.customerTelType = _estateBuildingMo.customerTelType;
        reportVC.bIsShowVisitInfo = _estateBuildingMo.customerVisitEnable;
        reportVC.mechanismType = _estateBuildingMo.mechanismType;
        reportVC.mechanismText = _estateBuildingMo.mechanismText;
        reportVC.type = 2;
        
        reportVC.buildingName = _buildingMo.name;
        reportVC.buildDistance = self.buildDistance;
        reportVC.featureTag = _estateBuildingMo.featureTag;
        reportVC.commission = _estateBuildingMo.formatCommissionStandard;
        [self.navigationController pushViewController:reportVC animated:YES];
        
    }
    
}


//分享
-(void)shareBtnClick:(UIButton *)sender
{
    [MobClick event:@"lpxq_lpfx"];
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_FXLP" andPageId:@"PAGE_LPXQ"];
    
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = _estateBuildingMo.buildingSellPoint;
    
    
    
    DLog(@"_estateBuildingMo.buildingSellPoint====%@",pboard.string);
    
    //测试使用
    //    [Tool setCache:@"CustomIOSAlertViewShow" value:NULL];
    
    
    if ([_estateBuildingMo.status isEqualToString:@"expired"]) {
        
        AlertShow(@"该楼盘合作已到期");
        return;
    }
    
    if ([_estateBuildingMo.status isEqualToString:@"finished"]) {
        
        AlertShow(@"该楼盘已下线");
        return;
    }
    
    [self showShareView];
    
}

-(void)buildingImageTap
{
    if (_buildingMo.albumArray.count > 0)
    {
        HouseAlbumViewController *VC = [[HouseAlbumViewController alloc]init];
        VC.building = _buildingMo;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}


#pragma mark - CustomIOSAlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"buttonIndex== %ld",(long)buttonIndex);
    //    01
    [self showShareView];
    [alertView close];
    
}

-(void)showShareView
{
    
    ShareModel *share = [[ShareModel alloc]init];
    share = _buildingMo.shareInfo;
    
    if(_shareView){
        [_shareView removeAllSubviews];
        [_shareView removeFromSuperview];
    }
    //    _shareView = [[ShareActionSheet alloc]initWithShareType:BUILDING andModel:share andParent:self.view];
    
    _shareView = [[ShareActionSheet alloc]initAutoShareViewWithShareRange:[UserData sharedUserData].shareRangeArray ShareType:BUILDING andModel:share andParent:self.view];
    
}


-(UIView *)alertContentView
{
    
    UIView *alertContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-80, 60)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertContentView.width, 44)];
    titleLabel.text = @"文案已帮你写好,粘贴分享";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x888888);
    titleLabel.font = FONT(16.f);
    
    [alertContentView addSubview:titleLabel];
    
    UILabel *messageOne = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom, alertContentView.width-40, 40)];
    messageOne.text = @"全是楼盘卖点";
    messageOne.textAlignment = NSTextAlignmentCenter;
    messageOne.font = FONT(14.f);
    messageOne.numberOfLines = 0;
    messageOne.textColor = UIColorFromRGB(0x333333);
    
    [alertContentView addSubview:messageOne];
    
    CGSize size = [messageOne boundingRectWithSize:CGSizeMake(alertContentView.width, 0)];
    
    messageOne.height = size.height;
    
    alertContentView.height = messageOne.height+titleLabel.height;
    if (alertContentView.height<=60+20) {
        alertContentView.height = 60+20;
    }
    
    return alertContentView;
    
}


-(void)EditNullValue
{
    if ([self isBlankString:_buildingMo.name])
    {
        _buildingMo.name = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.price]) {
        _estateBuildingMo.price = @"0";
    }
    
    if ([self isBlankString:_estateBuildingMo.mainCustomer])
    {
        _estateBuildingMo.mainCustomer = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.buyHouseDemand])
    {
        _estateBuildingMo.buyHouseDemand = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.buyHouseBudget])
    {
        _estateBuildingMo.buyHouseBudget = EMPTYSTRING;
    }
    
    
    if ([self isBlankString:_estateBuildingMo.customerWorkArea])
    {
        _estateBuildingMo.customerWorkArea = EMPTYSTRING;
    }
    
    
    if ([self isBlankString: _estateBuildingMo.customerGenera])
    {
        _estateBuildingMo.customerGenera = EMPTYSTRING;
    }
    
    
    if ([self isBlankString:_estateBuildingMo.featureTag])
    {
        _estateBuildingMo.featureTag = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.commissionStandard])
    {
        _estateBuildingMo.commissionStandard = EMPTYSTRING;
    }
#warning "后台没有客户职业字段  这个字段也要处理下
    
}

#pragma mark - 创建 第一个Cell View
-(UIView *)creatBuildingBaseDetailView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, 0)];
    
    //    UILabel *buildingNameLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-100, 17) text:_buildingMo.name textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)]; ;
    //    buildingNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    //    [bgView addSubview:buildingNameLabel];
    
    NSMutableArray *array = [NSMutableArray array];
#warning 测试数据
    
    //    self.buildingMo.isHot = arc4random() %(0+2);
    //    self.buildingMo.isNew = arc4random() %(0+2);
    //    self.buildingMo.isSpecialPrice = arc4random() %(0+2);
    //    self.buildingListData.bedroomSegment = @"1-5居";
    //    self.buildingListData.saleAreaSegment  = @"85-108㎡";
    //    self.buildingListData.districtName = @"昌平";
    //    self.buildingListData.plateName = @"天通苑";
    if (self.buildingMo.isHot) {
        [array appendObject:@"热门"];
    }
    if(self.buildingMo.isNew){
        [array appendObject:@"新上"];
    }
    if(self.buildingMo.isSpecialPrice){
        [array appendObject:@"特价"];
    }
    CGFloat AllLeftWith =kMainScreenWidth-  (5+(5+22)*array.count);
    if (array.count>0) {
        
        for (NSInteger i  = 0 ; i < array.count; i ++) {
            NSString *string = array[i];
            if ([string isEqualToString:@"热门"]) {
                [bgView addSubview:[self creatImageViewWithFrameX:AllLeftWith andImageName:@"building-hot"]];
                AllLeftWith = AllLeftWith+5+22;
                
            }
            if ([string isEqualToString:@"新上"]) {
                [bgView addSubview:[self creatImageViewWithFrameX:AllLeftWith andImageName:@"building-new"]];
                AllLeftWith = AllLeftWith  +5+22;
                
            }
            if ([string isEqualToString:@"特价"]) {
                [bgView addSubview:[self creatImageViewWithFrameX:AllLeftWith andImageName:@"building-specialprice"]];
                AllLeftWith = AllLeftWith +5+22;
            }
        }
    }
    UILabel *buildingNameLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-100, 17) text:_buildingMo.name textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)]; ;
    buildingNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    buildingNameLabel.numberOfLines = 0;
    CGSize buildNameSize = [buildingNameLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-27*array.count-15, 0)];
    buildingNameLabel.frame = CGRectMake(10, 15, buildNameSize.width, buildNameSize.height);
    [bgView addSubview:buildingNameLabel];
    
    
    UILabel *buildingAnotherNamelabel;
    if(_estateBuildingMo.alias.length>0 ){
        buildingAnotherNamelabel = [UILabel createLabelWithFrame:CGRectMake(buildingNameLabel.left, buildingNameLabel.bottom+10, kMainScreenWidth, 13) text:[NSString stringWithFormat:@"别名: %@ ",_estateBuildingMo.alias] textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x888888)];
        [bgView addSubview:buildingAnotherNamelabel];}
    
    //    _estateBuildingMo.priceTotal = @"500万/套";
    //    _estateBuildingMo.priceFirst = @"100万";
    NSString *priceString = [[NSString alloc]init];
    if (_estateBuildingMo.price.length>0) {
        priceString = [priceString stringByAppendingString:[NSString stringWithFormat:@"均价%@",_estateBuildingMo.price]];
    }
    if (_estateBuildingMo.priceTotal.length>0) {
        priceString = [priceString stringByAppendingString:[NSString stringWithFormat:@"\n总价%@",_estateBuildingMo.priceTotal]];
        
    }
    if (_estateBuildingMo.priceFirst.length>0) {
        priceString = [priceString stringByAppendingString:[NSString stringWithFormat:@"  首付款%@",_estateBuildingMo.priceFirst]];
        
    }
    UILabel *buildingPriceLabel = [UILabel createLabelWithFrame:CGRectMake(buildingNameLabel.left, _estateBuildingMo.alias.length>0?buildingAnotherNamelabel.bottom+13:buildingNameLabel.bottom+13, 0, 0) text:[NSString stringWithFormat:@"%@",priceString] textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:ORIGCOLOR];
    buildingPriceLabel.numberOfLines = 0;
    CGSize size =   [buildingPriceLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-20, 0)];
    
    buildingPriceLabel.width = size.width;
    buildingPriceLabel.height = size.height;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [priceString length])];
    [buildingPriceLabel setAttributedText:attributedString1];
    [buildingPriceLabel sizeToFit];
    
    [bgView addSubview:buildingPriceLabel];
    
    //计算器图案
    UIImageView *jiSuanIconImageView =   [self createImageViewWithFrame:CGRectMake(buildingPriceLabel.right+15, buildingPriceLabel.top, 15, 17) imageName:@"calculator"];
    jiSuanIconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jiSunQiTap)];
    [jiSuanIconImageView addGestureRecognizer:tap];
    
    [bgView addSubview:jiSuanIconImageView];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if (![self isBlankString:_estateBuildingMo.featureTag])
    {//不为空
        if ([_estateBuildingMo.featureTag rangeOfString:@","].location!=NSNotFound)
        {  //有分号,
            NSArray *array = [_estateBuildingMo.featureTag componentsSeparatedByString:@","];
            if(_estateBuildingMo.trystCar){
                
                for (NSString *string in array) {
                    if (string.length>0) {
                        
                        [tempArray appendObject:string];
                    }
                }
#warning 这里要和产品确认   需不需要手动添加标签
                //                [tempArray insertObject:@"约车看房" atIndex:0];
            }else{
                for (NSString *string in array) {
                    if (string.length>0) {
                        
                        [tempArray appendObject:string];
                    }
                }
            }
        }else{
            [tempArray appendObject:_estateBuildingMo.featureTag];
        }
    }
    GSTagView *tagView;
    if (tempArray.count>0) {
        
        tagView = [[GSTagView alloc]initWithFrame:CGRectMake(5, buildingPriceLabel.bottom+10, kMainScreenWidth-20, 0)];
        tagView.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        tagView.horizontalSpace = 10;
        tagView.verticalSpace =  10;
        tagView.tagViewStyle = BuildingDetailTagViewStyle;
        tagView.dataSource  = tempArray;
        [bgView addSubview:tagView];
    }
    
//    _buildingMo.salesPhaseName = @"顺利销售中   ";

    AutoLabel *salesPhaseNameLabel;
    if (![self isBlankString:_buildingMo.salesPhaseName]) {
        salesPhaseNameLabel  =[[AutoLabel alloc]initWithFrame:CGRectMake(10, tempArray.count>0?tagView.bottom+10:buildingPriceLabel.bottom+10, kMainScreenWidth-20-30, 0) andTitle:@"销售阶段:  " andContent:_buildingMo.salesPhaseName];
        [bgView addSubview:salesPhaseNameLabel];
    }
    
    CGFloat addressTopY = _buildingMo.salesPhaseName.length>0?salesPhaseNameLabel.bottom+10:(tempArray.count>0?tagView.bottom+10:buildingPriceLabel.bottom+10);
    AutoLabel *addressLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10,addressTopY , kMainScreenWidth-20-30, 0) andTitle:@"地       址:  " andContent:_estateBuildingMo.address];
    
    [bgView addSubview:addressLabel];
    //地图定位图标
    UIImageView *locationImageView = [self createImageViewWithFrame:CGRectMake(addressLabel.right+10, addressLabel.top, 14, 17) imageName:@"地址"];
    locationImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationImageViewTap)];
    [locationImageView addGestureRecognizer:locationTap];
    [bgView addSubview:locationImageView];
    
    
    AutoLabel *openDiscTimeLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(addressLabel.left, addressLabel.bottom+10, (kMainScreenWidth-20), 14) andTitle:@"开盘时间:  " andContent:_estateBuildingMo.openDiscTime];
    [bgView addSubview:openDiscTimeLabel];
    
    AutoLabel * soughtTimeLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(openDiscTimeLabel.left, openDiscTimeLabel.bottom+10, (kMainScreenWidth-20), 14) andTitle:@"交房时间:  " andContent:_estateBuildingMo.soughtTime];
    [bgView addSubview:soughtTimeLabel];
    
    UILabel *lineLebl = [[UILabel alloc ]initWithFrame:CGRectMake(0, soughtTimeLabel.bottom+10, kMainScreenWidth, 1)];
    lineLebl.backgroundColor = UIColorFromRGB(0xefeff4);
    [bgView addSubview:lineLebl];
    
    _buildingBaseDetailViewCellHeight = lineLebl.bottom;
    bgView.height = lineLebl.bottom;
    return bgView;
    
}

- (UIView *)creatYouHuiRenChouView
{
    _youHuiRenChouHeight = 0;
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 134/2)];
    
    NSString *youHuiName;
    NSString *renChouName;
    
    if (_buildingMo.youHuiLists.count>0) {
        Discount *dis = _buildingMo.youHuiLists[0];
        if (dis.name.length>0) {
            youHuiName = dis.name;
        }
    }
    
    if (_buildingMo.renChouLists.count>0) {
        Discount *dis = _buildingMo.renChouLists[0];
        if (dis.name.length>0) {
            renChouName = dis.name;
        }
    }
    
    UIImageView *youHuiImageView ;
    if (youHuiName.length>0) {
        
        youHuiImageView = [self createImageViewWithFrame:CGRectMake(10, 15, 40, 27/2) imageName:@"优惠"];
        [bgview addSubview:youHuiImageView];
        
        UILabel *youHuilabel = [UILabel createLabelWithFrame:CGRectMake(youHuiImageView.right+10, youHuiImageView.top, kMainScreenWidth-youHuiImageView.width-20-20, youHuiImageView.height) text:youHuiName textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x333333)];
        [bgview addSubview:youHuilabel];
        
        _youHuiRenChouHeight = youHuiImageView.bottom+15;
    }
    
    UIImageView *renChouimageView;
    if (renChouName.length>0) {
        
        renChouimageView= [self createImageViewWithFrame:CGRectMake(10,youHuiName.length>0?  youHuiImageView.bottom+10:15, 40, 27/2) imageName:@"认筹"];
        [bgview addSubview:renChouimageView];
        
        UILabel *renChouLabel = [UILabel createLabelWithFrame:CGRectMake(renChouimageView.right+10, renChouimageView.top, kMainScreenWidth-renChouimageView.width-20-20, renChouimageView.height) text:renChouName textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x333333)];
        [bgview addSubview:renChouLabel];
        
        _youHuiRenChouHeight = renChouimageView.bottom+15;
    }
    
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-7, (_youHuiRenChouHeight-14)/2, 7, 14)];
    arrowImageView.image = [UIImage imageNamed:@"点击三角"];
    [bgview addSubview:arrowImageView];
    
    
    return bgview;
    
}

#pragma mark -  跳转房贷计算器
-(void)jiSunQiTap
{
    
    
    MortgageCalculatorViewController *VC = [[MortgageCalculatorViewController alloc]init];
    
    //    NSString *result=_estateBuildingMo.price;
    
    NSString *uft8Price = [_estateBuildingMo.price stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"uft8Price--------%@",uft8Price);
    
    
    NSString *result=@"";
    NSString *str= _estateBuildingMo.price; // [_estateBuildingMo.price stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //@"abc239-90():!48#%<9*/31\23";
    for (int i=0; i<str.length; i++) {
        NSString *s=[str substringWithRange:NSMakeRange(i, 1)];
        const char *ch=[s UTF8String];
        if (*ch>='0'&&*ch<='9') {
            result=[result stringByAppendingString:s];         }     }
    
    NSLog(@"result--------%@",result);
    
    VC.housePrise = _estateBuildingMo.price;
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
    
}






#pragma mark - delegate
-(void)didCancelWith:(PopView *)popView;
{
    
    [self closeWithPopView:_popView];
    
}

-(void)maskViewTap
{
    [self closeWithPopView:_popView];
}

#pragma mark -  做弹出动画

-(void)showWithPopView:(PopView *)popView{
    
    self.popGestureRecognizerEnable = NO;
    _maskView = ({
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [maskView addGestureRecognizer:tap];
        
        maskView;
        
    });
    [self.view addSubview:_maskView];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];;
    
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    
    CGRect frame = popView.frame;
    frame.origin.y = self.view.bounds.size.height - popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.view.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.view.layer setTransform:[self secondTransform]];
            //                显示maskView
            [_maskView setAlpha:0.5f];
            //                popView上升
            popView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

- (void)closeWithPopView:(PopView *)popView
{
    self.popGestureRecognizerEnable = YES;
    CGRect frame = popView.frame;
    frame.origin.y += popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //maskView隐藏
        [_maskView setAlpha:0.f];
        //popView下降
        popView.frame = frame;
        
        //同时进行 感觉更丝滑
        [self.view.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [self.view.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            [popView removeAllSubviews];
            //移除
            [popView removeFromSuperview];
            
            [_popView removeAllSubviews];
            [_popView removeFromSuperview];
            _popView.delegate = nil;
            
            self.tableView.backgroundColor = BACKGROUNDCOLOR;
            
        }];
        
    }];
    
}




-(void)locationImageViewTap{
    
    
    MapViewController *VC = [[MapViewController alloc]init];
    
    VC.buileding = _buildingMo;
    VC.isShouldCallOut = YES;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - For UIImageView
- (UIImageView *)createImageViewWithFrame:(CGRect)frame
                                imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}



- (UIImageView *)creatImageViewWithFrameX:(CGFloat)framex andImageName:(NSString *)imageName;
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(framex, 0, 20, 56/2)];
    imageView.image = [UIImage imageNamed:imageName];
    
    return imageView;
}



- (void)baseNavigationController:(BaseNavigationController*)controller didReturn:(NSString*)className
{
    
    if ([className isEqualToString:@"BuildingDetailViewController"]) {
        
        if (_popView) {
            [_popView removeAllSubviews];
            [_popView removeFromSuperview];
        }
        
        
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getter
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        UIScrollView* scrollV = [[UIScrollView alloc]init];
        scrollV.frame = self.view.bounds;
        scrollV.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:scrollV];
        scrollV.contentSize = CGSizeMake(0, 1000);
        scrollV.delegate = self;
        scrollV.showsVerticalScrollIndicator = NO;
        _contentScrollView = scrollV;
    }
    return _contentScrollView;
}

- (UIView *)topContentView{
    if (!_topContentView) {
        UIView* view = [[UIView alloc]init];
        _topContentView = view;
        UIScrollView* contentV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 0.75)];
        contentV.delegate = self;
        _albumScrollView = contentV;
        contentV.pagingEnabled = YES;
        
        BuildingImageView *buildImage = [[BuildingImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*0.75) andBuildingId:self.buildingId];
        //        [buildImage setImageWithUrlString:@" placeholderImage:[UIImage imageNamed:@"列表默认图.png"]];
        [buildImage setImage:[UIImage imageNamed:@"楼盘详情页默认图.png"]];
        buildImage.contentMode = UIViewContentModeScaleAspectFill;
        buildImage.clipsToBounds = YES;
        UIImageView *backBlackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 152/2)];
        backBlackImageView.image = [UIImage imageNamed:@"blackhead"];
        [buildImage addSubview:backBlackImageView];
        
        _imageViewArray = @[buildImage];
        DLog(@"_buildingMo.imgUrl==== %@",_estateBuildingMo.imgUrl);
        
        
        if (_buildingMo.albumArray.count > 0)
        {
            [self initAlbumScrollViewWith:_buildingMo.albumArray];
        }else{
            [contentV addSubview:buildImage];
            contentV.contentSize = CGSizeMake(kMainScreenWidth, 0.0);
        }
        
        [view addSubview:contentV];
        buildImage.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        [buildImage addGestureRecognizer:tap];
        
        [self.contentScrollView addSubview:view];
    }
    return _topContentView;
}

//相册底部容器图
- (UIView *)bottomContentView{
    if (!_bottomContentView) {
        UIView* contentView = [[UIView alloc]init];
        [self.contentScrollView addSubview:contentView];
        _bottomContentView = contentView;
    }
    return _bottomContentView;
}

- (XTAlbumTitleView *)titleView{
    if (!_titleView) {
        
        __weak typeof(self) weakSelf = self;
        XTAlbumTitleView* titleV = [[XTAlbumTitleView alloc]initWithCallBack:^(XTAlbumTitleView *titleView,NSInteger index, UIButton *button) {
            [weakSelf changeImagesWithIndex:index];
        }];
        NSMutableArray* titleArray = [NSMutableArray array];
        if (self.buildingMo.albumArray.count > 0)
        {
            for (AlbumData *albumDate  in self.buildingMo.albumArray)
            {
                [titleArray appendObject:albumDate.albumName];
            }
        }
        //        titleArray = @[@"户型图",@"呵呵图",@"不知道图",@"设么还是呢"];
        titleV.titleArray = titleArray;
        titleV.frame = CGRectMake(0, kMainScreenHeight - 49.0f, kMainScreenWidth, 49.0f);
        [self.view addSubview:titleV];
        [self.view bringSubviewToFront:self.bottomView];
        _titleView = titleV;
    }
    return _titleView;
}

- (XTImageCountTipsView *)numbTipsView{
    if (!_numbTipsView) {
        AlbumData *albuData = [_buildingMo.albumArray objectForIndex:0];
        XTImageCountTipsView* tipV = [[XTImageCountTipsView alloc]init];
        tipV.type = CountTipsViewTypeBottomImage;
        [self.topContentView addSubview:tipV];
        tipV.titleString = albuData.albumName;
        tipV.totalNumber = albuData.images.count;
        tipV.currentIndex = 0;
        tipV.hidden = YES;
        _numbTipsView = tipV;
    }
    return _numbTipsView;
}

- (XTImageCountTipsView *)onImageTipsView{
    if (!_onImageTipsView) {
        AlbumData *albuData = [_buildingMo.albumArray objectForIndex:0];
        XTImageCountTipsView* tipV = [[XTImageCountTipsView alloc]init];
        tipV.type = CountTipsViewTypeOnImage;
        tipV.clipsToBounds = YES;
        tipV.layer.cornerRadius = 2.5;
        [self.topContentView addSubview:tipV];
        tipV.titleString = albuData.albumName;
        tipV.totalNumber = self.albumScrollView.contentSize.width/kMainScreenWidth==0?1:self.albumScrollView.contentSize.width/kMainScreenWidth;
        tipV.currentIndex = 0;
        tipV.hidden = _buildingMo.albumArray.count <= 0;
        _onImageTipsView = tipV;
    }
    return _onImageTipsView;
}

- (void)initScrollView{
    
}

-(PeripheralLocationView *)peripheralLocationView
{
    if (!_peripheralLocationView) {
        _peripheralLocationView = [[PeripheralLocationView alloc]initWithBuilding:self.buildingMo];
    }
    
    return _peripheralLocationView;
    
}

#pragma mark - Action
/**
 修改相册图片
 */
- (void)changeImagesWithIndex:(NSInteger)index{
    if (_buildingMo.albumArray.count <= index) {
        return;
    }
    NSMutableArray* imagesArray = [NSMutableArray array];
    for (int i = 0; i < index; i++) {
        AlbumData* data = [_buildingMo.albumArray objectForIndex:i];
        [imagesArray addObjectsFromArray:data.images];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [_albumScrollView setContentOffset:CGPointMake(imagesArray.count * kMainScreenWidth, 0)];
    }];
    
    
    /*    AlbumData* data = [_buildingMo.albumArray objectForIndex:index];
     _imageContentArray = data.images;
     
     NSMutableArray* imgVArray = [NSMutableArray array];
     for (int i = 0; i < _imageContentArray.count; i++) {
     NSString* url = _imageContentArray[i];
     YRImageView* imgV = [[YRImageView alloc]init];
     imgV.frame = CGRectMake(i * kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth * 0.75);
     [imgV setImageWithUrlString:url placeholderImage:[UIImage imageNamed:@"列表默认图.png"]];
     imgV.clipsToBounds = YES;
     imgV.contentMode = UIViewContentModeScaleAspectFill;
     UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
     imgV.userInteractionEnabled = YES;
     [imgV addGestureRecognizer:tap];
     [_albumScrollView addSubview:imgV];
     [imgVArray appendObject:imgV];
     }
     _imageViewArray = imgVArray;
     _albumScrollView.contentSize = CGSizeMake(kMainScreenWidth * _imageContentArray.count, 0);
     [_albumScrollView setContentOffset:CGPointZero];
     */
}

- (void)initAlbumScrollViewWith:(NSArray*)albumDataArray{
    if (albumDataArray.count <= 0) {
        return;
    }
    NSMutableArray* imagesArray = [NSMutableArray array];
    NSMutableArray* imgVArray = [NSMutableArray array];
    NSInteger totalIndex = 0;
    NSInteger groupIndex = 0;
    for (AlbumData *albuData in _buildingMo.albumArray)
    {
        NSInteger currentIndex = 0;
        for (NSString* url in albuData.images) {
            YRImageView* imgV = [[YRImageView alloc]init];
            imgV.frame = CGRectMake(totalIndex * kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth * 0.75);
            if (totalIndex==0) {
                [imgV setImageWithUrlString:url placeholderImage:[UIImage imageNamed:@"楼盘详情页默认图"]];
            }
            imgV.clipsToBounds = YES;
            imgV.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
            imgV.userInteractionEnabled = YES;
            [imgV addGestureRecognizer:tap];
            [_albumScrollView addSubview:imgV];
            [imgVArray appendObject:imgV];
            imgV.totalIndex = totalIndex;
            imgV.groupIndex = groupIndex;
            imgV.totalNumber = albuData.images.count;
            imgV.titleString = albuData.albumName;
            imgV.currentIndex = currentIndex;
            currentIndex++;
            totalIndex++;
        }
        [imagesArray addObjectsFromArray:albuData.images];
        groupIndex++;
    }
    _imageViewArray = imgVArray;
    _imageViewUrlArray =imagesArray;
    
    _albumScrollView.contentSize = CGSizeMake(kMainScreenWidth * imagesArray.count, 0);
    [_albumScrollView setContentOffset:CGPointZero];
}

/**
 相册图片点击事件
 */
- (void)imageViewAction:(UIGestureRecognizer*)gest{
    UIImageView* imgV = (UIImageView*)gest.view;
    if ([imgV isKindOfClass:[UIImageView class]] && _buildingMo.albumArray.count > 0) {
        if (_pullState == PULLSTATEDOWN) {
            ShowBigImageViewController *VC = [[ShowBigImageViewController alloc]init];
            VC.bigImage = imgV.image;
            [self presentViewController:VC animated:NO completion:nil];
        }else{
            [self tapAction:gest];
        }
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:@"contentSize"];
    }
    [_popView removeAllSubviews];
    [_popView removeFromSuperview];
    
}

- (UIButton *)downloadButton{
    if (!_downloadButton) {
        UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        toolBtn.frame = CGRectMake(kMainScreenWidth-44, 20, 44, 44);
        [toolBtn setImage:[UIImage imageNamed:@"building-down.png"] forState:UIControlStateNormal];
        //        20 24
        [toolBtn setImage:[UIImage imageNamed:@"building-down.png"] forState:UIControlStateHighlighted];
        [toolBtn addTarget:self action:@selector(saveImageClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationBar addSubview:toolBtn];
        _downloadButton = toolBtn;
        toolBtn.hidden = YES;
    }
    return _downloadButton;
}

-(void)saveImageClick
{
    NSInteger index = _albumScrollView.contentOffset.x/kMainScreenWidth;
    
    YRImageView *imageView = _imageViewArray[index];
    
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    self.downloadButton.userInteractionEnabled = NO;
    //    _tooView = [[LQToolView alloc]initWithDelegate:self andFrame:self.view.bounds];
    //
    //    [self.view addSubview:_tooView];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        [self showTips:@"保存失败..."];
    }else {
        NSLog(@"OK");
        [self showTips:@"保存成功！"];
        
    }
    self.downloadButton.userInteractionEnabled = YES;
    //    [_tooView removeFromSuperview];
}
#pragma mark - 新装app首次打开引导页 begin
//是否展示 使用帮助 引导图（新装app 首次打开展示）
- (void) shouldShowBuildingDetailFirstTimeShowImg
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"buildingDetail_FirstTimeShow"])
    {
        [self showFirstTimeDisplayImg];
    }
}
//展示引导图
- (void) showFirstTimeDisplayImg
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"buildingDetail_FirstTimeShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    UIButton *imgBtn_detail = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn_detail.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    [imgBtn_detail addTarget:self action:@selector(removeFirstTimeDisplayImg:) forControlEvents:UIControlEventTouchUpInside];
    if (iPhone4) {
        [imgBtn_detail setImage:[UIImage imageNamed:@"960buildingDetail"] forState:UIControlStateNormal];
        [imgBtn_detail setImage:[UIImage imageNamed:@"960buildingDetail"] forState:UIControlStateHighlighted];
    }else{
        [imgBtn_detail setImage:[UIImage imageNamed:@"1080buildingDetail"] forState:UIControlStateNormal];
        [imgBtn_detail setImage:[UIImage imageNamed:@"1080buildingDetail"] forState:UIControlStateHighlighted];
    }
    [delegate.window addSubview:imgBtn_detail];
}

//移除引导图
- (void) removeFirstTimeDisplayImg:(UIButton *) btn
{
    [btn removeFromSuperview];
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
