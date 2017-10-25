//
//  XTSaleRankingController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTSaleRankingController.h"
#import "XTMineRankingInfoView.h"
#import "XTSaleRankingCell.h"
#import "PerformanceRanking.h"
#import "SignRanking.h"
#import "LookRanking.h"
#import "NetWork.h"
#import "ActionResult.h"
#import "MineRankingInfoModel.h"
#import "DataFactory+Main.h"

@interface XTSaleRankingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UISegmentedControl* segmentedControl;

@property (nonatomic,weak)XTMineRankingInfoView* mineRankingView;
//排行榜数据时间区间
@property (nonatomic,weak)UILabel* dateIntervalLabel;

@property (nonatomic,weak)UITableView* tableView;

@property (nonatomic,strong)NSArray* rankingModelArray;

@property (nonatomic,strong)NSMutableArray* signRankingArray;

@property (nonatomic,strong)NSMutableArray* performanceArray;

@property (nonatomic,strong)NSMutableArray* lookRankingArray;

//排行字符串
@property (nonatomic,strong)MineRankingInfoModel* signRankingInfoModel;
@property (nonatomic,strong)MineRankingInfoModel* performanceInfoModel;
@property (nonatomic,strong)MineRankingInfoModel* lookRankingInfoModel;

@end

@implementation XTSaleRankingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)commonInit{
    
    self.navigationBar.titleLabel.text = @"排行榜";
    self.view.backgroundColor = [UIColor whiteColor];
    [self segmentedControl];
    
//    self.mineRankingView.frame = CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), self.view.frame.size.width, 99);
    
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    [self reloadInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        NSArray *titleArr =@[@"成交排行榜",@"业绩排行榜",@"带看排行榜"];
        
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:titleArr];
        //    segment.segmentedControlStyle= UISegmentedControlStyleBordered;
        [segment setFrame:CGRectMake(37, 84, (kMainScreenWidth-74), 29)];
        segment.layer.borderWidth = 1;
        segment.layer.borderColor = [BLUEBTBCOLOR CGColor];
        segment.layer.cornerRadius = 4;
        segment.layer.masksToBounds = YES;
        segment.tintColor = BLUEBTBCOLOR;
        UIFont *font = [UIFont boldSystemFontOfSize:13.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [segment setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
        [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:segment];
        _segmentedControl = segment;
        
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}



- (UITableView *)tableView{
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc]init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
        tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(void)segmentChange:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
        {
            [self signRankingArray];
        }
            break;
        case 1:
        {
            [self performanceArray];
        }
            break;
        case 2:
        {
            [self lookRankingArray];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rankingModelArray.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"segment"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"segment"];
        }
        self.segmentedControl.frame = CGRectMake(37, 20, kFrame_Width(self.view) - 74, 30);
        [cell.contentView addSubview:_segmentedControl];
    }else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"mineRanking"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineRanking"];
            XTMineRankingInfoView* mineView = [XTMineRankingInfoView mineRankingInfoView];
            mineView.frame = CGRectMake(0, 0, 0, 0);
            cell.contentView.frame = mineView.bounds;
            _mineRankingView = mineView;
            [cell.contentView addSubview:mineView];
        }
        
    }else if(indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"dateInterval"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dateInterval"];
        }
        self.dateIntervalLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
        [cell.contentView addSubview:_dateIntervalLabel];
    }else {
        XTSaleRankingCell* rankingCell = [XTSaleRankingCell saleRankingCellWithTableView:tableView];
        if(_rankingModelArray.count > 0)
        rankingCell.rankingModel = _rankingModelArray[indexPath.row - 3];
        
        cell = rankingCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50.0f;
    }else if(indexPath.row == 1){
        return 99.0f;
    }else if(indexPath.row == 2){
        return 20.0f;
    }else
    return 52.0f;
}

