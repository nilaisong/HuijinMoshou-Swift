//
//  XTCustomerClockTelCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/27.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCustomerClockTelCell.h"

@interface XTCustomerClockTelCell()
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerSexLabel;
@property (weak, nonatomic) IBOutlet UIButton *telButton;

@end

@implementation XTCustomerClockTelCell

+ (instancetype)customerClockTelCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTCustomerClockTelCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
    }
    return cell;
}

+ (instancetype)customerClockTelCellWithTableView:(UITableView *)tableView callBack:(CustomerClockTelActionResult)callBack{
    XTCustomerClockTelCell* cell = [self customerClockTelCellWithTableView:tableView];
    cell.callBack = callBack;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    [self reloadInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clockBtnClick:(UIButton *)sender {
    if (_callBack) {
        _callBack(CustomerClockTelCellEventClock,_customerReportedDetailModel);
    }
}
- (IBAction)phoneBtnClick:(UIButton *)sender {
        _callBack(CustomerClockTelCellEventTel,_customerReportedDetailModel);
}

- (void)setCustomerReportedDetailModel:(CustomerReportedDetailModel *)customerReportedDetailModel{
    _customerReportedDetailModel = customerReportedDetailModel;
    if ([customerReportedDetailModel.phone hasSuffix:@"*"]) {
        _telButton.hidden = YES;
    }
    [self reloadInfo];
}

- (void)reloadInfo{
    if (!_customerReportedDetailModel)return;
    _customerNameLabel.text = _customerReportedDetailModel.customerName;
    if (_customerReportedDetailModel.customerName.length > 5) {
        NSString* name = [_customerReportedDetailModel.customerName substringToIndex:5];
        _customerNameLabel.text = [NSString stringWithFormat:@"%@...",name];     
    }
    _customerPhoneNumberLabel.text = _customerReportedDetailModel.phone;
    if ([_customerReportedDetailModel.sex isEqualToString:@"MALE"]) {
        _customerSexLabel.text = @"先生";
    }else _customerSexLabel.text = @"女士";

}
@end
