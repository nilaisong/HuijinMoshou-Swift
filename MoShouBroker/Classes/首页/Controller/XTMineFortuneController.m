//
//  XTMineFortuneController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/17.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTMineFortuneController.h"
#import "XTEarningsContentView.h"
#import "XTLineChartVIew.h"
#import "ChartPoint.h"
#import "NSString+Extension.h"
#import "XTIncomeDetailsController.h"
#import "DataFactory+Main.h"

#import "XTIncomeAllModel.h"
#import "XTMonthCommission.h"
#import "ChartPoint.h"

@interface XTMineFortuneController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)XTEarningsContentView* topView;

@property (nonatomic,strong)NSArray* chartPointsArray;

@property (nonatomic,weak)UILabel* tipsLabel;

@property (nonatomic,weak)XTLineChartVIew* lineChart;

@property (nonatomic,weak)UITableView* tableView;

@property (nonatomic,weak)UIView* promptContentView;

@property (nonatomic,strong)XTIncomeAllModel* incomeModel;

@property (nonatomic,strong)NSCalendar* calendar;

@end

@implementation XTMineFortuneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"我的业绩";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self commonInit];
    [self hasNetwork];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)commonInit{
    
    
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 210);
    _tableView.tableHeaderView = self.topView;
//    self.topView.frame=  CGRectMake(0, 64, self.view.frame.size.width, 210);
//    self.tipsLabel.frame = CGRectMake(16, CGRectGetMaxY(_topView.frame) + 22.5, self.view.frame.size.width - 32, 12);
    
    __weak typeof(self) weakSelf = self;
    
    [[DataFactory sharedDataFactory]getIncomeAllWithMonthSize:0 callBack:^(XTIncomeAllModel *result) {
//        result.allCommission *= 10000;
//        result.currentMonthCommission *= 10000;
        weakSelf.incomeModel = result;
        for (int i = 0; i < self.chartPointsArray.count; i++) {
            ChartPoint* point = _chartPointsArray[i];
            for (XTMonthCommission* monthCommission in result.allCommissionList) {

                if ([point.date isEqualToString:monthCommission.month]) {
//                    monthCommission.commission *= 10000;
                    point.maxTmp = monthCommission.commission;
                }
            }
        }

        if (result.allCommissionList.count <= 0) {
//            weakSelf.lineChart = nil;
        }else {
                weakSelf.lineChart.points = [NSMutableArray arrayWithArray:_chartPointsArray];
        }
    } failedCallBack:^(ActionResult *result) {
        if(result != nil){
            [weakSelf showTips:result.message];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter
- (void)setIncomeModel:(XTIncomeAllModel *)incomeModel{
    _incomeModel = incomeModel;
    self.topView.incomeModel = incomeModel;
}


#pragma mark - getter 
- (NSCalendar *)calendar{
    if (!_calendar) {
       _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}

- (UIView *)promptContentView{
    if (!_promptContentView) {
        UIView* contentView = [[UIView alloc]init];
        NSString* label1 = @"重要说明";
        CGSize label1Size = [label1 sizeWithfont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.view.frame.size.width - 32, MAXFLOAT)];
        NSString* content1 = @"钱包里的总资产为卖房佣金所得，实际金额请以最终财务结算为准。";
        CGSize content1Size = [content1 sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(self.view.frame.size.width - 32, MAXFLOAT)];
        NSString* label2 = @"如何赚佣金";
        CGSize label2Size = [label2 sizeWithfont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.view.frame.size.width - 32, MAXFLOAT)];
        NSString* content2 = @"报备的客源最终真实成交的，在合同签订之日会及时给经纪人一定的佣金作为回报";
        CGSize content2Size = [content2 sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(self.view.frame.size.width - 32, MAXFLOAT)];
        UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, label1Size.width, label1Size.height)];
        l1.font = [UIFont systemFontOfSize:15];
        l1.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        l1.text = label1;
        
        UILabel* c1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(l1.frame) + 12,content1Size.width , content1Size.height)];
        c1.font = [UIFont systemFontOfSize:14];
        c1.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        c1.text = content1;
        
        UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(c1.frame) + 20, label2Size.width, label2Size.height)];
        l2.text = label2;
        l2.font = [UIFont systemFontOfSize:15];
        l2.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        
        UILabel* c2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(l2.frame) + 12, content2Size.width, content2Size.height)];
        c2.font = [UIFont systemFontOfSize:14];
        c2.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        c2.text = content2;
        l1.lineBreakMode = NSLineBreakByCharWrapping;
        l1.numberOfLines = 0;
    
        l2.lineBreakMode = NSLineBreakByCharWrapping;
        l2.numberOfLines = 0;
        
        c1.lineBreakMode = NSLineBreakByCharWrapping;
        c1.numberOfLines = 0;
        
        c2.lineBreakMode = NSLineBreakByCharWrapping;
        c2.numberOfLines = 0;
        [contentView addSubview:l1];
        [contentView addSubview:c1];
        [contentView addSubview:l2];
        [contentView addSubview:c2];
        contentView.frame = CGRectMake(16,20, self.view.size.width - 32, CGRectGetMaxY(c2.frame));
        _promptContentView = contentView;
        [self.view addSubview:contentView];
        _promptContentView.hidden = YES;
    }
    return _promptContentView;
}

