//
//  ReportTipViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "ReportReturnData.h"

typedef enum {
    kfailCustomer,  //报备客户部分失败
    kfailBuilding  //报备楼盘部分失败
}failType;

@interface ReportTipViewController : BaseViewController

@property (nonatomic, strong) ReportReturnData *reportData;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) failType  reportFailType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)   NSString  *buildingId;
@property (nonatomic, copy)   NSString  *customerId;
@property (nonatomic, strong) NSMutableDictionary   *custVisitDic;//客户是否展示到访信息
@property (nonatomic, strong) NSMutableDictionary   *confirmDic;//确客信息

@end
