//
//  XTSearchViewController.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/25.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTSearchViewController.h"
#import "NSString+Extension.h"
#import "XTSearchTextField.h"

@interface XTSearchViewController ()

@property (nonatomic,weak)XTSearchTextField* textField;

@property (nonatomic,weak)UIButton* cancelBtn;

@end

@implementation XTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f];
    
    [self commonInit];
}

- (void)commonInit{
    
    [self cancelBtn];
    [self textField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        UIButton* btn = [[UIButton alloc]init];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.08f green:0.44f blue:0.64f alpha:1.00f] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [NSString sizeWithString:@"取消" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - size.width - 8.5, 20 + (44 - size.height)/2, size.width, size.height);
        [self.view addSubview:btn];
        _cancelBtn = btn;
    }
    return _cancelBtn;
}

- (UITextField *)textField{
    if (!_textField) {
        XTSearchTextField* textField = [[XTSearchTextField alloc]init];
        CGSize size = [NSString sizeWithString:@"取消" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        textField.frame = CGRectMake(10, 20 + (44 - 29)/2, [UIScreen mainScreen].bounds.size.width - 35.5 - size.width, 29);
        [self.view addSubview:textField];
        textField.backgroundColor = [UIColor whiteColor];
        textField.clipsToBounds = YES;
        textField.layer.cornerRadius = 10;
        
        _textField = textField;
    }
    [_textField becomeFirstResponder];
    return _textField;
}

- (void)cancelBtnClick:(UIButton*)btn{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
