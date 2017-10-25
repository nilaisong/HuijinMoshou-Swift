//
//  BuildFollowDetailViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "TradeRecord.h"

@interface BuildFollowDetailViewController : BaseViewController

@property (nonatomic, copy) NSString         *customerId;
@property (nonatomic, copy) NSString         *customerName;
@property (nonatomic, copy) NSString         *customerPhone;
@property (nonatomic, strong) TradeRecord    *trade;
@property (nonatomic, assign) NSInteger      row;
@property (nonatomic, assign) BOOL           bIsMessageDetail;
@property (nonatomic, copy) NSString         *waitConfirmId;
@property (nonatomic, copy) NSString         *bizNodeId;
@property (nonatomic, copy) NSString         *bizType;

@end
