//
//  RecommendationRecordListView.m
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "RecommendationRecordListView.h"
#import "RecommendationRecordTableView.h"

#import "RecommendRecordOptionModel.h"
#import "DataFactory+Main.h"
#import "CustomerReportedRecord.h"

#import "DownloadStatus.h"

//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"

@interface RecommendationRecordListView()<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray* threeTableView;

@property (nonatomic,strong)NSArray* optionsArray;

@property (nonatomic,strong)NSArray* downloadQueue;

//@property (nonatomic,strong)MJRefreshFooter* refreshFooter;

@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation RecommendationRecordListView

- (instancetype)initWithEventCallBack:(RecommendationRecordListViewEventCallBack)callBack{
    if (self = [super init]) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
        _callBack = callBack;
//        _isRefresh = YES;
        _currentIndex = 999;
    }
    return self;
}

+ (instancetype)recommendRecordListViewWithEventCallBack:(RecommendationRecordListViewEventCallBack)callBack{
    return [[self alloc]initWithEventCallBack:callBack];
}

-(void)reloadView{
    self.contentSize = CGSizeMake(self.optionsArray.count * self.frame.size.width, 0);
    for (int i = 0;i < 3;i++) {
        RecommendationRecordTableView* listTableView = self.threeTableView[i];
        NSInteger trueIndex = _currentIndex;
        if (i == 0) {
            trueIndex = _currentIndex - 1;
        }else if(i == 1){
            trueIndex = _currentIndex;
        }else if(i == 2){
            trueIndex = _currentIndex + 1;
        }
        listTableView.frame = CGRectMake(trueIndex * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
//        listTableView.optionModel = _optionsArray[trueIndex];
//                [listTableView reloadData];
    }

}


- (NSArray *)optionsArray{
    if (!_optionsArray || _optionsArray.count <= 0) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            NSMutableArray* array = [NSMutableArray array];
            [arrayM appendObject:array];
        }
        _optionsArray = arrayM;
    }
    return _optionsArray;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger index = self.contentOffset.x / self.frame.size.width;
//    NSLog(@"%ld",index);
    if (_currentIndex == index) return;
    [self directionWithNewIndex:index];

    
    self.currentIndex = index;
    
//    _listTableView.optionTitle = _optionsArray[index];
    if (_callBack) {
        _callBack(RecommendationRecordListViewEventSwitchListView,index,nil,0);
    }


}


-(void)layoutSubviews{
//    [super layoutSubviews];
    
    [self reloadView];
}

#pragma mark - setter
- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    __weak typeof(self) weakSelf = self;
    [self startRequestAnimation];
    __block NSInteger safeIndex = _currentIndex;
    [[DataFactory sharedDataFactory]getReportRecordListWithGroudId:_currentIndex  keyWord:keyword page:1 callBack:^(XTReportedRecordListModel *result) {
        [weakSelf stopRequestAnimation];
         RecommendationRecordTableView* listTableView = weakSelf.threeTableView[1];

    DownloadStatus* status = weakSelf.downloadQueue[_currentIndex];
    status.hasNextPage = result.morePage;
    NSMutableArray* arrayM = weakSelf.optionsArray[_currentIndex];
    [arrayM removeAllObjects];
        if (!result){
            listTableView.customerModelArray = arrayM;
            return ;
        }
        if (result.customerList.count > 0) {
            [arrayM addObjectsFromArray:result.customerList];
        }
    
        if (safeIndex == weakSelf.currentIndex) {

            listTableView.customerModelArray = arrayM;
        }


    listTableView.legendFooter.hidden = !result.morePage;
    }];
    
    if (_callBack) {
        _callBack(RecommendationRecordListViewEventSwitchListView,_currentIndex,nil,0);
    }
}

#pragma mark - getter

