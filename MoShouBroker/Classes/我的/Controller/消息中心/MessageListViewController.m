//
//  MessageListViewController.m
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCenterViewController.h"
#import "MessageNoticeDetailViewController.h"
#import "DataFactory+Customer.h"
//#import "MJRefresh.h"
#import "UITableViewRowAction+JZExtension.h"
#import "IQKeyboardManager.h"
#import "UITableView+XTRefresh.h"

@interface MessageListViewController ()

@property (nonatomic, strong) MessageNoticeView *noticeView;
@property (nonatomic,strong)UITextField *searchTF;
@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)NSMutableArray *tempSearchResultArray;   //搜索结果数组
@property (nonatomic,assign)BOOL isSearching;


@property (nonatomic,copy)NSString * segmentNum;

@property (nonatomic, strong) UIView    *emptyView;

@end

@implementation MessageListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self refresh];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ChatUIHelper shareHelper] asyncConversationFromDB];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self tableViewDidTriggerHeaderRefresh];

    [self createEmptyView];
    
    
//    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
//    mage.enable = YES;
//    mage.shouldResignOnTouchOutside = YES;
//    mage.shouldToolbarUsesTextFieldTintColor = YES;
//    mage.enableAutoToolbar = NO;
//    
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
    self.isSearching = NO;
    self.tempSearchResultArray = [NSMutableArray array];
    
    //add by wangzz 161012
    self.navigationBar.titleLabel.text = @"消息列表";
    
    UIButton *historyBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-70, kFrame_Y(self.navigationBar.leftBarButton)+10,80,30)];
    [historyBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [historyBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    historyBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [historyBtn addTarget: self action:@selector(toggleHistoryButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:historyBtn];
    historyBtn.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 64+155/2, kMainScreenWidth, kMainScreenHeight-(64+155/2));

    [self addSegmentView];
    
    [self hasNetwork];
    
    [self createSearchView];
    _bgView.hidden = YES;

    
    // Do any additional setup after loading the view.
}

- (void)hasNetwork
{
    __weak MessageListViewController *message = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[message createNoticeView];}])
    {
        [self createNoticeView];
    }
}

- (void)createNoticeView
{//15034423692     123456
    _noticeView = [[MessageNoticeView alloc] initWithFrame:CGRectMake(0, viewTopY+50, kMainScreenWidth, self.view.bounds.size.height - viewTopY - 50)];
    _noticeView.cellDelegate = self;
    [self.view addSubview:_noticeView];
    UIImageView * loadingView = [self setRotationAnimationWithView];
    __weak MessageListViewController  *weakSelf = self;
    [[DataFactory sharedDataFactory] getMessagesListByPage:[NSString stringWithFormat:@"%d",_pageNum] WithCallBack:^(ActionResult *actionResult, DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
//            [self.noticeView.messageArray addObjectsFromArray:result.dataArray];
//            weakSelf.morePage = result.morePage;
            [self.noticeView.tableView addLegendHeaderWithRefreshingBlock:^{
                [weakSelf performSelector:@selector(HeaderRereshing) withObject:nil];
            }];//addLegendHeaderWithRefreshingTarget:weakSelf refreshingAction:@selector(HeaderRereshing)
            if (result.dataArray.count > 0) {
                self.noticeView.emptyView.hidden = YES;
            }else
            {
                self.noticeView.emptyView.hidden = NO;
            }
            [self.noticeView.messageArray addObjectsFromArray:result.dataArray];
            [self.noticeView.tableView reloadData];
        });
    }];
}


