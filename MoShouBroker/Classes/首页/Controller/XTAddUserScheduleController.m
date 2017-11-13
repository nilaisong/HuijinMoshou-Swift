//
//  XTAddUserScheduleController.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/10.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTAddUserScheduleController.h"
#import "BRPlaceholderTextView.h"

@interface XTAddUserScheduleController ()

@property (nonatomic,weak)BRPlaceholderTextView* textView;

@end

@implementation XTAddUserScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self commonInit];
}
- (void)commonInit{
    self.navigationBar.titleLabel.text  = @"添加提醒";
    self.view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    self.textView.frame = CGRectMake(0, 64, self.view.frame.size.width - 16, 225);
    
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
//        textView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [textView setContentInset:UIEdgeInsetsMake(8,16, -15, -5)];
        _textView = textView;
    }
    return _textView;
}

@end
