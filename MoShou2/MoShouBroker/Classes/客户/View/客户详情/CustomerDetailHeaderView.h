//
//  CustomerDetailHeaderView.h
//  MoShou2
//
//  Created by wangzz on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeRecord.h"

typedef void(^QRCodeButtonBlock)(NSString*);
typedef void(^OpenButtonBlock)(BOOL);

@interface CustomerDetailHeaderView : UIView

@property (nonatomic, assign) BOOL    isSelected;
@property (nonatomic, strong) TradeRecord  *trade;
@property (nonatomic, copy) OpenButtonBlock openButton;
@property (nonatomic, copy) QRCodeButtonBlock QRCodeButton;

-(void)changeOpenButtonBlock:(OpenButtonBlock)ablock;
-(void)createEncodingViewBlock:(QRCodeButtonBlock)ablock;

@end
