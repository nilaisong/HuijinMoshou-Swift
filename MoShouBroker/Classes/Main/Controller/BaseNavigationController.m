//
//  BaseNavigationController.m
//  MoShouBroker
//
//  Created by xiaotei on 15/11/22.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CustomerFollowDetailViewController.h"
#import "RemindListViewController.h"
#import "UserData.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    //    __weak typeof (self) weakSelf = self;
    //    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.interactivePopGestureRecognizer.delegate = weakSelf;
    //    }
    _popGestureRecognizerEnable = YES;
}
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    CGFloat scale = 1;
    CGPoint point = [gestureRecognizer locationInView:self.view];
//    self.topViewController;
//    if(![NetworkSingleton sharedNetWork].isNetworkConnection)return NO;
    NSArray* ignoreArray = @[@"XTUserScheduleViewController",@"MyBuildingViewController",@"MessageCenterViewController",@"ExchangeRecordsViewController",@"RemindListViewController",@"CustomerOperationViewController",@"CustomerFollowDetailViewController",@"XTWorkReportingController",@"XTAppointmentCarRecordController",@"XTWebNavigationControler",@"MessageListViewController",@"XTOperationListController",@"XTMapBuildingController",@"RecommendRecordController",@"XTBuildingSearchController"];
        NSString* topvcStr = NSStringFromClass(self.topViewController.class);
    for (NSString* vcStr in ignoreArray) {
        if ([topvcStr isEqualToString:vcStr]) {
            scale = 0.1;
        }
    }
    scale = [self scaleFloat:scale];
    
    BOOL islogIn = [UserData sharedUserData].isUserLogined;
    if (self.childViewControllers.count == 1 || !_popGestureRecognizerEnable || point.x >= self.view.frame.size.width * scale || !islogIn) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    
    if ([self.topViewController isKindOfClass:[CustomerFollowDetailViewController class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CustFollowLeftBarButtonItemClick" object:nil];
        return NO;
    }
    
    if ([self.topViewController isKindOfClass:[RemindListViewController class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemindLeftBarButtonItemClick" object:nil];
        return NO;
    }

    if ([self.topViewController isKindOfClass:[BaseViewController class]]) {
    id<BaseNavigationControllerDelegate> topVC = self.topViewController;
        if ([topVC respondsToSelector:@selector(baseNavigationController:didReturn:)]) {
            [topVC baseNavigationController:self didReturn:NSStringFromClass([self.topViewController class])];
        }
    }

    
    return YES;
}

- (CGFloat)scaleFloat:(CGFloat)scale{
    scale = 0.1;
    return scale;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"====== %@", NSStringFromClass([[[[[[touch.view superview] superview] superview] superview] superview] class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CustomerRangeSlider"]) {
//        return NO;
//    }
    
    return  YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

-(void)setPopGestureRecognizerEnable:(BOOL)popGestureRecognizerEnable{
    _popGestureRecognizerEnable = popGestureRecognizerEnable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
//    CGRect newStatusBarFrame = [(NSValue*)[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    

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
