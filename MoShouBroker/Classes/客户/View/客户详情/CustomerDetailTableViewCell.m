//
//  CustomerDetailTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerDetailTableViewCell.h"
#import "MoshouProgressView.h"

@implementation CustomerDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setProgressDataSource:(ProgressStatus *)progressDataSource
{
    if (_progressDataSource != progressDataSource) {
        _progressDataSource = progressDataSource;
    }
    [self layoutUI];
}

- (void)layoutUI
{
    CGSize nameSize = [_tradeRecord.buildingName sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    _buildingNameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, MIN(nameSize.width,nameSize.width), nameSize.height)];
    _buildingNameL.textColor = NAVIGATIONTITLE;
    _buildingNameL.text = _tradeRecord.buildingName;
    _buildingNameL.font =FONT(15);
    [self.contentView addSubview:_buildingNameL];
    
    CGSize descSize = [[NSString stringWithFormat:@"(%@)",_progressDataSource.descriptionText] sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_buildingNameL.left, _buildingNameL.bottom+10, descSize.width, _buildingNameL.height)];
    label.font = FONT(15);
    label.text = [NSString stringWithFormat:@"(%@)",_progressDataSource.descriptionText];
    label.textColor = ORIGCOLOR;
    label.textAlignment = NSTextAlignmentLeft;
    CGFloat width = _buildingNameL.right;
    if (![self isBlankString:_progressDataSource.descriptionText]) {
        [self.contentView addSubview:label];
    }
    
    if ([_tradeRecord.showURL boolValue]) {
        UIButton *QRCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(width+10, _buildingNameL.centerY-12, 24, 24)];
        [QRCodeBtn setImage:[UIImage imageNamed:@"iconfont_erweima"] forState:UIControlStateNormal];
        [QRCodeBtn addTarget:self action:@selector(toggleQRCodeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:QRCodeBtn];
        if (QRCodeBtn.right > kMainScreenWidth-20-_buildingNameL.height*8/14) {
            _buildingNameL.width = kMainScreenWidth-(10+10+_buildingNameL.height*8/14+QRCodeBtn.width+10+10);
//            label.left = _buildingNameL.right+10;
            QRCodeBtn.left = label.right+10;
        }
    }else {
        if (_buildingNameL.right > kMainScreenWidth-20-_buildingNameL.height*8/14) {
            _buildingNameL.width = kMainScreenWidth-(10+10+_buildingNameL.height*8/14+10);
//            label.left = _buildingNameL.right+10;
        }
    }
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-_buildingNameL.height*8/14, _buildingNameL.top, _buildingNameL.height*8/14, _buildingNameL.height)];
    [arrowImgView setImage:[UIImage imageNamed:@"arrow-right"]];
    [self.contentView addSubview:arrowImgView];
    
//    [self.contentView addSubview:[self createLineView:49.5 withX:15]];
    
    MoshouProgressView *progressView = [[MoshouProgressView alloc] initWithFrame:CGRectMake(0, 70, kMainScreenWidth, 90)];
    progressView.progressDataSource = _progressDataSource;
    [self.contentView addSubview:progressView];
    
    [self.contentView addSubview:[self createLineView:0 withX:10]];//130-0.5
}

//创建线条
- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    lineView.backgroundColor = CustomerBorderColor;
    return lineView;
}

//生成二维码
- (void)toggleQRCodeButton:(UIButton*)sender
{
    self.QRCodeButton(_tradeRecord.url);
}

-(void)createEncodingViewBlock:(QRCodeButtonBlock)ablock
{
    self.QRCodeButton = ablock;
}

- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
