//
//  MessageNoticeDetailViewController.m
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MessageNoticeDetailViewController.h"
#import "DataFactory+Customer.h"
#import "MessageNoticeDetailTableViewCell.h"
#import "CarDetailViewController.h"
#import "BuildFollowDetailViewController.h"
#import "CustomerReportedDetailModel.h"
#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "BuildingDetailViewController.h"

@interface MessageNoticeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *noticeDetailArr;

@end

@implementation MessageNoticeDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0eff5"];
    self.navigationBar.titleLabel.text = self.navTitle;
    self.page = 1;
    self.morePage = NO;
//    switch (_noticeType-1) {
//        case 0:
//        {
//            self.navigationBar.titleLabel.text = self.navTitle;
//        }
//            break;
//        case 1:
//        {
//            self.navigationBar.titleLabel.text = self.navTitle;
//        }
//            break;
//        case 2:
//        {
//            self.navigationBar.titleLabel.text = self.navTitle;
//        }
//            break;
//        case 3:
//        {
//            self.navigationBar.titleLabel.text = @"约车提醒";
//        }
//            break;
//        case 4:
//        {
//            self.navigationBar.titleLabel.text = self.navTitle;
//        }
//            break;
//            
//        default:
//            break;
//    }
    _noticeDetailArr = [[NSMutableArray alloc] init];
    [self hasNetwork];
    
    
    // Do any additional setup after loading the view.
}

- (void)hasNetwork
{
    __weak MessageNoticeDetailViewController *message = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[message reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
//    NSMutableArray *tempMutArr = [[NSMutableArray alloc] init];
//    for (int i=0; i<10; i++) {
//        MessageData *msg = [[MessageData alloc] init];
//        switch (i) {
//            case 0:
//            {
//                msg.title = @"门店名称公告";
//                msg.msgType = @"1";
//                msg.content = @"南京、太原定于7月28日晚9:00进行升级，请相关人员做好配合工作!";
//                msg.datetime = @"2016-10-24 13:20:11";
//                msg.count = @"11";
//            }
//                break;
//            case 1:
//            {
//                msg.title = @"汇金行公告";
//                msg.msgType = @"2";
//                msg.content = @"苏州、上海定于8月28日晚8:00进行升级";
//                msg.datetime = @"2016-10-24 13:20:01";
//                msg.count = @"1";
//            }
//                break;
//            case 2:
//            {
//                msg.title = @"汇金行提醒";
//                msg.msgType = @"3";
//                msg.content = @"汇金行温馨提示：丰田任何事";
//                msg.datetime = @"2016-10-24 13:20:01";
//                msg.count = @"23";
//            }
//                break;
//            case 3:
//            {
//                msg.title = @"约车看房";
//                msg.msgType = @"4";
//                msg.content = @"您预约的看房专车已将客户李宝芳送达首开地产您预约的看房专车已将客户李宝芳送达首开地产您预约的看房专车已将客户李宝芳送达首开地产您预约的看房专车已将客户李宝芳送达首开地产您预约的看房专车已将客户李宝芳送达首开地产您预约的看房专车已将客户李宝芳送达首开地产";
//                msg.datetime = @"2016-10-24 13:20:09";
//                msg.count = @"99+";
//            }
//                break;
//            case 4:
//            case 5:
//            case 6:
//            {
//                msg.title = @"【已确客】美俄米别墅";
//                msg.msgType = @"5";
//                msg.content = @"您在楼盘美俄米别墅报备客户聂荣军已被确客您在楼盘美俄米别墅报备客户聂荣军已被确客您在楼盘美俄米别墅报备客户聂荣军已被确客您在楼盘美俄米别墅报备客户聂荣军已被确客您在楼盘美俄米别墅报备客户聂荣军已被确客您在楼盘美俄米别墅报备客户聂荣军已被确客";
//                msg.datetime = @"2016-10-24 13:00:01";
//            }
//                break;
//            case 7:
//            {
//                msg.title = @"【已带看】北辰别墅";
//                msg.msgType = @"5";
//                msg.content = @"您在楼盘北辰别墅报备客户郭丹若已被带看您在楼盘北辰别墅报备客户郭丹若已被带看您在楼盘北辰别墅报备客户郭丹若已被带看您在楼盘北辰别墅报备客户郭丹若已被带看";
//                msg.datetime = @"2016-10-24 12:20:01";
//            }
//                break;
//            case 8:
//            case 9:
//            {
//                msg.title = @"【已认筹】美俄米别墅";
//                msg.msgType = @"5";
//                msg.content = @"您在楼盘美俄米别墅报备客户冯曦妤已认筹";
//                msg.datetime = @"2016-10-22 13:20:01";
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        [tempMutArr addObject:msg];
//    }
//    NSArray *array = tempMutArr;
//    [self.noticeDetailArr addObjectsFromArray:[[array reverseObjectEnumerator] allObjects]];
    [self createTableView];
    UIImageView * loadingView = [self setRotationAnimationWithView];
    __weak MessageNoticeDetailViewController *weakSelf = self;
    [[DataFactory sharedDataFactory] getNoticeListByPage:[NSString stringWithFormat:@"%d",_page] WithMsgType:_msgType AndEatateId:_eatateId WithCallBack:^(ActionResult *actionResult, DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
//            [self.noticeDetailArr addObjectsFromArray:result.dataArray];
            NSLog(@"当前页数 %d数组个数 %ld",_page,result.dataArray.count);
            [self.noticeDetailArr addObjectsFromArray:[[result.dataArray reverseObjectEnumerator] allObjects]];
            [self.tableView reloadData];
            if (self.noticeDetailArr.count>0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.noticeDetailArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            self.morePage = result.morePage;
            if (self.morePage) {
                [self.tableView clearRefreshView];
                [self.tableView addMessageHeaderWithRefreshingBlock:^{
                    [weakSelf performSelector:@selector(HeaderRereshing) withObject:nil];
                }];
//                [weakSelf.tableView addMessageHeaderWithRefreshingTarget:weakSelf refreshingAction:@selector(HeaderRereshing)];
            }
        });
    }];
}

