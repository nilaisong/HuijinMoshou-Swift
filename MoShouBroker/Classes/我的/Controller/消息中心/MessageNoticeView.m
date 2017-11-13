//
//  MessageNoticeView.m
//  MoShou2
//
//  Created by wangzz on 16/10/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MessageNoticeView.h"
#import "MessageNoticeTableViewCell.h"
#import "DataFactory+Customer.h"
//#import "UITableViewRowAction+JZExtension.h"


@interface MessageNoticeView ()


@end

@implementation MessageNoticeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"333333" alpha:0.1];
        _messageArray = [[NSMutableArray alloc] init];
        [self reloadView];
    }
    return self;
}

//- (void)setMessageArray:(NSMutableArray *)messageArray
//{
//    if (_messageArray != messageArray) {
//        _messageArray = messageArray;
//    }
//    if (_messageArray.count > 0) {
//        _emptyView.hidden = YES;
//    }else
//    {
//        _emptyView.hidden = NO;
//    }
//    [self.tableView reloadData];
//}

- (void)reloadView
{
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
//                msg.msgType = @"5";
//                msg.content = @"您预约的看房专车已将客户李宝芳送达首开地产";
//                msg.datetime = @"2016-10-24 13:20:09";
//                msg.count = @"99+";
//            }
//                break;
//            case 4:
//            case 5:
//            case 6:
//            {
//                msg.title = @"【已确客】美俄米别墅";
//                msg.msgType = @"4";
//                msg.content = @"您在楼盘美俄米别墅报备客户聂荣军已被确客";
//                msg.datetime = @"2016-10-24 13:00:01";
//            }
//                break;
//            case 7:
//            {
//                msg.title = @"【已带看】北辰别墅";
//                msg.msgType = @"4";
//                msg.content = @"您在楼盘北辰别墅报备客户郭丹若已被带看";
//                msg.datetime = @"2016-10-24 12:20:01";
//            }
//                break;
//            case 8:
//            case 9:
//            {
//                msg.title = @"【已认筹】美俄米别墅";
//                msg.msgType = @"4";
//                msg.content = @"您在楼盘美俄米别墅报备客户冯曦妤已认筹";
//                msg.datetime = @"2016-10-22 13:20:01";
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        [_messageArray addObject:msg];
//    }
    
    
    [self createTableView];
    [self createEmptyView];
    if (_messageArray.count > 0) {
        _emptyView.hidden = YES;
    }else
    {
        _emptyView.hidden = NO;
    }
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
}

- (void)createEmptyView
{
    _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    [self addSubview:_emptyView];
    
    float scale = kMainScreenWidth/375;
    
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"icon_notice_none"]];
    [tempImage setFrame:CGRectMake(157*scale, self.height/2-2*52*scale, 61*scale, 52*scale)];
//    [tempImage setCenterX:self.width/2];183
    [_emptyView addSubview:tempImage];
    
    CGSize size1 =[@"亲，你暂时没有收到消息哦!" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(10, tempImage.bottom+15, self.width - 20, size1.height)];
    [tipL setTextAlignment:NSTextAlignmentCenter];
    [tipL setFont:[UIFont boldSystemFontOfSize:16]];
    [tipL setCenterX:self.width/2];
    [tipL setTextColor:[UIColor colorWithHexString:@"888888"]];
    [tipL setText:@"亲，你暂时没有收到消息哦!"];
    [_emptyView addSubview:tipL];
    
    CGSize size2 =[@"报备流程、门店公告等通知会呈现在这里" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, tipL.bottom+5, self.width - 20, size2.height)];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [tip setFont:[UIFont systemFontOfSize:12]];
    [tip setCenterX:self.width/2];
    [tip setTextColor:[UIColor colorWithHexString:@"888888"]];
    [tip setText:@"报备流程、门店公告等通知会呈现在这里"];
    [_emptyView addSubview:tip];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count;
}

// 必须写的方法，和editActionsForRowAtIndexPath配对使用，里面什么不写也行
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {    }

//添加自定义侧滑删除
//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"xiaoxi删除"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//        [self deleteMessageWithIndexPath:indexPath];
//        
//    }];
//    
//    return @[action1];
//}
//删除按钮点击事件
//-(void)deleteMessageWithIndexPath:(NSIndexPath *)indexPath
//{
//    MessageData *data =(MessageData *)[self.listArr objectForIndex:indexPath.row];
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//        
//        [[DataFactory sharedDataFactory]deleteMessageWithMessageData:data andCallBack:^(ActionResult *result) {
//            if (result.success) {
//                if(self.listArr.count > indexPath.row){
//                    [self.listArr removeObjectForIndex:indexPath.row];
//                    
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [_msgTableView reloadData];
//                    
//                    if (self.listArr.count<=0) {
//                        [self tempView];
//                    }
//                });
//                
//                [TipsView showTipsCantClick:@"删除成功" inView:self.view];
//            }else{
//                [TipsView showTipsCantClick:result.message inView:self.view];
//            }
//            
//        }];
//    }
//    
//    
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageNoticeTableViewCell *cell = [[MessageNoticeTableViewCell alloc]init];
    
    MessageData *msgData = nil;
    if (self.messageArray.count>indexPath.row) {
        msgData = (MessageData *)[self.messageArray objectForIndex:indexPath.row];
    }
    
    cell.titleLabel.text = msgData.title;
    cell.contentLabel.text = msgData.content;
    NSDate *date = getNSDateWithDateTimeString(msgData.datetime);//[msgData.datetime stringByAppendingString:@":00"]
    cell.dateTimeLabel.text = [self stringFromDate:date];
