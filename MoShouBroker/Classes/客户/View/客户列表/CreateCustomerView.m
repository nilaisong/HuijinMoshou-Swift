//
//  CreateCustomerView.m
//  MoShou2
//
//  Created by wangzz on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CreateCustomerView.h"
#import "IQKeyboardManager.h"

@interface CreateCustomerView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *groupView;
@property (nonatomic, strong) UITextField *customerGroupTextField;
@property (nonatomic, assign) CGRect keyBoardFrame;
@end

@implementation CreateCustomerView
@synthesize groupView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.3];
        IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
        mage.enable = YES;
        mage.shouldResignOnTouchOutside = YES;
        mage.shouldToolbarUsesTextFieldTintColor = YES;
        mage.enableAutoToolbar = NO;
        if (kMainScreenWidth == 320) {
            //注册键盘出现的通知
            [[NSNotificationCenter defaultCenter] addObserver:self
             
                                                     selector:@selector(keyboardWasShown:)
             
                                                         name:UIKeyboardWillShowNotification object:nil];
            
            //注册键盘消失的通知
            [[NSNotificationCenter defaultCenter] addObserver:self
             
                                                     selector:@selector(keyboardWillBeHidden:)
             
                                                         name:UIKeyboardWillHideNotification object:nil];
        }
    }
    return self;
}
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    //键盘高度
    
    _keyBoardFrame = [[[aNotification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect rect = [groupView frame];
    
    rect.origin.y = self.height-_keyBoardFrame.size.height-180;
    [groupView setFrame:rect];
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect rect = [groupView frame];
   
    rect.origin.y = self.height/3;
    [groupView setFrame:rect];
    
    [UIView commitAnimations];
}


#pragma mark-------------数据源
- (void)setContent:(NSString *)content {
    _content = content;
    [self layoutUI];
}

-(void)createCustomerBlock:(createBtnSelectedBlock)ablock
{
    self.didSelected = ablock;
}

-(void)cancelCustomerBlock:(createBtnCancelBlock)ablock
{
    self.didCancel = ablock;
}

- (void)layoutUI
{
    groupView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-125, self.height/3, 250, 150)];
    groupView.backgroundColor = [UIColor whiteColor];
    groupView.alpha = 0.95;
    [groupView.layer setMasksToBounds:YES];
    [groupView.layer setCornerRadius:8.0];
    [self addSubview:groupView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, groupView.width-60, 30)];
    if ([_content isEqualToString:@""]) {
        nameLabel.text = @"新建客户组";
    }else
    {
        nameLabel.text = @"修改组名";
    }
    
    nameLabel.textColor = NAVIGATIONTITLE;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [groupView addSubview:nameLabel];
    
    UIView *textFieldBgView = [[UIView alloc] initWithFrame:CGRectMake(20, nameLabel.bottom+10, groupView.width-40, 40)];
    [textFieldBgView.layer setMasksToBounds:YES];
    [textFieldBgView.layer setCornerRadius:3.0];
    [textFieldBgView.layer setBorderWidth:0.5];
    [textFieldBgView.layer setBorderColor:LINECOLOR.CGColor];
    [groupView addSubview:textFieldBgView];
    
    _customerGroupTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, textFieldBgView.top+5, groupView.width-60, 30)];
    [_customerGroupTextField becomeFirstResponder];
    _customerGroupTextField.delegate = self;
    [_customerGroupTextField setFont:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]];
    if ([_content isEqualToString:@""]) {
        _customerGroupTextField.placeholder = @"新建客户组";
    }else
    {
        _customerGroupTextField.text = _content;
    }
    _customerGroupTextField.textColor = LABELCOLOR;
    [_customerGroupTextField addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [groupView addSubview:_customerGroupTextField];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, textFieldBgView.bottom+20, groupView.width, 0.5)];
    lineLabel.backgroundColor = LINECOLOR;
    [groupView addSubview:lineLabel];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, textFieldBgView.bottom+20, 90, 40)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]];
    [cancleBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(toggleCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:cancleBtn];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(groupView.width/2, textFieldBgView.bottom+20, 0.5, groupView.height-lineLabel.bottom)];
    lineLabel1.backgroundColor = LINECOLOR;
    [groupView addSubview:lineLabel1];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancleBtn.right+30, textFieldBgView.bottom+20, 90, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor clearColor]];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]];
    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(toggleSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:saveBtn];
}

- (void)toggleSaveBtn
{
    _didSelected(_customerGroupTextField.text);
}

-(void)toggleCancleBtn
{
    _didCancel();
}

- (void)textFieldDidChanged
{
    if (_customerGroupTextField.text.length >= 10) {
        _customerGroupTextField.text = [_customerGroupTextField.text substringToIndex:10];
        [_customerGroupTextField resignFirstResponder];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
