//
//  CustFollowTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 2017/3/10.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "CustFollowTableViewCell.h"

@implementation CustFollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    CGSize dateSize = [@"88-88" sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, dateSize.width, dateSize.height)];
    _dateLabel.textColor = NAVIGATIONTITLE;
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_dateLabel];
    
    CGSize timeSize = [@"88:88" sizeWithAttributes:@{NSFontAttributeName:FONT(12)}];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _dateLabel.bottom+10, _dateLabel.width, timeSize.height)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _timeLabel.font = FONT(12);
    [self.contentView addSubview:_timeLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dateLabel.right+25, _dateLabel.top, 120, _dateLabel.height)];
    _nameLabel.textColor = NAVIGATIONTITLE;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    CGSize roleSize = [@"西北小区大区经理" sizeWithAttributes:@{NSFontAttributeName:FONT(10)}];
    _roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right+10, _dateLabel.top+_dateLabel.height/2-(roleSize.height+4)/2, 100, roleSize.height+4)];
    _roleLabel.textAlignment = NSTextAlignmentCenter;
    _roleLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _roleLabel.font = FONT(10);
    [_roleLabel.layer setMasksToBounds:YES];
    [_roleLabel.layer setCornerRadius:(roleSize.height+4)/2];
    [_roleLabel.layer setBorderColor:[UIColor colorWithHexString:@"888888"].CGColor];
    [_roleLabel.layer setBorderWidth:0.5];
    [self.contentView addSubview:_roleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom+10, kMainScreenWidth-_nameLabel.left-10, 20)];
    _contentLabel.textColor = NAVIGATIONTITLE;
    _contentLabel.font = FONT(13);
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_contentLabel];
    
    _buildingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _contentLabel.bottom+10, _contentLabel.width, 30)];
    _buildingLabel.textColor = BLUEBTBCOLOR;
    _buildingLabel.font = FONT(13);
    [self.contentView addSubview:_buildingLabel];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buildingLabel.left, _buildingLabel.bottom+10, kMainScreenWidth-_buildingLabel.left, 0.5)];
    _lineLabel.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [self.contentView addSubview:_lineLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
