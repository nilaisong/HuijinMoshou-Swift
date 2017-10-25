//
//  MessageNoticeTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 2016/10/17.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNoticeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView  *headeImageView;//头像
@property (nonatomic, strong) UILabel      *titleLabel;//消息标题
@property (nonatomic, strong) UILabel      *contentLabel;//消息内容
@property (nonatomic, strong) UILabel      *dateTimeLabel;//时间
@property (nonatomic, strong) UILabel      *msgNumLabel;//未读消息条数

@end