-(NSArray *)threeTableView{
    if (!_threeTableView) {
        __weak typeof(self) weakSelf = self;
        __block RecommendationRecordTableView* listView2 = [[RecommendationRecordTableView alloc]initWithTableViewStyle:UITableViewStylePlain eventCallBack:^(XTCustomerRecordCell *cell, BOOL touchQRBtn) {
            if (weakSelf.callBack) {
                weakSelf.callBack(RecommendationRecordListViewEventSelectCell,0,cell,touchQRBtn);
            }
        }];
        [self addSubview:listView2];
        
        RecommendationRecordTableView* listView1 = nil;
        listView1 = [[RecommendationRecordTableView alloc]initWithTableViewStyle:UITableViewStylePlain eventCallBack:^(XTCustomerRecordCell *cell, BOOL touchQRBtn) {
            if (weakSelf.callBack) {
                weakSelf.callBack(RecommendationRecordListViewEventSelectCell,0,cell,touchQRBtn);
            }
        }];
        [self addSubview:listView1];
        if (weakSelf.optionsArray.count >= (weakSelf.currentIndex > 0?weakSelf.currentIndex - 1:0)) {
//        listView1.optionModel = _optionsArray[_currentIndex > 0?_currentIndex - 1:0];
//            [[DataFactory sharedDataFactory]getReportRecordListWithGroudId:(_currentIndex > 0?_currentIndex - 1:0) keyWord:nil page:1 callBack:^(XTReportedRecordListModel *result) {
//                listView1.customerModelArray = result.cust    omerList;
//            }];
        }
        
        RecommendationRecordTableView* listView3 = [[RecommendationRecordTableView alloc]initWithTableViewStyle:UITableViewStylePlain eventCallBack:^(XTCustomerRecordCell *cell, BOOL touchQRBtn) {
            if (weakSelf.callBack) {
                weakSelf.callBack(RecommendationRecordListViewEventSelectCell,0,cell,touchQRBtn);
            }
        }];
        [self addSubview:listView3];
        if (weakSelf.optionsArray.count >= (weakSelf.optionsArray.count-1 > weakSelf.currentIndex?_currentIndex+1:0)) {
        }
        listView3.separatorStyle = UITableViewCellSeparatorStyleNone;
        listView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        listView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _threeTableView = @[listView1,listView2,listView3];
    
        [listView2 addLegendFooterWithRefreshingBlock:^{

            DownloadStatus* status = weakSelf.downloadQueue[weakSelf.currentIndex];
             RecommendationRecordTableView* listTableView = weakSelf.threeTableView[1];
            if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
                [listTableView.legendFooter endRefreshing];
                return ;
            }
            if (status.hasNextPage) {
//                [weakSelf.refreshFooter resetNoMoreData];
//                [weakSelf startRequestAnimation];
                [[DataFactory sharedDataFactory]getReportRecordListWithGroudId:weakSelf.currentIndex keyWord:_keyword page:++status.currentPage callBack:^(XTReportedRecordListModel *result) {
                    [listTableView.legendFooter endRefreshing];
                    //                    [weakSelf stopRequestAnimation];
                    if (!result)return ;
                    DownloadStatus* status = weakSelf.downloadQueue[weakSelf.currentIndex];
                    status.hasNextPage = result.morePage;
                    NSMutableArray* arrayM = weakSelf.optionsArray[weakSelf.currentIndex];
                    if (result.customerList.count > 0) {
                        [arrayM addObjectsFromArray:result.customerList];
                    }
                   
                    
                    if (arrayM.count > 0) {
                        listTableView.customerModelArray = arrayM;
                    }

                    listTableView.legendFooter.hidden = !result.morePage;
                }];
            }
            if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                status.hasNextPage = NO;
            }else{
                status.hasNextPage = YES;
                status.currentPage = 0;
                [listTableView.legendFooter endRefreshing];
                listTableView.legendFooter.hidden = YES;
                if (weakSelf.callBack) {
                    weakSelf.callBack(RecommendationRecordListViewEventNoNetWorkConnection,0,nil,0);
                }
                return ;
            }

        }];
        
        __block NSInteger safeIndex = _currentIndex;
//        
        [listView2 addLegendHeaderWithRefreshingBlock:^{
//            _keyword = nil;
            safeIndex = weakSelf.currentIndex;
            RecommendationRecordTableView* listTableView = weakSelf.threeTableView[1];
            if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
                [listTableView.legendHeader endRefreshing];
                return ;
            }
            DownloadStatus* status = weakSelf.downloadQueue[safeIndex];
            if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                status.hasNextPage = NO;
            }else{
                status.hasNextPage = YES;
                [listTableView.legendHeader endRefreshing];
                listTableView.legendFooter.hidden = YES;
                if (weakSelf.callBack) {
                    weakSelf.callBack(RecommendationRecordListViewEventNoNetWorkConnection,0,nil,0);
                }
                return ;
            }
            status.currentPage = 0;
