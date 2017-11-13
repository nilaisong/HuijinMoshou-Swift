//
//  XTTitleAndCreatimeView.m
//  MoShou2
//
//  Created by xiaotei's on 16/9/29.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTTitleAndCreatimeView.h"
#import "NSString+Extension.h"

@interface XTTitleAndCreatimeView()

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* createTimeLabel;

@end

@implementation XTTitleAndCreatimeView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 
 */

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!_descModelItem) {
        return;
    }
    self.titleLabel.text = _descModelItem.title;
    self.createTimeLabel.text = _descModelItem.updateTime;
    CGSize tSize = [_descModelItem.title sizeWithfont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(self.width - 16, MAXFLOAT)];
    self.titleLabel.frame = CGRectMake(8, 8, tSize.width, tSize.height);
    CGSize mSize = [_descModelItem.updateTime sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(self.width - 16, MAXFLOAT)];
    self.createTimeLabel.frame = CGRectMake(8, CGRectGetMaxY(_titleLabel.frame), mSize.width, mSize.height);
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:18];
        [self addSubview:label];
        _titleLabel  = label;
    }
    return _titleLabel;
}

- (UILabel *)createTimeLabel{
    if (!_createTimeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        _createTimeLabel = label;
    }
    return _createTimeLabel;
}

- (void)setDescModelItem:(XTRecdDescModelItem *)descModelItem{
    _descModelItem = descModelItem;
    [self setNeedsLayout];
}

+ (CGFloat)heightWith:(XTRecdDescModelItem *)itemModel{
    CGSize tSize = [itemModel.title sizeWithfont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(kMainScreenWidth - 16, MAXFLOAT)];
    CGSize mSize = [itemModel.updateTime sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kMainScreenWidth - 16, MAXFLOAT)];
    return tSize.height + mSize.height + 24;
}

@end
