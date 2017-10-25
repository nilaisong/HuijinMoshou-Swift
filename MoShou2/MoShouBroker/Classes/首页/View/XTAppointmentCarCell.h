//
//  XTAppointmentCarCell.h
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NAMEFONTSIZE 17
#define PHONEFONTSIZE 14
#define BUILDINGFONTSIZE 14
#define DATEFONTSIZE 12
#define NAMECOLOR @"333333"
#define PHONECOLOR @"777777"
#define BUILDINGCOLOR @"777777"
#define DATECOLOR @"777777"

@class CarReportedRecordModel;
@class XTAppointmentCarCell;

typedef NS_ENUM(NSInteger,XTAppointmentCarCellEvent) {
    XTAppointmentCarCellTap,
    XTAppointmentCarCellAction,
};

/**
 *  打车cell回调
 *
 *  @param cell  cell对象
 *  @param event 事件
 *  @param model 模型
 */
typedef void(^XTAppointmentCarCellCallBack)(XTAppointmentCarCell* cell,XTAppointmentCarCellEvent event,CarReportedRecordModel* model);

@interface XTAppointmentCarCell : UITableViewCell

@property (nonatomic,strong)CarReportedRecordModel* model;

+ (instancetype)appointmentCarCellWith:(UITableView*)tableView;

+ (instancetype)appointmentCarCellWith:(UITableView *)tableView model:(CarReportedRecordModel*)model callBack:(XTAppointmentCarCellCallBack)callBack;

@end
