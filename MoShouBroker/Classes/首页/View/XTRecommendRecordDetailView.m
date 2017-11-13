		//
//  XTRecommendRecordDetailView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/27.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTRecommendRecordDetailView.h"
#import "XTCustomerClockTelCell.h"
#import "XTCustomerBuildingCell.h"
#import "XTCustomerFollowRecordCell.h"
#import "XTCustomerFollowRecordDetailCell.h"

#import "DataFactory+Main.h"
#import "CustomerReportedDetailModel.h"
#import "ReportBuildingTrack.h"
#import "BuildingTrackInfoView.h"
#import "XTCustomerReportBuildingDetailView.h"

#import "NSString+Extension.h"

#import "XTCustomerInfoHeaderView.h"
#import "XTCustomerDetailTelCell.h"
#import "XTBuildingNameView.h"
#import "XTBuildingHeaderProgressView.h"

#import "MobileVisible.h"

#import "ProgressStatus.h"
#import "MessageData.h"

//测试用模型
#import "ReportDetailMessage.h"
#import "ReportBuildingTrack.h"

@interface XTRecommendRecordDetailView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView* contentTableView;

@property (nonatomic,strong)NSArray* progressModelArray;

//电话号码模型数组
@property (nonatomic,strong)NSArray* mobileModelArray;


@property (nonatomic,strong)ReportDetailBuilding* buildingModel;

@property (nonatomic,strong)NSMutableArray* buildingViewStatusArray;

@end

@implementation XTRecommendRecordDetailView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.userInteractionEnabled = true;
    self.contentTableView.userInteractionEnabled = true;
    
    [self contentTableView];

//    XTCustomerInfoHeaderView * view = [[XTCustomerInfoHeaderView alloc]initWithCallBack:^(CustomerInfoHeaderEvent event) {
//        
//    }];
//    self.contentTableView.tableHeaderView = view;
//    view.frame = CGRectMake(0, 0, kMainScreenWidth, 30);
    
    
//    [self.contentTableView reloadData];
}

- (void)layoutSubviews{
    self.contentTableView.frame = self.bounds;
}

- (UITableView *)contentTableView{
    if (!_contentTableView) {
        UITableView* tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        _contentTableView = tableView;
        _contentTableView.showsVerticalScrollIndicator = NO;
        _contentTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _contentTableView;
}

- (void)didMoveToSuperview{

    [super didMoveToSuperview];

}

#pragma mark - tableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _detailModel.phoneList.count;
    }else if(section >= 2){
//        ReportDetailBuilding* building = _detailModel.buildingList[section - 2];
//        if (_buildingViewStatusArray != nil&&_buildingViewStatusArray.count > section - 2) {
//            BOOL isOpen = [_buildingViewStatusArray[section - 2] boolValue];
//            if (isOpen) {
//                return 1 + building.buildingTrackList.count;
//            }
            return 0;
//        }
    }

    return 0;
}
//详情，section数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    ReportDetailBuilding* build = [_detailModel.buildingList firstObject];
    NSUInteger num = 0;
    if (build) {
       num = build.progressList.count;
    }
    
    return 2 + num;
}
//报备详情具体cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        
        XTCustomerDetailTelCell* cell = [XTCustomerDetailTelCell customerDetailTelCellWithTableView:tableView eventCallBack:^(CustomerDetailTelCellEvent event,NSString* telString) {
            if ([weakSelf.delegate respondsToSelector:@selector(CustomerRecommendRecordDetailView:didSelectedTelAction:)]) {
                [weakSelf.delegate CustomerRecommendRecordDetailView:weakSelf didSelectedTelAction:telString];
            }
        }];
        
        if (_detailModel.phoneList.count > indexPath.row) {
            cell.mobileModel = _detailModel.phoneList[indexPath.row];
        }
    
        return cell;
    }else if (indexPath.section >= 2){
        ReportDetailBuilding* building = _detailModel.buildingList[indexPath.section - 2];
        if (indexPath.row == 0) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"buildingDetail"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"buildingDetail"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.userInteractionEnabled = YES;
            }
            XTCustomerReportBuildingDetailView* detailView = [[XTCustomerReportBuildingDetailView alloc]initWithCallBack:^(XTCustomerReportBuildingDetailView *detailVC, ReportDetailBuilding *building) {
                if ([weakSelf.delegate respondsToSelector:@selector(CustomerRecommendRecordDetailView:didSelectedAddTrackAction:)]) {
                
                    
                    
                    
                }
            }];
            detailView.frame = CGRectMake(0, 0, kMainScreenWidth, 42.0f + building.messageList.count * 31 + (building.messageList.count>0?18:0));
