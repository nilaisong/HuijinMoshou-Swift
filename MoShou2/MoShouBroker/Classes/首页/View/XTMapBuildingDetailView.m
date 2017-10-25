//
//  XTMapBuildingDetailView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/7.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapBuildingDetailView.h"
#import "NSString+Extension.h"

@interface XTMapBuildingDetailView()

@property (nonatomic,weak)UIImageView* imageView;

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* addressLabel;

@property (nonatomic,weak)UILabel* priceLabel;

@property (nonatomic,weak)UIView* commissionView;//佣金view
@property (nonatomic,weak)UILabel* commissionLabel;//佣金label
@property (nonatomic,weak)UIImageView* commissionImg;//佣金图标

@end

@implementation XTMapBuildingDetailView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
 
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView.frame = CGRectMake(0, 0, kMainScreenWidth, 200 * SCALE6);
    
    CGSize titleSize = [self.titleLabel.text sizeWithfont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize priceSize = [self.priceLabel.text sizeWithfont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.titleLabel.frame = CGRectMake(10, 15 * SCALE6 + CGRectGetMaxY(_imageView.frame), kMainScreenWidth - 25 - priceSize.width, titleSize.height);
    
    self.priceLabel.frame = CGRectMake(kMainScreenWidth - 10 - priceSize.width, 15 * SCALE6 + CGRectGetMaxY(_imageView.frame), priceSize.width, priceSize.height);
    
    CGSize addressSize = [self.addressLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kMainScreenWidth - 20, MAXFLOAT)];
    
    self.addressLabel.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 10 * SCALE6, kMainScreenWidth - 20, addressSize.height);
    
    self.commissionImg.frame = CGRectMake(10, 7, 14, 14);
    CGSize commissionSize = [self.commissionLabel.text sizeWithfont:CommissionFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.commissionLabel.frame = CGRectMake(CGRectGetMaxX(_commissionImg.frame) + 5, 6, commissionSize.width, 17);
    self.commissionView.frame = CGRectMake(0, _imageView.height - 15 - 30,CGRectGetMaxX(_commissionLabel.frame) + 10,28);
    
    _commissionView.layer.masksToBounds = YES;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_commissionView.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: (CGSize){5.0f, 5.0f}].CGPath;
    
    _commissionView.layer.mask = maskLayer;
    
}


- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认图片首页"]];
        [self addSubview:imageView];
        _imageView = imageView;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (void)tapAction:(UIGestureRecognizer*)gest{
    if ([_delegate respondsToSelector:@selector(mapBuildingDetailView:didSelectedImageView:)]) {
        [_delegate mapBuildingDetailView:self didSelectedImageView:_infoModel];
    }
}


- (UILabel *)priceLabel{
    if (!_priceLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"ff6600"];
        [self addSubview:label];
        _priceLabel = label;
    }
    return _priceLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:label];
        _titleLabel  = label;
    }
    return _titleLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"888888"];
        [self addSubview:label];
        label.numberOfLines = 0;
        _addressLabel = label;
    }
    return _addressLabel;
}


//佣金视图
- (UIView *)commissionView{
    if (!_commissionView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"37AEFF"];
        
        [self.imageView addSubview:view];
        _commissionView = view;
    }
    return _commissionView;
}

- (UIImageView *)commissionImg{
    if (!_commissionImg) {
        UIImageView* imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home-commission"]];
        imgv.contentMode = UIViewContentModeScaleAspectFit;
        //        imgv.backgroundColor = [UIColor grayColor];
        [self.commissionView addSubview:imgv];
        _commissionImg = imgv;
    }
    return _commissionImg;
}

- (UILabel *)commissionLabel{
    if (!_commissionLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setFont:CommissionFont];
        [label setTextColor:[UIColor whiteColor]];
        [self.commissionView addSubview:label];
        _commissionLabel = label;
    }
    return _commissionLabel;
}

- (void)setInfoModel:(XTMapBuildInfoModel *)infoModel{
    _infoModel = infoModel;
    
    if (_infoModel.name.length > 0) {
        [self.titleLabel setText:infoModel.name];
    }
    
    if (_infoModel.price.length > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"均价%@元/平",infoModel.price];
        self.priceLabel.hidden = NO;
    }else{
        self.priceLabel.hidden = YES;
    }
    
    if (infoModel.address.length > 0) {
        self.addressLabel.text = infoModel.address;
        self.addressLabel.hidden = NO;
    }else{
        self.addressLabel.hidden = YES;
    }
 
    self.commissionView.hidden = NO;
    self.commissionView.hidden = [infoModel.commissionDisplay boolValue];
    if (infoModel.formatCommissionStandard.length > 0) {
        self.commissionLabel.text = infoModel.formatCommissionStandard;
        
    }else{
        self.commissionView.hidden = YES;
    }
    
    if (infoModel.thmUrl.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:infoModel.thmUrl] placeholderImage:[UIImage imageNamed:@"mapbuild-building"]];
    }
    
    [self setNeedsLayout];
}


+ (CGFloat)heightWith:(XTMapBuildInfoModel *)infoModel{
    CGSize titleSize = [infoModel.name sizeWithfont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize addressSize = [infoModel.address sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kMainScreenWidth - 20, MAXFLOAT)];
    return 240 * SCALE6 + titleSize.height + addressSize.height;
}

@end
