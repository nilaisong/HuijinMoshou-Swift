//
//  CustomerDetailHeaderView.m
//  MoShou2
//
//  Created by wangzz on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerDetailHeaderView.h"

@interface CustomerDetailHeaderView ()

//@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation CustomerDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

#pragma mark-------------数据源
- (void)setTrade:(TradeRecord *)trade {
    if (_trade != trade) {
        _trade = trade;
    }
    [self layoutUI];
}

- (void)layoutUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:[self createLineView:0 withX:0]];
    [self addSubview:[self createLineView:self.height-0.5 withX:0]];
    
    UIImageView *loupImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    [loupImgView setImage:[UIImage imageNamed:@"mine_loupan"]];
    [self addSubview:loupImgView];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize size2 = [_trade.buildingName sizeWithAttributes:attributes];
    UILabel *loupanName = [[UILabel alloc] initWithFrame:CGRectMake(loupImgView.right+5, 10, MIN(size2.width, kMainScreenWidth-5-5-50-loupImgView.right), 30)];
    loupanName.textColor = NAVIGATIONTITLE;
    loupanName.font = [UIFont systemFontOfSize:17];
    loupanName.text = _trade.buildingName;
    [self addSubview:loupanName];
    
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.frame = CGRectMake(kMainScreenWidth - 32, 21, 16, 8);
    [self addSubview:_arrowImgView];
    
    UIButton *openBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    openBtn.backgroundColor = [UIColor clearColor];
    openBtn.selected = self.isSelected;
    if (openBtn.selected) {
        [_arrowImgView setImage:[UIImage imageNamed:@"arrow_up"]];
    }else
    {
        [_arrowImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    [openBtn addTarget:self action:@selector(toggleOpenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openBtn];
    
    if ([_trade.showURL boolValue]) {
        UIButton *QRCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(loupanName.right+5, 13, 24, 24)];
        [QRCodeBtn setImage:[UIImage imageNamed:@"iconfont_erweima"] forState:UIControlStateNormal];
        [QRCodeBtn addTarget:self action:@selector(toggleQRCodeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:QRCodeBtn];
    }
    
}

//创建线条
- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    lineView.backgroundColor = CustomerBorderColor;
    return lineView;
}

-(void)createEncodingViewBlock:(QRCodeButtonBlock)ablock
{
    self.QRCodeButton = ablock;
}

-(void)changeOpenButtonBlock:(OpenButtonBlock)ablock
{
    self.openButton = ablock;
}

//生成二维码
- (void)toggleQRCodeButton:(UIButton*)sender
{
    self.QRCodeButton(_trade.url);
}

- (void)toggleOpenButton:(UIButton*)sender
{
    if (!sender.selected) {
        sender.selected = YES;
        [_arrowImgView setImage:[UIImage imageNamed:@"arrow_up"]];
    }else
    {
        sender.selected = NO;
        [_arrowImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    self.openButton(sender.selected);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
