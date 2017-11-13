//
//  CustomerEditViewController.m
//  MoShouBroker
//
//  Created by wangzz on 15/10/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerEditViewController.h"
#import "CustomerTextView.h"
#import "DataFactory+Customer.h"
#import "CustomerDetailViewController.h"
#import "CustomerFollowDetailViewController.h"
#import "XTUserScheduleViewController.h"
#import "UserData.h"

@interface CustomerEditViewController ()<UITextViewDelegate>
@property (nonatomic, strong) CustomerTextView *textview;
@property (nonatomic, assign) BOOL           bIsTouched;//互斥锁，防止保存报备过程中多次点击
@property (nonatomic, strong) UIButton *rightBarItem;
@property (nonatomic, strong) UILabel *displayLb;

@end

@implementation CustomerEditViewController
//@synthesize customerMsgType;
@synthesize textview;
@synthesize rightBarItem;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    textview = [[CustomerTextView alloc] initWithFrame:CGRectMake(16, viewTopY+10, kMainScreenWidth-32, 120)];
    textview.backgroundColor = [UIColor whiteColor];
    textview.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [textview becomeFirstResponder];
    textview.delegate = self;
    [self.view addSubview:textview];
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, textview.bottom+5, kMainScreenWidth, 0.5)];
    lineLb.backgroundColor = LINECOLOR;
    [self.view addSubview:lineLb];
    
    _displayLb = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100, lineLb.bottom+5, 85, 30)];
    _displayLb.text = @"0/50";
    _displayLb.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    _displayLb.textColor = LABELCOLOR;
    _displayLb.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_displayLb];
//    switch (customerMsgType) {
//        case kAddRemarksMsg:
//        {
            self.navigationBar.titleLabel.text = @"添加备注";
            textview.placeHolder = @"请输入备注信息";
    if (![self isBlankString:_editString]) {
        textview.text = _editString;
    }
//        }
//            break;
//        case kAddCustomerFollowMsg:
//        case kAddFolloMsg:
//        {
//            self.navigationBar.titleLabel.text = @"添加跟进";
//            textview.placeHolder = @"请输入跟进信息";
//        }
//            break;
//          
//        default:
//            break;
//    }
    
    rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-8-40, 20+5, 40, 34)];
    [rightBarItem setTitle:@"保存" forState:UIControlStateNormal];
    [rightBarItem setTitleColor:stringColor forState:UIControlStateNormal];
    rightBarItem.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBarItem addTarget:self action:@selector(toggleRightBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:rightBarItem];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)recognizer
{
    [textview resignFirstResponder];
}

- (void)toggleRightBarItem:(UIButton*)sender
{
    NSString *content = [textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//textview.text;
    
    [textview resignFirstResponder];
   
    if (!_bIsTouched) {
        _bIsTouched = YES;
        if ([NetworkSingleton sharedNetWork].isNetworkConnection)
        {
//            switch (customerMsgType) {
//                case kAddRemarksMsg:
//                {
                    if ([self isBlankString:content]) {
                        _bIsTouched = NO;
                        [self showTips:@"备注内容不能为空"];
                        return;
                    }
                    UIImageView* loadingView = [self setRotationAnimationWithView];
                    [[DataFactory sharedDataFactory] editCustomerRemarkWithCustId:_customerMsdId andRemark:content withCallBack:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self removeRotationAnimationView:loadingView];
                            if (result.success) {
//                                _bIsTouched = NO;
                                [self showTips:@"添加成功"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    _customerEditBlock();
                                    //防止多次pop发生崩溃闪退
//                                    _bIsTouched = NO;
                                    if ([self.view superview]) {
                                        _bIsTouched = NO;
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                });
                            }else
                            {
                                _bIsTouched = NO;
                                [self showTips:result.message];
                            }
                        });
                    }];
