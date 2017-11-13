//
//  NewAddressViewController.h
//  MoShou2
//
//  Created by wangzz on 2017/2/22.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressData.h"
typedef enum {
    kNewAddress,  //添加新地址
    kEditAddress  //编辑地址
}modiftAddressType;

typedef void(^SaveAddressBlock)();

@interface NewAddressViewController : BaseViewController

@property (nonatomic, assign) modiftAddressType    addressType;
@property (nonatomic, strong) AddressData          *addressData;
@property (nonatomic, copy) SaveAddressBlock        saveAddressButton;

-(void)saveModifyAddressBlock:(SaveAddressBlock)ablock;

@end
