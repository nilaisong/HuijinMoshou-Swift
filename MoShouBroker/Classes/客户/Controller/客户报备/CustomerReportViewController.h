//
//  CustomerReportViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFactory+Customer.h"

@interface CustomerReportViewController : BaseViewController

@property (nonatomic,copy) NSString     *buildingID;
@property (nonatomic,copy) NSString     *buildingName;//楼盘名
@property (nonatomic,copy) NSString     *buildDistance;//楼盘距离
@property (nonatomic,copy) NSString     *featureTag;//楼盘标签
@property (nonatomic,copy) NSString     *commission;//佣金
@property (nonatomic,copy) NSString     *customerTelType;// 全号  隐号报备 (0 :全号隐号均可     1:仅全号)
@property (nonatomic, assign) NSInteger type;//跳转页面使用 (1、楼盘列表页跳转过来 2、楼盘详情跳转过来)
@property (nonatomic, assign) BOOL      bIsShowVisitInfo;//当某楼盘设定了报备客户必须要录入客户到访信息（预计到访时间、预计到访人数、交通方式），不填写无法报备成功

@property (nonatomic, assign) BOOL      mechanismType;//报备机制   0默认报备   1为选择确客报备
@property (nonatomic, copy) NSString    *mechanismText;//顶部提示语

@property (nonatomic, strong) Customer *customerData;//修改页面需要的客户数组
@property (nonatomic, strong) OptionData  *groupData;
@property (nonatomic, assign) NSInteger pageType;

@end
