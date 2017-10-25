//
//  EaseBubbleView+RedPacket.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (RedPacket)

//  MARK:__redbag
@property (strong, nonatomic) UIImageView *redpacketIcon;  //楼盘图标
@property (strong, nonatomic) UILabel *redpacketNameLabel;  //楼盘姓名
@property (strong, nonatomic) UILabel *redpacketTitleLabel;   //






//@property (strong, nonatomic) UILabel *redpacketSubLabel;
//@property (strong, nonatomic) UIImageView *redpacketCompanyIcon;


- (void)setupRedPacketBubbleView;

- (void)updateRedpacketMargin:(UIEdgeInsets)margin;

@end
