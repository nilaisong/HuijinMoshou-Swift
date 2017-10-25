//
//  CustomerTableView.h
//  MoShou2
//
//  Created by wangzz on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
#import "CustomerVisitInfoData.h"
#import "ConfirmUserInfoObject.h"

@class CustomerTableView;

typedef void(^scrollBlock)(UIScrollView*);

@protocol CustomerTableViewCellDelegate <NSObject>
@optional
//点击右侧索引展示首字母
- (void)customerTableView:(CustomerTableView*)tableView FirstLetterSelecte:(NSString*)string;
//taleview上下滑动控制搜索框出现与隐藏
-(void)scrollWithTableView:(CustomerTableView*)tableView ScrollView:(UIScrollView *)scrollView;
//所有客户为空时添加客户
- (void)addLocalCustomer:(CustomerTableView*)tableView;
//其他分组客户为空时添加组成员
- (void)addGroupMember:(CustomerTableView*)tableView;
//点击tableviewcell
- (void)CustomerDidSelectedCell:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath Customer:(Customer*)cust;
//拨打电话
- (void)customerTableView:(CustomerTableView*)tableView CallWithCustomer:(Customer*)cust;
//报备楼盘
//delete by wangzz 161020
//- (void)customerTableView:(CustomerTableView*)tableView ReportWithCustId:(Customer*)custId;
//选择客户组成员
- (void)customerTableView:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath SelecteCustomerWithId:(NSString*)custId AndSeletedStatus:(BOOL)bIsSelected;

//复制电话
- (void)customerTableView:(CustomerTableView*)tableView CopyWithCustomer:(Customer*)cust;

@end

@interface CustomerTableView : UITableView

-(instancetype)initWithCustomer:(NSArray*)addressBookTemp ByCustomerType:(NSInteger)customerType AndFrame:(CGRect)frame tableType:(NSInteger)tableType withHasShop:(BOOL)hasShop;
-(void)refreshTableViewWithCustomer:(NSArray*)customerArray ByCustomerType:(NSInteger)customerType withStore:(BOOL)bHasStore;
-(void)refreshTableViewWithCustomer:(NSArray*)customerArray ByCustomerType:(NSInteger)customerType LastSelectedArray:(NSArray*)selectedArray;
-(void)refreshRowInSection:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath*)indexPath WithConfirmData:(NSMutableDictionary*)confirmInfoData;

-(void)refreshRowInSection:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath*)indexPath WithVisitData:(NSMutableDictionary*)visitInfoData;

@property (nonatomic, copy) scrollBlock didScrollTableView;
@property (nonatomic) id <CustomerTableViewCellDelegate> cellDelegate;
@property (nonatomic, strong) UILabel *searchEmptyL;

@property (nonatomic, strong) NSMutableArray   *statusArray;//客户是否被选中的状态记录数组，初始状态均为0
@property (nonatomic, strong) NSMutableArray   *visitStatusArray;//客户是否展示到访信息
@property (nonatomic, strong) NSMutableArray   *confirmStatusArray;//客户是否展示确客信息
@property (nonatomic, assign) BOOL    bIsShowVisitInfo;
@property (nonatomic, assign) BOOL    bIsShowConfirmInfo;

@end
