//
//  XTAppointmentRecordView.m
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTAppointmentRecordView.h"
#import "CarRecordListModel.h"
#import "XTAppointmentRecordCell.h"
#import "NetworkSingleton.h"
#import "DataFactory+Main.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"

@interface XTAppointmentRecordView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray* dataArray;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,weak)UITableView* tableView;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)BOOL noResult;

@property (nonatomic,copy)XTAppointmentRecordViewCallBack callBack;
@end


@implementation XTAppointmentRecordView

- (instancetype)initWithCallBack:(XTAppointmentRecordViewCallBack)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAppointmentRecordView) name:@"refreshAppointmentRecordView" object:nil];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshAppointmentRecordView" object:nil];
}

- (void)refreshAppointmentRecordView
{
    _currentPage = 1;
//    if (_callBack) {
//        _callBack(self,XTAppointmentRecordViewEventBegainAnimation,nil);
//    }
    [self requestData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView* table = [[UITableView alloc]init];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        [table registerClass:[XTAppointmentRecordCell class] forCellReuseIdentifier:NSStringFromClass([XTAppointmentRecordCell class])];
        _tableView =table;
        
        __weak typeof(self) weakSelf = self;
        [table addLegendHeaderWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf requestData];
        }];
        
        [table addLegendFooterWithRefreshingBlock:^{
            weakSelf.currentPage++;
            [weakSelf requestData];
        }];
        
        [table.legendFooter setHidden:YES];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* noResultCellKey = @"noResultCellKey";
    if (_noResult) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:noResultCellKey];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noResultCellKey];
            UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-wenjian"]];
            imgView.frame = CGRectMake(0, 0, 98, 111);
            imgView.center = CGPointMake(self.frame.size.width / 2.0f, (kMainScreenHeight - 49 * SCALE6 - 64 - 44 - 150) / 2.0 + 30 * SCALE6 + 14);
            [cell.contentView addSubview:imgView];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 21, kMainScreenWidth, 12)];
            label.text = @"列表为空,想了解更多?";
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 1;
            label.textColor = [UIColor colorWithRed:0.69f green:0.69f blue:0.70f alpha:1.00f];
            UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 2, kMainScreenWidth, 12)];
            label2.font = [UIFont systemFontOfSize:12];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.numberOfLines = 1;
            label2.textColor = [UIColor colorWithRed:0.69f green:0.69f blue:0.70f alpha:1.00f];
            label2.text = @"请点击下方的专车详情。";
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:label2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    NSString* className = NSStringFromClass([XTAppointmentRecordCell class]);
    XTAppointmentRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[XTAppointmentRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
//    cell.textLabel.text = _dataArray[indexPath.row];
    if (_dataArray.count > indexPath.row) {
        cell.model = _dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_callBack && _dataArray.count > indexPath.row) {
        _callBack(self,XTAppointmentRecordViewEventSelected,_dataArray[indexPath.row]);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noResult) {
        return self.frame.size.height;
    }
    return 40 * SCALE6 + 31.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray && _dataArray.count > 0) {
        return _dataArray.count;
    }else if(_noResult){
        return 1;
    }else return 0;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_callBack) {
        _callBack(self,XTAppointmentRecordViewEventScroll,nil);
    }
}

- (void)requestData{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert && !_isRefresh) {
        [[DataFactory sharedDataFactory] getTrystCarReportedRecordListWith:_keyword page:_currentPage size:20 callBack:^(DataListResult *result) {
            if (_callBack) {
                _callBack(self,XTAppointmentRecordViewEventEndAnimation,nil);
            }
            [_tableView.legendFooter setHidden:!result.morePage];
            if (_currentPage == 1) {
                self.dataArray = result.dataArray;
            }else{
                if (_dataArray == nil) {
                    _dataArray = @[];
                }
                self.dataArray = [_dataArray arrayByAddingObjectsFromArray:result.dataArray];
            }
            [self.tableView.legendFooter endRefreshing];
            [self.tableView.legendHeader endRefreshing];
            if (_callBack) {
                _callBack(self,XTAppointmentRecordViewEventEndAnimation,nil);
            }
            _isRefresh   = NO;
        } failedCallBack:^(ActionResult *result) {
            self.dataArray = @[];
            _isRefresh = NO;
            if (result.message.length <= 0 || result.message == nil) {
                result.message = @"数据请求失败";
            }
            [TipsView showTips:result.message inView:self.superview];
            [self.tableView.legendFooter endRefreshing];
            [self.tableView.legendHeader endRefreshing];
        }];
        _isRefresh = YES;
    }else{
        [self.tableView.legendFooter endRefreshing];
        [self.tableView.legendHeader endRefreshing];
    }
}

- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    _currentPage = 1;
    if (_callBack) {
        _callBack(self,XTAppointmentRecordViewEventBegainAnimation,nil);
    }
    [self requestData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (dataArray == nil || dataArray.count <= 0 ) {
        _noResult = YES;
    }else if(dataArray.count > 0) _noResult = NO;
    [self.tableView reloadData];
}

@end