//            [weakSelf startRequestAnimation];
            [[DataFactory sharedDataFactory]getReportRecordListWithGroudId:weakSelf.currentIndex keyWord:_keyword page:++status.currentPage callBack:^(XTReportedRecordListModel *result) {
                [listTableView.legendHeader endRefreshing];
//                [weakSelf stopRequestAnimation];
                if(safeIndex != weakSelf.currentIndex)return ;
                
                status.hasNextPage = result.morePage;
                NSMutableArray* arrayM = weakSelf.optionsArray[safeIndex];
                if (result.morePage) {
                    listTableView.legendHeader.hidden = NO;
                }
                [arrayM removeAllObjects];
                if (result.customerList.count > 0) {
                    [arrayM addObjectsFromArray:result.customerList];
                }
                
                    listTableView.customerModelArray = arrayM;
                
                listTableView.legendFooter.hidden = !result.morePage;
                
                safeIndex = weakSelf.currentIndex;
            }];

            
            if (weakSelf.callBack) {
                weakSelf.callBack(RecommendationRecordListViewEventSwitchListView,weakSelf.currentIndex,nil,0);
            }
        }];
    
    }
    
    return _threeTableView;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    NSAssert(currentIndex >= 0 && currentIndex < 1000, @"索引值不合法");
    if (_currentIndex == currentIndex) return;
    self.contentOffset = CGPointMake(currentIndex * self.frame.size.width, 0);
    _currentIndex = currentIndex;
    
    if (self.threeTableView.count > 0) {
        for (int i = 0; i < 3; i++) {
            RecommendationRecordTableView* listTableView = self.threeTableView[i];
            NSInteger trueIndex = _currentIndex;
            if (i == 0) {
                trueIndex = (_currentIndex - 1) >= 0?(_currentIndex - 1):0;
            }else if(i == 1){
                trueIndex = _currentIndex;
            }else if(i == 2){
                trueIndex = (_currentIndex + 1) <= _optionsArray.count - 1?(_currentIndex + 1):_currentIndex;
            }
            NSMutableArray* arrayM = self.optionsArray[trueIndex];
            if (i == 1 && _callBack) {
                [arrayM removeAllObjects];
                [self startRequestAnimation];
            }
            listTableView.customerModelArray = nil;
            if (i == 1)
            {
                __weak typeof(self) weakSelf = self;
//                if (i == 1) {
//                    [weakSelf startRequestAnimation];
//                }
                DownloadStatus* status = self.downloadQueue[trueIndex];
                status.hasNextPage = YES;
                status.currentPage = 0;
                if (status.hasNextPage && [NetworkSingleton sharedNetWork].isNetworkConnection) {
                    [[DataFactory sharedDataFactory] getReportRecordListWithGroudId:trueIndex keyWord:_keyword page:++status.currentPage callBack:^(XTReportedRecordListModel *result) {
                        weakSelf.isRefresh = NO;
                        [weakSelf stopRequestAnimation];
                        
                        RecommendationRecordTableView* listTableView1  = weakSelf.threeTableView[1];
                        if (!result){
                            [arrayM removeAllObjects];
                            listTableView1.customerModelArray = arrayM;
                            return ;
                        }
                        
                        DownloadStatus* status = weakSelf.downloadQueue[trueIndex];
                        status.hasNextPage = result.morePage;
                        NSMutableArray* arrayM = weakSelf.optionsArray[trueIndex];
                        if (result.customerList.count > 0) {
//                            arrayM = [NSMutableArray arrayWithArray:result.customerList];
                            [arrayM removeAllObjects];
                            [arrayM addObjectsFromArray:result.customerList];
                        }
//                        if (arrayM.count > 0) {
                            listTableView.customerModelArray = arrayM;
//                        }
                        if (trueIndex == 0 && weakSelf.currentIndex == 0) {
                            
                            listTableView1.customerModelArray = arrayM;
                            listTableView1.legendFooter.hidden = !result.morePage;
                        }
                        if (result.morePage) {
                            listTableView.legendFooter.hidden = NO;
                        }
                    }];
                }
                if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                    status.hasNextPage = NO;
                }else{
                    status.hasNextPage = YES;
                    status.currentPage = 0;
                    listTableView.legendFooter.hidden = YES;                    
                    if (weakSelf.callBack) {
                        weakSelf.callBack(RecommendationRecordListViewEventNoNetWorkConnection,0,nil,0);
                    }
                }
            }
        }
    }
    RecommendationRecordTableView* listTableView = self.threeTableView[1];
    DownloadStatus* status = self.downloadQueue[_currentIndex];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        listTableView.legendFooter.hidden = !status.hasNextPage;
    }else listTableView.legendFooter.hidden = YES;
    [listTableView.legendFooter endRefreshing];
    [listTableView.legendHeader endRefreshing];
    [self setNeedsLayout];
    

}

//动画方向，根据新的index
-(void)directionWithNewIndex:(NSInteger)newIndex{
    TableViewAnimationDirection direction = TableViewAnimationDirectionNone;
    if (newIndex > _currentIndex) {
        direction = TableViewAnimationDirectionLeft;
    }else if(newIndex < _currentIndex){
        direction = TableViewAnimationDirectionRight;
    }
}

