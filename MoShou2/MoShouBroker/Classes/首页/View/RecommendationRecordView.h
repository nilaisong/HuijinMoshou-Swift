//
//  RecommendationRecordView.h
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//  报备记录主视图

#import <UIKit/UIKit.h>
#import "TopOptionsView.h"
#import "XTCustomerRecordCell.h"
#import "RecommendationRecordListView.h"
#import "DataFactory+Main.h"

@class RecommendationRecordView;

@protocol RecommendationRecordViewDelegate <NSObject>

//选中了某个cell
- (void)recommendRecordView:(RecommendationRecordView*)rrView didSelectedCell:(XTCustomerRecordCell*)customerCell;

//点击了某个cell的二维码按钮
- (void)recommendRecordView:(RecommendationRecordView *)rrView didTouchQRBtn:(XTCustomerRecordCell*)customerCell;

- (void)recommendRecordView:(RecommendationRecordView*)rrView requestOptionsModels:(NSArray*)models;

- (void)recommendRecordView:(RecommendationRecordView *)rrView netWorkNoConnection:(UITableView*)tableView;

- (void)recommendRecordView:(RecommendationRecordView *)rrView startRqeust:(UITableView*)tableView;

- (void)recommendRecordView:(RecommendationRecordView *)rrView stopRequest:(UITableView*)tableView;

@end

@interface RecommendationRecordView : UIView

//报备信息列表
@property (nonatomic,weak)RecommendationRecordListView* rrListView;

//顶部选项视图
@property (nonatomic,weak)TopOptionsView* topOptionsView;

@property (nonatomic,assign)NSInteger currentIndex;

//关键字
@property (nonatomic,copy)NSString* keyword;

@property (nonatomic,weak)id <RecommendationRecordViewDelegate> delegate;


@property (nonatomic,strong)NSArray* optionsModelArray;
@end
