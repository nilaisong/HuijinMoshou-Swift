//
//  XTCustomerRecordCell.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTCustomerRecordCell;
@class CustomerReportedRecord;

//cell内部事件回调
typedef void(^XTCustomerRecordCellEventCallBack)(XTCustomerRecordCell* cell,BOOL touchQRBtn);

@interface XTCustomerRecordCell : UITableViewCell

//- (instancetype)initWithTableView:(UITableView*)tableView;

+ (instancetype)customerRecordCellWithTableView:(UITableView*)tableView;

+ (instancetype)customerRecordCellWithTableView:(UITableView *)tableView eventCallBack:(XTCustomerRecordCellEventCallBack)callBack;

@property (nonatomic,copy)XTCustomerRecordCellEventCallBack callBack;

@property (nonatomic,weak)CustomerReportedRecord *customerReportedRecord;

//二维码
@property (weak, nonatomic) IBOutlet UIButton *QRCodeButton;

+ (CGFloat)heightWithCustomerModel:(CustomerReportedRecord*)recordModel;

@end
