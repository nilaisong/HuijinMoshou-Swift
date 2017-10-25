//
//  CustomerSelectViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerSelectViewController.h"
#import "CustomerTableView.h"
#import "DataFactory+Customer.h"
#import "CustomerSelectButton.h"
#import "IQKeyboardManager.h"

@interface CustomerSelectViewController ()<UIScrollViewDelegate,UITextFieldDelegate,CustomerTableViewCellDelegate>
{
    CGFloat      _oldOffset;
    NSString     *searchContent;
}

@property (nonatomic, strong) UIView          *topView;
@property (nonatomic, strong) UITextField     *searchBarTextField;
@property (nonatomic, strong) UIScrollView    *tableScrollView;

@property (nonatomic, strong) CustomerTableView *tableView1;
@property (nonatomic, strong) CustomerTableView *tableView2;
@property (nonatomic, strong) CustomerSelectButton *btnView;

@property (nonatomic, strong) NSMutableArray *addressBookTemp;//通讯录获取到的联系人集合
@property (nonatomic, strong) UILabel *firstLetterLabel;

@property (nonatomic, assign) int          currentIndex;
@property (nonatomic, assign) BOOL         bIsScrollTop;

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation CustomerSelectViewController
@synthesize topView;
@synthesize searchBarTextField;

@synthesize titleArray;

@synthesize addressBookTemp;
@synthesize firstLetterLabel;

@synthesize tableScrollView;
@synthesize tableView1;
@synthesize tableView2;
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
    if (self.tableScrollView.superview) {
        self.tableScrollView.frame = CGRectMake(0, viewTopY, self.view.bounds.size.width, self.view.bounds.size.height-viewTopY);
    }
}

- (void)hasNetwork
{
    __weak CustomerSelectViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    currentIndex = 0;
    
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
    
    OptionData* item1 = [[OptionData alloc] init];
    item1.itemName = @"全部";
    item1.itemValue=@"0";
    [self.titleArray insertObject:item1 forIndex:0];
    [self createTableView];
    [self createHeaderViewOfTable:viewTopY];
    [self.view addSubview:topView];
    
    [self.view bringSubviewToFront:firstLetterLabel];
    [self.view addSubview:firstLetterLabel];
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerSelectViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getCustomerListWithKeyword:@"" andGroupId:@"0" withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!actionResult.success) {
                [self showTips:actionResult.message];
            }
            [self.addressBookTemp addObjectsFromArray:result.customerList];
            [[DataFactory sharedDataFactory] getCustomerGroupListWithCallBack:^(ActionResult *actionResult,NSArray *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!actionResult.success) {
                        [self showTips:actionResult.message];
                    }
                    if (self.titleArray.count>0) {
                        [self.titleArray removeAllObjects];
                    }
                    [self.titleArray addObjectsFromArray:result];
                    OptionData* item1 = [[OptionData alloc] init];
                    item1.itemName = @"全部";
                    item1.itemValue=@"0";
                    [self.titleArray insertObject:item1 forIndex:0];
                    
                    [btnView removeAllSubviews];
                    [btnView removeFromSuperview];
                    btnView = nil;
                    [self createButtonView];
                    tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
                    if (currentIndex%2) {
                        self.tableView2.left = self.tableScrollView.contentOffset.x;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:NO];
                        }else
                        {
                            [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
                        }
                        
                    }else{
                        self.tableView1.left = self.tableScrollView.contentOffset.x;
                        if (self.addressBookTemp.count>0) {
                            [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:NO];
                        }else
                        {
                            [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
                        }
                    }
                });
            }];
        });
    }];
}

- (void)requestCustomerListByKeyword:(NSString*)keyWord AndGroupId:(NSString*)groupId WithIndex:(NSInteger)index WithFlag:(BOOL)flag
{
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = nil;
    if (flag) {
        loadingView = [self setRotationAnimationWithView];
    }
//    __weak CustomerSelectViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getCustomerListWithKeyword:keyWord andGroupId:groupId withCallBack:^(ActionResult *actionResult,CustomersResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (flag) {
                if (![self removeRotationAnimationView:loadingView]) {
                    return ;
                }
            }
            if (self.addressBookTemp.count > 0) {
                [self.addressBookTemp removeAllObjects];
            }
            [self.addressBookTemp addObjectsFromArray:result.customerList];
            if (index%2) {
                self.tableView2.left = self.tableScrollView.contentOffset.x;
                if (self.addressBookTemp.count>0) {
                    [self.tableView2 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:NO];
                }else
                {
                    [self.tableView2 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
                }
                
            }else{
                self.tableView1.left = self.tableScrollView.contentOffset.x;
                if (self.addressBookTemp.count>0) {
                    [self.tableView1 refreshTableViewWithCustomer:self.addressBookTemp ByCustomerType:self.currentIndex withStore:NO];
                }else
                {
                    [self.tableView1 refreshTableViewWithCustomer:nil ByCustomerType:self.currentIndex withStore:NO];
                }
            }
        });
    }];
}