-(void)createSearchView
{
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(17/2, 30+64+10+5, kMainScreenWidth-17, 56/2)];
    
    _bgView.backgroundColor = BACKGROUNDCOLOR;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [self.view addSubview:_bgView];
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 15, 15)];
    [searchIcon setImage:[UIImage imageNamed:@"search-icon.png"]];
    [_bgView addSubview:searchIcon];
    
    _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(kFrame_XWidth(searchIcon)+5, 0, kFrame_Width(_bgView)-kFrame_XWidth(searchIcon)-30, 29)];
    _searchTF.placeholder = @"请输入确客姓名";
    _searchTF.font = FONT(14.f);
    _searchTF.textAlignment = NSTextAlignmentLeft;
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTF.delegate = self;
    [_searchTF addTarget:self action:@selector(searchTextEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//    [_searchTF becomeFirstResponder];
    _searchTF.returnKeyType = UIReturnKeySearch;

    [_bgView addSubview:_searchTF];

}

- (void)createEmptyView
{
    _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.tableView.height)];
    
    [self.tableView addSubview:_emptyView];
    
    float scale = kMainScreenWidth/375;
    
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"icon_notice_linemessage"]];
    [tempImage setFrame:CGRectMake(160*scale, _emptyView.height/2-2*57.5*scale, 55*scale, 57.5*scale)];
    //    [tempImage setCenterX:self.width/2];183
    [_emptyView addSubview:tempImage];
    
    CGSize size1 =[@"亲，你暂时没有收到消息哦!" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(10, tempImage.bottom+15, _emptyView.width - 20, size1.height)];
    [tipL setTextAlignment:NSTextAlignmentCenter];
    [tipL setFont:[UIFont boldSystemFontOfSize:16]];
    [tipL setCenterX:_emptyView.width/2];
    [tipL setTextColor:[UIColor colorWithHexString:@"888888"]];
    [tipL setText:@"亲，你暂时没有收到消息哦!"];
    [_emptyView addSubview:tipL];
    
    CGSize size2 =[@"与确客的会话消息会呈现在这里" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, tipL.bottom+5, _emptyView.width - 20, size2.height)];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [tip setFont:[UIFont systemFontOfSize:12]];
    [tip setCenterX:_emptyView.width/2];
    [tip setTextColor:[UIColor colorWithHexString:@"888888"]];
    [tip setText:@"与确客的会话消息会呈现在这里"];
    [_emptyView addSubview:tip];
    _emptyView.hidden = YES;
}

- (void)setupUnreadMessageCount{
    [self setEmptyViewHidden];
    [self refreshAndSortView];

}

- (void)setEmptyViewHidden
{
    //获取所有回话
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    DLog(@"conversations  dataarray ==   %ld    %ld",conversations.count,self.dataArray.count);
//    NSString *string = [NSString stringWithFormat:@"conversations  dataarray ==   %ld    %ld",conversations.count,self.dataArray.count];
//    AlertShow(string);
//    self.dataArray.count
    if ( self.dataArray.count >0) {
        _emptyView.hidden = YES;
    }else
    {
        _emptyView.hidden = NO;
    }
}

- (void)HeaderRereshing
{
    UIImageView * loadingView = [self setRotationAnimationWithView];
//    __weak MessageListViewController  *weakSelf = self;
    [[DataFactory sharedDataFactory] getMessagesListByPage:[NSString stringWithFormat:@"%d",_pageNum] WithCallBack:^(ActionResult *actionResult, DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self removeRotationAnimationView:loadingView]) {
                return ;
            }
            if (self.noticeView.messageArray.count > 0) {
                [self.noticeView.messageArray removeAllObjects];
            }
            [self.noticeView.messageArray addObjectsFromArray:result.dataArray];
//            weakSelf.morePage = result.morePage;
            if (result.dataArray.count > 0) {
                self.noticeView.emptyView.hidden = YES;
            }else
            {
                self.noticeView.emptyView.hidden = NO;
            }
            [self.noticeView.tableView.legendHeader endRefreshing];
            [self.noticeView.tableView reloadData];
        });
    }];
}

- (void)toggleHistoryButton
{
    [MobClick event:@"xxzx_lsjl"];//消息中心-历史记录
    MessageCenterViewController *msgVC = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}

-(void)addSegmentView
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"通知",@"聊天",nil];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, viewTopY+10, 200*SCALE, 30);
    segment.selectedSegmentIndex = 0;
    _emptyView.hidden = YES;
    segment.tintColor = BLUEBTBCOLOR;
    
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];
    
}

-(void)segmentAction:(UISegmentedControl *)segment
{
//    _Index = segment.selectedSegmentIndex;
    
    self.segmentNum = [NSString stringWithFormat:@"%zd",(long)segment.selectedSegmentIndex];
    
    _pageNum = 1;
    //0 通知       1 聊天
    if (segment.selectedSegmentIndex) {
        _noticeView.hidden = YES;
        _bgView.hidden = NO;
        [MobClick event:@"xxzx_liaotian"];//消息中心-聊天
        
        [self tableViewDidTriggerHeaderRefresh];

        [self setEmptyViewHidden];
    }else
    {
        [MobClick event:@"xxzx_tongzhi"];//消息中心-通知
        _noticeView.hidden = NO;
        _bgView.hidden = YES;
        _emptyView.hidden = YES;
    }
}

