//
//  XTHomeBuildingCell.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/11/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTHomeBuildingCell.h"
#import "NSString+Extension.h"
#import "BuildingListData.h"

@interface XTHomeBuildingCell()

@property (nonatomic,weak)UIImageView* imgView;

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* priceLabel;

@property (nonatomic,weak)UILabel* areaLabel;

@property (nonatomic,weak)UIView* backView;

@property (nonatomic,weak)UIView* commissionView;//佣金view
@property (nonatomic,weak)UILabel* commissionLabel;//佣金label
@property (nonatomic,weak)UIImageView* commissionImg;//佣金图标

@property (nonatomic,weak)UIImageView* stopReportView;//停止报备


@property (nonatomic,strong)NSArray* tipImagesArray;

@end

@implementation XTHomeBuildingCell

+ (instancetype)buildingCellWithTableView:(UITableView *)tableView{
    NSString* cellName = NSStringFromClass([self class]);
    XTHomeBuildingCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        [tableView registerClass:[self class] forCellReuseIdentifier:cellName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    }
    return cell;
}

+ (instancetype)buildingCellWithTableView:(UITableView *)tableView data:(BuildingListData *)listData{
    XTHomeBuildingCell* cell = [self buildingCellWithTableView:tableView];
    cell.listData = listData;
    return cell;
}

+(CGFloat)buildingCellHeight{
    UIFont * font1 = [UIFont boldSystemFontOfSize:16];
    UIFont * font2 = [UIFont systemFontOfSize:12];
    NSString* str = @"测试";
    CGFloat height1 = [str sizeWithfont:font1 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat height2 = [str sizeWithfont:font2 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    return  (kMainScreenWidth - 20) * 175/355.0 + 40 * SCALE6 + height1 + height2 + 15;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    [self commonInit];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self imageView];
    
    [self commonInit];
}


- (void)commonInit{
    [self imageView];
    [self stopReportView];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    self.backView.backgroundColor = [UIColor whiteColor];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imgView.frame = CGRectMake(10, 0, kMainScreenWidth - 20, (kMainScreenWidth - 20) * 175/355.0);
    for (UIView* imgV in _imgView.subviews) {
        if ([imgV isKindOfClass:[UIImageView class]]) {
            [imgV removeFromSuperview];
        }
    }
    NSArray* imagesArray = [[self.tipImagesArray reverseObjectEnumerator] allObjects];
    for (int i = 0; i < imagesArray.count; i++) {
        UIImageView* imgV = _tipImagesArray[i];
        [_imgView addSubview:imgV];
        CGFloat offsetX = _imgView.width - 10 - 22 * (i + 1) - 5 * i;
        imgV.frame = CGRectMake(offsetX, 0, 22, 28);
    }
    
    CGSize areaSize = [self.areaLabel.text sizeWithfont:AreaFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize titleSize = [self.titleLabel.text sizeWithfont:TitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.backView.frame=  CGRectMake(10, CGRectGetMaxY(_imgView.frame), kMainScreenWidth - 20, 40 * SCALE6 + titleSize.height + areaSize.height);
    
    self.areaLabel.frame = CGRectMake(_backView.width - 10 - areaSize.width, 15 * SCALE6, areaSize.width , areaSize.height);
    
    
    self.titleLabel.frame = CGRectMake(10, 15 * SCALE6, _backView.width - 15 - areaSize.width, titleSize.height);
    
    self.priceLabel.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 10 * SCALE6, _backView.width - 20, 14);
    
    self.commissionImg.frame = CGRectMake(10, 7, 14, 14);
    CGSize commissionSize = [self.commissionLabel.text sizeWithfont:CommissionFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _commissionLabel.frame = CGRectMake(CGRectGetMaxX(_commissionImg.frame) + 5, 6, commissionSize.width, 17);
    self.commissionView.frame = CGRectMake(0, _imgView.height - 15 - 30,CGRectGetMaxX(_commissionLabel.frame) + 10,28);
    
    self.stopReportView.frame = CGRectMake(10, 0, 40, 40);
    
    _commissionView.layer.masksToBounds = YES;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_commissionView.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: (CGSize){5.0f, 5.0f}].CGPath;
    
    _commissionView.layer.mask = maskLayer;
    
    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.path = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){5.0f, 5.0f}].CGPath;
    
    _backView.layer.mask = maskLayer2;
}