- (void)createTableView
{
    tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY)];
    tableScrollView.delegate = self;
    tableScrollView.pagingEnabled = YES;
    tableScrollView.contentSize = CGSizeMake(kMainScreenWidth*titleArray.count, 0);
    [self.view addSubview:tableScrollView];
    
    tableView1 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:0 AndFrame:CGRectMake(0, 0, tableScrollView.width, tableScrollView.height) tableType:3 withHasShop:YES];
    tableView1.cellDelegate = self;
    __weak CustomerSelectViewController *weakSelf = self;
    tableView1.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [tableScrollView addSubview:tableView1];
    
    tableView2 = [[CustomerTableView alloc] initWithCustomer:addressBookTemp ByCustomerType:1 AndFrame:CGRectMake(kMainScreenWidth, 0, tableScrollView.width, tableScrollView.height) tableType:3 withHasShop:YES];
    tableView2.cellDelegate = self;
    tableView2.didScrollTableView = ^(UIScrollView *scrollView){
        [weakSelf scrollTableView:scrollView];
    };
    [tableScrollView addSubview:tableView2];
}

- (void)createHeaderViewOfTable:(CGFloat)theY
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, theY, kMainScreenWidth-15, 88)];
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
    
    UIView *scrollBgView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBarView.bottom+7, topView.width, 44)];
    scrollBgView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:scrollBgView];
    
    [self createButtonView];
}

- (void)createButtonView
{
    btnView = [[CustomerSelectButton alloc] initWithFrame:CGRectMake(0, 44+5, topView.width - 15, 39)];//预留出4像素的蓝线
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.padding = UIEdgeInsetsMake(0, 10, 0, 10); //上,左,下,右,的边距
    btnView.lastSelected = currentIndex;
    btnView.horizontalSpace = 10;                       //横向间隔
    //    headView.verticalSpace = 10;                         //纵向间隔
    btnView.dataSource = titleArray;
    __weak CustomerSelectViewController *customer = self;
    //数据源
    [btnView buttonSeleteBlock:^(int index,BOOL isSelected){
        if (customer.currentIndex != index) {
            customer.currentIndex = index;
            OptionData *option = nil;
            if (customer.titleArray.count > index) {
                option = [customer.titleArray objectForIndex:index];
            }
            [customer.tableScrollView setContentOffset:CGPointMake(index*customer.tableScrollView.width, 0)];
            [customer requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:index WithFlag:YES];
        }
    }];
    [topView addSubview:btnView];
}

- (void)CustomerDidSelectedCell:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath *)indexPath Customer:(Customer*)cust
{
    self.custoemrSelectBlock(cust);
    if ([self.view superview]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)returnCustoemrResultBlock:(CustomerSelectBlock)ablock
{
    self.custoemrSelectBlock = ablock;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (int)(tableScrollView.contentOffset.x/kMainScreenWidth);
    
    if (currentIndex != index) {
        currentIndex = index;
        [btnView seletedbBtnWithScrollIndex:index];
        OptionData *option = nil;
        if (titleArray.count > index) {
            option = [titleArray objectForIndex:index];
        }
        [self requestCustomerListByKeyword:searchBarTextField.text AndGroupId:option.itemValue WithIndex:index WithFlag:YES];
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
        if (!bIsScrollTop) {
            NSLog(@"向下滑动！");
            bIsScrollTop = YES;
        }
    }
    
    DLog(@"currentIndex = %d",currentIndex);
}

#pragma mark - tableview上下滑动
-(void)scrollTableView:(UIScrollView *)scrollView{
    searchContent = searchBarTextField.text;
    [searchBarTextField resignFirstResponder];
    int index = (int)(tableScrollView.contentOffset.x/kMainScreenWidth)%2;
    CGFloat height;
    if (index) {
        height = tableView2.height;
    }else{
        height = tableView1.height;
    }
    if (scrollView.contentOffset.y > _oldOffset && scrollView.contentOffset.y > 88) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
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
    [CustomerSelectViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
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
    __weak CustomerSelectViewController *customer = self;
    OptionData *option = nil;
    if (titleArray.count > currentIndex) {
        option = [titleArray objectForIndex:currentIndex];
    }
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:customer.currentIndex WithFlag:NO];}]) {
        [self requestCustomerListByKeyword:customer.searchBarTextField.text AndGroupId:option.itemValue WithIndex:customer.currentIndex WithFlag:NO];
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
