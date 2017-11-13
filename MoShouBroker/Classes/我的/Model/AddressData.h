//
//  AddressData.h
//  MoShou2
//
//  Created by wangzz on 2017/2/22.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressData : NSObject

@property (nonatomic, strong) NSString   *addressId;//收货地址id
@property (nonatomic, strong) NSString   *userId;//经纪人id
@property (nonatomic, strong) NSString   *receiverUser;//收货人
@property (nonatomic, strong) NSString   *receiverMobile;//收货电话
@property (nonatomic, strong) NSString   *receiverAddress;//收货地址
@property (nonatomic, strong) NSString   *createTime;//创建时间
@property (nonatomic, strong) NSString   *updater;//更新者id
@property (nonatomic, strong) NSString   *updateTime;//更行时间
@property (nonatomic, strong) NSString   *delFlag;//删除标志
//@property (nonatomic, strong) NSString   *address;//

@end
