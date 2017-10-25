//
//  BaseViewController.m
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkSingleton.h"
//#import "IQKeyboardManager.h"//add by zhm
//#import "ChangeInfoViewController.h"
#import "BaseNavigationController.h"
#import "UserData.h"

@interface BaseViewController ()<PLNavigationBarDelegate,UIAlertViewDelegate>
{
//        UIButton *startDateButton;
//        UIButton *endDateButton;
}
//网络请求失败页面
@property(nonatomic,strong) NetworkRequestFailed *networkRequestFailed;
@end


@implementation BaseViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self createNavigationBar];
    [self.view setBackgroundColor:BACKGROUNDCOLOR];
    /**
     *  解注释即可打开手势侧滑返回
     */
//    [self addSwipeRecognizer];//添加侧滑返回
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self activateAnimation];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.extendedLayoutIncludesOpaqueBars = NO;
    NSLog(@"%@",NSStringFromClass([self class]));
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    //add by zhm 20150713 使用智能键盘
    //    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    //    mage.enable = YES;
    //    mage.shouldResignOnTouchOutside = YES;
    //    mage.shouldToolbarUsesTextFieldTintColor = YES;
    //    mage.enableAutoToolbar = NO;
    
}

//在视图即将消失的时候打开侧滑返回create by xiaotei 2015/11/23
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    NSLog(@"%@",NSStringFromClass([self class]));
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        BaseNavigationController* baseNav = (BaseNavigationController*)self.navigationController;
        baseNav.popGestureRecognizerEnable = YES;
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark 添加右滑手势
- (void)addSwipeRecognizer
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popReturn)];
    
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    
    // 添加手势
    [self.view  addGestureRecognizer:swipeRecognizer];
}

//重写侧滑返回设置属性的setter方法create by xiaotei 2015/11/23
-(void)setPopGestureRecognizerEnable:(BOOL)popGestureRecognizerEnable{
    _popGestureRecognizerEnable = popGestureRecognizerEnable;
    
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        BaseNavigationController* baseNav = (BaseNavigationController*)self.navigationController;
        baseNav.popGestureRecognizerEnable = popGestureRecognizerEnable;
    }
}

#pragma mark 返回上一级
- (void)popReturn
{
    // 最低控制器无需返回
    if (self.navigationController.viewControllers.count <= 1) return;
    
    // pop返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)createNoNetWorkViewWithReloadBlock:(ReloadDataBlock)reloadData
{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection)
    {
        if (_networkRequestFailed.superview) {
            [_networkRequestFailed removeFromSuperview];
        }
        return NO;
    }
    else
    {
        if(!_networkRequestFailed.superview)
        {
            _networkRequestFailed=[[NetworkRequestFailed alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, self.view.bounds.size.height-64)];
            _networkRequestFailed.reloadData = reloadData;
            [self.view addSubview:_networkRequestFailed];
        }
        return YES;
    }
}
//接收和处理热点连接状态栏的变化消息事件
- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
//        CGRect newStatusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect newStatusBarFrame = [(NSValue*)[notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    if (newStatusBarFrame.size.height==20) {
        self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    }
    else if(newStatusBarFrame.size.height==40)
    {
        self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-20);
    }
    
    [self adjustFrameForHotSpotChange];
}

-(void)adjustFrameForHotSpotChange
{
    if (_networkRequestFailed.superview) {
        _networkRequestFailed.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
        [_networkRequestFailed adjustFrameForHotSpotChange];
    }
    if (self.animationImgView.superview) {
        CGFloat bg_width = 62 * self.view.bounds.size.width/320;
        self.animationImgView.frame = CGRectMake((self.view.bounds.size.width - bg_width)/2, (1 - 0.5) * self.view.bounds.size.height, bg_width, bg_width);
    }
}


-(void)createNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationBar = [[PLNavigationBar alloc] initWithDelegate:self];
    [self.view addSubview:self.navigationBar];
}

-(id<UIApplicationDelegate>)appDelegate
{
    id<UIApplicationDelegate> theDelegate = [UIApplication sharedApplication].delegate;
    return theDelegate;
}

- (void)leftBarButtonItemClick;
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(id)rootViewController
{
    UIViewController* rootVC = [[self appDelegate] window].rootViewController;
    return rootVC;
}