//            detailView.detailModel = _detailModel;
            detailView.building = building;
            
            [cell.contentView removeAllSubviews];
            [cell.contentView addSubview:detailView];
            return  cell;
        }else if (indexPath.row >= 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"trackInfoCell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"trackInfoCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.userInteractionEnabled = YES;
            }
            __weak typeof(self) weakSelf = self;
            BuildingTrackInfoView* info = [[BuildingTrackInfoView alloc]initWithEventCallBack:^(BuildingTrackInfoView *infoView, UIButton *actionBtn) {
                if ([weakSelf.delegate respondsToSelector:@selector(CustomerRecommendRecordDetailView:didSelectedDeleteTrackAction:)] && infoView.buildingTrack.trackId.length > 0) {
                    [weakSelf.delegate CustomerRecommendRecordDetailView:weakSelf didSelectedDeleteTrackAction:info.buildingTrack.trackId];
                }
            }];
            info.buildingTrack = building.buildingTrackList[indexPath.row - 1];
            info.frame = CGRectMake(0, 0, kMainScreenWidth,info.buildingTrack.trackHgiht);
            [cell.contentView removeAllSubviews];
            [cell.contentView addSubview:info];
             return  cell;
        }
       
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView* view = nil;
    
    __weak typeof(self) weakSelf = self;
    if (section == 0) {
     XTCustomerInfoHeaderView* headView = [XTCustomerInfoHeaderView customerInfoHeaderViewWithTableView:tableView eventCallBack:^(CustomerInfoHeaderEvent event) {
         if ([weakSelf.delegate respondsToSelector:@selector(CustomerRecommendRecordDetailView:didSelectedClockAction:)]) {
             [weakSelf.delegate CustomerRecommendRecordDetailView:weakSelf didSelectedClockAction:weakSelf.detailModel];
         }
        }];
        headView.detailModel = _detailModel;
        view = headView;
    }else if (section == 1) {
       XTBuildingNameView* buildingView = [XTBuildingNameView buildingNameViewWith:tableView eventCallBack:^(BuildingNameViewEvent event) {
           if ([weakSelf.delegate respondsToSelector:@selector(CustomerRecommendRecordDetailView:didSelectedQRAction:)]) {
               [weakSelf.delegate CustomerRecommendRecordDetailView:weakSelf didSelectedQRAction:weakSelf.customerReportedRecord.url];
           }
        }];
        buildingView.building = [_detailModel.buildingList firstObject];
        if (_customerReportedRecord) {
            buildingView.buildingName = _customerReportedRecord.buildingName;
        }
        view = buildingView;
    }else if (section >= 2){
        ReportDetailBuilding* building = [_detailModel.buildingList firstObject];
        
        XTBuildingHeaderProgressView*  headView = [XTBuildingHeaderProgressView buildingHeaderProgressViewWith:tableView eventCallBack:^(BuildingHeaderProgressViewEvent event,NSInteger section,UIButton* button) {
                                                   
//          if (weakSelf.buildingViewStatusArray != nil && weakSelf.buildingViewStatusArray.count > section - 2) {
              switch (event) {
                  case BuildingHeaderProgressViewEventOpen:
                  {
                      NSNumber *number = weakSelf.buildingViewStatusArray[section - 2];
                      if (number.integerValue == 0) {
                          [weakSelf.buildingViewStatusArray replaceObjectForIndex:section - 2 withObject:[NSNumber numberWithInt:1]];
                          
                      }else{
                          [weakSelf.buildingViewStatusArray replaceObjectForIndex:section - 2 withObject:[NSNumber numberWithInt:0]];
                          
                      }
                      [weakSelf.contentTableView reloadData];
                  }
                      break;
                  case BuildingHeaderProgressViewEventTap:{
                      ReportDetailBuilding* building = [weakSelf.detailModel.buildingList firstObject];
                      TradeRecord* trade = [[TradeRecord alloc] init];
                      trade.expiredate = building.expiredate;
                      trade.expiredateFlag = [NSString stringWithFormat:@"%ld",(long)building.expiredateFlag];
                      trade.buildingName = building.buildingName;
                      trade.buildingCustomerId = [NSString stringWithFormat:@"%ld",(long)building.buildingCustomerId];
                      
                      NSMutableArray* trackList = [NSMutableArray array];
                      for (int i = 0; i < building.buildingTrackList.count; i++) {
                          ReportBuildingTrack* track = building.buildingTrackList[i];
                          MessageData* trackData = [[MessageData alloc] init];
                          trackData.content = track.content;
                          trackData.datetime = track.datetime;
                          trackData.msgId = track.trackId;
                          [trackList appendObject:trackData];
                      }
                      
                      trade.confirmUserName = weakSelf.detailModel.quekeName;
                      trade.confirmUserMobile = weakSelf.detailModel.quekePhone;
                      
                      trade.progress = [NSArray arrayWithObjects:[building.progressList objectForIndex:section - 2], nil];
//                      for (ProgressStatus* status in building.progressList) {
//                          trade.messages = status.messages;
//                          trade.expiredate = building.expiredate;
//                          trade.expiredateFlag = [NSString stringWithFormat:@"%ld",(long)building.expiredateFlag];
//                      }
                     
                      trade.track = trackList;
                      
                      trade.district = building.district;
                      if ([weakSelf.delegate respondsToSelector:@selector(CustomerRecommendRecordDetailView:didSelectedBuilding:)]) {
                          [weakSelf.delegate CustomerRecommendRecordDetailView:weakSelf didSelectedBuilding:trade];
                          
                      }
                      DLog(@"点击了楼盘进度视图");
                  }
                      break;
                  default:
                      break;
              }
//          }
        }];
        headView.section = section;
//        headView.isOpen = [_buildingViewStatusArray[section - 2] boolValue];
        if (building.progressList.count > section - 2) {
            headView.status = [building.progressList objectForIndex:section - 2];
        }
        if (building.progressList.count == section - 1) {
            headView.isLast = YES;
        }else{
            headView.isLast = NO;
        }
//
//        
        view = headView;
//
    }
    
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc]init];
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  48.0f;
    }else if(section ==1){
        return 60.0f;
    }else if(section >= 2){
        return 130.0f;
    }
    return 116;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MobileVisible* visible = _detailModel.phoneList[indexPath.row];
        if (visible.totalPhone.length > 0 && visible.hidingPhone.length > 0) {
            return 63.0f;
        }
        return 44.0f;
    }else if(indexPath.section >= 2){
        ReportDetailBuilding* building = _detailModel.buildingList[indexPath.section - 2];
        if (indexPath.row == 0) {
            NSInteger height = 42.0f + building.messageList.count * 31 + (building.messageList.count>0?18:0);
            return height;
        }else if(indexPath.row >= 1){
            [building trackHeight];
            ReportBuildingTrack* track = building.buildingTrackList[indexPath.row - 1];
            return track.trackHgiht;
        }
        
        return 150.0f;
    }
    return 43.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)setCustomerReportedRecord:(CustomerReportedRecord *)customerReportedRecord{
    _customerReportedRecord = customerReportedRecord;
}

- (void)setDetailModel:(CustomerReportedDetailModel *)detailModel{
    _detailModel = detailModel;
    for (ReportDetailBuilding* building in detailModel.buildingList) {
        for (ReportBuildingTrack* _buildingTrack in building.buildingTrackList) {
            CGSize size = [NSString sizeWithString:_buildingTrack.content font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kMainScreenWidth - 32, CGFLOAT_MAX)];
            _buildingTrack.trackHgiht = size.height + 28 + 24;
        }
    }
//
    NSMutableArray* arrayM = [NSMutableArray array];
    for (int i = 0; i < _detailModel.buildingList.count; i++) {
        [arrayM appendObject:[NSNumber numberWithInt:0]];
    }
    _buildingViewStatusArray = arrayM;
    
//
    [_contentTableView reloadData];
}

@end
