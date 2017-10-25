//
//  CustomerDetailTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeRecord.h"
#import "ProgressStatus.h"

typedef void(^QRCodeButtonBlock)(NSString*);

@interface CustomerDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel          *buildingNameL;
@property (nonatomic, strong) UIButton         *QRCodeBtn;
@property (nonatomic, strong) TradeRecord      *tradeRecord;
@property (nonatomic, strong) ProgressStatus   *progressDataSource;
@property (nonatomic, copy) QRCodeButtonBlock  QRCodeButton;

-(void)createEncodingViewBlock:(QRCodeButtonBlock)ablock;

@end
