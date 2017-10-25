//
//  CompleteNumViewController.h
//  MoShou2
//
//  Created by wangzz on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    kfailCompleteCustomer,  //报备客户部分失败
    kfailCompleteBuilding  //报备楼盘部分失败
}failCompleteType;

@interface CompleteNumViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *completeData;
@property (nonatomic, assign) failCompleteType  reportFailCompleteType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)   NSString  *buildingId;
//@property (nonatomic, copy)   NSString  *customerId;
@property (nonatomic, copy) NSMutableDictionary   *custVisitDic;//客户是否展示到访信息
@property (nonatomic, strong) NSMutableDictionary   *confirmDic;//确客信息

@end
