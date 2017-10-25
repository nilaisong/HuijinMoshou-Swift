//
//  XTAddRemindController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTAddRemindController.h"
#import "BRPlaceholderTextView.h"
#import "XTCustomerSelectView.h"
#import "XTRemindTimeView.h"
#import "XTSelectCustomerController.h"
#import "XTDateSelectView.h"
#import "Customer.h"

#import "NSString+Extension.h"
#import "DataFactory+Main.h"
#import "DataFactory+Customer.h"
#import "AppDelegate.h"

#import "RemindListViewController.h"

@interface XTAddRemindController ()<UITextViewDelegate>

@property (nonatomic,weak)BRPlaceholderTextView* textView;

@property (nonatomic,weak)XTCustomerSelectView* customerView;

@property (nonatomic,weak)XTRemindTimeView * remindTimeView;

@property (nonatomic,assign)NSUInteger maxWordNumber;

@property (nonatomic,assign)NSUInteger currentWordNumber;

@property (nonatomic,weak)UILabel* wordNumberLabel;

@property (nonatomic,weak)UIButton* saveButton;

@property (nonatomic,strong)Customer* selectedCustomer;

@end

@implementation XTAddRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)commonInit{
    _maxWordNumber = 50;
    self.navigationBar.titleLabel.text  = @"添加提醒";
    self.view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    self.customerView.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    
    self.remindTimeView.frame = CGRectMake(0, CGRectGetMaxY(_customerView.frame) + 10, self.view.frame.size.width, 44);
    
    self.textView.frame = CGRectMake(0,CGRectGetMaxY(_remindTimeView.frame) + 10, self.view.frame.size.width, 125);
    
    self.wordNumberLabel.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + 10, self.view.frame.size.width - 16, 15);
    
    self.saveButton.frame = CGRectMake(8, CGRectGetMaxY(_wordNumberLabel.frame) + 30, self.view.frame.size.width - 16, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BRPlaceholderTextView *)textView{
    if (!_textView) {
        BRPlaceholderTextView* textView = [[BRPlaceholderTextView alloc]init];
        textView.placeholder = @"请输入提醒内容";
        [self.view addSubview:textView];
        textView.delegate = self;
        textView.scrollEnabled = NO;
        textView.returnKeyType = UIReturnKeyDone;
        [textView setPlaceholderColor:TFPLEASEHOLDERCOLOR];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        textView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 8.0f, 10.0f, 8.0f);
        textView.contentInset = UIEdgeInsetsMake(10.0f, 8.0f, 10.0f, -8.0f);
//        textView.contentInset = UIEdgeInsetsZero;
        textView.scrollEnabled = YES;
        textView.scrollsToTop = NO;
        textView.userInteractionEnabled = YES;
        textView.font = [UIFont systemFontOfSize:16.0f];
        textView.textColor = [UIColor blackColor];
        textView.backgroundColor = [UIColor whiteColor];
        textView.returnKeyType = UIReturnKeyDone;
        textView.textAlignment = NSTextAlignmentLeft;
        _textView = textView;
    }
    return _textView;
}



#pragma mark - getter
- (XTCustomerSelectView *)customerView{
    if (!_customerView) {
        __weak typeof(self) weakSelf = self;
        XTCustomerSelectView* view = [[XTCustomerSelectView alloc]initWithEventCallBack:^(XTCustomerSelectView *customerSelect) {
            XTSelectCustomerController* selectVC = [[XTSelectCustomerController alloc]initWithCallBack:^(Customer* customer) {
                weakSelf.selectedCustomer = customer;
                weakSelf.customerView.customerNameLabel.text = customer.name;
                weakSelf.customerView.customerPhoneNumberLabel.text = customer.listPhone;
                weakSelf.customerView.sexString = customer.sex;
                [weakSelf.customerView reloadView];
            }];
            [weakSelf.navigationController pushViewController:selectVC  animated:YES];
        }];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        _customerView = view;
    }
    return _customerView;
}

