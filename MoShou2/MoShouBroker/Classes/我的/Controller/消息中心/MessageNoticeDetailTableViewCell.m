//
//  MessageNoticeDetailTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 2016/10/24.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MessageNoticeDetailTableViewCell.h"

@implementation MessageNoticeDetailTableViewCell

- (id)initWithMessageData:(MessageData*)data AndMsgType:(NSString*)msgType AndIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if (self) {
        [self layoutUIWithData:data WithMsgType:msgType];
    }
    return self;
}

- (void)layoutUIWithData:(MessageData*)msgData WithMsgType:(NSString*)msgType
{
    NSDictionary *attributes = @{NSFontAttributeName:FONT(12)};
    CGSize size = [@"2020-02-02 08:30" sizeWithAttributes:attributes];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-size.width-10)/2, 15, size.width+20, size.height+10)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor colorWithHexString:@"cfcfcf"];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = FONT(12);
    NSDate *date = getNSDateWithDateTimeString(msgData.datetime);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLabel.text = [dateFormatter stringFromDate:date];//msgData.datetime
    [_timeLabel.layer setMasksToBounds:YES];
    [_timeLabel.layer setCornerRadius:(size.height+10)/2];
    [_timeLabel.layer setBorderWidth:0.5];
    [_timeLabel.layer setBorderColor:[UIColor colorWithHexString:@"cfcfcf"].CGColor];
    [self.contentView addSubview:_timeLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, _timeLabel.bottom+15, kMainScreenWidth - 30, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView.layer setMasksToBounds:YES];
    [bgView.layer setCornerRadius:5];
    [self.contentView addSubview:bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.left+15, bgView.top+10, bgView.width - 30, 30)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = NAVIGATIONTITLE;
    _titleLabel.text = msgData.title;
    _titleLabel.font = FONT(16);
    [self.contentView addSubview:_titleLabel];
    
    _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, 20)];
    _dateTimeLabel.textAlignment = NSTextAlignmentLeft;
    _dateTimeLabel.textColor = LABELCOLOR;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM-dd HH:mm"];
    _dateTimeLabel.text = [dateFormatter1 stringFromDate:date];
//    _dateTimeLabel.text = msgData.datetime;
    _dateTimeLabel.font = FONT(14);
    [self.contentView addSubview:_dateTimeLabel];
    
    [self.contentView addSubview:[self createLineView:_dateTimeLabel.bottom+10]];
    
    CGSize contentSize = [self textSize:msgData.content withConstraintWidth:_dateTimeLabel.width];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dateTimeLabel.left, _dateTimeLabel.bottom+25, _dateTimeLabel.width, contentSize.height)];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = LABELCOLOR;
    _contentLabel.font = FONT(14);
    _contentLabel.text = msgData.content;
    _contentLabel.numberOfLines = 0;
    [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_contentLabel];
    bgView.height = _contentLabel.bottom+15-bgView.top;
    
    if ([msgType isEqualToString:@"4"] || [msgType isEqualToString:@"5"] || [msgType isEqualToString:@"8"]) {
        [self.contentView addSubview:[self createLineView:_contentLabel.bottom+15]];
        UILabel *detailL = [[UILabel alloc] initWithFrame:CGRectMake(_contentLabel.left, _contentLabel.bottom+25, 100, 24)];
        detailL.textAlignment = NSTextAlignmentLeft;
        detailL.textColor = NAVIGATIONTITLE;
        detailL.font = FONT(14);
        detailL.text = @"查看详情";
        [self.contentView addSubview:detailL];
        
        UIImageView *btnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15-8 - 15, detailL.top+5, 8, 14)];
        [btnImgView setImage:[UIImage imageNamed:@"arrow-right"]];
        [self.contentView addSubview:btnImgView];
        
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.left, detailL.top-10, bgView.width, 44)];
        _bottomBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_bottomBtn];
        
        bgView.height = detailL.bottom+10-bgView.top;
    }
    
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, y, kMainScreenWidth-45, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
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
