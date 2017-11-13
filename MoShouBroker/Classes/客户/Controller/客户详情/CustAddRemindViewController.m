//
//  CustAddRemindViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustAddRemindViewController.h"
#import "RemindListViewController.h"
#import "CustomerDetailViewController.h"
#import "RecommendRecordDetailController.h"
#import "CustomerTextView.h"
#import "XTRemindTimeView.h"
#import "XTDateSelectView.h"
#import "AppDelegate.h"

#import "NSString+Extension.h"
#import "DataFactory+Main.h"

@interface CustAddRemindViewController ()<UITextViewDelegate>

@property (nonatomic, strong) CustomerTextView *textview;
@property (nonatomic, weak) XTRemindTimeView   *remindTimeView;
@property (nonatomic, assign) BOOL             bIsTouched;//互斥锁，防止保存报备过程中多次点击
@property (nonatomic, strong) UIButton         *saveBtn;
@property (nonatomic, strong) UILabel          *displayLb;
//@property (nonatomic, strong) NSDate           *selectedDate;

@end

@implementation CustAddRemindViewController
@synthesize textview;
@synthesize saveBtn;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    self.navigationBar.titleLabel.text = @"添加提醒";
    
    UIView *textBgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, 120)];
    textBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBgView];
    
    [self.view addSubview:[self createLineView:textBgView.bottom]];
    
    textview = [[CustomerTextView alloc] initWithFrame:CGRectMake(16, viewTopY, kMainScreenWidth-32, 120)];
    textview.backgroundColor = [UIColor whiteColor];
    textview.placeHolder = @"请输入提醒内容";
    textview.font = FONT(14);
    [textview becomeFirstResponder];
    textview.delegate = self;
    [self.view addSubview:textview];
    
    _displayLb = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100, textview.bottom+5, 85, 30)];
    _displayLb.text = @"0/50";
    _displayLb.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    _displayLb.textColor = TFPLEASEHOLDERCOLOR;
    _displayLb.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_displayLb];
    
    self.remindTimeView.frame = CGRectMake(0, _displayLb.bottom + 10, kMainScreenWidth, 44);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    self.remindTimeView.dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [self.view addSubview:[self createLineView:_displayLb.bottom+9.5]];
    [self.view addSubview:[self createLineView:self.remindTimeView.bottom]];
    
    self.saveBtn.frame = CGRectMake(8, _remindTimeView.bottom + 30, kMainScreenWidth - 16, 44);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    //    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
}

- (XTRemindTimeView *)remindTimeView{
    if (!_remindTimeView) {
        __weak typeof(self) weakSelf = self;
        XTRemindTimeView* view = [[XTRemindTimeView alloc]initWithCallBack:^(XTRemindTimeView *timeView) {
            [weakSelf.textview endEditing:YES];
            XTDateSelectView* dateView = [[XTDateSelectView alloc]initWithEventCallBack:^(XTDateSelectView *view, NSDate *selectedDate) {

                weakSelf.remindTimeView.selectedDate = selectedDate;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                weakSelf.remindTimeView.dateStr = [dateFormatter stringFromDate:selectedDate];
//                NSString *message =  [NSString stringWithFormat:
//                                      @"您选择的日期和时间是：%@", weakSelf.remindTimeView.dateStr];
//                NSLog(@"%@",message);
            }];
            
            dateView.selectedDate = weakSelf.remindTimeView.selectedDate;
            dateView.frame = weakSelf.view.bounds;
            [weakSelf.view addSubview:dateView];
        }];
        if (_remindTimeView.selectedDate != nil) {
            view.selectedDate = _remindTimeView.selectedDate;
        }
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        _remindTimeView = view;
    }
    return _remindTimeView;
}

- (void)handleTapGesture:(UITapGestureRecognizer*)recognizer
{
    [textview resignFirstResponder];
}

- (UIButton *)saveBtn{
    if (!saveBtn) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(saveButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.backgroundColor = BLUEBTBCOLOR;
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 5;
        saveBtn = button;
    }
    return saveBtn;
}

- (void)saveButtonTouch:(UIButton*)btn{
    if ([self isBlankString:self.textview.text]) {
        [self showTips:@"内容不能为空"];
        return;
    }
    if ([self isBlankString:self.remindTimeView.dateStr]) {
        [self showTips:@"请选择提醒时间"];
        return;
    }
    if (!_bIsTouched) {
        _bIsTouched = YES;
        if ([NetworkSingleton sharedNetWork].isNetworkConnection)
        {
//            __weak CustAddRemindViewController *weakSelf = self;
            UIImageView* loadingView = [self setRotationAnimationWithView];
            [[DataFactory sharedDataFactory]addScheduleWithCustomer:_custList content:textview.text date:_remindTimeView.dateStr type:@"0" callBack:^(ActionResult *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeRotationAnimationView:loadingView];
                    if (result.success) {
                        [self showTips:result.message];
                        AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        [appDeleage performSelectorOnMainThread:@selector(registerAllLocalNotifications) withObject:nil waitUntilDone:YES];
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[RemindListViewController class]]) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshRemindList" object:nil];
                                self.bIsTouched = NO;
                                [self.navigationController popViewControllerAnimated:YES];
                                return;
                            }
                        }
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[CustomerDetailViewController class]] || [temp isKindOfClass:[RecommendRecordDetailController class]]) {
                                if ([temp isKindOfClass:[CustomerDetailViewController class]])
                                {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailHeader" object:nil];
                                }
                                RemindListViewController *remindVC = [[RemindListViewController alloc] init];
                                remindVC.custList = self.custList;
                                self.bIsTouched = NO;
                                [self.navigationController pushViewController:remindVC animated:YES];
                                return;
                            }
                        }
                    }else
                    {
                        self.bIsTouched = NO;
                        [self showTips:result.message];
                    }
                });
            }];
        }else
        {
            _bIsTouched = NO;
        }
    }
}
#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length >= 50)
    {
        //        [self showTips:@"不能超过140个字"];
        textView.text = [textView.text substringToIndex:50];
        [textView resignFirstResponder];
    }
    _displayLb.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textview.text.length];
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
}

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
