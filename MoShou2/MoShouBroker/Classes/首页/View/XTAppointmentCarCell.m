//
//  XTAppointmentCarCell.m
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTAppointmentCarCell.h"
#import "NSString+Extension.h"
#import "CarReportedRecordModel.h"
#import "MobileVisible.h"

@interface XTAppointmentCarCell()

@property (nonatomic,weak)UILabel* nameLabel;

@property (nonatomic,weak)UILabel* phoneLabel;

@property (nonatomic,weak)UILabel* buildingLabel;

@property (nonatomic,weak)UIButton* promitButton;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UILabel* statusLabel;

@property (nonatomic,copy)XTAppointmentCarCellCallBack callBack;


@end

@implementation XTAppointmentCarCell

+ (instancetype)appointmentCarCellWith:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    XTAppointmentCarCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        [tableView registerClass:[self class] forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
    }
    return cell;
}

+ (instancetype)appointmentCarCellWith:(UITableView *)tableView model:(CarReportedRecordModel *)model callBack:(XTAppointmentCarCellCallBack)callBack{
    XTAppointmentCarCell* cell = [self appointmentCarCellWith:tableView];
    cell.model = model;
    cell.callBack = callBack;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_model == nil) {
        _model = [[CarReportedRecordModel alloc]init];
        _model.buildingName = @"";
//        _model. = @"           ";
        _model.name = @"";
    }
    CGFloat width = [self.nameLabel.text sizeWithfont:[UIFont systemFontOfSize:NAMEFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.nameLabel.frame = CGRectMake(16, 15 * SCALE6, width, NAMEFONTSIZE);
    width = [@"18282828888" sizeWithfont:[UIFont systemFontOfSize:PHONEFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.phoneLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 15, CGRectGetMaxY(_nameLabel.frame) -  PHONEFONTSIZE, width + 20, PHONEFONTSIZE);
    
    width = [_model.buildingName sizeWithfont:[UIFont systemFontOfSize:BUILDINGFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.buildingLabel.frame = CGRectMake(16, CGRectGetMaxY(_nameLabel.frame) + 10 * SCALE6, width, BUILDINGFONTSIZE);
    
    width = [self.statusLabel.text sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.statusLabel.frame = CGRectMake(_buildingLabel.right + 4, _buildingLabel.top, width, 14);
    
    width = [self.promitButton.titleLabel.text sizeWithfont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.promitButton.frame = CGRectMake(self.frame.size.width - width - 20 * SCALE6 - 16, (self.frame.size.height - 28 * SCALE6)/2.0, width + 20 * SCALE6, 28 * SCALE6);
    if (_promitButton.left <= _phoneLabel.right) {
        _phoneLabel.width = _promitButton.left - _phoneLabel.left - 4;
    }
    self.lineView.frame = CGRectMake(16, self.frame.size.height - 0.5, kMainScreenWidth, 0.5);
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:NAMEFONTSIZE];
        label.textColor = [UIColor colorWithHexString:NAMECOLOR];
        [self.contentView addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:PHONEFONTSIZE];
        label.textColor = [UIColor colorWithHexString:PHONECOLOR];
        [self.contentView addSubview:label];
        _phoneLabel = label;
    }
    return _phoneLabel;
}

- (UILabel *)buildingLabel{
    if (!_buildingLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:BUILDINGFONTSIZE];
        label.textColor = [UIColor colorWithHexString:BUILDINGCOLOR];
        [self.contentView addSubview:label];
        _buildingLabel = label;
    }
    return _buildingLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:BUILDINGFONTSIZE];
        label.textColor = BLUEBTBCOLOR;
        [self.contentView addSubview:label];
        _statusLabel = label;
    }
    return _statusLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"d9d9db"];
        [self addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

- (UIButton *)promitButton{
    if (!_promitButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 4.0f;
        btn.clipsToBounds = YES;
        [btn setTitle:@"去约车" forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"1d9fea"]];
        _promitButton = btn;
    }
    return _promitButton;
}

- (void)buttonClick:(UIButton*)btn{
    if (_callBack) {
        _callBack(self,XTAppointmentCarCellAction,_model);
    }
}

- (void)setModel:(CarReportedRecordModel *)model{
    _model = model;
    if (model.name.length <= 9) {
        self.nameLabel.text = model.name;
    }else
    {
        self.nameLabel.text = [NSString stringWithFormat:@"%@...", [model.name substringToIndex:9]];
    }
    self.buildingLabel.text=  model.buildingName;
//    self.phoneLabel.text = model.customerName;
    if (model.phoneList.count > 0) {
        MobileVisible* mobile = [model.phoneList firstObject];
        self.phoneLabel.text = mobile.hidingPhone;
    }

    [self.promitButton setTitle:_model.trystCar forState:UIControlStateNormal];
    [self setNeedsLayout];
    if (model.optType.length > 0) {
        [self.statusLabel setText:model.optType];
    }else [self.statusLabel setText:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
