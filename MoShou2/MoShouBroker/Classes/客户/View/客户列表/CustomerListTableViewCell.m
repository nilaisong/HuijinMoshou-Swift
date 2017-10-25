//
//  CustomerListTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerListTableViewCell.h"

@implementation CustomerListTableViewCell
@synthesize telLabel;
@synthesize customerNameLabel;
//@synthesize purchaseIntentionLabel;
@synthesize callBtn;
//@synthesize reportBtn;//delete by wangzz 161020
@synthesize selectedBtn;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithShop:(BOOL)bIsShop CallHidden:(BOOL)bIsCallHidden AndSelectedHidden:(BOOL)bIsSelHidden PurchaseHidden:(BOOL)bIsPurHidden
{
    self = [super init];
    if (self) {
        customerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, kMainScreenWidth-150, 30)];//CGRectMake(headImageView.right+10, 5, kMainScreenWidth-headImageView.right-20, 20)
        customerNameLabel.textColor = NAVIGATIONTITLE;
        customerNameLabel.textAlignment = NSTextAlignmentLeft;
        //        customerNameLabel.backgroundColor = [UIColor yellowColor];
        customerNameLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:customerNameLabel];
        
        telLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerNameLabel.left, customerNameLabel.bottom, 120, 20)];
        telLabel.backgroundColor = [UIColor clearColor];
        telLabel.textAlignment = NSTextAlignmentLeft;
        telLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
        telLabel.textColor = LABELCOLOR;;//[UIColor colorWithHexString:@"0e0e0e"];
        [self.contentView addSubview:telLabel];
        
//        purchaseIntentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(telLabel.left, telLabel.bottom, kMainScreenWidth - telLabel.left - 120, 30)];
//        purchaseIntentionLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
//        purchaseIntentionLabel.textColor = LABELCOLOR;//[UIColor colorWithHexString:@"252525"];
//        [self.contentView addSubview:purchaseIntentionLabel];
        
        callBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-40-25, (telLabel.bottom+10)/2 -20, 40, 40)];
        [callBtn setBackgroundColor:[UIColor clearColor]];
        [callBtn setImage:[UIImage imageNamed:@"button_call"] forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"button_call_h"] forState:UIControlStateHighlighted];
        [callBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
//delete by wangzz 161020
//        reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 40 - 40 - 25 - 10, callBtn.top, 40, 40)];
//        [reportBtn setBackgroundColor:[UIColor clearColor]];
//        [reportBtn setImage:[UIImage imageNamed:@"button_report"] forState:UIControlStateNormal];
//        [reportBtn setImage:[UIImage imageNamed:@"button_report_h"] forState:UIControlStateHighlighted];
//        [reportBtn addTarget:self action:@selector(toggleReportBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:reportBtn];
//end
        selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(kMainScreenWidth-40-25, (telLabel.bottom+10)/2 -20, 40, 40);
        [selectedBtn setBackgroundColor:[UIColor clearColor]];
        [selectedBtn setImage:[UIImage imageNamed:@"big_selected"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"big_selected_h"] forState:UIControlStateSelected];
        [selectedBtn addTarget:self action:@selector(toggleSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectedBtn];
        
        if (bIsPurHidden) {
            if (bIsSelHidden) {
//                purchaseIntentionLabel.hidden = YES;
                callBtn.hidden = YES;
//                reportBtn.hidden = YES;//delete by wangzz 161020
                selectedBtn.hidden = YES;
            }else
            {
//                purchaseIntentionLabel.hidden = YES;
                callBtn.hidden = YES;
//                reportBtn.hidden = YES;//delete by wangzz 161020
            }
        }
        else{
            if (bIsShop) {
                if (bIsCallHidden) {
                    callBtn.hidden = YES;
//                    reportBtn.frame = callBtn.frame;//delete by wangzz 161020
                    selectedBtn.hidden = YES;
                }else
                {
                    selectedBtn.hidden = YES;
                }
            }else{
                if (bIsCallHidden) {
                    callBtn.hidden = YES;
                }
//                reportBtn.hidden = YES;//delete by wangzz 161020
                selectedBtn.hidden = YES;
            }
        }
        
    }
    
//    BOOL showVisit = [[NSUserDefaults standardUserDefaults] boolForKey:@"bIsShowVisitInfo"];
//    BOOL showConfirm = [[NSUserDefaults standardUserDefaults] boolForKey:@"bIsShowConfirmInfo"];
//    if (showVisit) {
//        selectedBtn.centerY = 75;
//        _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(customerNameLabel.left, telLabel.bottom+5, kMainScreenWidth*18/25, 70)];
//        _showVisitInfoView.showInfoType = kShowVisitInfo;
//        [self.contentView addSubview:_showVisitInfoView];
//        if (showConfirm) {
//            selectedBtn.centerY = 85;
//            _showVisitInfoView.height = 90;
//        }
//    }else
//    {
//        if (showConfirm) {
//            selectedBtn.centerY = 60;
////            _showVisitInfoView.height = 90;
//            _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(customerNameLabel.left, telLabel.bottom+5, kMainScreenWidth*18/25, 40)];
//            _showVisitInfoView.showInfoType = kShowConfirmInfo;
//            [self.contentView addSubview:_showVisitInfoView];
//        }
//    }
    
    return self;
}

