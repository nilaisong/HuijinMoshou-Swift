//
//  XTIncomeDetailsCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTIncomeDetailsCell.h"

@interface XTIncomeDetailsCell()

//收支事件
@property (weak, nonatomic) IBOutlet UILabel *incomeEventLabel;
//收支时间
@property (weak, nonatomic) IBOutlet UILabel *incomeTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *incomeNumberLabel;

@property (nonatomic,weak)UIView* lineView;

@end


@implementation XTIncomeDetailsCell

+ (instancetype)incomeDetailsCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTIncomeDetailsCell* detailCell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!detailCell) {
        UINib* nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        detailCell = [tableView dequeueReusableCellWithIdentifier:className];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailCell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(16, self.frame.size.height - 1, kMainScreenWidth - 16, 1);
}

- (void)awakeFromNib {
    // Initialization code
    [self reloadInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIncomeModel:(XTIncomeModel *)incomeModel{
    _incomeModel = incomeModel;
    
    [self reloadInfo];
}

- (void)reloadInfo{
    if (!_incomeModel)return;
    
//    if (_incomeModel.commission > 0) {
        _incomeNumberLabel.text = [NSString stringWithFormat:@"%.0f",fabs(_incomeModel.commission)];
        _incomeNumberLabel.textColor = [UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f];
//    }else {
//        _incomeNumberLabel.text = [NSString stringWithFormat:@"-%.0f",fabs(_incomeModel.commission)];
//        _incomeNumberLabel.textColor = [UIColor colorWithRed:0.99f green:0.42f blue:0.20f alpha:1.00f];
//    }
    _incomeEventLabel.text = _incomeModel.commissionOpt;
    _incomeTimeLabel.text = _incomeModel.createTime;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineView = [[UIView alloc]init];
        
        lineView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

@end