- (void)HeaderRereshing
{
    _page++;
    UIImageView * loadingView = [self setRotationAnimationWithView];
    __weak MessageNoticeDetailViewController  *weakSelf = self;
    [[DataFactory sharedDataFactory] getNoticeListByPage:[NSString stringWithFormat:@"%d",_page] WithMsgType:_msgType AndEatateId:_eatateId WithCallBack:^(ActionResult *actionResult, DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            
            //            [self.noticeView.messageArray addObjectsFromArray:result.dataArray];
            for (int i=0; i<result.dataArray.count; i++) {
                [self.noticeDetailArr insertObject:[result.dataArray objectForIndex:i] forIndex:0];
            }
            self.morePage = result.morePage;
            [self.tableView.header endRefreshing];
            
            [self.tableView removeHeader];
            if (self.morePage)
            {
                [self.tableView clearRefreshView];
                [self.tableView addMessageHeaderWithRefreshingBlock:^{
                    [weakSelf performSelector:@selector(HeaderRereshing) withObject:nil];
                }];
//                [weakSelf.tableView addMessageHeaderWithRefreshingTarget:weakSelf refreshingAction:@selector(HeaderRereshing)];
            }
            
            [self.tableView reloadData];
            if (self.noticeDetailArr.count>result.dataArray.count) {
                NSInteger row = self.noticeDetailArr.count-(_page-1)*[PAGESIZE integerValue];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
    }];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.size.height-viewTopY)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f0eff5"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noticeDetailArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *msgData = nil;
    if (_noticeDetailArr.count>indexPath.row) {
        msgData = [_noticeDetailArr objectForIndex:indexPath.row];
    }
    MessageNoticeDetailTableViewCell *cell = [[MessageNoticeDetailTableViewCell alloc]initWithMessageData:msgData AndMsgType:_msgType AndIndexPath:indexPath];
    [cell.bottomBtn addTarget:self action:@selector(toggleDetailButton:) forControlEvents:UIControlEventTouchUpInside];
//    cell.timeLabel.text = @"2016-10-24 06:20";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    MessageData *msgData = nil;
    if (_noticeDetailArr.count>indexPath.row) {
        msgData = [_noticeDetailArr objectForIndex:indexPath.row];
    }
    NSDictionary *attributes = @{NSFontAttributeName:FONT(12)};
    CGSize size = [@"2020-02-02 08:30" sizeWithAttributes:attributes];
    CGSize contentSize = [self textSize:msgData.content withConstraintWidth:kMainScreenWidth-60];
    if ([_msgType isEqualToString:@"4"] || [_msgType isEqualToString:@"5"] || [_msgType isEqualToString:@"8"]) {
        height = 15+size.height+10+15+10+30+20+25+contentSize.height+25+24+10;
    }else
    {
        height = 15+size.height+10+15+10+30+20+25+contentSize.height+15;
    }
    if (indexPath.row == _noticeDetailArr.count-1) {
        height += 10;
    }
    
    return height;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)toggleDetailButton:(UIButton*)sender
{
    MessageNoticeDetailTableViewCell *cell = nil;
    if (iOS8) {
        cell = (MessageNoticeDetailTableViewCell *)[[sender superview] superview];
    }else
    {
        cell = (MessageNoticeDetailTableViewCell *)[[[sender superview] superview] superview];
    }
    NSIndexPath *tempIndexPath = [self.tableView indexPathForCell:cell];
    MessageData *msgData = nil;
    if (_noticeDetailArr.count>tempIndexPath.row) {
        msgData = [_noticeDetailArr objectForIndex:tempIndexPath.row];
    }
    if ([_msgType isEqualToString:@"4"])
    {
        BuildFollowDetailViewController *buildDetailVC = [[BuildFollowDetailViewController alloc] init];
//        buildDetailVC.trade = trade;
        
        buildDetailVC.bizType = msgData.bizType;
        buildDetailVC.bizNodeId = msgData.bizNodeId;
        buildDetailVC.waitConfirmId = msgData.waitConfirmId;
        buildDetailVC.bIsMessageDetail = YES;
        [self.navigationController pushViewController:buildDetailVC animated:YES];
        
    }else if ([_msgType isEqualToString:@"5"])
    {
        CarDetailViewController *carDetailVC = [[CarDetailViewController alloc] init];
        carDetailVC.estateAppointCarID = msgData.estateAppointCarId;
        [self.navigationController pushViewController:carDetailVC animated:YES];
    }else if ([_msgType isEqualToString:@"8"])
    {
        BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
        VC.buildingId = msgData.estateId;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
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
