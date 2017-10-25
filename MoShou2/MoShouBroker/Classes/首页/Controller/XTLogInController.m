//
//  XTLogInController.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTLogInController.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "XTLoginInputView.h"

#import "UIButton+StateColor.h"
#import "NSString+Extension.h"
#import "FindViewController.h"
#import "RegisterViewController.h"

#import "DataFactory+User.h"

#import "Tool.h"

#import "ChangePasswordViewController.h"

#import "XTChangePasswordController.h"


@interface XTLogInController ()<UIScrollViewDelegate>

@property (nonatomic,weak)TPKeyboardAvoidingScrollView* contentScrollView;

@property (nonatomic,weak)UIImageView* headImageView;

@property (nonatomic,weak)UIImageView* logoImageView;

@property (nonatomic,weak)XTLoginInputView* phoneView;

@property (nonatomic,weak)XTLoginInputView* passwdView;

@property (nonatomic,weak)UIButton* logInButton;


@property (nonatomic,weak)UIButton* findPasswdButton;

@property (nonatomic,weak)UIButton* registerButton;

@property (nonatomic,copy)NSString* phoneNumber;

@property (nonatomic,copy)NSString* passwdNumber;

@property (nonatomic,weak)UIImageView* loadingView;


@property (nonatomic,assign)BOOL hasLoginAction;

@end

@implementation XTLogInController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self commonInit];

    //密码不够安全，会有这个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordUnlegalAction:) name:@"XTPasswordUnLegalNotification" object:nil];
    _hasLoginAction = NO;
}


- (void)commonInit{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar.hidden = YES;
    
    self.contentScrollView.frame = self.view.bounds;
    
    self.headImageView.frame = CGRectMake((kMainScreenWidth - 100 * SCALE6)/2.0, 78 * SCALE6, 100 * SCALE6, 100 * SCALE6);
    
    self.phoneView.frame = CGRectMake(30, CGRectGetMaxY(_headImageView.frame) + 25 * SCALE6, kMainScreenWidth - 60, 46);
    self.passwdView.frame = CGRectMake(30, CGRectGetMaxY(_phoneView.frame) + 10 * SCALE6, kMainScreenWidth - 60, 46);
    
    self.logInButton.frame = CGRectMake(30, CGRectGetMaxY(_passwdView.frame) + 25 * SCALE6, kMainScreenWidth - 60, 46);
    
    CGSize findBtnSize = [self.findPasswdButton.titleLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.findPasswdButton.frame = CGRectMake(30, CGRectGetMaxY(_logInButton.frame) + 10 * SCALE6, findBtnSize.width, 42);
    self.registerButton.frame = CGRectMake(kMainScreenWidth - 30 - findBtnSize.width, CGRectGetMaxY(_logInButton.frame) + 10 * SCALE6, findBtnSize.width, 42);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.logoImageView.frame = CGRectMake((kMainScreenWidth - 117)/2.0, kMainScreenHeight - 27 - 20, 117, 27);
}

- (TPKeyboardAvoidingScrollView *)contentScrollView{
    if (!_contentScrollView) {
        TPKeyboardAvoidingScrollView* scrollV = [[TPKeyboardAvoidingScrollView alloc]init];
        scrollV.delegate = self;
        [self.view addSubview:scrollV];
        _contentScrollView = scrollV;
    }
    return _contentScrollView;
}

- (XTLoginInputView *)phoneView{
    if (!_phoneView) {
        __weak typeof(self) weakSelf = self;
        XTLoginInputView* view = [[XTLoginInputView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 60, 46) Type:LoginInputViewPhone titleStr:@"手机号" callBack:^(XTLoginInputView *inputView, NSString *text) {
            [weakSelf judgePhoneNumber:text];
            weakSelf.phoneNumber = text;
        }];
        view.showTipsCallBack = ^(XTLoginInputView* logInView,NSString* message){
            if (message.length > 0) {
                [weakSelf showTips:message];
            }
        };
        [self.contentScrollView addSubview:view];
        _phoneView = view;
    }
    return _phoneView;
}

- (void)judgePhoneNumber:(NSString*)phoneNum{
    NSString* avatarUrlStr = [Tool getCache:phoneNum];
    if (avatarUrlStr.length > 0) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"login-head-normal"]];
    }else{
        [self.headImageView setImage:[UIImage imageNamed:@"login-head-normal"]];
    }
}

- (XTLoginInputView *)passwdView{
    if (!_passwdView) {
        __weak typeof(self) weakSelf = self;
        XTLoginInputView* view = [[XTLoginInputView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 60, 46) Type:LoginInputViewPasswd titleStr:@"密   码" callBack:^(XTLoginInputView *inputView, NSString *text) {
            weakSelf.passwdNumber = text;
        }];
        [self.contentScrollView addSubview:view];
        _passwdView = view;
    }
    return _passwdView;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView* imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login-head-normal"]];
        imgV.clipsToBounds = YES;
        imgV.layer.cornerRadius = 100 * SCALE6 / 2.0;
        [self.contentScrollView addSubview:imgV];
        _headImageView = imgV;
    }
    return _headImageView;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login-logo.png"]];
        [self.view addSubview:img];
        _logoImageView = img;
    }
    return _logoImageView;
}

