//
//  MessageNoticeDetailTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 2016/10/24.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"

@interface MessageNoticeDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *dateTimeLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIView      *bottomView;

@property (nonatomic, strong) UIButton    *bottomBtn;

- (id)initWithMessageData:(MessageData*)data AndMsgType:(NSString*)msgType AndIndexPath:(NSIndexPath*)indexPath;

@end
