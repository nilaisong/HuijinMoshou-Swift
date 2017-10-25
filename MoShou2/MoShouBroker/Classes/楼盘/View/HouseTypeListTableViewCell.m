//
//  HouseTypeListTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 2016/12/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "HouseTypeListTableViewCell.h"

@implementation HouseTypeListTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    _picImgView = [[MyImageView alloc] initWithFrame:CGRectMake(10, 15, 100, 75)];
    [_picImgView.layer setMasksToBounds:YES];
    [_picImgView.layer setCornerRadius:3];
    _picImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_picImgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picImgView.right+10, _picImgView.top+7, kMainScreenWidth-_picImgView.right-20-8, 25)];
    _titleLabel.textColor = NAVIGATIONTITLE;
    _titleLabel.font = kMainScreenWidth>320?FONT(16):FONT(15);
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+10, _titleLabel.width, 20)];
    _detailLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _detailLabel.font = FONT(12);
    [self.contentView addSubview:_detailLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-8-10-120, 52.5-15, 120, 30)];
    _priceLabel.textColor = ORIGCOLOR;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = kMainScreenWidth>320?[UIFont boldSystemFontOfSize:16]:[UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_priceLabel];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_priceLabel.right+10, 52.5-8, 8, 16)];
    [arrowImgView setImage:[UIImage imageNamed:@"arrow-right"]];
    [self.contentView addSubview:arrowImgView];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
