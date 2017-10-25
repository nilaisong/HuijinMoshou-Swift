//
//  MessageListViewController.h
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//
#import "MessageNoticeView.h"

#import "BaseViewController.h"

@interface MessageListViewController : EaseConversationListViewController<MessageNoticeViewDelegate,EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource,UITextFieldDelegate>

@property(nonatomic,assign)int pageNum;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,assign)BOOL morePage;
-(void)refresh;

- (void)refreshDataSource;



@end