//    msgData.count = @"100";
    NSString *msgCount = msgData.count;
    if ([msgCount integerValue] > 99) {
        msgCount = @"99+";
    }
    if ([msgData.count integerValue] > 0) {
        NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
        CGSize size = [msgCount sizeWithAttributes:attributes];
        cell.msgNumLabel.hidden = NO;
        cell.msgNumLabel.frame = CGRectMake(kMainScreenWidth-MAX(size.width+10, size.height)-8, cell.dateTimeLabel.bottom+(22-size.height)/2, MAX(size.width+10, size.height), size.height);
        [cell.msgNumLabel.layer setCornerRadius:size.height/2];
        cell.msgNumLabel.text = msgCount;
    }
    switch ([msgData.msgType integerValue]-1) {
        case 0:
        {
            cell.headeImageView.backgroundColor = BLUEBTBCOLOR;//[UIColor colorWithHexString:@""];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_all"]];
        }
            break;
        case 1:
        {
            cell.headeImageView.backgroundColor = BLUEBTBCOLOR;//[UIColor colorWithHexString:@""];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_all"]];
        }
            break;
        case 2:
        {
            cell.headeImageView.backgroundColor = BLUEBTBCOLOR;//[UIColor colorWithHexString:@""];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_all"]];
        }
            break;
        case 3:
        {
            cell.headeImageView.backgroundColor = [UIColor colorWithHexString:@"f0be24"];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_report"]];
        }
            break;
        case 4:
        {
            cell.headeImageView.backgroundColor = [UIColor colorWithHexString:@"f58e58"];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_car"]];
        }
            break;
        case 5:
        {
//            cell.headeImageView.backgroundColor = [UIColor colorWithHexString:@"f58e58"];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_custRefer"]];
        }
            break;
            
        default:
        {
            cell.headeImageView.backgroundColor = BLUEBTBCOLOR;//[UIColor colorWithHexString:@""];
            [cell.headeImageView setImage:[UIImage imageNamed:@"icon_notice_all"]];
        }
            break;
    }
    [cell addSubview:[self createLineView:60-0.5]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *msgData=nil;
    if (self.messageArray.count>indexPath.row) {
        msgData =(MessageData *)[self.messageArray objectForIndex:indexPath.row];
        [[DataFactory sharedDataFactory] readMessageByMsgType:msgData.msgType AndEstateId:msgData.estateId withCallBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.success) {
                    msgData.count = @"0";
                    if (self.messageArray.count > indexPath.row) {
                        [self.messageArray replaceObjectForIndex:indexPath.row withObject:msgData];
                    }
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeDot" object:nil];
                }
            });
        }];
        
    }
    if ([self.cellDelegate respondsToSelector:@selector(MessageDidSelectedCell:AndIndexPath:Message:)]) {
        [self.cellDelegate MessageDidSelectedCell:self AndIndexPath:indexPath Message:msgData];
    }
}

- (NSString*)stringFromDate:(NSDate*)inputDate
{
    NSString *str = nil;
    NSDate *date = [NSDate date];
    //    NSDate *earlier_date = [inputDate earlierDate:date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    NSInteger year = [components year]; // gives you year
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSDateComponents* components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:inputDate]; // Get necessary date components
    NSInteger year1 = [components1 year]; // gives you year
    NSInteger month1 = [components1 month];
    NSInteger day1 = [components1 day];
    if (year != year1) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        str = [dateFormatter stringFromDate:inputDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];//[dateFormatter setDateFormat:@"MM-dd HH:mm"];
        str = [dateFormatter stringFromDate:inputDate];
        NSLog(@"%@", str);
    }else
    {
        if (month == month1 && day == day1) {
//            str = @"今天";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            str = [dateFormatter stringFromDate:inputDate];//[NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:inputDate]];
            
        }
        //        else if ([earlier_date isEqualToDate:inputDate]) {
        //            str = @"昨天";
        //        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];//[dateFormatter setDateFormat:@"MM-dd HH:mm"];
            str = [dateFormatter stringFromDate:inputDate];
        }
    }
    //    NSDate *laterDate = [inputDate laterDate:date];
    //    NSLog(@"laterDate  = %@",laterDate);
    
    return str;
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, y, kMainScreenWidth-8, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
