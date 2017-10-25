//
//  ChatViewController.m
//  MoShou2
//
//  Created by strongcoder on 16/9/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ChatViewController.h"
#import "BuildingMessageDetailCell.h"
#import "EaseBaseMessageCell.h"
#import "MJRefresh.h"
#import "DataFactory+Building.h"
#import "IQKeyboardManager.h"
//#import "UITableView+XTRefresh.h"

#import "PopView.h"
#import "AppDelegate.h"
//#import "BuildingDetailViewController.m"
@interface ChatViewController ()<PopViewDelegate>
{
    
    PopView *_popView;
    Building * _buildingZiXunArrayModel;
    UIView * _maskView;
    
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    [self loadBuildingData];
    
    
//    
//    UITapGestureRecognizer *ziXunTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(consultBuilding)];
//    if ([self.conversation.conversationId rangeOfString:@"confirm"].location!=NSNotFound) {
//        //@"确客";
////        toobar.ziXunBuildingLabel.text = @"咨询楼盘";
//        
//        CGFloat chatbarHeight = 46;  //[EaseChatToolbar defaultHeight];
//        EMChatToolbarType barType = self.conversation.type == EMConversationTypeChat ? EMChatToolbarTypeChat : EMChatToolbarTypeGroup;
//        self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
//        self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//
//        
//        EaseChatToolbar *toobar = (EaseChatToolbar *)self.chatToolbar;
//        toobar.ziXunBuildingLabel.height = 0;
//        toobar.ziXunBuildingLabel.hidden = YES;
//        toobar.ziXunTitleLabel.height = 0;
//        toobar.ziXunTitleLabel.hidden = YES;
//        
//        [toobar.inputTextView setTop:5];
//        [toobar.inputTextView setHeight:36.f];
//        
//        
//    }else{
////        toobar.ziXunBuildingLabel.text = @"推荐楼盘";
//    
//        CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
//        EMChatToolbarType barType = self.conversation.type == EMConversationTypeChat ? EMChatToolbarTypeChat : EMChatToolbarTypeGroup;
//        self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
//        self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        
//
//    
//    }

    
    EaseChatToolbar *toobar = (EaseChatToolbar *)self.chatToolbar;

    UITapGestureRecognizer *ziXunTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(consultBuilding)];
    if ([self.conversation.conversationId rangeOfString:@"confirm"].location!=NSNotFound) {
        //@"确客";
        toobar.ziXunBuildingLabel.text = @"咨询楼盘";
        
    }else{
//        toobar.ziXunBuildingLabel.text = @"推荐楼盘";
        toobar.ziXunBuildingLabel.height = 0;
        toobar.ziXunBuildingLabel.hidden = YES;
        toobar.ziXunTitleLabel.height = 0;
        toobar.ziXunTitleLabel.hidden = YES;
        
        [toobar.toolbarBackgroundImageView setHeight:72/2-5];
        toobar.toolbarBackgroundImageView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];

    }
    

    [toobar.ziXunBuildingLabel addGestureRecognizer:ziXunTap];


    
    NSString *nickName = [UserCacheManager getNickById:self.conversation.conversationId ];
    
    //如果没有传过来值 就用本地数据中的查找昵称
    if (self.nickName.length>0) {
       
        self.navigationBar.titleLabel.text = self.nickName;        

    }else{
        self.navigationBar.titleLabel.text = nickName;
    }
    
    [[BuildingMessageDetailCell appearance] setAvatarSize:40.f];
    [[BuildingMessageDetailCell appearance] setAvatarCornerRadius:20.f];
    
    
    __weak ChatViewController *weakSelf = self;
    [self.tableView.legendHeader setHidden:YES];
//    [self.tableView clearRefreshView];
    [self.tableView addMessageHeaderWithRefreshingBlock:^{
        [weakSelf tableViewDidTriggerHeaderRefresh];
        [weakSelf.tableView.header beginRefreshing];
        
    }];
    
    [self shouldShowChatVCFirstTimeShowImg];
}


-(void)loadBuildingData
{
    
    [[DataFactory sharedDataFactory] getEstateByConfirmUser:nil andConfirmChatUserName:self.conversation.conversationId withCallBack:^(ActionResult *result, NSArray *array) {
        
        if (result.success) {
            
            if (array.count) {
            
                _buildingZiXunArrayModel= [[Building alloc]init];
                _buildingZiXunArrayModel.ziXunBuildingArray = array;
            
            }
            
        }
        
    }];
    
}