- (void)MessageDidSelectedCell:(MessageNoticeView*)noticeView AndIndexPath:(NSIndexPath *)indexPath Message:(MessageData*)msg
{
    MessageNoticeDetailViewController *detailVC = [[MessageNoticeDetailViewController alloc] init];
    detailVC.noticeType = [msg.msgType intValue];
    detailVC.navTitle = msg.title;
    detailVC.msgType = msg.msgType;
    detailVC.eatateId = msg.estateId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UITextFieldDelegate
-(void)searchTextEventEditingChanged:(UITextField*)textField
{
    DLog(@"textField.text = %@ ",textField.text);
    if (textField.text.length==0) {
        
        self.isSearching = NO;
        [self.tableView reloadData];
        return;
    }
    
    
    
    
    [self.tempSearchResultArray removeAllObjects];


    self.isSearching = YES;
    
    for (EaseConversationModel *conversationMo in self.dataArray) {
        
        DLog(@"nickName==%@",conversationMo.title);
        
       NSString *nameString =[UserCacheManager getNickById:conversationMo.conversation.conversationId];


        if ([nameString rangeOfString:textField.text].location!=NSNotFound) {
     //有 就加进去
            
            [self.tempSearchResultArray appendObject:conversationMo];
            
            DLog(@"_tempSearchResultArray==%@",_tempSearchResultArray);
            
        }
    }
    
    [self.tableView reloadData];
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    DLog(@"搜索  %@  ",textField.text);
    
    [textField resignFirstResponder];

    [self.tableView reloadData];

    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.searchTF resignFirstResponder];
    
//    self.isSearching = NO;
    
    [self.tableView reloadData];
    
    
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.searchTF resignFirstResponder];
    
//    self.isSearching = NO;
    
    [self.tableView reloadData];
    
}





#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (self.isSearching) {
        
      return [self.tempSearchResultArray count];
        
    }else{
     
        return [self.dataArray count];

    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DLog(@"_tempSearchResultArray==%@",_tempSearchResultArray);

    
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if (self.isSearching) {
        
        if ([self.tempSearchResultArray count] <= indexPath.row) {
            return cell;
        }
        
    }else{
        
        if ([self.dataArray count] <= indexPath.row) {
            return cell;
        }
    }
    
    
    id<IConversationModel> model;
    
    if (self.isSearching) {
        if (self.tempSearchResultArray.count > indexPath.row) {
            model = [self.tempSearchResultArray objectForIndex:indexPath.row];
        }

    }else{
        if (self.dataArray.count > indexPath.row) {
            model = [self.dataArray objectForIndex:indexPath.row];
        }
    }
    
    cell.model = model;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self.dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] textFont:cell.detailLabel.font];
    } else {
        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [self.dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    
    return cell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{


        if ([self.segmentNum isEqualToString:@"1"])
        {
            return YES;
        }else
        {
            return NO;
        }

}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 我的楼盘删除.png
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"loupan删除.png"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        
        EaseConversationModel *model;
        if (self.isSearching) {
            if (self.tempSearchResultArray.count > indexPath.row) {
                model = [self.tempSearchResultArray objectForIndex:indexPath.row];
            }

        }else{
            if (self.dataArray.count > indexPath.row) {
                model = [self.dataArray objectForIndex:indexPath.row];
            }

        }
        
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
        if (self.isSearching) {
            [self.tempSearchResultArray removeObjectForIndex:indexPath.row];

        }else{
            [self.dataArray removeObjectForIndex:indexPath.row];

        }
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self setEmptyViewHidden];

    }];
    
    return @[action];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeDot" object:nil];

    
    if (self.isSearching) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
            EaseConversationModel *model = [self.tempSearchResultArray objectForIndex:indexPath.row];
            [self.delegate conversationListViewController:self didSelectConversationModel:model];
        } else {
            EaseConversationModel *model = [self.tempSearchResultArray objectForIndex:indexPath.row];
            
            ChatViewController *viewController = [[ChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
            [self.navigationController pushViewController:viewController animated:YES];
        }

        
    }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
            EaseConversationModel *model = [self.dataArray objectForIndex:indexPath.row];
            [self.delegate conversationListViewController:self didSelectConversationModel:model];
        } else {
            EaseConversationModel *model = [self.dataArray objectForIndex:indexPath.row];
            
            ChatViewController *viewController = [[ChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
   }





-(void)refresh
{
    [self refreshAndSortView];
}
-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}



#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];

        
        NSDate *data = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        if ([data isToday]) {
            
            [formatter setDateFormat:@"HH:mm"];

        }else{
            [formatter setDateFormat:@"MM-dd"];

        }
        
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
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
