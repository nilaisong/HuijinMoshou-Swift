//
//  XTAppointmentRecordCell.m
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTAppointmentRecordCell.h"
#import "CarRecordListModel.h"
#import "NSString+Extension.h"
#import "MobileVisible.h"
#import "UIViewExt.h"

@interface XTAppointmentRecordCell()

@property (nonatomic,weak)UILabel* nameLabel;

@property (nonatomic,weak)UILabel* phoneLabel;

@property (nonatomic,weak)UILabel* buildingLabel;

@property (nonatomic,weak)UILabel* dateLabel;

@property (nonatomic,weak)UILabel* statusLabel;

@property (nonatomic,weak)UIImageView* dirImageView;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UILabel* baoStatusLabel;

@end

@implementation XTAppointmentRecordCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = [self.nameLabel.text sizeWithfont:[UIFont systemFontOfSize:NAMEFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.nameLabel.frame = CGRectMake(16, 15 * SCALE6, width, NAMEFONTSIZE);
    width = [@"18282828888" sizeWithfont:[UIFont systemFontOfSize:PHONEFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.phoneLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 15 * SCALE6, CGRectGetMaxY(_nameLabel.frame) -  PHONEFONTSIZE, width + 20, PHONEFONTSIZE);
    if (_model == nil) {
    
    }
    width = [self.dateLabel.text sizeWithfont:[UIFont systemFontOfSize:DATEFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    self.dirImageView.frame = CGRectMake(kMainScreenWidth - 16 - 8, (self.frame.size.height - 13)/2.0, 8, 13);
    
    self.dateLabel.frame = CGRectMake(kMainScreenWidth - width - 34 , CGRectGetMaxY(_nameLabel.frame) + 8, width, DATEFONTSIZE);
    
    CGFloat optWidth = [_model.optType sizeWithfont:[UIFont systemFontOfSize:BUILDINGFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    width = [_model.buildingName sizeWithfont:[UIFont systemFontOfSize:BUILDINGFONTSIZE] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    if (width > kMainScreenWidth - 32 - _dateLabel.width - 4 - optWidth) {
        width = kMainScreenWidth - 32 - _dateLabel.width - 4 - optWidth;
    }
    self.buildingLabel.frame = CGRectMake(16, CGRectGetMaxY(_nameLabel.frame) + 10 * SCALE6, width, BUILDINGFONTSIZE);
    
    
    self.baoStatusLabel.frame = CGRectMake(_buildingLabel.right + 4, _buildingLabel.top, optWidth, 14);
    
    
    width = [self.statusLabel.text sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    self.statusLabel.frame = CGRectMake(kMainScreenWidth - width - 34, _nameLabel.frame.origin.y, width, 14);
    if (self.statusLabel.frame.origin.x <= CGRectGetMaxX(_phoneLabel.frame)) {
        _phoneLabel.width = _statusLabel.left - _phoneLabel.left - 4;
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
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:DATEFONTSIZE];
        label.textColor = [UIColor colorWithHexString:DATECOLOR];
        [self.contentView addSubview:label];
        _dateLabel = label;
    }
    return _dateLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        _statusLabel = label;
    }
    return _statusLabel;
}

- (UILabel *)baoStatusLabel{
    if (!_baoStatusLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:BUILDINGFONTSIZE];
        label.textColor = BLUEBTBCOLOR;
        [self.contentView addSubview:label];
        _baoStatusLabel = label;
    }
    return _baoStatusLabel;
   
}

- (UIImageView *)dirImageView{
    if (!_dirImageView) {
        UIImageView* imgV = [[UIImageView alloc]init];
        [imgV setImage:[UIImage imageNamed:@"arrow-right"]];
        [self.contentView addSubview:imgV];
        _dirImageView = imgV;
    }
    return _dirImageView;
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


- (void)setModel:(CarRecordListModel *)model{
    _model = model;
    if (model.customerName.length <= 9) {
        self.nameLabel.text = model.customerName;
    }else
    {
        self.nameLabel.text = [NSString stringWithFormat:@"%@...", [model.customerName substringToIndex:9]];
    }
    self.phoneLabel.text = model.customerMobile;
//    if (model.phoneList.totalPhone.length > 0) {
//        self.phoneLabel.text = model.phoneList.totalPhone;
//    }else if (model.phoneList.hidingPhone.length > 0){
//        self.phoneLabel.text = model.phoneList.hidingPhone;
//    }
    self.buildingLabel.text = model.buildingName;
    if (_model.optType.length > 0) {
        [self.baoStatusLabel setText:_model.optType];
    }else [self.baoStatusLabel setText:@""];
    
    
    self.dateLabel.text = model.createTime;
    
    self.statusLabel.text = model.status;
    
    switch ([model.statusId integerValue]) {
        case 0:
            self.statusLabel.textColor = [UIColor colorWithHexString:@"1d9fea"];
            break;
        case 1:
            self.statusLabel.textColor = [UIColor colorWithHexString:@"ff4900"];
            break;
        case 2:
            self.statusLabel.textColor = [UIColor colorWithHexString:@"00d319"];
            break;
        case 3:
            self.statusLabel.textColor = [UIColor colorWithHexString:@"777777"];
            break;
        case 4:
            self.statusLabel.textColor = [UIColor colorWithHexString:@"f11716"];
            break;
        default:
            self.statusLabel.textColor = [UIColor colorWithHexString:@"777777"];
            break;
    }
    
    [self setNeedsLayout];
}

@end
