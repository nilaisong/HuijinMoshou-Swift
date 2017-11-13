//
//  XTOperationListController.m
//  MoShou2
//
//  Created by xiaotei's on 16/9/30.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTOperationListController.h"
#import "XTOperationModelItem.h"
#import "DataFactory+Main.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "XTWebNavigationControler.h"
#import "XTListOperationCell.h"

@interface XTOperationListController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,weak)UITableView* tableView;
/**
 *  XTInformationItemModel
 */
@property (nonatomic,strong)NSArray* dataArray;

@property (nonatomic,assign)NSInteger pageNo;
@end

@implementation XTOperationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
    
    self.pageNo = 1;
    
    if (_navTitle.length > 0 && _navTitle != nil) {
        self.navigationBar.titleLabel.text = _navTitle;
    }
    
    [self requestData];
}

- (void)requestData{
    if (_requestType.length <= 0 || _requestType == nil) {
        return;
    }
    UIImageView* imgV = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getMoreRecdWithType:_requestType pageNo:_pageNo pageSize:20 callBack:^(NSArray *result, BOOL morePage) {
        [self removeRotationAnimationView:imgV];
        if (_pageNo == 1) {
            self.dataArray  = result;
            [_tableView.legendHeader endRefreshing];
        }else{
            self.dataArray = [_dataArray arrayByAddingObjectsFromArray:result];
            [_tableView.legendFooter endRefreshing];
        }
        _tableView.legendFooter.hidden = !morePage;
    } faildCallBack:^(ActionResult *result) {
        if (result.message.length > 0) {
            [self showTips:result.message];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (!_tableView) {
        __weak typeof(self) weakSelf = self;
        UITableView* tabV = [[UITableView alloc]initWithFrame:self.view.bounds];
        [tabV addLegendHeaderWithRefreshingBlock:^{
            weakSelf.pageNo = 1;
            [weakSelf requestData];
        }];
        tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tabV addLegendFooterWithRefreshingBlock:^{
            weakSelf.pageNo++;
            [weakSelf requestData];
        }];
        [tabV setFooterViewHidden:YES];
        [tabV registerClass:[XTListOperationCell class] forCellReuseIdentifier:NSStringFromClass([XTListOperationCell class])];
        tabV.delegate = self;
        tabV.dataSource = self;
        _tableView = tabV;
        [self.view addSubview:tabV];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* className = NSStringFromClass([XTListOperationCell class]);
    XTListOperationCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[XTListOperationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
        
    }
    if (_dataArray.count > indexPath.row) {
        XTOperationModelItem* model = _dataArray[indexPath.row];
//        cell.textLabel.text = model.title;
        cell.titleStr = model.title;
        if (model) {
            cell.itemModel = model;    
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineState = 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f * SCALE6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > indexPath.row) {
        XTWebNavigationControler* webVC = [[XTWebNavigationControler alloc]init];
        webVC.showTitleAndMore = YES;
        webVC.isSecondLoad = YES;
        webVC.titleString = @"相关推荐";
        
        XTOperationModelItem* itemModel = _dataArray[indexPath.row];
        itemModel.type = _requestType;
        webVC.itemModel = itemModel;
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end
