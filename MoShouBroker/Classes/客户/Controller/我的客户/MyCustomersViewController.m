//
//  MyCustomersViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MyCustomersViewController.h"
#import "MyCustomersTableViewCell.h"
#import "DataFactory+Customer.h"
#import "CustomerDetailViewController.h"
#import "CustomerEmptyView.h"
#import "CustomerCopyPhoneView.h"
//#import "CreateCallView.h"

@interface MyCustomersViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSIndexPath    *telIndexPath;
}
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) CustomerEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray  *isRestoreArray;
@property (nonatomic, strong) NSMutableArray  *telArray;
@property (nonatomic, copy) NSString        *telString;
@property (nonatomic, strong) UIWebView       *webView;//打电话时弹出的view
@property (nonatomic, copy) NSString          *buildingCustomerId;
@property (nonatomic, assign) BOOL            bIsTouched;

@end

@implementation MyCustomersViewController
@synthesize customerArr;
@synthesize isRestoreArray;
@synthesize telArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"我的客户";
    // Do any additional setup after loading the view.
//    customerArr = [[NSMutableArray alloc] init];
    isRestoreArray = [[NSMutableArray alloc] init];
    telArray = [[NSMutableArray alloc] init];
    [self hasNetwork];
}

- (void)leftBarButtonItemClick
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditFinishRefresh" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame =CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY) ;
    }
}