- (void)setListData:(BuildingListData *)listData{
    _listData = listData;
    for (UIView* view in _tipImagesArray) {
        [view removeAllSubviews];
    }
    _tipImagesArray = nil;
    [self.titleLabel setText:listData.name];
    //    [self.priceLabel setText: [NSString stringWithFormat:@"均价%@",listData.price]];
    [self.priceLabel setText:listData.showPriceString];
    
    [self.areaLabel setText:listData.districtName];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[self homeBuildingUrlWithString:listData.url]] placeholderImage:[UIImage imageNamed:@"home-hotbuilding"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.commissionView.hidden = NO;
    self.commissionView.hidden = [listData.commissionDisplay boolValue];
    if (listData.formatCommissionStandard.length > 0) {
        self.commissionLabel.text = listData.formatCommissionStandard;
        
    }else{
        self.commissionView.hidden = YES;
    }
    //    self.stopReportView.hidden = NO;
    self.stopReportView.hidden = !listData.agencyReportType;
    //    self.commissionLabel.text = [NSString stringWithFormat:@"%@~%@万元",listData.commissionBegin,listData.commissionEnd];
    //    listData.featureTag 特色
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - getter

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setFont:PriceFont];
        [label setTextColor:PriceColor];
        [self.backView addSubview:label];
        _priceLabel = label;
    }
    return _priceLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        
        [label setFont:TitleFont];
        [label setTextColor:TitleColor];
        [self.backView addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)areaLabel{
    if (!_areaLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setFont:AreaFont];
        [label setTextColor:AreaColor];
        [self.backView addSubview:label];
        _areaLabel = label;
    }
    return _areaLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        UIImageView* imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, (kMainScreenWidth - 20) * 175/355.0)];
        [imgV setImage:[UIImage imageNamed:@"home-hotbuilding"]];
        [self.contentView addSubview:imgV];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.layer.masksToBounds = YES;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:imgV.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){5.0f, 5.0f}].CGPath;
        
        imgV.layer.mask = maskLayer;
        _imgView = imgV;
    }
    return _imgView;
}

- (NSArray *)tipImagesArray{
    if (!_tipImagesArray) {
        UIImageView* imgV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"building-new"]];
        
        UIImageView* imgV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"building-specialprice"]];
        UIImageView* imgV3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"building-hot"]];
        imgV1.frame = CGRectMake(0, 0, 22, 28);
        imgV2.frame = CGRectMake(0, 0, 22, 28);
        imgV3.frame = CGRectMake(0, 0, 22, 28);
        
        NSMutableArray* arrayM = [NSMutableArray array];
        if (_listData.isHot) {
            [arrayM appendObject:imgV3];
        }
        if (_listData.isSpecialPrice) {
            [arrayM appendObject:imgV2];
        }
        if (_listData.isNew) {
            [arrayM appendObject:imgV1];
        }
        _tipImagesArray = arrayM;
    }
    return _tipImagesArray;
}

- (UIView *)backView{
    if (!_backView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 20, 68 * SCALE6)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        view.layer.masksToBounds = YES;
        
        
        _backView = view;
    }
    return _backView;
}

//佣金视图
- (UIView *)commissionView{
    if (!_commissionView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"37AEFF"];
        
        [self.imgView addSubview:view];
        _commissionView = view;
    }
    return _commissionView;
}

-(UIImageView *)stopReportView
{
    if (!_stopReportView) {
        UIImageView *imageView =[[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"stopReport.png"];
        [self.contentView addSubview:imageView];
        _stopReportView =imageView;
    }
    return _stopReportView;
}




- (UIImageView *)commissionImg{
    if (!_commissionImg) {
        UIImageView* imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home-commission"]];
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


- (NSString*)homeBuildingUrlWithString:(NSString*)string{
    if (string.length > 0) {
#warning 这的图片没有后台切图       2017-02-27 15:31:41 PHP 组的李孝冰加上了
        return [NSString stringWithFormat:@"%@_710x350.%@",string,string.pathExtension];
        //        return string;
    }
    return string;
}


@end