- (UIButton *)logInButton{
    if (!_logInButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"36AEFF"] forState:UIControlStateNormal];
        _logInButton = btn;
        [self.contentScrollView addSubview:btn];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        btn.clipsToBounds = YES;
        btn.tag = 1001;
        btn.layer.cornerRadius = 2.5;
        [btn addTarget:self action:@selector(evnetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _logInButton;
}

- (UIButton *)findPasswdButton{
    if (!_findPasswdButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"找回密码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"37AEFF"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        _findPasswdButton = btn;
        [btn addTarget:self action:@selector(evnetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:btn];
        btn.tag = 1002;
    }
    return _findPasswdButton;
}

- (UIButton *)registerButton{
    if (!_registerButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"立即注册" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"37AEFF"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(evnetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:btn];
        _registerButton = btn;
        btn.tag = 1003;
    }
    return _registerButton;
}


- (void)evnetButtonClick:(UIButton*)btn{
    switch (btn.tag) {//登陆按钮点击
        case 1001:{
            [self logIntWith:self.phoneNumber passwd:self.passwdNumber];
        }
            break;
        case 1002:{//找回密码
            DLog(@"找回密码");
            FindViewController* findVC = [[FindViewController alloc]init];
            [self.navigationController pushViewController:findVC animated:YES];
        }
            break;
        case 1003:{//立即注册
            DLog(@"立即注册");
            RegisterViewController* registVC = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:registVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//登陆按钮点击
- (void)logIntWith:(NSString*)phoneNumber passwd:(NSString*)passwd{
    
    if (phoneNumber.length<=0) {
        [TipsView showTips:@"请输入手机号" inView:self.view];
        _logInButton.userInteractionEnabled = YES;
        
    }else if (phoneNumber.length<11){
        
        [TipsView showTips:@"请输入正确格式手机号" inView:self.view];
        _logInButton.userInteractionEnabled = YES;
        
    }else if (passwd.length<=0) {
        [TipsView showTips:@"请输入密码" inView:self.view];
        _logInButton.userInteractionEnabled = YES;
        
    }else if (passwd.length<6){
        [TipsView showTips:@"请输入6到20位的密码" inView:self.view];
        _logInButton.userInteractionEnabled = YES;
        
    }else if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        UIImageView *loading = [self setRotationAnimationWithView];
        _loadingView = loading;
        _hasLoginAction = YES;
        [[DataFactory sharedDataFactory] loginWtihMobile:[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""] andPassword:passwd andCallback:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{//add by wangzz 160809
                [self removeRotationAnimationView:loading];
                
                if (result.success) {
                    [self.passwdView setEndEditing:YES];
                    [self.phoneView setEndEditing:YES];
                    if (_phoneNumber.length > 0) {
                        [Tool setCache:_phoneNumber value:@"user_account"];
                    }
                    
                    if (result.message.length==0) {
                        result.message = @"登录成功";
                    }
                    [TipsView showTipsCantClick:result.message inView:self.view];
                    //检测版本升级
                    [self.appDelegate performSelector:@selector(checkVersionUpdate)];
                    

                    //[[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                    [self.phoneView setEndEditing:YES];
                    [self.passwdView setEndEditing:YES];
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popView) userInfo:nil repeats:NO];
                }else{
                    
                    [TipsView showTipsCantClick:result.message inView:self.view];
                    [self removeRotationAnimationView:loading];
                    
                    self.logInButton.userInteractionEnabled = YES;
                }
                
            });
        }];
        self.logInButton.userInteractionEnabled = NO;
    }
}

- (void)passwordUnlegalAction:(NSNotification*)notif{
    if (!_hasLoginAction) {
        return;
    }
    _hasLoginAction = NO;
    if (_loadingView) {
        [self removeRotationAnimationView:_loadingView];
        [self.passwdView clearText];
        self.logInButton.userInteractionEnabled = YES;
    }
    NSString* message = @"你的密码过于简单,为了你的账户安全，请及时修改密码";
//    if ([notif.object isKindOfClass:[NSString class]]) {
//        NSString* msg = (NSString*)notif.object;
//        message = msg.length > 0?msg:message;
//    }
    [TipsView showTips:message inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XTChangePasswordController* changeVC = [[XTChangePasswordController alloc] init];
        [self.navigationController pushViewController:changeVC animated:YES];
    });
}


-(void)popView{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SELECTEDHOMEPAGE" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadAllBuildingListVC" object:nil];

    
}
@end
