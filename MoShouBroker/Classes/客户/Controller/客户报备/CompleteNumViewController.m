//
//  CompleteNumViewController.m
//  MoShou2
//
//  Created by wangzz on 16/5/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CompleteNumViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CompleteNumberView.h"
#import "BuildingDetailViewController.h"
#import "MyBuildingViewController.h"
#import "CustomerDetailViewController.h"
#import "QuickReportViewController.h"

#import "DataFactory+Customer.h"
#import "FailListData.h"
#import "Customer.h"
#import "MobileVisible.h"
#import "CustomerVisitInfoData.h"
#import "ConfirmUserInfoObject.h"

@interface CompleteNumViewController ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *customerArray;
@property (nonatomic, strong) NSMutableArray *viewArray;

@property (nonatomic, assign) NSInteger      tag;
@property (nonatomic, assign) BOOL             bIsTouched;

@end

@implementation CompleteNumViewController
@synthesize scrollView;
@synthesize customerArray;
@synthesize viewArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"补全手机号";
    
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height - viewTopY - 44)];
    scrollView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:scrollView];
    
    customerArray = [[NSMutableArray alloc] init];
    viewArray = [[NSMutableArray alloc] init];
    
    if (_reportFailCompleteType == kfailCompleteBuilding) {
        if (_completeData.count>0) {
            [customerArray appendObject:[_completeData objectForIndex:0]];
        }
    }else
    {
        customerArray = _completeData;
    }
    
    [self createCompleteNumView];
    [self createBottomView];
    
    
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];

    if (self.scrollView.superview) {
        self.scrollView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY-44);
    }
}

- (void)createCompleteNumView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth-30, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"请补全报备失败的客户手机号";
    label.textColor = LABELCOLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = FONT(14);
    [scrollView addSubview:label];
    _tag = 0;
    if (customerArray.count>0) {
        for (int i=0; i<customerArray.count; i++) {
            FailListData *cust = (FailListData*)[customerArray objectForIndex:i];
            NSLog(@"cust.phoneList is %@",cust.phoneList);
            for (int j=0; j<cust.phoneList.count; j++) {
                MobileVisible *mobile = (MobileVisible*)[cust.phoneList objectForIndex:j];
                CompleteNumberView *completeView = [[CompleteNumberView alloc] initWithFrame:CGRectMake(0, label.bottom+10+44*_tag, kMainScreenWidth, 44)];
                completeView.tag = _tag;
                completeView.index = _tag;
                completeView.phone = mobile.hidingPhone;
                completeView.nameLabel.text = cust.name;
                if (j==0) {
                    completeView.nameLabel.hidden = NO;
                }
                __weak CompleteNumViewController *weakSelf = self;
                [completeView completeTextFieldDidChangedBlock:^(NSInteger index) {
                    if (index < weakSelf.tag) {
                        CompleteNumberView *view = nil;
                        if (weakSelf.viewArray.count > index+1) {
                            view = (CompleteNumberView*)[weakSelf.viewArray objectForIndex:index+1];
                        }
                        [view.middleNum becomeFirstResponder];
                    }else if (index == weakSelf.tag)
                    {
                        CompleteNumberView *view = nil;
                        if (weakSelf.viewArray.count > index) {
                            view = (CompleteNumberView*)[weakSelf.viewArray objectForIndex:index];
                        }
                        [view.middleNum resignFirstResponder];
                    }
                    
                }];
                [scrollView addSubview:completeView];
                [viewArray appendObject:completeView];
                NSLog(@"before completeView.tag is %ld",(long)_tag);
                _tag++;
                NSLog(@"completeView.tag is %ld",(long)_tag);
                scrollView.contentSize = CGSizeMake(kMainScreenWidth, completeView.bottom);
            }
        }
        _tag--;
    }
}

- (void)createBottomView
{
    UIButton *reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, kMainScreenWidth, 44)];//CGRectMake(0, kMainScreenHeight-44, kMainScreenWidth, 44)
    [reportBtn setBackgroundColor:BLUEBTBCOLOR];
    reportBtn.titleLabel.font = FONT(17);
    [reportBtn setTitle:@"报备" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportBtn addTarget:self action:@selector(toggleReportButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportBtn];
}