- (UILabel *)dateIntervalLabel{
    if (!_dateIntervalLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        _dateIntervalLabel = label;
        label.text = @"最近30天 (09月18日——10月17日)";
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:0.89f green:0.97f blue:1.00f alpha:1.00f];
        [self.view addSubview:label];
    }
    return _dateIntervalLabel;

}

- (void)requestSignRanking{
    
    __weak typeof(self) weakSelf = self;
    UIImageView* imageView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory]getSignRankingRequestWithCallBack:^(XTSignRankingRequestModel *result) {
        [weakSelf removeRotationAnimationView:imageView];
        weakSelf.rankingModelArray = result.ranking;
        [weakSelf setStartAndEndDate:result.myRanking.startDate endDate:result.myRanking.endDate];
        [weakSelf setMyRankingNum:result.myRanking.rownum allAgentCount:0];
        [weakSelf setMyRankingPerformance:result.allCnt comission:result.myRanking.signNum];
        [weakSelf setMyRankingNum:result.myRanking.rownum allAgentCount:result.allCnt];
        if (result.myRanking.headPic.length > 0) {
            [weakSelf.mineRankingView.myHeadPic setImageWithURL:[NSURL URLWithString:result.myRanking.headPic]  placeholderImage:[UIImage imageNamed:@"me-big"]];
        }
        _signRankingInfoModel = [[MineRankingInfoModel alloc]init];
        
        weakSelf.signRankingInfoModel.rankingInfo = weakSelf.mineRankingView.currentRankingLabel.attributedText;
        weakSelf.signRankingInfoModel.comission = weakSelf.mineRankingView.currentMonthInfoLabel.attributedText;
        weakSelf.signRankingInfoModel.performance = weakSelf.mineRankingView.allIncomLabel.attributedText;
        
        _signRankingArray = [NSMutableArray arrayWithArray:result.ranking];
    }];
}

- (void)requestPerformanceRanking{
    __weak typeof(self) weakSelf = self;
    UIImageView* imageView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getPerformanceRankingWithCallBack:^(XTPerformanceRankingRequestModel *result) {
        [weakSelf removeRotationAnimationView:imageView];
        weakSelf.rankingModelArray = result.ranking;
        
        [weakSelf setMyRankingNum:result.myRanking.rownum allAgentCount:0];
        [weakSelf setMyRankingPerformance:result.allCnt comission:result.myRanking.assistantManualVal];
        [weakSelf setMyRankingNum:result.myRanking.rownum allAgentCount:result.allCnt];
        weakSelf.performanceInfoModel = [[MineRankingInfoModel alloc]init];
        weakSelf.performanceInfoModel.rankingInfo = weakSelf.mineRankingView.currentRankingLabel.attributedText;
        weakSelf.performanceInfoModel.comission = weakSelf.mineRankingView.currentMonthInfoLabel.attributedText;
        weakSelf.performanceInfoModel.performance = weakSelf.mineRankingView.allIncomLabel.attributedText;
        weakSelf.performanceArray = [NSMutableArray arrayWithArray:result.ranking];
    }];
    
    return;
}

- (void)requestLookRanking{
    __weak typeof(self) weakSelf = self;
    
    UIImageView* imageView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory]getLookRankingWithCallBack:^(XTLookRankingRequestModel *result) {
        [weakSelf removeRotationAnimationView:imageView];
        weakSelf.rankingModelArray = result.ranking;
        [weakSelf setMyRankingNum:result.myRanking.rownum allAgentCount:result.allCnt];
//        [weakSelf setStartAndEndDate:result.myLookRanking.startDate endDate:result.myPerformanceRanking.endDate];
        [weakSelf setMyRankingPerformance:result.allCnt comission:result.myRanking.guideNum];
        [weakSelf setMyRankingNum:result.myRanking.rownum allAgentCount:0];
        
        weakSelf.lookRankingInfoModel = [[MineRankingInfoModel alloc]init];
        weakSelf.lookRankingInfoModel.rankingInfo = weakSelf.mineRankingView.currentRankingLabel.attributedText;
        weakSelf.lookRankingInfoModel.comission = weakSelf.mineRankingView.currentMonthInfoLabel.attributedText;
        weakSelf.lookRankingInfoModel.performance = weakSelf.mineRankingView.allIncomLabel.attributedText;
        weakSelf.lookRankingArray = [NSMutableArray arrayWithArray:result.ranking];
    }];
}