- (XTRemindTimeView *)remindTimeView{
    if (!_remindTimeView) {
        __weak typeof(self) weakSelf = self;
        XTRemindTimeView* view = [[XTRemindTimeView alloc]initWithCallBack:^(XTRemindTimeView *timeView) {
            [weakSelf.textView endEditing:YES];
            XTDateSelectView* dateView = [[XTDateSelectView alloc]initWithEventCallBack:^(XTDateSelectView *view, NSDate *selectedDate) {
                weakSelf.remindTimeView.selectedDate = selectedDate;
                weakSelf.remindTimeView.dateStr = [weakSelf.inputFormatter stringFromDate:selectedDate];
            }];
            
            dateView.selectedDate = _selectedDate;
            dateView.frame = self.view.bounds;
            [weakSelf.view addSubview:dateView];
        }];

        view.dateStr = [weakSelf.inputFormatter stringFromDate:_selectedDate];
        view.selectedDate = _selectedDate;
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        _remindTimeView = view;
    }
    return _remindTimeView;
}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    // 获取textView中得内容
    NSMutableString *goalStr = [[NSMutableString alloc]initWithString:textView.text];
    [goalStr replaceCharactersInRange:range withString:text];
    
    if ( goalStr.length > _maxWordNumber){
        [textView endEditing:YES];
        return NO;
    }
    
    return YES;
}   

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
     NSMutableString *goalStr = [[NSMutableString alloc]initWithString:textView.text];
    if (goalStr.length > _maxWordNumber) {
        [textView endEditing:YES];
        return NO;
    }
   return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
  
    if (textView.markedTextRange == nil && self.maxWordNumber > 0 && textView.text.length > self.maxWordNumber) {
        textView.text = [textView.text substringToIndex:self.maxWordNumber];
    }
    // 获取textView中得内容
    NSMutableString *goalStr = [[NSMutableString alloc]initWithString:textView.text];
    _currentWordNumber = goalStr.length;
    if (goalStr.length >= _maxWordNumber) {
        [textView endEditing:YES];
    }
    _wordNumberLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_currentWordNumber,(unsigned long)_maxWordNumber];
}

- (UILabel *)wordNumberLabel{
    if (!_wordNumberLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
        label.textColor = TFPLEASEHOLDERCOLOR;
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"0/%lu",(unsigned long)_maxWordNumber];
        [self.view addSubview:label];
        _wordNumberLabel = label;
    }
    return _wordNumberLabel;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(saveButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 5;
        _saveButton = button;
    }
    return _saveButton;
}

- (void)saveButtonTouch:(UIButton*)btn{

    NSLog(@"保存按钮点击");
    if ([self stringContainsEmoji:self.textView.text]) {
        [self showTips:@"添加失败，请不要输入特殊字符"];
        return;
    }
    if (!_selectedCustomer) {
        [self showTips:@"请选择提醒客户"];
        return;
    }
    if (_selectedCustomer.name.length <= 0) {
        [self showTips:@"请输入客户姓名"];
        return;
    }
    if (_selectedCustomer.sex.length <= 0) {
        [self showTips:@"请选择客户性别"];
        return;
    }
    if (_selectedCustomer.listPhone.length <= 0) {
        [self showTips:@"请输入客户手机号"];
        return;
    }
    if (self.remindTimeView.dateStr.length <= 0) {
        [self showTips:@"请选择提醒时间"];
        return;
    }
    
    if (self.textView.text.length <= 0) {
        [self showTips:@"内容不能为空"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] addScheduleWithCustomer:_selectedCustomer content:_textView.text date:_remindTimeView.dateStr type:@"1" callBack:^(ActionResult *result) {
            AppDelegate* appDeleage = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [appDeleage performSelectorOnMainThread:@selector(registerAllLocalNotifications) withObject:nil waitUntilDone:YES];
        
            [weakSelf removeRotationAnimationView:loadingView];
            if (result.success) {
                [weakSelf showTips:result.message];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
//                [weakSelf.navigationController popViewControllerAnimated:YES];
                
//                }else [weakSelf.navigationController popViewControllerAnimated:YES];
            }else
            {
                [weakSelf showTips:result.message];//@"添加失败\n请检查信息后重试"
            }

    }];
    
}

#pragma mark - 表情判断
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