- (void)hasNetwork
{
    __weak MyCustomersViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    self.emptyView = [[CustomerEmptyView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY)];
    [self.view addSubview:self.emptyView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height - viewTopY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    if (self.customerArr.count>0) {
        self.emptyView.hidden = YES;
    }else
    {
        self.tableView.hidden = YES;
    }
    for (int i=0; i<customerArr.count; i++) {
        Customer *cust = [customerArr objectForIndex:i];
        if (![self isBlankString:cust.can_revokeRecommendation]) {
            [isRestoreArray appendObject:cust.can_revokeRecommendation];
        }
    }
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bHasCall"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bIsReport"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bHasQueKe"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return customerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    Customer *customerList = nil;
    if (customerArr.count>indexPath.row) {
        customerList = [customerArr objectForIndex:indexPath.row];
    }
//    MyCustomersTableViewCell *cell = (MyCustomersTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (isRestoreArray.count>indexPath.row) {
        if ([[isRestoreArray objectForIndex:indexPath.row] boolValue])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bIsReport"];
        }else
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bIsReport"];
        }
    }
    if ([customerList.listPhone rangeOfString:@"****"].location !=NSNotFound)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bHasCall"];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bHasCall"];
    }
    
    if (![self isBlankString:customerList.confirmUserName] || ![self isBlankString:customerList.confirmUserMobile]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bHasQueKe"];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bHasQueKe"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    if (cell == nil) {
        MyCustomersTableViewCell *cell = [[MyCustomersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
//    }
    __weak MyCustomersViewController *weakSelf = self;
    
    cell.customerList = customerList;
    if (customerList.name.length <= 9) {
        cell.customerNameLabel.text = customerList.name;
    }else
    {
        cell.customerNameLabel.text = [NSString stringWithFormat:@"%@...", [customerList.name substringToIndex:9]];
    }
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longGesture setMinimumPressDuration:0.4];
    cell.telLabel.userInteractionEnabled=YES;
    [cell.telLabel addGestureRecognizer:longGesture];
    cell.telLabel.text = customerList.listPhone;
    
    cell.statusLabel.text =customerList.status;
    UIView *lineView = nil;
    if (![self isBlankString:customerList.confirmUserName] || ![self isBlankString:customerList.confirmUserMobile]) {
        lineView = [self createLineView:100-0.5];
        cell.QueKeNameLabel.text = [NSString stringWithFormat:@"确客专员%@",customerList.confirmUserName];
        cell.QueKeTelLabel.text = customerList.confirmUserMobile;
        NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
        CGSize size = [cell.QueKeNameLabel.text sizeWithAttributes:attributes];
        cell.QueKeNameLabel.width = size.width;
        cell.QueKeTelLabel.left = cell.QueKeNameLabel.right +15;
    }else
    {
        lineView = [self createLineView:70-0.5];
    }
    [cell.contentView addSubview:lineView];
    [cell callMyCustomerCellBlock:^(NSString* phone){
//        int x = 1+arc4random() % 3;
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        if (x==1) {
//            [array appendObject:phone];
//        }else if (x==2)
//        {
//            [array appendObject:phone];
//            [array appendObject:@"158****0925"];
//            [array appendObject:@"15845890925"];
//        }else if (x==3)
//        {
//            [array appendObject:phone];
//            [array appendObject:@"13671206275"];//[array appendObject:@"158****0925"];//
//            [array appendObject:@"15945892580"];
//        }
//        for (int i=0; i<array.count; i++) {
//            if ([[array objectForIndex:i] rangeOfString:@"****"].location == NSNotFound) {
//                [weakSelf.telArray appendObject:[array objectForIndex:i]];
//            }
//        }
//        
//        if (weakSelf.telArray.count>1) {
//            CreateCallView *callView = [[CreateCallView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
//            callView.telArray = weakSelf.telArray;
//            [callView callCustomerBlock:^(NSInteger number) {
//                if (weakSelf.webView == nil) {
//                    weakSelf.webView = [[UIWebView alloc] init];
//                }
//                DLog(@"%p", weakSelf.webView);
//                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[weakSelf.telArray objectForIndex:number]]];
//                DLog(@"phoneNumber:%@",[weakSelf.telArray objectForIndex:number]);
//                NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                
//                [weakSelf.webView loadRequest:request];
//                [weakSelf.view addSubview:weakSelf.webView];
//            }];
//            [callView cancelViewBlock:^{
//                [weakSelf.telArray removeAllObjects];
//                [callView removeFromSuperview];
//            }];
//            [[UIApplication sharedApplication].keyWindow addSubview:callView];
//        }else
//        {
        if (weakSelf.webView == nil) {
            weakSelf.webView = [[UIWebView alloc] init];
        }
        DLog(@"%p", weakSelf.webView);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
        DLog(@"phoneNumber:%@",phone);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [weakSelf.webView loadRequest:request];
        [weakSelf.view addSubview:weakSelf.webView];
        [weakSelf.telArray removeAllObjects];
    }];
    
    [cell revertReportCellBlock:^(NSString *buildCustId){
        weakSelf.buildingCustomerId = buildCustId;
        if (!weakSelf.bIsTouched) {
            weakSelf.bIsTouched = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否要撤销报备？撤销后需要重新报备客户" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }
        
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 70;
    Customer *customerList = nil;
    if (customerArr.count>indexPath.row) {
        customerList = [customerArr objectForIndex:indexPath.row];
    }
    if (![self isBlankString:customerList.confirmUserName] || ![self isBlankString:customerList.confirmUserMobile]) {
        height = 100;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Customer *customerList = nil;
    if (customerArr.count>indexPath.row) {
        customerList = [customerArr objectForIndex:indexPath.row];
    }
    CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc] init];
    detailVC.custId = customerList.customerId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, y, kMainScreenWidth-15, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

#pragma mark - 长按手势
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    MyCustomersTableViewCell *cell = nil;
    if (iOS8) {
        cell = (MyCustomersTableViewCell *)[[longPress.view superview] superview];
    }else
    {
        cell = (MyCustomersTableViewCell *)[[[longPress.view superview] superview] superview];
    }
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    
    //    if ([self.bubbleView.text hasSuffix:@".amr"] || [self isFileExist:self.bubbleView.text]) {
    //        return;
    //    }else
//    {
    
        telIndexPath = [self.tableView indexPathForCell:cell];
    
    Customer *customerList = nil;
    if (customerArr.count>telIndexPath.row) {
        customerList = [customerArr objectForIndex:telIndexPath.row];
    }
    MobileVisible *mobile = (MobileVisible*)[customerList.phoneList objectForIndex:0];
    if (![self isBlankString:mobile.totalPhone]) {
        CustomerCopyPhoneView *custCopyView = [[CustomerCopyPhoneView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
        custCopyView.phoneArray = customerList.phoneList;
        //    __weak CustomerListViewController *customer = self;
        [custCopyView copyCustomerPhoneBlock:^(NSInteger number) {
            MobileVisible *mobile = (MobileVisible*)[customerList.phoneList objectForIndex:0];
            NSString *telString = mobile.hidingPhone;
            if (number == 1)
            {
                telString = mobile.totalPhone;
            }
            [[UIPasteboard generalPasteboard] setString:telString];
        }];
        [self.view addSubview:custCopyView];
    }else {
        _telString = cell.telLabel.text;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *saveItem;
        //    if(self.bubbleView.data){
        //        saveItem = [[UIMenuItem alloc] initWithTitle:@"Save" action:@selector(saveImage:)];
        //    }else{
        //        saveItem = nil;
        //    }
        
        [menu setMenuItems:[NSArray arrayWithObjects:saveItem, nil]];
        
        CGRect targetRect = [cell convertRect:cell.telLabel.frame
                                     fromView:cell.telLabel];
        [menu setTargetRect:CGRectInset(CGRectMake(targetRect.origin.x/2-20, targetRect.origin.y-30, targetRect.size.width, targetRect.size.height),0.0f, 0.0f) inView:cell];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        [menu setMenuVisible:YES animated:YES];
        
        [menu update];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] revokeRecommendationWithTrackId:self.buildingCustomerId withCallBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
                [self showTips:result.message];
                if (result.success) {
                    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:self.buildingId WithCallBack:^(ActionResult *actionResult,NSArray *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!actionResult.success) {
                                [self showTips:actionResult.message];
                            }
                            [self.customerArr removeAllObjects];
                            [self.isRestoreArray removeAllObjects];
                            self.customerArr = [NSMutableArray arrayWithArray:result];
                            
                            for (int i=0; i<self.customerArr.count; i++) {
                                Customer *cust = [self.customerArr objectForIndex:i];
                                if (![self isBlankString:cust.can_revokeRecommendation]) {
                                    [self.isRestoreArray appendObject:cust.can_revokeRecommendation];
                                }
                            }
                            _bIsTouched = NO;
                            [self.tableView reloadData];
                            if (self.customerArr.count>0) {
                                self.emptyView.hidden = YES;
                                self.tableView.hidden = NO;
                            }else
                            {
                                self.tableView.hidden = YES;
                                self.emptyView.hidden = NO;
                            }
                        });
                    }];
                }else
                {
                    _bIsTouched = NO;
                }
            });
        }];
    }
}

#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    //    self.bubbleView.selectedToShowCopyMenu = NO;
    MyCustomersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:telIndexPath];
    cell.telLabel.backgroundColor = [UIColor clearColor];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    //    self.bubbleView.selectedToShowCopyMenu = YES;
    MyCustomersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:telIndexPath];
    cell.telLabel.backgroundColor = bgViewColor;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    //    NSMutableArray *messageRange = [[NSMutableArray alloc] init];
    //
    //    NSMutableString *messageStr = [NSMutableString string];
    //    NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
    //    for (int index = 0; index < [messageRange count]; index++) {
    //
    //        NSString *str = [messageRange objectForIndex:index];
    //
    //            [messageStr appendString:str];
    //
    //    }
    
    [[UIPasteboard generalPasteboard] setString:_telString];
    [self resignFirstResponder];
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
