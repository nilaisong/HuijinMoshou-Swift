//
//  CustReportSelectViewController.m
//  MoShou2
//
//  Created by manager on 2017/4/26.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "CustReportSelectViewController.h"
#import "CustomerTableView.h"
#import "DataFactory+Customer.h"
#import "CustomerSelectButton.h"
#import "IQKeyboardManager.h"

@interface CustReportSelectViewController ()<UIScrollViewDelegate,UITextFieldDelegate,CustomerTableViewCellDelegate>
{
    CGFloat      _oldOffset;
    NSString     *searchContent;
}

@property (nonatomic, strong) UIView          *topView;
@property (nonatomic, strong) UITextField     *searchBarTextField;

@property (nonatomic, strong) CustomerTableView *tableView;
@property (nonatomic, strong) CustomerSelectButton *btnView;

@property (nonatomic, strong) NSMutableArray *addressBookTemp;//通讯录获取到的联系人集合
@property (nonatomic, strong) UILabel *firstLetterLabel;

@property (nonatomic, assign) int          currentIndex;
@property (nonatomic, assign) BOOL         bIsScrollTop;

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation CustReportSelectViewController
@synthesize topView;
@synthesize searchBarTextField;

@synthesize titleArray;

@synthesize addressBookTemp;
@synthesize firstLetterLabel;

@synthesize btnView;

@synthesize currentIndex;
@synthesize bIsScrollTop;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.titleLabel.text = @"选择客户";
    self.navigationBar.barBackgroundImageView.backgroundColor = BACKGROUNDCOLOR;
    titleArray = [[NSMutableArray alloc] init];
    addressBookTemp = [[NSMutableArray alloc] init];
    bIsScrollTop = YES;
    
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY);
    }
}

- (void)hasNetwork
{
    __weak typeof(self) customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    firstLetterLabel=[[UILabel alloc] init];
    CGFloat x = kMainScreenWidth*2/3-25;
    CGFloat y = self.view.bounds.size.height*2/3-50;
    firstLetterLabel.frame=CGRectMake(x, y, 50, 50);
    firstLetterLabel.backgroundColor=[UIColor colorWithHexString:@"c9c9ce" alpha:0.6];
    firstLetterLabel.textColor=[UIColor colorWithHexString:@"939393"];
    firstLetterLabel.font=[UIFont boldSystemFontOfSize:30];
    firstLetterLabel.textAlignment = NSTextAlignmentCenter;
    [firstLetterLabel.layer setMasksToBounds:YES];
    [firstLetterLabel.layer setCornerRadius:5];
    firstLetterLabel.hidden = YES;
    
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    
    [self createTableView];
    [self createHeaderViewOfTable:viewTopY];
    [self initTableviewHeader];
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:firstLetterLabel];
    [self.view addSubview:firstLetterLabel];
    
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
    //    __weak CustomerReportViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:_buildingID AndKeyword:@"" WithCallBack:^(ActionResult *result,NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!result.success) {
                [self showTips:result.message];
            }
            [addressBookTemp addObjectsFromArray:array];
            bIsScrollTop = YES;
            
            if (self.addressBookTemp.count>0) {
                [self.tableView refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:0 withStore:NO];
            }else
            {
                [self.tableView refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
            }
            [self.tableView bringSubviewToFront:self.tableView.tableHeaderView];
        });
    }];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCustomerReportView" object:nil];
}

- (void)reloadCustomerReportViewData:(NSNotification*)notification
{
    [self requestCustomerListByKeyword:searchBarTextField.text];
}

- (void)createTableView
{
    _tableView = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) tableType:3 withHasShop:YES];
    _tableView.cellDelegate = self;
    __weak typeof(self) weakSelf = self;
    _tableView.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [self.view addSubview:_tableView];
}

- (void)initTableviewHeader
{
    //    NSString *str = @"";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    headerView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.tableHeaderView = headerView;
}

