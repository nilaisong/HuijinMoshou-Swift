//
//  CustomerSelGroupViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerSelGroupViewController.h"

@interface CustomerSelGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *groupArray;
@property (nonatomic, strong) NSMutableArray  *statusArray;
@property (nonatomic, strong) OptionData      *selectedData;
@property (nonatomic, strong) OptionData      *lastSelectedData;
@property (nonatomic, strong) UIButton        *saveBtn;
@property (nonatomic, assign) BOOL            bIsTouched;

@end

@implementation CustomerSelGroupViewController
@synthesize saveBtn;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    saveBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-40, kFrame_Y(self.navigationBar.leftBarButton)+10,50,30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"166fa2"] forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [saveBtn addTarget:self action:@selector(saveSelGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:saveBtn];
    
    _statusArray = [[NSMutableArray alloc] init];
    _groupArray = [[NSMutableArray alloc] init];
    _lastSelectedData = [[OptionData alloc] init];
    _lastSelectedData = _selectedData;
    
    [self hasNetwork];
    // Do any additional setup after loading the view.
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
    __weak CustomerSelGroupViewController *customer = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[customer reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, kMainScreenWidth - 60 -60, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    [titleLabel setAttributedText:[self transferLouPanString:[NSString stringWithFormat:@"%lu",(unsigned long)_groupArray.count]]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationBar addSubview:titleLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak CustomerSelGroupViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getCustomerGroupListWithCallBack:^(ActionResult *actionResult,NSArray *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (!actionResult.success) {
                [self showTips:actionResult.message];
            }
            if (self.groupArray.count > 0) {
                [self.groupArray removeAllObjects];
            }
            [self.groupArray addObjectsFromArray:result];
            OptionData* item1 = [[OptionData alloc] init];
            item1.itemName = @"全部";
            item1.itemValue=@"0";
            [self.groupArray appendObject:item1];
            [titleLabel setAttributedText:[self transferLouPanString:[NSString stringWithFormat:@"%lu",(unsigned long)self.groupArray.count]]];
            for (int i=0; i<self.groupArray.count; i++) {
                if (i==(self.groupArray.count-1)) {
                    [self.statusArray appendObject:@"1"];
                }else{
                    [self.statusArray appendObject:@"0"];
                }
            }
            for (int i=0;i<self.groupArray.count;i++) {
                OptionData *option = (OptionData*)[self.groupArray objectForIndex:i];
                if ([option.itemValue isEqualToString:self.selectedData.itemValue])
                {
                    if (self.statusArray.count > i) {
                        [self.statusArray replaceObjectForIndex:i withObject:@"1"];
                    }
                    break;
                }
            }
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIView   *lineView = nil;
    UILabel  *groupL = nil;
    UIButton *selectedBtn = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        lineView = [self createLineView:44-0.5];
        lineView.tag = 100;
        [cell.contentView addSubview:lineView];
        
        groupL = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, kMainScreenWidth-40-30, 30)];
        groupL.textColor = LABELCOLOR;
        groupL.font = FONT(16);
        groupL.tag = 101;
        [cell.contentView addSubview:groupL];
    
        selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(kMainScreenWidth-30-20, 7, 30, 30);
        selectedBtn.tag = 102;
        [selectedBtn setBackgroundColor:[UIColor clearColor]];
        [selectedBtn setImage:[UIImage imageNamed:@"big_selected"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"big_selected_h"] forState:UIControlStateSelected];
        [selectedBtn addTarget:self action:@selector(toggleSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectedBtn];
        
    }else
    {
        lineView = (UIView *)[cell.contentView viewWithTag:100];
        groupL = (UILabel *)[cell.contentView viewWithTag:101];
        selectedBtn = (UIButton *)[cell.contentView viewWithTag:102];
    }
    OptionData *data = nil;
    if (_groupArray.count > indexPath.row) {
        data = (OptionData*)[_groupArray objectForIndex:indexPath.row];
    }
    groupL.text = data.itemName;
    if (_statusArray.count > indexPath.row) {
        selectedBtn.selected = [[_statusArray objectForIndex:indexPath.row] boolValue];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, y, kMainScreenWidth-20, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

- (NSAttributedString *)transferLouPanString:(NSString*)number
{
    NSString *string = [NSString stringWithFormat:@"选择组[(%@ 组)]",number];
    NSRange range = [string  rangeOfString:@"]"];
    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:NAVIGATIONTITLE
                        range:NSMakeRange(0, 3)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:17]
                        range:NSMakeRange(0, 3)];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:LABELCOLOR
                        range:NSMakeRange(4, range.location-4)];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:15]
                        range:NSMakeRange(4, range.location-4)];
    return attriString;
}

