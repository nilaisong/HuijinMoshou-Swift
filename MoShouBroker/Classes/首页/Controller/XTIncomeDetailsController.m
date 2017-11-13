//
//  XTIncomeDetailsController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTIncomeDetailsController.h"
#import "XTIncomeDetailsCell.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "NetWork.h"
#import "ActionResult.h"
#import "XTIncomeModel.h"
#import "DataFactory+Main.h"
#import "NSString+Extension.h"

@interface XTIncomeDetailsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView* tableView;

//已显示所有数据
@property (nonatomic,weak)UILabel* resultEndLabel;

@property (nonatomic,assign)NSUInteger currentPage;

@property (nonatomic,assign)BOOL morePage;

@property (nonatomic,strong)NSMutableArray* modelsArray;

@property (nonatomic,weak)UIView* noDataTipsView;

@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation XTIncomeDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 0;
    // Do any additional setup after loading the view.
    
    [self commonInit];
    _morePage = YES;
    _isRefresh = NO;
    [self requestMoreData];
}

- (void)commonInit{
    self.navigationBar.titleLabel.text = @"业绩明细（元）";
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
//    self.resultEndLabel.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UILabel *)resultEndLabel{
    if (!_resultEndLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"已显示所有数据";
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        label.frame = CGRectMake(0, kMainScreenHeight - statusHeight + 4, kMainScreenWidth, 12);
        _resultEndLabel = label;
        label.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f];
        [self.view addSubview:label];
        label.hidden = YES;

    }
    return _resultEndLabel;
}

- (NSMutableArray *)modelsArray{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        tableView.delegate =self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        _tableView = tableView;
        __weak typeof(self) weakSelf = self;
        [_tableView addLegendFooterWithRefreshingBlock:^{
            if (weakSelf.morePage) {
                [weakSelf requestMoreData];
            }
        }];
        
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
        _tableView.legendFooter.hidden = YES;
        [_tableView.legendFooter endRefreshing];
    }
    return _tableView;
}

//- (UILabel *)resultEndLabel{
//    if (!_resultEndLabel) {
//        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 27, self.view.frame.size.width, 12)];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"已显示所有数据";
//        [self.view addSubview:label];
//        _resultEndLabel = label;
//    }
//    return _resultEndLabel;
//}

#pragma mark - delegate - datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XTIncomeDetailsCell* cell = [XTIncomeDetailsCell incomeDetailsCellWithTableView:tableView];
    if (_modelsArray.count > indexPath.row) {
        cell.incomeModel = _modelsArray[indexPath.row];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (void)requestMoreData{
    if (_isRefresh)return;
    _currentPage++;
    __weak typeof(self) weakSelf = self;
    if (_morePage) {

    [[DataFactory sharedDataFactory]getCommissionListWithPage:[NSString stringWithFormat:@"%zi",_currentPage] WithCallBack:^(DataListResult *result) {
        weakSelf.isRefresh = NO;
        [weakSelf.tableView.legendFooter endRefreshing];
        [weakSelf.modelsArray addObjectsFromArray:result.dataArray];
        [weakSelf.tableView reloadData];
        
        weakSelf.morePage = result.morePage;
        if (weakSelf.modelsArray.count <= 0) {
            weakSelf.noDataTipsView.hidden = NO;
        }else weakSelf.noDataTipsView.hidden = YES;
        weakSelf.tableView.legendFooter.hidden = !result.morePage;
        weakSelf.resultEndLabel.hidden = result.morePage || !(weakSelf.modelsArray.count > 0);
        if (!result.morePage) {
            weakSelf.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 16);
        }else weakSelf.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }];
    }else{
//        [weakSelf.tableView.footer noticeNoMoreData];
    }
    _isRefresh = YES;
}

- (void)refreshData{
    if (_isRefresh)return;
    _currentPage = 1;
    _morePage = YES;
    __weak typeof(self) weakSelf = self;
    [weakSelf.modelsArray removeAllObjects];
    [[DataFactory sharedDataFactory]getCommissionListWithPage:@"1" WithCallBack:^(DataListResult *result) {
        weakSelf.isRefresh = NO;
        [weakSelf.modelsArray addObjectsFromArray:result.dataArray];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.legendHeader endRefreshing];
        weakSelf.tableView.legendFooter.hidden = !result.morePage;
        weakSelf.resultEndLabel.hidden = result.morePage;
    }];
    _isRefresh = YES;
}

- (UIView *)noDataTipsView{
    if (!_noDataTipsView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton* requestMoneyBtn = [[UIButton alloc]init];
        [requestMoneyBtn addTarget:self action:@selector(requestMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [requestMoneyBtn setTitle:@"去报备客户赚钱吧!" forState:UIControlStateNormal];
        requestMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [requestMoneyBtn setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [self.view addSubview:view];
        UILabel* label = [[UILabel alloc]init];
        label.text = @"没有数据,";
        label.font = [UIFont systemFontOfSize:14];
        NSString* titleString = @"没有数据,去报备客户赚钱吧!";
        CGSize size = [titleString sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat x = (self.view.frame.size.width - size.width) / 2.0;
        CGFloat y = (view.frame.size.height - size.height) / 2.0;
        label.frame = CGRectMake(x, y, 70, 14);
        requestMoneyBtn.frame = CGRectMake(CGRectGetMaxX(label.frame), label.frame.origin.y, 126, 14);
        UIView* blueLineView = [[UIView alloc]init];
        blueLineView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        blueLineView.frame = CGRectMake(requestMoneyBtn.frame.origin.x, requestMoneyBtn.frame.origin.y + 16, 126, 1);
        [view addSubview:blueLineView];
        [view addSubview:requestMoneyBtn];
        [view addSubview:label];
        _noDataTipsView = view;
        view.hidden = YES;
    }
    return _noDataTipsView;
}

//进入楼盘列表
- (void)requestMoneyBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SELECTEDBUILDINGPAGE" object:nil];
}

@end
