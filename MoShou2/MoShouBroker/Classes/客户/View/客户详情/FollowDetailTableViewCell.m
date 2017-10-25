//
//  FollowDetailTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "FollowDetailTableViewCell.h"

@implementation FollowDetailTableViewCell

- (id)initWithMessageData:(MessageData*)data TrackType:(NSInteger)trackType AndIndexPath:(NSInteger)indexPath
{
    self = [super init];
    if (self) {
        if (trackType) {
            if (indexPath) {
                NSString *str = data.content;
                CGFloat labelWidth = kMainScreenWidth-30;
                CGSize strSize = [self textSize:str withConstraintWidth:labelWidth];
                _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, kMainScreenWidth-30, strSize.height)];
                _contentLabel.text = str;
                _contentLabel.textColor = LABELCOLOR;
                _contentLabel.font = FONT(14);
                _contentLabel.adjustsFontSizeToFitWidth = YES;
                [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [_contentLabel setNumberOfLines:0];
                [self.contentView addSubview:_contentLabel];
                
                NSString *str1 = data.datetime;
                CGSize str1Size = [self textSize:str1 withConstraintWidth:labelWidth];
                _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _contentLabel.bottom+5, kMainScreenWidth-30, str1Size.height)];
                _timeLabel.textAlignment = NSTextAlignmentLeft;
                _timeLabel.text = str1;
                _timeLabel.textColor = LABELCOLOR;
                _timeLabel.font = FONT(14);
                [self.contentView addSubview:_timeLabel];
                
                [self.contentView addSubview:[self createLineView:_timeLabel.bottom+12-0.5]];
            }else
            {
                NSString *str1 = data.datetime;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
                
                CGSize str1Size = [str1 sizeWithAttributes:attributes];
                _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, str1Size.width, str1Size.height)];
                _timeLabel.textAlignment = NSTextAlignmentLeft;
                _timeLabel.text = str1;
                _timeLabel.textColor = LABELCOLOR;
                _timeLabel.font = FONT(14);
                [self.contentView addSubview:_timeLabel];
                
                NSString *str = [NSString stringWithFormat:@"(%@)",data.content];
                
                CGSize strSize = [str sizeWithAttributes:attributes];
                _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.right+5, 7, strSize.width, strSize.height)];
                _contentLabel.text = str;
                _contentLabel.textColor = BLUEBTBCOLOR;
                _contentLabel.font = FONT(14);
                [self.contentView addSubview:_contentLabel];
            }
        }else
        {
            NSString *str = data.content;
            CGFloat labelWidth = kMainScreenWidth-30;
            CGSize strSize = [self textSize:str withConstraintWidth:labelWidth];
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth-30, strSize.height)];
            _contentLabel.text = str;
            _contentLabel.textColor = LABELCOLOR;
            _contentLabel.font = FONT(14);
            _contentLabel.adjustsFontSizeToFitWidth = YES;
            [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [_contentLabel setNumberOfLines:0];
            [self.contentView addSubview:_contentLabel];
            
            NSString *str1 = data.datetime;
            CGSize str1Size = [self textSize:str1 withConstraintWidth:labelWidth];
            _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _contentLabel.bottom+5, kMainScreenWidth-30, str1Size.height)];
            _timeLabel.textAlignment = NSTextAlignmentLeft;
            _timeLabel.text = str1;
            _timeLabel.textColor = LABELCOLOR;
            _timeLabel.font = FONT(14);
            [self.contentView addSubview:_timeLabel];
            
            [self.contentView addSubview:[self createLineView:_timeLabel.bottom+7-0.5]];
        }
    }
    return self;
}

-(void)setBIsShowVisitInfo:(BOOL)bIsShowVisitInfo
{
    if (_bIsShowVisitInfo != bIsShowVisitInfo) {
        _bIsShowVisitInfo = bIsShowVisitInfo;
    }
    if (_bIsShowVisitInfo) {
        _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.bottom+7, kMainScreenWidth*18.5/25, 70)];
        _showVisitInfoView.showInfoType = kShowVisitInfo;
        [self.contentView addSubview:_showVisitInfoView];
    }
}

-(void)setBIsShowConfirmInfo:(BOOL)bIsShowConfirmInfo
{
    if (_bIsShowConfirmInfo != bIsShowConfirmInfo) {
        _bIsShowConfirmInfo = bIsShowConfirmInfo;
    }
    if (_bIsShowConfirmInfo) {
        if (_bIsShowVisitInfo) {
            _showVisitInfoView.height = 90;
        }else
        {
            _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(_timeLabel.left, _timeLabel.bottom+7, kMainScreenWidth*18.5/25, 30)];
            _showVisitInfoView.showInfoType = kShowConfirmInfo;
            [self.contentView addSubview:_showVisitInfoView];
        }
    }
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, y, kMainScreenWidth-15, 0.5)];
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
