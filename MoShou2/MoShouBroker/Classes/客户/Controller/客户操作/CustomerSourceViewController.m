//
//  CustomerSourceViewController.m
//  MoShou2
//
//  Created by manager on 2017/4/20.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "CustomerSourceViewController.h"
#import "DataFactory+Customer.h"
#import "UserData.h"

@interface CustomerSourceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *sourceArr;
@property (nonatomic, strong) NSIndexPath    *oldIndex;

@end

@implementation CustomerSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"客户来源";
    _sourceArr = [[NSArray alloc] init];
    
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
    __weak typeof(self) weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = LINECOLOR;
    [self.view addSubview:self.tableView];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *str = [dateFormatter stringFromDate:nowDate];
    NSString *keyStr = [NSString stringWithFormat:@"CustomerSourceListData%@",[UserData sharedUserData].userInfo.userId];
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:keyStr] isEqualToString:str])
    {
        UIImageView* loadingView  = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] getCustomerSourceWithCallBack:^(ActionResult *result, NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI
                [self removeRotationAnimationView:loadingView];
                if (result.success) {
                    if (array.count>0) {
                        _sourceArr = array;
                        [_tableView reloadData];
                        [[NSUserDefaults standardUserDefaults] setValue:str forKey:keyStr];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else
                    {
                        [self showTips:result.message];
                    }
                }else
                {
                    [self showTips:result.message];
                }
            });
        }];
    }else
    {
        NSString* filePath = documentFilePathWithFileName(@"customerSourcedata", DataCacheFolder);
        NSDictionary *dic = [Tool unarchiveObjectWithKey:@"customerSourcedata" fromPath:filePath];
        _sourceArr = [CustomerSourceData objectArrayWithKeyValuesArray:dic];
        [_tableView reloadData];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth - 20-30, 30)];
    contentL.backgroundColor = [UIColor clearColor];
    contentL.textAlignment = NSTextAlignmentLeft;
    contentL.font = [UIFont systemFontOfSize:12];
    contentL.textColor = NAVIGATIONTITLE;//[UIColor colorWithHexString:@"0e0e0e"];
    [cell.contentView addSubview:contentL];
    
    UIImageView *selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-30-10, 12, 20, 20)];
    [selectImgView setImage:[UIImage imageNamed:@"img_select"]];
    selectImgView.hidden = YES;
    [cell.contentView addSubview:selectImgView];
    
    CustomerSourceData *sourceData = nil;
    if (_sourceArr.count>indexPath.row) {
        sourceData = [_sourceArr objectForIndex:indexPath.row];
    }
    contentL.text = [NSString stringWithFormat:@"%@.%@",sourceData.code,sourceData.label];
    if (_selectedData != nil) {
        if ([_selectedData.code isEqualToString:sourceData.code]) {
            selectImgView.hidden = NO;
            _oldIndex = indexPath;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_oldIndex];
    oldCell.imageView.hidden = YES;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.hidden = NO;
    [self.tableView reloadData];
    CustomerSourceData *confirm = nil;
    if (_sourceArr.count>indexPath.row) {
        confirm = [_sourceArr objectForIndex:indexPath.row];
    }
    _didSelectedSourceBlock(confirm);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectCustomerSourceDataBlock:(CustomerSourceSelectBlock)ablock
{
    self.didSelectedSourceBlock = ablock;
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