#pragma mark -begin 旋转加载动画loading
//重新激活加载动画
-(void)activateAnimation
{
    if (_animationImgView.superview)
    {
        UIImageView *loadingImgV = (UIImageView *)[_animationImgView viewWithTag:1];
        [loadingImgV.layer  removeAnimationForKey:@"Rotation"];
        
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.duration = .8;
        rotationAnimation.repeatCount = 10000000;//你可以设置到最大的整数值
        rotationAnimation.cumulative = NO;
        rotationAnimation.removedOnCompletion = YES;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [loadingImgV.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    }
}

- (void)handleUIApplicationWillEnterForegroundNotification:(NSNotification*)notification
{
    [self activateAnimation];
}

-(void)disableUserInteraction
{
    if ([_animationImgView superview])
    {
        for (UIView* subView in self.view.subviews) {
            
            if (![subView isEqual:self.navigationBar]) {
                subView.userInteractionEnabled = NO;
            }
        }
    }
}
-(void)setUserInteractionWithEnabel:(BOOL)enable{
   
        for (UIView* subView in self.view.subviews) {
            
            if (![subView isEqual:self.navigationBar]) {
                subView.userInteractionEnabled = enable;
            }
        }
    

}
- (UIImageView *)setRotationAnimationWithView
{
    [self performSelector:@selector(disableUserInteraction) withObject:nil afterDelay:0.0];
    
    //第二次进入，删除
    if ([_animationImgView superview]) {
        [_animationImgView removeFromSuperview];
    }
    
    CGFloat bg_width = 65 * SCALE6;
    
    CGFloat centerY = bg_width/2.0 - (bg_width /2.0 - (10 + 21 * SCALE6))/2.0 - 8 * SCALE6;
    
    _animationImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - bg_width)/2, (1 - 0.5) * self.view.bounds.size.height-bg_width/2, bg_width, bg_width)];
    _animationImgView.backgroundColor = [UIColor whiteColor];
    _animationImgView.clipsToBounds = YES;
    _animationImgView.layer.cornerRadius = 2.5;
    

    [self.view addSubview:_animationImgView];
    
    
    UIImageView* refreshV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16* SCALE6, 16 * SCALE6)];
    refreshV.image = [UIImage imageNamed:@"xtrefresh"];
    [_animationImgView addSubview:refreshV];
    [refreshV setCenter:CGPointMake(bg_width/2, centerY)];
    
    CGFloat width = 30 * SCALE6;
    UIImageView *loadingImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, width, width)];
    loadingImgV.tag = 1;
    [loadingImgV setCenter:CGPointMake(bg_width/2, centerY)];
    loadingImgV.image = [UIImage imageNamed:@"loading"];
    [_animationImgView addSubview:loadingImgV];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = .8;
    rotationAnimation.repeatCount = 10000000;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [loadingImgV.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(loadingImgV.frame) + 5 * SCALE6, _animationImgView.frame.size.width, 10)];
    label.textColor = [UIColor colorWithHexString:@"555555"];
    label.text = @"加载中...";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    [_animationImgView addSubview:label];
    
    return _animationImgView;

}

- (BOOL)removeRotationAnimationView:(UIImageView *)animationImgV
{
    for (UIView* subView in self.view.subviews) {
        subView.userInteractionEnabled = YES;
    }
//    UIImageView *animationImgV = (UIImageView *)[self.view viewWithTag:99990];
    if ([animationImgV superview]) {
        [animationImgV removeFromSuperview];
        animationImgV = nil;
        return YES;
    }
    return NO;
}
#pragma mark -end 旋转加载动画

//add by wangzz 150616
- (void) showTips:(NSString *)info
{
    [TipsView showTips:info inView:self.view];
}

- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES; 
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)myAlertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
//    if (alertView.tag == 10000)
//    {
//        switch (buttonIndex) {
//            case 0:
//            {
//            }
//                break;
//            case 1:
//            {
//                ChangeInfoViewController *VC = [[ChangeInfoViewController alloc]init];
//                VC.jumpType = 3;
//                [self.navigationController pushViewController:VC animated:YES];
//            }
//                break;
//            default:
//                break;
//        }
//    }
}

- (BOOL)verifyTheRulesWithShouldJump:(BOOL)isShouldJump;
{
    
    UserData *user = [UserData sharedUserData];
    if ([self isBlankString:user.storeId])
    {
        //如果门店为空
            if (isShouldJump) //需要跳转
            {
                MyAlertView *alert = [[MyAlertView alloc] initWithTitle:@"温馨提示" message:@"对不起，您还没有绑定门店，请先到[个人信息]绑定门店!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                alert.tag = 10000;
                [alert show];
                
                return NO;
            }
        
    }else
    {
        //有门店
        return YES;
    }
    return NO;
    
}






@end
