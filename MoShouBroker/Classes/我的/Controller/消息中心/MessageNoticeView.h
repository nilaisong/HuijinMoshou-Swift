//
//  MessageNoticeView.h
//  MoShou2
//
//  Created by wangzz on 16/10/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MessageData;
@class MessageNoticeView;
@protocol MessageNoticeViewDelegate <NSObject>
@optional

//点击tableviewcell
- (void)MessageDidSelectedCell:(MessageNoticeView*)noticeView AndIndexPath:(NSIndexPath *)indexPath Message:(MessageData*)msg;

@end

@interface MessageNoticeView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView          *tableView;
@property (nonatomic) id <MessageNoticeViewDelegate> cellDelegate;
@property (nonatomic, strong) NSMutableArray       *messageArray;
@property (nonatomic, strong) UIView    *emptyView;

//-(instancetype)initWithMessageArray:(NSArray*)msgArray AndFrame:(CGRect)frame;

@end