- (void)setRankingModelArray:(NSArray *)rankingModelArray{
    _rankingModelArray = rankingModelArray;
    [_tableView reloadData];
}

- (NSMutableArray *)signRankingArray{
    if (!_signRankingArray) {
        _signRankingArray = [NSMutableArray array];
        [self requestSignRanking];
    }else if(_signRankingArray.count > 0){
        self.rankingModelArray = _signRankingArray;
    }
    _mineRankingView.currentRankingLabel.attributedText = _signRankingInfoModel.rankingInfo;
    _mineRankingView.currentMonthInfoLabel.attributedText = _signRankingInfoModel.comission;
    _mineRankingView.allIncomLabel.attributedText = _signRankingInfoModel.performance;
    return _signRankingArray;
}

- (NSMutableArray *)performanceArray{
    if (!_performanceArray) {
        _performanceArray = [NSMutableArray array];
        [self requestPerformanceRanking];
    }else if(_performanceArray.count > 0){
        self.rankingModelArray = _performanceArray;
    }
    _mineRankingView.currentRankingLabel.attributedText = _performanceInfoModel.rankingInfo;
    _mineRankingView.currentMonthInfoLabel.attributedText = _performanceInfoModel.comission;
    _mineRankingView.allIncomLabel.attributedText = _performanceInfoModel.performance;
    return _performanceArray;
}

- (NSMutableArray *)lookRankingArray{
    if (!_lookRankingArray) {
        _lookRankingArray = [NSMutableArray array];
        [self requestLookRanking];
    }else if (_lookRankingArray.count > 0){
        self.rankingModelArray = _lookRankingArray;
    }
    _mineRankingView.currentRankingLabel.attributedText = _lookRankingInfoModel.rankingInfo;
    _mineRankingView.currentMonthInfoLabel.attributedText = _lookRankingInfoModel.comission;
    _mineRankingView.allIncomLabel.attributedText = _lookRankingInfoModel.performance;
    return _lookRankingArray;
}

- (void)setStartAndEndDate:(NSString*)startDate endDate:(NSString*)endDate{
    
    if (startDate.length <= 0 || endDate.length <= 0) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM月dd日"];
        NSDateComponents* component = [NSDateComponents new];
        component.month = -1;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* pastData = [calendar dateByAddingComponents:component toDate:[NSDate date] options:0];
    
        startDate = [formatter stringFromDate:pastData];
        endDate = [formatter stringFromDate:[NSDate date]];
    }
    NSString* string = [NSString stringWithFormat:@"最近30天(%@--%@)",startDate,endDate];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    _dateIntervalLabel.attributedText = AttributedStr;
}

