//
//  XTCustomerRecordCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCustomerRecordCell.h"
#import "CustomerReportedRecord.h"
#import "MobileVisible.h"
@interface XTCustomerRecordCell()

//客户电话
@property (weak, nonatomic) IBOutlet UILabel *customerTel;
/*社区*/
@property (weak, nonatomic) IBOutlet UILabel *customerCommunity;
//进度状态
@property (weak, nonatomic) IBOutlet UILabel *processStatusLabel;
//进度时间
@property (weak, nonatomic) IBOutlet UILabel *processTimeLabel;
//客户名
@property (weak, nonatomic) IBOutlet UILabel *customerName;

//确客信息
@property (weak, nonatomic) IBOutlet UILabel *quekeLabel;

@property (nonatomic,weak)UIView* lineView;

@end

@implementation XTCustomerRecordCell

+ (instancetype)customerRecordCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTCustomerRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
        NSLog(@"注册，注册，注册cellla1");
    }
    return cell;
}

+ (instancetype)customerRecordCellWithTableView:(UITableView *)tableView eventCallBack:(XTCustomerRecordCellEventCallBack)callBack{
    XTCustomerRecordCell* cell = [self customerRecordCellWithTableView:tableView];
    cell.callBack = callBack;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(16, self.frame.size.height - 1, kMainScreenWidth - 32, 1);
}

- (IBAction)QRCodeBtnClick:(UIButton *)sender {
    if (_callBack) {
        _callBack(self,YES);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomerReportedRecord:(CustomerReportedRecord *)customerReportedRecord{
    _customerReportedRecord = customerReportedRecord;
    MobileVisible* visible = [customerReportedRecord.phoneList firstObject];
    
    NSString* tel = nil;
    if (visible) {
        if (visible.hidingPhone.length > 0) {
            tel = visible.hidingPhone;
        }else if (visible.totalPhone.length > 0) {
            tel = visible.totalPhone;
        }
    }
    _customerTel.text = tel;
    _customerName.text = customerReportedRecord.name;
    if (customerReportedRecord.name.length > 5) {
        NSString* name = [customerReportedRecord.name substringToIndex:5];
        _customerName.text = [NSString stringWithFormat:@"%@...",name];

    }
    _customerCommunity.text = customerReportedRecord.buildingName;
    
    if (_customerCommunity.text.length > 10) {
        NSString* buildingName = [_customerCommunity.text substringToIndex:10];
        _customerCommunity.text = [NSString stringWithFormat:@"%@...",buildingName];
    }
    
    _processStatusLabel.text = customerReportedRecord.status;
    _processTimeLabel.text = customerReportedRecord.datetime;
    
    if (customerReportedRecord.showURL) {
        _QRCodeButton.hidden = NO;
        _processStatusLabel.textColor = [UIColor colorWithRed:0.98f green:0.32f blue:0.00f alpha:1.00f];
        
    }else {
        _processStatusLabel.textColor = [UIColor colorWithRed:0.00f green:0.63f blue:0.92f alpha:1.00f];
        _QRCodeButton.hidden = YES;
    }
    
    if ([_processStatusLabel.text isEqualToString:@"失效"] || [_processStatusLabel.text isEqualToString:@"无效"] ) {

        _processStatusLabel.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
    }
    
    if (customerReportedRecord.quekeName.length > 0 && customerReportedRecord.quekePhone.length > 0) {
        self.quekeLabel.hidden = NO;
        self.quekeLabel.text = [NSString stringWithFormat:@"确客专员%@ %@",customerReportedRecord.quekeName,customerReportedRecord.quekePhone];
    }else{
        self.quekeLabel.hidden = YES;
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [self.contentView addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

+ (CGFloat)heightWithCustomerModel:(CustomerReportedRecord *)recordModel{
    if (recordModel.quekePhone.length >0 && recordModel.quekeName.length > 0) {
        return 94.0f;
    }
    return 70.0f;
}

@end