- (XTEarningsContentView *)topView{
    if (!_topView) {
        __weak typeof(self) weakSelf = self;
        XTEarningsContentView* earView = [XTEarningsContentView earningsContentViewWithEventCallBack:^(XTEarningsContentView *view, XTEarningsContentViewEventType type) {
            switch (type) {
                case XTEarningsContentViewEventTypeQuestion:
                    [weakSelf showTips:@"总资产是您的累计佣金"];
                    break;
                case XTEarningsContentViewEventTypeViewRecord:{
                    XTIncomeDetailsController* incomeVC = [[XTIncomeDetailsController alloc]init];
                    [weakSelf.navigationController pushViewController:incomeVC animated:YES];
                }  break;
                default:
                    break;
            }
        }];
        
        [self.view addSubview:earView];
        
        _topView = earView;
    }
    return _topView;
}


- (XTLineChartVIew *)lineChart{
    if (!_lineChart) {
        XTLineChartVIew* lineChart = [[XTLineChartVIew alloc]init];
        _lineChart = lineChart;
        lineChart.frame = CGRectMake(18 ,0, self.view.frame.size.width - 32,300 * kMainScreenWidth / 375.0);
        [lineChart addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:lineChart];
        lineChart.points = [NSMutableArray arrayWithArray:self.chartPointsArray];
        lineChart.contentOffset = CGPointMake(_chartPointsArray.count * 75 - lineChart.frame.size.width, 0);
    }
    return _lineChart;
}

-(NSArray *)chartPointsArray{
    if (_chartPointsArray == nil) {
        NSMutableArray* arrayM = [NSMutableArray array];
        
        NSDate* currentDate = [NSDate date];
        for (int i = 0; i < 4; i++) {
            ChartPoint* point = [[ChartPoint alloc]init];
            NSDateComponents *dateComponents = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[self addToDate:currentDate months:-(3 - i)]];
            NSString* dateStr = nil;
            if (dateComponents.month < 10) {
                dateStr = [NSString stringWithFormat:@"0%ld",dateComponents.month];
            }else dateStr = [NSString stringWithFormat:@"%ld",dateComponents.month];
            point.date = [NSString stringWithFormat:@"%ld-%@",(long)dateComponents.year,dateStr];
            point.maxTmp = 0;
            
            
            [arrayM appendObject:point];
        }
        
        _chartPointsArray = arrayM;
    }
    return _chartPointsArray;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"业绩收入趋势图(元)";
        label.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f];
        label.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:label];
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
//        [_lineChart setNeedsDisplay];
    }
}

- (void)dealloc{
    [_lineChart removeObserver:self forKeyPath:@"contentOffset" context:nil];
    _lineChart = nil;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView* tableVie = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableVie.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableVie.delegate = self;
        tableVie.dataSource = self;
        tableVie.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableVie];
        _tableView = tableVie;
    }
    return _tableView;
}

#pragma mark - tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"tipLabelCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tipLabelCell"];
            self.tipsLabel.frame = CGRectMake(16,22.5, self.view.frame.size.width - 32, 12);
            [cell.contentView addSubview:self.tipsLabel];
        }
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lineViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lineViewCell"];
//            self.topView.frame = CGRectMake(0, 0,  self.view.frame.size.width, 210);
            [cell.contentView addSubview:self.lineChart];
            UIView * lineView = [[UIView alloc]init];
            lineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
            lineView.frame = CGRectMake(17.0 ,0, 1, _lineChart.frame.size.height - BottomHeight + 1);
            [cell.contentView addSubview:lineView];
        }
    }else if(indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"tipsViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tipsViewCell"];
            [cell.contentView addSubview:self.promptContentView];

        }
       _promptContentView.hidden =  NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 54.5;
    }else if(indexPath.row == 1){
        return 300.0f * kMainScreenWidth / 375.0;
    }else if(indexPath.row == 2){
        return self.promptContentView.frame.size.height + 30;
    }
    return 50;
}

/**
 *  获取距离月份的时间
 */
- (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months
{
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    
    
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}


- (CGFloat)randomFloatWithMax:(NSInteger)max{
    max -= 100;
    return random()%max + 100;
}

- (void)hasNetwork{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [self commonInit];
    }else{
        [self createNoNetWorkViewWithReloadBlock:^{
            [self hasNetwork];
        }];
    }
}

@end
