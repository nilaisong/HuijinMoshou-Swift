//
//  CustomerVisitInfoView.h
//  MoShou2
//
//  Created by wangzz on 16/6/27.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerVisitInfoData.h"
#import "ConfirmUserInfoObject.h"

typedef void(^showtipEndDateBlock)();
typedef void(^cancelButtonSelectedBlock)();
typedef void(^saveButtonSelectedBlock)(CustomerVisitInfoData*,ConfirmUserInfoObject*);

@interface CustomerVisitInfoView : UIView

@property (nonatomic, strong) CustomerVisitInfoData *visitInfoData;
@property (nonatomic, strong) ConfirmUserInfoObject *confirmInfoData;

@property (nonatomic, assign) BOOL   bIsShowConfirm;
@property (nonatomic, strong) NSMutableArray        *confirmMutArr;

@property (nonatomic, copy) showtipEndDateBlock didShowTip;
@property (nonatomic, copy) saveButtonSelectedBlock didSelectedSaveBtn;
@property (nonatomic, copy) cancelButtonSelectedBlock didSelectedCancelBtn;

- (void)seleteEndDateBlock:(showtipEndDateBlock)ablock;
- (void)seleteSaveButtonBlock:(saveButtonSelectedBlock)ablock;
- (void)seleteCancelButtonBlock:(cancelButtonSelectedBlock)ablock;

@end
