//
//  MyEvaluationTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 2017/3/6.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "MyEvaluationTableViewCell.h"

@implementation MyEvaluationTableViewCell

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
    UIImage *avaterImg = [UIImage imageNamed:@"客户默认头像"];
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(10 + avaterImg.size.width / 2.0, 15, kMainScreenWidth - (10 + avaterImg.size.width / 2.0), avaterImg.size.height)];
    userInfoView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [self.contentView addSubview:userInfoView];
    
    UIImageView *avaterImgView = [[UIImageView alloc] initWithImage:avaterImg];
    avaterImgView.frame = CGRectMake(10, 15, avaterImgView.size.width, avaterImgView.size.height);
    [self.contentView addSubview:avaterImgView];
    
    CGSize nameSize = [@"带看评价:" sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avaterImg.size.width / 2.0 + 15, 10, 20, nameSize.height)];
    _nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    _nameLabel.font = FONT(13);
    [userInfoView addSubview:_nameLabel];
    
    _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, _nameLabel.top, 20, nameSize.height)];
    _telLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _telLabel.font = FONT(12);
    [userInfoView addSubview:_telLabel];
    
    CGSize scoreSize = [@"带看评价:" sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(userInfoView.frame.size.width - 30, _nameLabel.top, 20, scoreSize.height)];
    _scoreLabel.textColor = [UIColor colorWithHexString:@"ec6a5f"];
    _scoreLabel.font = FONT(15);
    [userInfoView addSubview:_scoreLabel];

    _buildL = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 10, nameSize.width, nameSize.height)];
    _buildL.text = @"带看楼盘:";
    _buildL.textColor = [UIColor colorWithHexString:@"888888"];
    _buildL.font = FONT(12);
    [userInfoView addSubview:_buildL];
    _buildLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buildL.right+10, _buildL.top, userInfoView.frame.size.width - (_buildL.right+10) - 10, nameSize.height)];
    _buildLabel.textColor = [UIColor colorWithHexString:@"333333"];
    _buildLabel.font = FONT(12);
    [userInfoView addSubview:_buildLabel];
    
    _evaluationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + avaterImg.size.width + 15, 15 + avaterImg.size.height + 15, kMainScreenWidth-(10 + avaterImg.size.width + 15) - 10, nameSize.height)];
    _evaluationLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _evaluationLabel.font = FONT(13);
    _evaluationLabel.numberOfLines = 0;
    _evaluationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_evaluationLabel];
    
    _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_evaluationLabel.left, _evaluationLabel.bottom + 15, 100, nameSize.height)];
    _dateTimeLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _dateTimeLabel.font = FONT(10);
    [self.contentView addSubview:_dateTimeLabel];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _dateTimeLabel.bottom + 15, kMainScreenWidth, 10)];
    _lineLabel.backgroundColor = VIEWBGCOLOR;
    [self.contentView addSubview:_lineLabel];

    
////    _custTelL = [[UILabel alloc] initWithFrame:CGRectMake(custNameL.left, custNameL.bottom+10, custNameL.width, custNameL.height)];
////    _custTelL.text = @"手 机 号:";
////    _custTelL.textColor = [UIColor colorWithHexString:@"888888"];
////    _custTelL.font = FONT(13);
////    [self.contentView addSubview:_custTelL];
    
////    _scoreL = [[UILabel alloc] initWithFrame:CGRectMake(custNameL.left, _buildL.bottom+10, custNameL.width, custNameL.height)];
////    _scoreL.text = @"带看评分:";
////    _scoreL.textColor = [UIColor colorWithHexString:@"888888"];
////    _scoreL.font = FONT(13);
////    [self.contentView addSubview:_scoreL];
    
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
