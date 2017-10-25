//
//  CustomerShowVisitInfoView.h
//  MoShou2
//
//  Created by wangzz on 16/7/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kShowVisitInfo,
    kShowConfirmInfo
}showType;

@interface CustomerShowVisitInfoView : UIView

//@property (nonatomic, assign) BOOL    mechanismType;
@property (nonatomic, assign) showType showInfoType;

@property (nonatomic, strong) UILabel *visitDateLabel;
@property (nonatomic, strong) UILabel *visitCountLabel;
@property (nonatomic, strong) UILabel *visitFuncLabel;
@property (nonatomic, strong) UILabel *confirmUserLabel;

@end