//-(void)setBIsShowVisitInfo:(BOOL)bIsShowVisitInfo
//{
//    if (_bIsShowVisitInfo != bIsShowVisitInfo) {
//        _bIsShowVisitInfo = bIsShowVisitInfo;
//    }
//    if (_bIsShowVisitInfo) {
//        
//    }
//}

-(void)setBIsShowVisitInfo:(BOOL)bIsShowVisitInfo
{
    if (_bIsShowVisitInfo != bIsShowVisitInfo) {
        _bIsShowVisitInfo = bIsShowVisitInfo;
    }
    if (_bIsShowVisitInfo) {
        selectedBtn.centerY = 75;
        _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(customerNameLabel.left, telLabel.bottom+5, kMainScreenWidth*18.5/25, 70)];
        _showVisitInfoView.showInfoType = kShowVisitInfo;
        [self.contentView addSubview:_showVisitInfoView];
        if (_bIsShowConfirmInfo) {
            selectedBtn.centerY = 85;
            _showVisitInfoView.height = 90;
        }
    }
}

-(void)setBIsShowConfirmInfo:(BOOL)bIsShowConfirmInfo
{
    if (_bIsShowConfirmInfo != bIsShowConfirmInfo) {
        _bIsShowConfirmInfo = bIsShowConfirmInfo;
    }
    
    if (_bIsShowConfirmInfo) {
        if (_bIsShowVisitInfo) {
            selectedBtn.centerY = 85;
            _showVisitInfoView.height = 90;
        }else
        {
            selectedBtn.centerY = 60;
            _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(customerNameLabel.left, telLabel.bottom+5, kMainScreenWidth*18.5/25, 30)];
            _showVisitInfoView.showInfoType = kShowConfirmInfo;
            [self.contentView addSubview:_showVisitInfoView];
            
        }
    }
}

//拨打电话
- (void)toggleCallBtn:(UIButton*)sender
{
    _didSelectCallCustomer(self);
}
//delete by wangzz 161020
//- (void)toggleReportBtn:(UIButton*)sender
//{
//    _didSelectReportCustomer(self);
//}
//end
- (void)toggleSelectedBtn:(UIButton*)sender
{
    if (!sender.selected) {
        sender.selected = YES;
    }else
    {
        sender.selected = NO;
    }
    _didSelectCustomer(self,sender.selected);
}

-(void)selectCallBlock:(callCustomerBlock)ablock
{
    self.didSelectCallCustomer = ablock;
}
//delete by wangzz 161020
//-(void)selectReportBlock:(reportCustomerBlock)ablock
//{
//    self.didSelectReportCustomer = ablock;
//}
//end
-(void)selectCustomerBlock:(selecteCustomerBlock)ablock
{
    self.didSelectCustomer = ablock;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