/*                }
                    break;
                case kAddCustomerFollowMsg:
                {
                    if ([self isBlankString:content]) {
                        _bIsTouched = NO;
                        [self showTips:@"跟进内容不能为空"];
                        return;
                    }
                    UIImageView* loadingView = [self setRotationAnimationWithView];
                    [[DataFactory sharedDataFactory] addTrackMessage:content withCustId:_customerMsdId withConfirm:@"1" withCallBack:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self removeRotationAnimationView:loadingView];
                            if (result.success) {
//                                _bIsTouched = NO;
                                [self showTips:@"添加成功"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    _customerEditBlock();
                                    //防止多次pop发生崩溃闪退
                                    if ([self.view superview]) {
                                        _bIsTouched = NO;
                                        for (UIViewController *temp in self.navigationController.viewControllers) {
                                            if ([temp isKindOfClass:[CustomerFollowDetailViewController class]]) {
//                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerFollowList" object:nil];
                                                [self.navigationController popViewControllerAnimated:YES];
                                                return;
                                            }
                                        }
                                        for (UIViewController *temp in self.navigationController.viewControllers) {
                                            if ([temp isKindOfClass:[CustomerDetailViewController class]] || [temp isKindOfClass:[XTUserScheduleViewController class]]) {
//                                                if ([temp isKindOfClass:[CustomerDetailViewController class]])
//                                                {
//                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerDetailHeader" object:nil];
//                                                }
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerFollowList" object:nil];
                                                CustomerFollowDetailViewController *followVC = [[CustomerFollowDetailViewController alloc] init];
                                                followVC.custId = self.customerMsdId;
                                                [self.navigationController pushViewController:followVC animated:YES];
                                                return;
                                            }
                                        }
                                    }
                                });
                            }else
                            {
                                _bIsTouched = NO;
                                [self showTips:result.message];
                            }
                        });
                    }];
                }
                    break;
                case kAddFolloMsg:
                {
                    if ([self isBlankString:content]) {
                        _bIsTouched = NO;
                        [self showTips:@"跟进内容不能为空"];
                        return;
                    }
                    NSString *confirmShowTrack = [NSString stringWithFormat:@"%d",[UserData sharedUserData].confirmShowTrack];
                    UIImageView* loadingView = [self setRotationAnimationWithView];
                    [[DataFactory sharedDataFactory] addTrackMessage:content withBuildingCustId:_customerMsdId withConfirm:confirmShowTrack withCallBack:^(ActionResult *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self removeRotationAnimationView:loadingView];
                            
                            if (result.success) {
                                
                                [self showTips:@"添加成功"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    _customerEditBlock();
                                    //防止多次pop发生崩溃闪退
//                                    _bIsTouched = NO;
                                    if ([self.view superview]) {
                                        _bIsTouched = NO;
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                });
                            }else
                            {
                                _bIsTouched = NO;
                                [self showTips:result.message];
                            }
                        });
                    }];
                }
                    break;
                    
                default:
                    break;
            }*/
        }else
        {
            _bIsTouched = NO;
        }
    }
}

-(void)returnCustomerEditResultBlock:(CustomerDetailMsgEdit)ablock
{
    self.customerEditBlock = ablock;
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        [rightBarItem setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    }else
    {
        [rightBarItem setTitleColor:stringColor forState:UIControlStateNormal];
    }
    if(textView.text.length >= 50)
    {
        textView.text = [textView.text substringToIndex:50];
        [textView resignFirstResponder];
    }
    _displayLb.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textview.text.length];
}

#pragma mark - 计算字符140个，致使发送内容不超过140个
//if([self textLength:self.contentTextView.text] > 140)
//-(int)textLength:(NSString *)dataString
//{
//    float sum = 0.0;
//    for(int i=0;i<[dataString length];i++)
//    {
//        NSString *character = [dataString substringWithRange:NSMakeRange(i, 1)];
//        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
//        {
//            sum++;
//        }
//        else
//            sum += 0.5;
//    }
//    
//    return ceil(sum);
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