- (void)toggleReportButton:(UIButton*)sender
{
    NSMutableDictionary *completeDic = [[NSMutableDictionary alloc] init];
    NSString *buildingId = @"";
    NSString *type = @"";
    NSString *visitInfo = @"";
    NSString *confirmInfo = @"";
    NSMutableArray *buildArr = [[NSMutableArray alloc] init];
    NSMutableArray *confirmArr = [[NSMutableArray alloc] init];
    if (self.reportFailCompleteType == kfailCompleteBuilding) {
        NSLog(@"kfailCompleteBuilding");
        type = @"0";
        for (int i=0; i<_completeData.count; i++) {
            FailListData *cust = (FailListData*)[_completeData objectForIndex:i];
            if (i==0) {
                buildingId = cust.buildingId;
            }else
            {
                buildingId = [NSString stringWithFormat:@"%@,%@",buildingId,cust.buildingId];
            }
            CustomerVisitInfoData *visitData = (CustomerVisitInfoData*)[_custVisitDic valueForKey:cust.buildingId];
            
            if (visitData != nil) {
                NSMutableDictionary *buildDic = [[NSMutableDictionary alloc] init];
                [buildDic setValue:cust.buildingId forKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                NSString *startStr = [dateFormatter stringFromDate:visitData.startDate];
                NSString *endStr = [dateFormatter stringFromDate:visitData.endDate];
                if (![self isBlankString:startStr]) {
                    [buildDic setValue:startStr forKey:@"visitTimeBegin"];
                }
                if (![self isBlankString:endStr]) {
                    [buildDic setValue:endStr forKey:@"visitTimeEnd"];
                }
                [buildDic setValue:[visitData.visitCount substringToIndex:visitData.visitCount.length-1] forKey:@"numPeople"];
                [buildDic setValue:visitData.transfFunc forKey:@"trafficMode"];
                [buildArr appendObject:buildDic];
            }
            
            ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[_confirmDic valueForKey:cust.buildingId];
            if (confirmData != nil) {
                NSMutableDictionary *confirmDic = [[NSMutableDictionary alloc] init];
                [confirmDic setValue:cust.buildingId forKey:@"id"];
                [confirmDic setValue:confirmData.confirmUserId forKey:@"confirmUserId"];
                [confirmArr appendObject:confirmDic];
            }
        }
        if (buildArr.count > 0) {
            NSDictionary *buildDic = [NSDictionary dictionaryWithObjectsAndKeys:buildArr,@"customerList", nil];
            visitInfo = [CompleteNumViewController dictionaryToJson:buildDic];
        }
        if (![self isBlankString:visitInfo]) {
            [completeDic setValue:visitInfo forKey:@"customerVisitInfo"];
        }
        if (confirmArr.count > 0) {
            NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:confirmArr,@"confirmUsers", nil];
            confirmInfo = [CompleteNumViewController dictionaryToJson:phoneListDic];
        }
        if (![self isBlankString:confirmInfo]) {
            [completeDic setValue:confirmInfo forKey:@"confirmUsers"];
        }
    }else if (self.reportFailCompleteType == kfailCompleteCustomer)
    {
        NSLog(@"kfailCompleteCustomer");
        type = @"1";
        buildingId = self.buildingId;
    }
    if (![self isBlankString:buildingId]) {
        [completeDic setValue:buildingId forKey:@"buildingId"];
    }
    if (![self isBlankString:type]) {
        [completeDic setValue:type forKey:@"type"];
    }
    NSMutableArray *custArr = [[NSMutableArray alloc] init];
    NSMutableArray *custVisitArr = [[NSMutableArray alloc] init];
    NSMutableArray *custConfirmArr = [[NSMutableArray alloc] init];
    int count = 0;
    for (int i=0; i<customerArray.count; i++) {
        FailListData *cust = (FailListData*)[customerArray objectForIndex:i];
        MobileVisible *mobile = nil;
        if (cust.phoneList.count > 0) {
            mobile = (MobileVisible*)[cust.phoneList objectForIndex:0];
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
//        count += cust.phone.count;
        for (int j=count; j<count+cust.phoneList.count; j++) {
            
            CompleteNumberView *completeView = nil;
            if (viewArray.count > j) {
                completeView = (CompleteNumberView*)[viewArray objectForIndex:j];
            }
//            NSLog(@"completeView superview is %@",[completeView superview]);
            NSString *str = [NSString stringWithFormat:@"%@%@%@",completeView.firstNum.text,completeView.middleNum.text,completeView.tailNum.text];
            if ([cust.name isEqualToString:completeView.nameLabel.text]) {
                if (![self isBlankString:completeView.middleNum.text] && completeView.middleNum.text.length == 4) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:mobile.hidingPhone,@"phone",str,@"phoneNew", nil];
                    [arr appendObject:dic];
                    
                    CustomerVisitInfoData *visitData = (CustomerVisitInfoData*)[_custVisitDic valueForKey:cust.customerId];
                    
                    if (visitData != nil) {
                        NSMutableDictionary *buildDic = [[NSMutableDictionary alloc] init];
                        [buildDic setValue:cust.customerId forKey:@"id"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                        NSString *startStr = [dateFormatter stringFromDate:visitData.startDate];
                        NSString *endStr = [dateFormatter stringFromDate:visitData.endDate];
                        if (![self isBlankString:startStr]) {
                            [buildDic setValue:startStr forKey:@"visitTimeBegin"];
                        }
                        if (![self isBlankString:endStr]) {
                            [buildDic setValue:endStr forKey:@"visitTimeEnd"];
                        }
                        [buildDic setValue:[visitData.visitCount substringToIndex:visitData.visitCount.length-1] forKey:@"numPeople"];
                        [buildDic setValue:visitData.transfFunc forKey:@"trafficMode"];
                        [custVisitArr appendObject:buildDic];
                    }
                    
                    ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[_confirmDic valueForKey:cust.customerId];
                    if (confirmData != nil) {
                        NSMutableDictionary *confirmDic = [[NSMutableDictionary alloc] init];
                        [confirmDic setValue:cust.customerId forKey:@"id"];
                        [confirmDic setValue:confirmData.confirmUserId forKey:@"confirmUserId"];
                        [custConfirmArr appendObject:confirmDic];
                    }
                }
            }
            
        }
        if (arr.count>0) {
            NSDictionary *dic1 = nil;
            if (![self isBlankString:cust.customerId]) {
                dic1 = [NSDictionary dictionaryWithObjectsAndKeys:cust.customerId,@"customerId",arr,@"phoneList", nil];
            }else
            {
                dic1 = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"phoneList", nil];
            }
            [custArr appendObject:dic1];
        }
        count += cust.phoneList.count;
//        NSLog(@"complete number is %@",str);
    }
    if (custArr.count == 0) {
        for (int i=0; i<count; i++) {
            CompleteNumberView *completeView = nil;
            if (viewArray.count > i) {
                completeView = (CompleteNumberView*)[viewArray objectForIndex:i];
            }
            [completeView.middleNum resignFirstResponder];
            [completeView.middleNum.layer setBorderColor:redBgColor.CGColor];
        }
        [self showTips:@"请先补全号码"];
        return;
    }
    NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:custArr,@"customerList", nil];
    NSString *phoneList = [CompleteNumViewController dictionaryToJson:phoneListDic];
    if (![self isBlankString:phoneList]) {
        [completeDic setValue:phoneList forKey:@"phoneList"];
    }
    if (_reportFailCompleteType == kfailCompleteCustomer) {
        if (custVisitArr.count > 0) {
            NSDictionary *custDic = [NSDictionary dictionaryWithObjectsAndKeys:custVisitArr,@"customerList", nil];
            visitInfo = [CompleteNumViewController dictionaryToJson:custDic];
        }
        if (confirmArr.count > 0) {
            NSDictionary *phoneListDic = [NSDictionary dictionaryWithObjectsAndKeys:custConfirmArr,@"confirmUsers", nil];
            confirmInfo = [CompleteNumViewController dictionaryToJson:phoneListDic];
        }
        if (![self isBlankString:visitInfo]) {
            [completeDic setValue:visitInfo forKey:@"customerVisitInfo"];
        }
        if (![self isBlankString:confirmInfo]) {
            [completeDic setValue:confirmInfo forKey:@"confirmUsers"];
        }
    }
    if (!_bIsTouched) {
        _bIsTouched = YES;
        //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
        UIImageView * loadingView = [self setRotationAnimationWithView];
//        __weak CompleteNumViewController *weakSelf = self;
        [[DataFactory sharedDataFactory] fillPhoneAndRecommendationWithDict:completeDic withCallBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
                if (result.success) {
                    [self showTips:result.message];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
//                    if (returnData.failBuildingList.count>0) {//如果部分提交成功，则打开跳转至报备提示页面，显示失败原因
//                        NSString *tempStr = @"0";
//                        if ([weakSelf isBlankString:returnData.count]) {
//                            if ([weakSelf isBlankString:weakSelf.custData.count]) {
//                                tempStr = weakSelf.count;
//                            }else
//                            {
//                                tempStr = weakSelf.custData.count;
//                            }
//                        }else
//                        {
//                            tempStr = returnData.count;
//                        }
//                        weakSelf.reportLoupLabel.text = [NSString stringWithFormat:@"(可报备 %@ 个)",tempStr];
//                        weakSelf.blankLabel.text = [NSString stringWithFormat:@"最多只能添加 %@ 个楼盘哦!",tempStr];
//                        ReportTipViewController *reportTipVC = [[ReportTipViewController alloc] init];
//                        reportTipVC.reportFailType = kfailBuilding;
//                        reportTipVC.reportData = returnData;
//                        reportTipVC.customerId = _custData.customerId;
//                        //                        if (weakSelf.bIsHiddenNum) {
//                        //                            reportTipVC.dataArray = weakSelf.notFullPhoneLoupArr;
//                        //                        }else
//                        //                        {
//                        reportTipVC.dataArray = weakSelf.loupArr;
//                        //                        }
//                        
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            weakSelf.bIsTouched = NO;
//                            [weakSelf.reportBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//                            [weakSelf.navigationController pushViewController:reportTipVC animated:YES];
//                            [weakSelf performSelector:@selector(clearData) withObject:nil afterDelay:3];
//                        });
//                    }else
                    {//如全部提交成功，则跳转至报备记录页面已报备状态下
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showTips:result.message];
                            self.bIsTouched = NO;
                            switch (self.type) {
                                case 0:
                                {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomerView" object:nil];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                                    break;
                                case 1:
                                {
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                                    break;
                                case 2:
                                {
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[BuildingDetailViewController class]]) {
                                            // || [temp isKindOfClass:[XTUserScheduleViewController class]]
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBuildingDetail" object:nil];
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }
                                    break;
                                case 3:
                                {
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[MyBuildingViewController class]]) {
                                            // || [temp isKindOfClass:[XTUserScheduleViewController class]]
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }
                                    break;
                                case 4:
                                {
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[CustomerDetailViewController class]]) {
                                            // || [temp isKindOfClass:[XTUserScheduleViewController class]]
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailHeader" object:nil];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailBottom" object:nil];
                                            
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }
                                    break;
                                case 5:
                                {
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[QuickReportViewController class]]) {
                                            // || [temp isKindOfClass:[XTUserScheduleViewController class]]
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }
                                    break;
                                    
                                default:
                                {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                    break;
                            }
                        });
                    }
                }else
                {//提交失败，留在当前页
                    self.bIsTouched = NO;
                    [self showTips:result.message];
                }
            });
        }];
    }
    
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//- (void)middleNumTextFieldDidChanged{
//    if (middleNum.text.length >= 4) {
//        middleNum.text = [middleNum.text substringToIndex:4];
//        [middleNum resignFirstResponder];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