//-(void)toBuildingDetailClick:(UIButton*)sender
//{
//    BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
//    
//    VC.buildingId = self.buildingID;
//    
//    [self.navigationController pushViewController:VC animated:YES];
//
//}
//
-(void)consultBuilding
{   [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_ZXLP" andPageId:@"PAGE_LTXQ"];
    [MobClick event:@"xxzx_liaotian_zxlp"];

    DLog(@"点击咨询楼盘了");
    EaseChatToolbar *toobar = (EaseChatToolbar *)self.chatToolbar;

    [toobar.inputTextView resignFirstResponder];
    
    
    

    if (!_popView) {
        _popView = [[PopView alloc]initWithType:([self.conversation.conversationId rangeOfString:@"confirm"].location!=NSNotFound)?kConsultBuilding:kRecommendBuilding AndBuilding:_buildingZiXunArrayModel];
        _popView.delegate =self;
        
        __weak ChatViewController *weakSelf = self;
        
        _popView.DidSelectOneBuildingBlock = ^(Estate *estateModel){
            NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
            
            //    agency_building_url    楼盘图片url
            //    agency_building_name    楼盘名字
            //    agency_building_id    楼盘id
            //    agency_building_area    楼盘区域商圈
            //    agency_building_detail     是否显示楼盘详情的自定义图片view
            //    agency_mobile            经纪人手机号
            //    agency_employeeNo  经纪人员工编号
            //    agency_department 经纪人机构门店
            //    [extDic setValue:userInfo.Id forKey:kChatUserId];
            //    [extDic setValue:userInfo.AvatarUrl forKey:kChatUserPic];
            //    [extDic setValue:userInfo.NickName forKey:kChatUserNick];
            
            [extDic setValue:estateModel.url forKey:@"agency_building_url"];
            [extDic setValue:estateModel.name forKey:@"agency_building_name"];
            [extDic setValue:estateModel.estateId forKey:@"agency_building_id"];
            [extDic setValue:[NSString stringWithFormat:@"%@-%@",estateModel.districtName,estateModel.plateName] forKey:@"agency_building_area"];
            [extDic setValue:@"1" forKey:@"agency_building_detail"];
            [extDic setValue:[UserData sharedUserData].mobile forKey:@"agency_mobile"];
            [extDic setValue:[UserData sharedUserData].employeeNo forKey:@"agency_employeeNo"];
            [extDic setValue:[NSString stringWithFormat:@"%@ %@",[UserData sharedUserData].orgnizationName,[UserData sharedUserData].storeName] forKey:@"agency_department"];
            //对方环信ID
            //    easemobConfirmMo.username
            //@"test_confirm_15344444444"
            NSString *sendMsg =  [NSString stringWithFormat:@"[%@]",estateModel.name];
            //发送文字消息
            
            
            
            
            EMMessage *message = [EaseSDKHelper sendTextMessage:sendMsg
                                                             to:weakSelf.conversation.conversationId//接收方
                                                    messageType:EMChatTypeChat//消息类型
                                                     messageExt:extDic]; //扩展信息
            [weakSelf _sendMessage:message];
            
            
            
            //    //发送构造成功的消息
            //    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
            //    } completion:^(EMMessage *message, EMError *error) {
            //        
            //      
            //        DLog(@"%@    %@   %@  ",message.from,message.to,message,error);
            //    }];
            
        };
        
        [self showWithPopView:_popView];

        
    }
    
    
}





- (void)_sendMessage:(EMMessage *)message
{
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_WZLT" andPageId:@"PAGE_LTXQ"];

    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            [weakself _refreshAfterSentMessage:aMessage];
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
}


- (void)_refreshAfterSentMessage:(EMMessage*)aMessage
{
    if ([self.messsagesSource count] && [EMClient sharedClient].options.sortMessageByServerTime) {
        NSString *msgId = aMessage.messageId;
        EMMessage *last = self.messsagesSource.lastObject;
        if ([last isKindOfClass:[EMMessage class]]) {
            
            __block NSUInteger index = NSNotFound;
            index = NSNotFound;
            [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[EMMessage class]] && [obj.messageId isEqualToString:msgId]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            if (index != NSNotFound) {
                [self.messsagesSource removeObjectForIndex:index];
                [self.messsagesSource appendObject:aMessage];
                
                //格式化消息
                self.messageTimeIntervalTag = -1;
                NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:formattedMessages];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                return;
            }
        }
    }
    [self.tableView reloadData];
}

- (NSArray *)formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (EMMessage *message in messages) {
        //Calculate time interval
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSString *timeStr = @"";
            
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:stringForDate:)]) {
                timeStr = [self.dataSource messageViewController:self stringForDate:messageDate];
            }
            else{
                timeStr = [messageDate formattedTime];
            }
            [formattedArray appendObject:timeStr];
            self.messageTimeIntervalTag = message.timestamp;
        }
        
        //Construct message model
        id<IMessageModel> model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
            model = [self.dataSource messageViewController:self modelForMessage:message];
        }
        else{
            model = [[EaseMessageModel alloc] initWithMessage:message];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            model.failImageName = @"imageDownloadFail";
        }
        
        if (model) {
            [formattedArray appendObject:model];
        }
    }
    
    return formattedArray;
}



