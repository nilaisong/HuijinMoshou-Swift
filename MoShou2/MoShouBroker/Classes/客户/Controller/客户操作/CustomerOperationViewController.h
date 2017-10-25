//
//  CustomerOperationViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFactory+Customer.h"

typedef enum {
    kAddNewCustomer,  //添加新客户
//    kReportNewCustomer,//报备新客户
    kModifyCustomer  //编辑客户
}viewControllerType;

//typedef enum {
//    kAddTFBtn,//显示添加按钮
//    kDeleteTFBtn,//显示删除按钮
//    kNoneTFBtn//不显示按钮
//}textFieldButtonType;

@interface CustomerOperationViewController : BaseViewController<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *buildingID;
@property (nonatomic, copy) NSString *customerTelType;// 全号  隐号报备 (0 :全号隐号均可     1:仅全号)
//@property (nonatomic, copy) NSString *customerName;
//@property (nonatomic, copy) NSString *phone;
//@property (nonatomic, assign) BOOL bIsCustomerList;//是否从客户列表进入该页面
@property (nonatomic, assign) BOOL bCanModify;//是否可以修改客户手机号码

@property (nonatomic, assign) viewControllerType  customerViewCtrlType;
//@property (nonatomic, assign) textFieldButtonType textBtnType;
@property (nonatomic, strong) Customer *customerData;//修改页面需要的客户数组
@property (nonatomic, strong) OptionData  *groupData;
//@property (nonatomic, assign) BOOL      bIsShowVisitInfo;//当某楼盘设定了报备客户必须要录入客户到访信息（预计到访时间、预计到访人数、交通方式），不填写无法报备成功
//@property (nonatomic, assign) BOOL   bIsShowConfirm;
//@property (nonatomic, strong) NSMutableArray *confirmArr;

@property (nonatomic, assign) NSInteger pageType;

@end
