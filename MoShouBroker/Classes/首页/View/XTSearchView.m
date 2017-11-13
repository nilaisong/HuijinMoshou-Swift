//
//  XTSearchView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTSearchView.h"
#import "XTSearchTextField.h"
#import "NSString+Extension.h"
#import "XTPromptSearchInputView.h"
#import "FMDBSource+Broker.h"

@interface XTSearchView() <UITextFieldDelegate>

@property (nonatomic,weak)UIView* topContentView;

@property (nonatomic,weak)XTSearchTextField* textField;

@property (nonatomic,weak)UIButton* cancelBtn;

@property (nonatomic,weak)UIView* maskView;

//提示信息展示（历史记录+提示）
@property (nonatomic,weak)XTPromptSearchInputView* promptShowView;
@end

@implementation XTSearchView

- (instancetype)initWithFrame:(CGRect)frame inputCallBack:(XTSearchViewGetInputCallBack)callBack{
    if (self = [super initWithFrame:frame]) {
        _callBack = callBack;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self commonInit];
    }
    return self;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
// Do any additional setup after loading the view.
//    self.navigationBar.hidden = YES;
- (void)willMoveToSuperview:(UIView *)newSuperview{

    
    
//    [self commonInit];
}

- (void)commonInit{
    self.userInteractionEnabled  = YES;
    [self cancelBtn];
    [self textField];
    [self promptShowView];
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
        [self.topContentView addSubview:btn];
        _cancelBtn = btn;
    }
    return _cancelBtn;
}

- (UITextField *)textField{
    if (!_textField) {
        XTSearchTextField* textField = [[XTSearchTextField alloc]init];
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.backgroundColor = [UIColor whiteColor];
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        CGSize size = [NSString sizeWithString:@"取消" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        textField.frame = CGRectMake(10, 20 + (44 - 29)/2, [UIScreen mainScreen].bounds.size.width - 35.5 - size.width, 29);
        [self.topContentView addSubview:textField];
        _textField = textField;
        [textField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    }
    [_textField becomeFirstResponder];
    return _textField;
}

- (void)cancelBtnClick:(UIButton*)btn{
    
    [self removeFromSuperview];
}

- (UIView *)topContentView{
    if (!_topContentView) {
        UIView* contentView = [[UIView alloc]init];
        contentView.userInteractionEnabled = YES;
        contentView.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.0f];
        contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self addSubview:contentView];
        _topContentView = contentView;
        [self maskView];
    }
    return _topContentView;
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView* view = [[UIView alloc]init];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction:)];
        tap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tap];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:0.90f];
        view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        [self addSubview:view];
        _maskView = view;
    }
    return _maskView;
}

- (XTPromptSearchInputView *)promptShowView{
    if (!_promptShowView) {
        __weak typeof(self) weakSelf = self;
        XTPromptSearchInputView* promptView = [XTPromptSearchInputView historyViewWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) selectBlock:^(NSInteger index, NSString *keyword) {
            if (weakSelf.callBack) {
                weakSelf.callBack(keyword,YES);
                [self cancelBtnClick:self.cancelBtn];
            }
        }];
        [self addSubview:promptView];
        promptView.promptsArray = self.promptArray;
        _promptShowView = promptView;
        
    }
    return _promptShowView;
}

- (void)cancelAction:(UIGestureRecognizer*)gest{
    [self cancelBtnClick:_cancelBtn];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0 && _callBack) {
        _callBack(textField.text,YES);
    }
    [self cancelBtnClick:_cancelBtn];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (_textField.text.length > 0&&_callBack) {
        _callBack(_textField.text,NO);
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (_textField.text.length > 0&&_callBack) {
//        _callBack(_textField.text,NO);
//    }
//}

- (void)setPromptArray:(NSArray *)promptArray{
    _promptArray = promptArray;
    self.promptShowView.promptsArray = promptArray;
}

@end