#pragma mark - EaseMessageViewControllerDelegate

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel;
{
    NSDictionary *ext = messageModel.message.ext;
    
    if ([[ext valueForKey:@"agency_building_detail"] isEqualToString:@"1"]) {
        
        BuildingMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuildingMessageDetailCell cellIdentifierWithModel:messageModel]];
        
        if (!cell) {
            
            cell = [[BuildingMessageDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuildingMessageDetailCell cellIdentifierWithModel:messageModel] model:messageModel];
            cell.delegate = self;
            cell.model = messageModel;
            
            [self _sendHasReadResponseForMessages:@[messageModel.message] isRead:YES];
        }
        
        return cell;
        
    }
    
    return nil;
    
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;
{
    
    NSDictionary *ext = messageModel.message.ext;
    if ([[ext valueForKey:@"agency_building_detail"] isEqualToString:@"1"]) {
        
        return [BuildingMessageDetailCell cellHeightWithModel:messageModel];
    }
    
    
    return [EaseBaseMessageCell cellHeightWithModel:messageModel];
    
}



#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
  
    UserCacheInfo * userInfo = [UserCacheManager getById:model.nickname];
    if (userInfo) {
        model.avatarURLPath = userInfo.AvatarUrl;
        model.nickname = userInfo.NickName;
    }
    model.failImageName = @"imageDownloadFail";
    
    
    
    
    return model;
}

- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead
{
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++)
    {
        EMMessage *message = messages[i];
        BOOL isSend = YES;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:shouldSendHasReadAckForMessage:read:)]) {
            isSend = [self.dataSource messageViewController:self
                         shouldSendHasReadAckForMessage:message read:isRead];
        }
        else{
            isSend = [self shouldSendHasReadAckForMessage:message
                                                     read:isRead];
        }
        
        if (isSend)
        {
            [unreadMessages appendObject:message];
        }
    }
    
    if ([unreadMessages count])
    {
        for (EMMessage *message in unreadMessages)
        {
            [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:nil];
        }
    }
}




#pragma mark - delegate
-(void)didCancelWith:(PopView *)popView;
{
    
    [self closeWithPopView:_popView];
    
}


#pragma mark - maskViewTap
-(void)maskViewTap
{
    [self closeWithPopView:_popView];
}

#pragma mark -  做弹出动画

-(void)showWithPopView:(PopView *)popView{
    self.popGestureRecognizerEnable = NO;

    _maskView = ({
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [maskView addGestureRecognizer:tap];
        
        maskView;
        
    });
    [self.view addSubview:_maskView];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];;
    
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    
    CGRect frame = popView.frame;
    frame.origin.y = self.view.bounds.size.height - popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.view.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.view.layer setTransform:[self secondTransform]];
            //                显示maskView
            [_maskView setAlpha:0.5f];
            //                popView上升
            popView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

- (void)closeWithPopView:(PopView *)popView
{
    self.popGestureRecognizerEnable = YES;

    CGRect frame = popView.frame;
    frame.origin.y += popView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //maskView隐藏
        [_maskView setAlpha:0.f];
        //popView下降
        popView.frame = frame;
        
        //同时进行 感觉更丝滑
        [self.view.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [self.view.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
            [popView removeFromSuperview];
            
            [_popView removeAllSubviews];
            [_popView removeFromSuperview];
            _popView.delegate = nil;
            _popView = nil;
            self.tableView.backgroundColor = [UIColor clearColor];
        }];
        
    }];
    
}

- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}





#pragma mark - 新装app首次打开引导页 begin
//是否展示 使用帮助 引导图（新装app 首次打开展示）
- (void) shouldShowChatVCFirstTimeShowImg
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ChatVC_FirstTimeShow"])
    {
        [self showFirstTimeDisplayImg];
    }
}
//展示引导图
- (void) showFirstTimeDisplayImg
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ChatVC_FirstTimeShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //    UIButton *imgBtn_manage = [UIButton buttonWithType:UIButtonTypeCustom];
    //    imgBtn_manage.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    //
    //    [imgBtn_manage addTarget:self action:@selector(removeFirstTimeDisplayImg:) forControlEvents:UIControlEventTouchUpInside];
    //    [imgBtn_manage setImage:[UIImage imageNamed:@"buidingDetailManage_firstTimeShow"] forState:UIControlStateNormal];
    //    [imgBtn_manage setImage:[UIImage imageNamed:@"buidingDetailManage_firstTimeShow"] forState:UIControlStateHighlighted];
    //    [delegate.window addSubview:imgBtn_manage];
    
    UIButton *imgBtn_detail = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn_detail.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    [imgBtn_detail addTarget:self action:@selector(removeFirstTimeDisplayImg:) forControlEvents:UIControlEventTouchUpInside];
    if (iPhone4) {
        [imgBtn_detail setImage:[UIImage imageNamed:@"960im"] forState:UIControlStateNormal];
        [imgBtn_detail setImage:[UIImage imageNamed:@"960im"] forState:UIControlStateHighlighted];
    }else{
        [imgBtn_detail setImage:[UIImage imageNamed:@"1080im"] forState:UIControlStateNormal];
        [imgBtn_detail setImage:[UIImage imageNamed:@"1080im"] forState:UIControlStateHighlighted];
    }
    [delegate.window addSubview:imgBtn_detail];
}

//移除引导图
- (void) removeFirstTimeDisplayImg:(UIButton *) btn
{
    [btn removeFromSuperview];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
