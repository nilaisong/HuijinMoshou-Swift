//
//  OptionSelectedViewController.h
//  MoShou2
//
//  Created by wangzhenzhen on 15/11/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    kCustomerFastVC,   //快速报备页面
//    kCustomerListVC,   //客户列表页面//delete by wangzz 161020
    kCustomerDetailVC  //客户详情页面
}customerVCType;

typedef void (^optionSelectBlock) (NSMutableArray *,NSMutableDictionary*,NSMutableDictionary*);

@interface OptionSelectedViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *selectedOptions;
@property (nonatomic, strong) NSMutableDictionary *visitOptions;
@property (nonatomic, strong) NSMutableDictionary *confirmOptions;

@property (copy,nonatomic) optionSelectBlock optionSelectBlock;//传参block块
@property (nonatomic, assign) customerVCType  optionSelType;
@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *identitycard;

//@property (nonatomic, copy) NSString *bIsFullPhone;//true:全号 false: 隐号

-(void)returnResultBlock:(optionSelectBlock)ablock;

@end
