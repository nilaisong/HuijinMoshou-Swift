//
//  MessageNoticeTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 2016/10/17.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MessageNoticeTableViewCell.h"

@implementation MessageNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    _headeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 44, 44)];
    [_headeImageView.layer setMasksToBounds:YES];
    [_headeImageView.layer setCornerRadius:4];
    [self.contentView addSubview:_headeImageView];
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(11)};
    CGSize size = [@"08:30" sizeWithAttributes:attributes];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headeImageView.right+10, _headeImageView.top, kMainScreenWidth-_headeImageView.right-10-8-10-size.width-10, 22)];
    _titleLabel.textColor = NAVIGATIONTITLE;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = FONT(16);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, 22)];
    _contentLabel.textColor = LABELCOLOR;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = FONT(12);
    [self.contentView addSubview:_contentLabel];
    
    _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right+10, _titleLabel.top, size.width+10, 22)];
    _dateTimeLabel.textColor = LABELCOLOR;
    _dateTimeLabel.textAlignment = NSTextAlignmentRight;
    _dateTimeLabel.font = FONT(12);
    [self.contentView addSubview:_dateTimeLabel];
    
    _msgNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentLabel.right+10, _contentLabel.top, 90, 22)];
    _msgNumLabel.backgroundColor = ORIGCOLOR;
    _msgNumLabel.textColor = [UIColor whiteColor];
    _msgNumLabel.textAlignment = NSTextAlignmentCenter;
    _msgNumLabel.font = FONT(14);
    [_msgNumLabel.layer setMasksToBounds:YES];
    [_msgNumLabel.layer setCornerRadius:5];
    [self.contentView addSubview:_msgNumLabel];
    _msgNumLabel.hidden = YES;
    
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
