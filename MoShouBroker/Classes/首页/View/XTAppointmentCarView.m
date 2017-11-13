//
//  XTAppointmentCarView.m
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTAppointmentCarView.h"
#import "CarReportedRecordModel.h"
#import "XTAppointmentCarCell.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "DataFactory+Main.h"
#import "NetworkSingleton.h"
#import "TipsView.h"

@interface XTAppointmentCarView()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _firstAppear;
}

@property (nonatomic,weak)UILabel* tipsLabel;
@property (nonatomic,strong)NSArray* dataArray;
@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,weak)UITableView* tableView;

@property (nonatomic,assign)BOOL isRefresh;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UIView* lineView1;

@property (nonatomic,assign)BOOL noResult;

@property (nonatomic,copy)XTAppointmentCarViewCallBack callBack;


@end

@implementation XTAppointmentCarView

- (instancetype)initWithCallBack:(XTAppointmentCarViewCallBack)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
        _firstAppear = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAppointmentCarView) name:@"refreshAppointmentCarView" object:nil];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    _isRefresh = NO;
    self.backgroundColor = [UIColor whiteColor];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshAppointmentCarView" object:nil];
}

- (void)refreshAppointmentCarView
{
    _currentPage = 1;
    
    [self requestData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 0.5);
    self.tipsLabel.frame = CGRectMake(16, 10 * SCALE6, kMainScreenWidth - 20, 14);
    self.lineView1.frame = CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame) + 10 * SCALE6 - 0.5, kMainScreenWidth, 0.5);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame) + 10 * SCALE6, self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_tipsLabel.frame) - 10 * SCALE6);
    
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 8 *  SCALE6, kMainScreenWidth - 20, 14)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"777777"];
        label.text = @"确客有效客户";
        [self addSubview:label];
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"d9d9db"];
        [self addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

- (UIView *)lineView1{
    if (!_lineView1) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"d9d9db"];
        [self addSubview:view];
        _lineView1 = view;
    }
    return _lineView1;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView* table = [[UITableView alloc]init];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        _tableView =table;
        [table registerClass:[XTAppointmentCarCell class] forCellReuseIdentifier:NSStringFromClass([XTAppointmentCarCell class])];
        
        
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
    CarReportedRecordModel* model = nil;
    if (_dataArray.count > indexPath.row) {
        model = _dataArray[indexPath.row];
    }
    
    static NSString* noResultCellKey = @"noResultCellKey";
    if (_noResult) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:noResultCellKey];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noResultCellKey];
            UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-wenjian"]];
            imgView.frame = CGRectMake(0, 0, 98, 111);
            imgView.center = CGPointMake(self.frame.size.width / 2.0f, (kMainScreenHeight - 49 * SCALE6 - 64 - 44 - 150) / 2.0);
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

    
    __weak typeof(self) weakSelf = self;
    XTAppointmentCarCell* cell = [XTAppointmentCarCell appointmentCarCellWith:tableView model:model callBack:^(XTAppointmentCarCell *cell, XTAppointmentCarCellEvent event, CarReportedRecordModel *model) {
        switch (event) {
            case XTAppointmentCarCellAction:{
                if (weakSelf.callBack) {
                    weakSelf.callBack(self,XTAppointmentCarViewEventTrystCar,model);
                }
            }
                break;
            case XTAppointmentCarCellTap:{
                if (weakSelf.callBack) {
                    weakSelf.callBack(self,XTAppointmentCarViewEventSelected,model);
                }
            }
                break;
                
            default:
                break;
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noResult) {
        return self.frame.size.height - 14 - 20 * SCALE6;
    }
    return 40 * SCALE6 + 31.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
        _callBack(self,XTAppointmentCarViewEventScroll,nil);
    }
}

- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    _currentPage = 1;
    if (_callBack) {
        _callBack(self,XTAppointmentCarViewBegainAnimation,nil);
    }
    [self requestData];
}

- (void)requestData{
    
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert && !_isRefresh) {
//        if (_firstAppear && _callBack) {
//            _callBack(self,XTAppointmentCarViewBegainAnimation,nil);
//        }
        [[DataFactory sharedDataFactory] getAppointmentCarListWith:_keyword page:_currentPage size:20 callBack:^(DataListResult *result) {
            if (_callBack) {
                _callBack(self,XTAppointmentCarViewEndAnimation,nil);
            }
            if (_firstAppear && _callBack) {
                _firstAppear = NO;
            }
            [self.tableView.legendFooter setHidden:!result.morePage];
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
            self.isRefresh = NO;
        } failedCallBack:^(ActionResult *result) {
            self.dataArray = @[];
            self.isRefresh = NO;
            if (result.message.length <= 0 || result.message == nil) {
                result.message = @"数据请求失败";
            }
            [TipsView showTips:result.message inView:self.superview];
            [self.tableView.legendFooter endRefreshing];
            [self.tableView.legendHeader endRefreshing];
        }];
        _isRefresh = YES;
//        _firstAppear = NO;
    }else{
        [self.tableView.legendFooter endRefreshing];
        [self.tableView.legendHeader endRefreshing];
    }
    
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (dataArray == nil || dataArray.count <= 0) {
        _noResult = YES;
    }else if(dataArray.count > 0) _noResult = NO;
    [self.tableView reloadData];
}

@end
