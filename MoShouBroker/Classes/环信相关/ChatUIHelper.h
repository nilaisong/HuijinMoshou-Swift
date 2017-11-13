/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

#import "ChatListViewController.h"
//#import "ConversationListController.h"
//#import "ContactListViewController.h"
#import "ChatViewController.h"
#import "MessageListViewController.h"


@interface ChatUIHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>
@property (nonatomic,copy) NSString *currentChatConversationId; //当前聊天对象ID 初始化位空

//@property (nonatomic, weak) ContactListViewController *contactViewVC;

@property (nonatomic, weak) MessageListViewController *conversationListVC;

//@property (nonatomic, weak) UIViewController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;


@property (nonatomic, assign)EMConnectionState connectionState;


+ (instancetype)shareHelper;

- (void)asyncPushOptions;

//- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

#if DEMO_CALL == 1

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

#endif

- (void)playSoundAndVibration;
@end
