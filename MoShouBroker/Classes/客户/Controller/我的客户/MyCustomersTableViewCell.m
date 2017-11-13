//
//  MyCustomersTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MyCustomersTableViewCell.h"
#import "MobileVisible.h"

@implementation MyCustomersTableViewCell
@synthesize telLabel;
@synthesize customerNameLabel;
@synthesize revertReportBtn;
@synthesize callBtn;
@synthesize statusLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer
{
    customerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth-150, 30)];//CGRectMake(headImageView.right+10, 5, kMainScreenWidth-headImageView.right-20, 20)
    customerNameLabel.textColor = NAVIGATIONTITLE;
    customerNameLabel.textAlignment = NSTextAlignmentLeft;
    //        customerNameLabel.backgroundColor = [UIColor yellowColor];
    customerNameLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:customerNameLabel];
    
    telLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerNameLabel.left, customerNameLabel.bottom, 120, 20)];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    telLabel.textColor = LABELCOLOR;//[UIColor colorWithHexString:@"0e0e0e"];
    [self.contentView addSubview:telLabel];
    
    callBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40-15, 15, 40, 40)];
    [callBtn setBackgroundColor:[UIColor clearColor]];
    [callBtn setImage:[UIImage imageNamed:@"button_call"] forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"button_call_h"] forState:UIControlStateHighlighted];
    [callBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:callBtn];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 40 - 60 - 15 - 10, 10, 60, 30)];
    statusLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = BLUEBTBCOLOR;//[UIColor colorWithHexString:@"252525"];
    [self.contentView addSubview:statusLabel];
    
    revertReportBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 40 - 60 - 15 - 10, 40, 60, 20)];
    [revertReportBtn setBackgroundColor:[UIColor whiteColor]];
    revertReportBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    revertReportBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [revertReportBtn setTitle:@"撤销报备" forState:UIControlStateNormal];
    [revertReportBtn setTitleColor:ORIGCOLOR forState:UIControlStateNormal];
    [revertReportBtn.layer setCornerRadius:4.0];
    [revertReportBtn.layer setMasksToBounds:YES];
    [revertReportBtn.layer setBorderWidth:0.5];
    revertReportBtn.layer.borderColor = ORIGCOLOR.CGColor;
    [revertReportBtn addTarget:self action:@selector(toggleReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:revertReportBtn];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"bHasCall"]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"bIsReport"]) {
            statusLabel.top = 20;
            revertReportBtn.hidden = YES;
        }
    }else{
        callBtn.hidden = YES;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"bIsReport"]) {
//            statusLabel.left = kMainScreenWidth - 60 - 15;
//            revertReportBtn.left = kMainScreenWidth - 60 - 15;
        }else
        {
            statusLabel.top = 20;
//            statusLabel.left = kMainScreenWidth - 60 - 15;
            revertReportBtn.hidden = YES;
        }
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"bHasQueKe"]) {
        _QueKeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(telLabel.left, telLabel.bottom, (statusLabel.left - telLabel.left)/2 - 7.5, 30)];
        _QueKeNameLabel.textColor = LABELCOLOR;
        _QueKeNameLabel.backgroundColor = [UIColor clearColor];
        _QueKeNameLabel.textAlignment = NSTextAlignmentLeft;
        _QueKeNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_QueKeNameLabel];
        
        _QueKeTelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_QueKeNameLabel.right+15, _QueKeNameLabel.top, telLabel.width, 30)];
        _QueKeTelLabel.textColor = LABELCOLOR;
        _QueKeTelLabel.backgroundColor = [UIColor clearColor];
        _QueKeTelLabel.textAlignment = NSTextAlignmentLeft;
        _QueKeTelLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_QueKeTelLabel];
    }
}

-(void)callMyCustomerCellBlock:(callMyCustomerBlock)ablock
{
    self.didSelectCallCustomer = ablock;
}

-(void)revertReportCellBlock:(revertReportMyCustomerBlock)ablock
{
    self.didSelectReportCustomer = ablock;
}

//拨打电话
- (void)toggleCallBtn:(UIButton*)sender
{
    if (_customerList.phoneList.count > 0) {
        NSString *phone = @"";
        MobileVisible *mobile = (MobileVisible*)[_customerList.phoneList objectForIndex:0];
        phone = mobile.hidingPhone;
        if (![self isBlankString:mobile.hidingPhone] && ![self isBlankString:mobile.totalPhone]) {
            if ([mobile.hidingPhone rangeOfString:@"****"].location != NSNotFound) {
                phone = mobile.totalPhone;
            }
        }
        _didSelectCallCustomer(phone);
    }
    
}

- (void)toggleReportBtn:(UIButton*)sender
{
    _didSelectReportCustomer(_customerList.buildingCustomerId);
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