- (void)setMyRankingNum:(NSInteger)myRankingNum allAgentCount:(NSInteger)allCount{
    CGFloat baiFen = ((CGFloat)allCount - (CGFloat)myRankingNum) / (CGFloat)allCount * 100;
    if (allCount == 0) {
        baiFen = 100;
    }
    NSString* string = [NSString stringWithFormat:@"当前排名:%ld", (long)myRankingNum];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15]
                          range:NSMakeRange(5,[NSString stringWithFormat:@"%ld",(long)myRankingNum].length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
                          range:NSMakeRange(5,[NSString stringWithFormat:@"%ld",(long)myRankingNum].length)];
    _mineRankingView.currentRankingLabel.attributedText = AttributedStr;
}
//设置我的总业绩和近30天业绩
- (void)setMyRankingPerformance:(CGFloat)allPerformace comission:(CGFloat)myComission{
    
    NSString* typeAllPerformaceStr = nil;
    NSString* myComissionStr = nil;
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            myComissionStr = @"近一月成交数:";
            typeAllPerformaceStr = @"总成交数:";

            NSString* string = nil;
            string =  [NSString stringWithFormat:@"%@%.0f",myComissionStr,myComission];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:11]
                                  range:NSMakeRange(myComissionStr.length,[NSString stringWithFormat:@"%.0f",myComission].length)];
            
            NSUInteger endLength = [NSString stringWithFormat:@"%.0f",myComission].length;
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
             
                                  range:NSMakeRange(myComissionStr.length,endLength)];
            
            _mineRankingView.currentMonthInfoLabel.attributedText = AttributedStr;
            string = [NSString stringWithFormat:@"%@%.0f",typeAllPerformaceStr,allPerformace];
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:11]
                                  range:NSMakeRange(typeAllPerformaceStr.length,[NSString stringWithFormat:@"%.0f",allPerformace].length)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
                                  range:NSMakeRange(typeAllPerformaceStr.length,[NSString stringWithFormat:@"%.0f",allPerformace].length)];
            
            _mineRankingView.allIncomLabel.attributedText = AttributedStr;
            
        }
            break;
        case 1:
        {
            myComissionStr =  @"近一月业绩:";
            typeAllPerformaceStr = @"总业绩:";
            NSString* string = nil;
//            myComission *= 10000;
            string =  [NSString stringWithFormat:@"%@%.0f元",myComissionStr,myComission];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:11]
             
                                  range:NSMakeRange(myComissionStr.length,[NSString stringWithFormat:@"%.0f",myComission].length)];
            
            NSUInteger endLength = [NSString stringWithFormat:@"%.0f",myComission].length;
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
             
                                  range:NSMakeRange(myComissionStr.length,endLength)];
            
            _mineRankingView.currentMonthInfoLabel.attributedText = AttributedStr;
            endLength = [NSString stringWithFormat:@"%.0f",allPerformace].length;
            string =  [NSString stringWithFormat:@"%@%.0f元",typeAllPerformaceStr,allPerformace];
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:11]
                                  range:NSMakeRange(typeAllPerformaceStr.length,endLength)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
                                  range:NSMakeRange(typeAllPerformaceStr.length,endLength)];
            
            _mineRankingView.allIncomLabel.attributedText = AttributedStr;
        }
            break;
            
        case 2:
        {
            myComissionStr = @"近一月带看数:";
            typeAllPerformaceStr =  @"总带看数:";
            NSString* string = nil;
            string =  [NSString stringWithFormat:@"%@%.0f",myComissionStr,myComission];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:11]
             
                                  range:NSMakeRange(myComissionStr.length,[NSString stringWithFormat:@"%.0f",myComission].length)];
            
            NSUInteger endLength = [NSString stringWithFormat:@"%.0f",myComission].length;
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
             
                                  range:NSMakeRange(myComissionStr.length,endLength)];
            
            _mineRankingView.currentMonthInfoLabel.attributedText = AttributedStr;

            string = [NSString stringWithFormat:@"%@%.0f",typeAllPerformaceStr,allPerformace];
            
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:11]
                                  range:NSMakeRange(typeAllPerformaceStr.length,[NSString stringWithFormat:@"%.0f",allPerformace].length)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f]
                                  range:NSMakeRange(typeAllPerformaceStr.length,[NSString stringWithFormat:@"%.0f",allPerformace].length)];
            
            _mineRankingView.allIncomLabel.attributedText = AttributedStr;
        }
            break;
        default:
            break;
    }
    
}

- (void)reloadInfo{
    __weak typeof(self) weakSelf = self;
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self createNoNetWorkViewWithReloadBlock:^{
            [weakSelf reloadInfo];
        }];
    }else{
        [self signRankingArray];
    }
}

-(NSString*) getTheCorrectNum:(NSString*)tempString

{
    
    while ([tempString hasPrefix:@"0"])
        
    {
        
        tempString = [tempString substringFromIndex:1];

    }
    
    return tempString;
    
}

@end