- (void)requestCustomerListByKeyword:(NSString*)keyword
{
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    //    UIImageView * loadingView = [self setRotationAnimationWithView];
    //    __weak CustomerReportViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:_buildingID AndKeyword:keyword WithCallBack:^(ActionResult *result,NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            if (![weakSelf removeRotationAnimationView:loadingView]) {
            //                return ;
            //            }
            //            if (!result.success) {
            //                [weakSelf showTips:result.message];
            //            }
            if (self.addressBookTemp.count != 0) {
                [self.addressBookTemp removeAllObjects];
            }
            [self.addressBookTemp addObjectsFromArray:array];
            self.bIsScrollTop = YES;
            if (self.addressBookTemp.count>0) {
                [self.tableView refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:0 withStore:NO];
            }else
            {
                [self.tableView refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:0 withStore:NO];
            }
            [self.tableView bringSubviewToFront:self.tableView.tableHeaderView];
        });
    }];
}

- (void)createHeaderViewOfTable:(CGFloat)theY
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, theY, kMainScreenWidth-15, 44)];
    topView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(10, 7, topView.width-20, 30)];
    searchBarView.backgroundColor = [UIColor whiteColor];
    [searchBarView.layer setCornerRadius:5];
    [searchBarView.layer setMasksToBounds:YES];
    [topView addSubview:searchBarView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, 14, 14)];
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [topView addSubview:searchImageView];
    
    searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(37, 10, topView.width - 47, 24)];
    searchBarTextField.delegate = self;
    searchBarTextField.returnKeyType = UIReturnKeySearch;
    searchBarTextField.placeholder = @"请输入客户姓名或手机号";
    searchBarTextField.text = searchContent;
    [searchBarTextField setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    searchBarTextField.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    searchBarTextField.textColor = NAVIGATIONTITLE;
    searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchBarTextField addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [topView addSubview:searchBarTextField];
}

- (void)CustomerDidSelectedCell:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath Customer:(Customer*)cust
{
    self.custoemrSelectBlock(cust);
    if ([self.view superview]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)returnCustoemrResultBlock:(CustomerReportSelectBlock)ablock
{
    self.custoemrSelectBlock = ablock;
}

#pragma mark - tableview上下滑动
-(void)scrollTableView:(UIScrollView *)scrollView{
    searchContent = searchBarTextField.text;
    [searchBarTextField resignFirstResponder];
    CGFloat height = _tableView.height;
    if (scrollView.contentOffset.y > _oldOffset && scrollView.contentOffset.y > 44) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
        if (bIsScrollTop) {
            bIsScrollTop = NO;
            NSLog(@"向上滑动！");
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.8];
            CGRect rect = [topView frame];
            
            rect.origin.x = 0;
            rect.origin.y = -24;
            [topView setFrame:rect];
            
            [self.view bringSubviewToFront:self.navigationBar];
            [UIView commitAnimations];
        }
    }
    else if (scrollView.contentOffset.y >= scrollView.contentSize.height - height)
    {
        if (!bIsScrollTop) {
            NSLog(@"滑到底部！");
            bIsScrollTop = YES;
        }
    }
    else if (scrollView.contentOffset.y < _oldOffset)
    {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - height-80 ) {
            bIsScrollTop = NO;
        }
        else{
            if (!bIsScrollTop) {
                NSLog(@"向下滑动！");
                bIsScrollTop = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.8];
                CGRect rect = [topView frame];
                rect.origin.x = 0;
                rect.origin.y = viewTopY;
                
                [topView setFrame:rect];
                
                [self.view bringSubviewToFront:self.navigationBar];
                [UIView commitAnimations];
            }
        }
    }
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

- (void)customerTableView:(CustomerTableView*)tableView FirstLetterSelecte:(NSString*)string
{
    firstLetterLabel.text = string;
    firstLetterLabel.hidden = NO;
    [CustReportSelectViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
}

- (void)delayMethod
{
    firstLetterLabel.hidden = YES;
}

//键盘搜索点击
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self textFieldDidChanged];
    return YES;
}

- (void)textFieldDidChanged
{
    __weak typeof(self) customer = self;
    OptionData *option = nil;
    if (titleArray.count > currentIndex) {
        option = [titleArray objectForIndex:currentIndex];
    }
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer requestCustomerListByKeyword:customer.searchBarTextField.text];}]) {
        [self requestCustomerListByKeyword:searchBarTextField.text];
    }
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