- (void)saveSelGroup
{
//    if ([_lastSelectedData.itemValue isEqualToString:_selectedData.itemValue]) {
//        [self showTips:@"客户组未发生变动"];
//        return;
//    }
    if (!_bIsTouched) {
        [saveBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];
        _bIsTouched = YES;
        if (_bHasRequest) {
//            __weak CustomerSelGroupViewController *weakSelf = self;
            //一般这些个里边是网络请求，然后会有延迟，不会像现在刷新这么快
            UIImageView * loadingView = [self setRotationAnimationWithView];
            //        if ([_selectedData.itemValue isEqualToString:@""]) {
            //            [[DataFactory sharedDataFactory] delGroupCustomerWithCustomerId:_custId withCallBack:^(ActionResult *result) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    if (![weakSelf removeRotationAnimationView:loadingView]) {
            //                        return ;
            //                    }
            //
            //                    if (result.success) {
            //                        [weakSelf showTips:@"移动至\"全部\"组成功"];
            //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                            _didSelectedGroupBlock(_selectedData);
            //                            [weakSelf.navigationController popViewControllerAnimated:YES];
            //                        });
            //                    }else
            //                    {
            //                        [weakSelf showTips:@"移动至\"全部\"组失败"];
            //                    }
            //                });
            //            }];
            //        }else {
            [[DataFactory sharedDataFactory] moveCustToGroupWithCustId:_custId andGroupId:_selectedData.itemValue withCallBack:^(ActionResult *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![self removeRotationAnimationView:loadingView]) {
                        self.bIsTouched = NO;
                        [self.saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                        return ;
                    }
                    if (result.success) {
                        [self showTips:[NSString stringWithFormat:@"移动至\"%@\"组成功",_selectedData.itemName]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.bIsTouched = NO;
                            [self.saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                            self.didSelectedGroupBlock(self.selectedData);
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }else
                    {
                        self.bIsTouched = NO;
                        [self.saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                        [self showTips:[NSString stringWithFormat:@"移动至\"%@\"组失败",self.selectedData.itemName]];
                    }
                });
            }];
            //        }
        }else
        {
            _bIsTouched = NO;
            [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
            _didSelectedGroupBlock(_selectedData);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)toggleSelectedBtn:(UIButton*)sender
{
    UITableViewCell *cell = nil;
    if (iOS8) {
        cell = (UITableViewCell *)[[sender superview] superview];
    }else
    {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    NSLog(@"%@",sender.superview);
    NSLog(@"%@",sender.superview.superview);
    //拿到单元格后就把该单元格与表中单元格匹配
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    NSLog(@"-----%ld",(long)indexPath.row);
    if (indexPath.row != (_groupArray.count-1)) {
        if (!sender.selected) {
            sender.selected = YES;
            _selectedData = nil;
            if (_groupArray.count > indexPath.row) {
                _selectedData = [_groupArray objectForIndex:indexPath.row];
            }
            if (_statusArray.count > indexPath.row) {
                [_statusArray replaceObjectForIndex:indexPath.row withObject:@"1"];
            }
//            [_selectedArray appendObject:[_groupArray objectForIndex:indexPath.row]];
            for (int i=0;i<_statusArray.count;i++) {
                NSString *status = [_statusArray objectForIndex:i];
                if ([status isEqualToString:@"1"] && i != (_groupArray.count-1) && i != indexPath.row) {
                    if (_statusArray.count > indexPath.row) {
                        [_statusArray replaceObjectForIndex:i withObject:@"0"];
                    }
//                    [_selectedArray removeObject:[_groupArray objectForIndex:i]];
                    [self.tableView reloadData];
                    return;
                }
            }
        }else
        {
            sender.selected = NO;
            _selectedData = [_groupArray objectForIndex:_groupArray.count-1];
            if (_statusArray.count > indexPath.row) {
                [_statusArray replaceObjectForIndex:indexPath.row withObject:@"0"];
            }
//            [_selectedArray removeObject:[_groupArray objectForIndex:indexPath.row]];
        }
    }
}

- (void)setData:(OptionData *)data andGroupBlock:(CustomerSelectGroupBlock)ablock
{
    self.selectedData = data;
    self.didSelectedGroupBlock = ablock;
    
    [self.tableView reloadData];
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