- (void)dealloc{
    for (UIView* view in _threeTableView) {
        [view removeFromSuperview];
    }
    _threeTableView = nil;
}

- (NSArray*)requestDataWithIndex:(NSInteger)index{
//    __weak typeof(self) weakSelf = self;
    NSMutableArray* arrayM = _optionsArray[index];
    if (arrayM.count > 0) {
//        self.currentIndex  = _currentIndex;
        return arrayM;
    }else{

    }
    return nil;
}

- (NSArray *)downloadQueue{
    if (!_downloadQueue) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            DownloadStatus* status = [[DownloadStatus alloc]init];
            status.hasNextPage = YES;
            status.currentPage = 0;
            [arrayM appendObject:status];
        }
        _downloadQueue = arrayM;
    }
    return _downloadQueue;
}

- (void)didMoveToSuperview:(UIView *)newSuperview{
    self.currentIndex = _currentIndex;
}

//- (void)requestMorePageDataAction:(MJRefreshFooter*)footer{
//    __weak typeof(self) weakSelf = self;
////    [self startRequestAnimation];
//    DownloadStatus* status = _downloadQueue[_currentIndex];
//    if (status.hasNextPage && [NetworkSingleton sharedNetWork].isNetworkConnection) {
//        [_refreshFooter resetNoMoreData];
//            [[DataFactory sharedDataFactory]getReportRecordListWithGroudId:_currentIndex keyWord:nil page:++status.currentPage callBack:^(XTReportedRecordListModel *result) {
//                
////                [weakSelf stopRequestAnimation];
//                if (!result)return ;
//            DownloadStatus* status = weakSelf.downloadQueue[weakSelf.currentIndex];
//            status.hasNextPage = result.morePage;
//            NSMutableArray* arrayM = weakSelf.optionsArray[weakSelf.currentIndex];
//            if (result.customerList.count > 0) {
//                [arrayM addObjectsFromArray:result.customerList];
//            }
//            RecommendationRecordTableView* listTableView = weakSelf.threeTableView[1];
//            
//            if (arrayM.count > 0) {
//                listTableView.customerModelArray = arrayM;
//            }
//            [weakSelf.refreshFooter endRefreshing];
//            weakSelf.refreshFooter.hidden = !result.morePage;
//        }];
//    }
//    [footer endRefreshing];
//    status.hasNextPage = NO;
//}

- (void)refreshData{
    __weak typeof(self) weakSelf = self;
    __block  NSInteger safeIndex = _currentIndex;
    RecommendationRecordTableView* listTableView = weakSelf.threeTableView[1];
    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
        [listTableView.legendHeader endRefreshing];
        return ;
    }
    DownloadStatus* status = weakSelf.downloadQueue[safeIndex];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        status.hasNextPage = NO;
    }else{
        status.hasNextPage = YES;
        [listTableView.legendHeader endRefreshing];
        listTableView.legendFooter.hidden = YES;
        if (weakSelf.callBack) {
            weakSelf.callBack(RecommendationRecordListViewEventNoNetWorkConnection,0,nil,0);
        }
        return ;
    }
    status.currentPage = 0;
    [weakSelf startRequestAnimation];
    [[DataFactory sharedDataFactory]getReportRecordListWithGroudId:weakSelf.currentIndex keyWord:_keyword page:++status.currentPage callBack:^(XTReportedRecordListModel *result) {
        [listTableView.legendHeader endRefreshing];
//        [weakSelf stopRequestAnimation];
        if(safeIndex != weakSelf.currentIndex)return ;
        
        status.hasNextPage = result.morePage;
        NSMutableArray* arrayM = weakSelf.optionsArray[safeIndex];
        if (result.morePage) {
            listTableView.legendHeader.hidden = NO;
        }
        [arrayM removeAllObjects];
        if (result.customerList.count > 0) {
            [arrayM addObjectsFromArray:result.customerList];
        }
        if (arrayM.count > 0) {
            listTableView.customerModelArray = arrayM;
        }
        listTableView.legendFooter.hidden = !result.morePage;
        
        safeIndex = weakSelf.currentIndex;
    }];

}

- (void)didMoveToSuperview{
    _isRefresh = NO;
}

- (void)startRequestAnimation{
    if (_callBack && !_isRefresh) {
        _callBack(RecommendationRecordListViewEventRequestStart,0,nil,nil);
//        _isRefresh = YES;
    }
//    _isRefresh = !_isRefresh;
}

- (void)stopRequestAnimation{
    
    if (_callBack && !_isRefresh) {
        _callBack(RecommendationRecordListViewEventRequestEnd,0,nil,nil);
    }
}




@end
