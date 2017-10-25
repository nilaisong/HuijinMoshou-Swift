//
//  XTListOperationCell.m
//  MoShou2
//
//  Created by xiaotei's on 16/10/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTListOperationCell.h"
#import "XTOperationModelItem.h"
#import "NSString+Extension.h"


@interface XTListOperationCell()

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* creatTimeLabel;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UIImageView* headImgView;

@end

@implementation XTListOperationCell

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview  ];
    if (self.titleStr.length > 0) {
        self.titleLabel.text = _titleStr;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.headImgView.frame = CGRectMake(16, 8, 65, 45 - 16);
//    self.titleLabel.frame = CGRectMake(16, kFrame_Width(_headImgView) + 4, kMainScreenWidth - kFrame_Width(_headImgView) - 8, 14);
//    self.lineView.frame = CGRectMake(16, _lineState==0?0:(self.height - 0.5), kMainScreenWidth, 0.5);
//    self.creatTimeLabel.frame = CGRectMake(CGRectGetMaxX(_headImgView.frame) + 4, kFrame_YHeight(_headImgView) - 12, kMainScreenWidth - kFrame_XWidth(_headImgView) - 8, 12);
    self.headImgView.frame = CGRectMake(10, 15 * SCALE6, 100 * SCALE6, 75 *SCALE6);
    
    CGSize textSize = [self.titleLabel.text sizeWithfont:self.titleLabel.font maxSize:CGSizeMake(kMainScreenWidth - CGRectGetMaxX(_headImgView.frame) - 20 * SCALE6 , MAXFLOAT)];
    CGFloat maxLabelHeight = self.height - 40 * SCALE6 - 13;
    maxLabelHeight = maxLabelHeight < textSize.height ? maxLabelHeight : textSize.height;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(_headImgView.frame) + 10 * SCALE6, 20 * SCALE6, kMainScreenWidth - CGRectGetMaxX(_headImgView.frame) - 20 * SCALE6 ,maxLabelHeight);
    
    self.creatTimeLabel.frame = CGRectMake(CGRectGetMaxX(_headImgView.frame) + 10 * SCALE6, self.height - 20 * SCALE6 - 13, self.width - CGRectGetMaxX(_headImgView.frame) - 20 * SCALE6, 13);
    
    self.lineView.frame = CGRectMake(16, _lineState==0?0:(self.height - 0.5), kMainScreenWidth, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:label];
        label.numberOfLines = 0;
        label.contentMode = UIViewContentModeTopLeft;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)creatTimeLabel{
    if (!_creatTimeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:label];
        _creatTimeLabel = label;
    }
    return _creatTimeLabel;
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        UIImage* img = [UIImage imageNamed:@"默认图片xiao"];
        UIImageView* imgv = [[UIImageView alloc]initWithImage:img];
        [self.contentView addSubview:imgv];
        _headImgView = imgv;
    }
    return _headImgView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *lineV = [[UIView alloc]init];
        [self.contentView addSubview:lineV];
        lineV.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        _lineView = lineV;
    }
    return _lineView;
}

- (void)setItemModel:(XTOperationModelItem *)itemModel{
    _itemModel = itemModel;
    NSURL* url = [NSURL URLWithString:itemModel.imgUrl];
    [self.headImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认图片xiao"]];
    [self.titleLabel setText:itemModel.title];
    if (self.itemModel.updateTime.length >= 10) {
        NSString* timeStr = [NSString stringWithFormat:@"汇金行 %@",[self.itemModel.updateTime substringToIndex:10]];
        [self.creatTimeLabel setText:timeStr];
    }
    
}


@end
