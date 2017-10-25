//
//  BuildingMessageDetailCell.m
//  MoShou2
//
//  Created by strongcoder on 16/10/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BuildingMessageDetailCell.h"

#import "EaseBubbleView+RedPacket.h"

#import "BuildingDetailViewController.h"




@implementation BuildingMessageDetailCell

{
    
    NSString * _buildingID;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    
    if (self) {
//        self.hasRead.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}



- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
    
//    self.bubbleView.imageView.layer.cornerRadius = self.bubbleView.imageView.width/2;
//    self.bubbleView.imageView.layer.masksToBounds = YES;
    
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    [_bubbleView setupRedPacketBubbleView];
//
//    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    [_bubbleView updateRedpacketMargin:bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    if (model.isSender) {
        _bubbleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, 2, 213, 94);
        self.bubbleView.redpacketIcon.frame = CGRectMake(13, 19, 26, 34);
        self.bubbleView.redpacketTitleLabel.frame = CGRectMake(48, 19, 156, 15);
//        self.bubbleView.redpacketSubLabel.frame = CGRectMake(48, 41, 49, 12);
        self.bubbleView.redpacketNameLabel.frame = CGRectMake(13, 73, 200, 20);
    }else{
        _bubbleView.frame = CGRectMake(55, 2, 213, 94);
        self.bubbleView.redpacketIcon.frame = CGRectMake(20, 19, 26, 34);
        self.bubbleView.redpacketTitleLabel.frame = CGRectMake(55, 19, 156, 15);
//        self.bubbleView.redpacketSubLabel.frame = CGRectMake(55, 41, 49, 12);
        self.bubbleView.redpacketNameLabel.frame = CGRectMake(20, 73, 200, 20);
    }
    
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return model.isSender ? @"__redPacketCellSendIdentifier__" : @"__redPacketCellReceiveIdentifier__";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 100;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSDictionary *dict = model.message.ext;
    
    
//    ChatUserId      //环信ID
//    ChatUserNick    //环信昵称
//    ChatUserPic     //环信 &用户头像
//    
//    
//    agency_building_url    楼盘图片url
//    agency_building_name    楼盘名字
//    agency_building_id    楼盘id
//    agency_building_area    楼盘区域商圈
//    agency_building_detail     是否显示楼盘详情的自定义图片view
//    agency_mobile            经纪人手机号
//    agency_employeeNo  经纪人员工编号
//    agency_department 经纪人机构门店
    
    
    UIImageView * buildingImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 94-24, 94-24)];
    [buildingImage sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"agency_building_url"]] placeholderImage:[UIImage imageNamed:@"首页-资讯默认图"]];
    
    
    UIColor *color;;
    if (model.isSender) {
        color = [UIColor whiteColor];
    }else{
        color = [UIColor blackColor];
    }
    
    [self.bubbleView addSubview:buildingImage];
    
    UILabel *buildingNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(12+94-24+10, 12,213-(94-24)-28 , (94-24)/2)];
    buildingNamelabel.text = [dict valueForKey:@"agency_building_name"];
    buildingNamelabel.font = FONT(14.f);
    buildingNamelabel.textColor = color;

    [self.bubbleView addSubview:buildingNamelabel];
    
    
//     楼盘区域商圈
    UILabel *departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(12+94-24+10, 12+(94-24)/2, 213-(94-24)-28, (94-24)/2)];
    
    departmentLabel.text = [dict valueForKey:@"agency_building_area"];
    departmentLabel.textColor = color;
    departmentLabel.font = FONT(12.f);
    
    [self.bubbleView addSubview:departmentLabel];
    
    
    self.bubbleView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToBuildingDetailVC)];
    
    [self.bubbleView addGestureRecognizer:tap];
    
    _buildingID =[dict valueForKey:@"agency_building_id"];

//    _hasRead.hidden = YES;
    _nameLabel = nil;// 不显示姓名
    _nameLabel.hidden = YES;
    _nameLabel.textColor = [UIColor clearColor];
    
}

-(void)jumpToBuildingDetailVC
{
    BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
    VC.buildingId = _buildingID;
    VC.eventId = @"PAGE_IM_LPLJ";
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:VC animated:YES];
    
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    NSString *imageName = self.model.isSender ? @"RedpacketCellResource.bundle/redpacket_sender_bg" : @"RedpacketCellResource.bundle/redpacket_receiver_bg";
//    UIImage *image = self.model.isSender ? [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:30 topCapHeight:35] :
//    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
//    
//    self.bubbleView.backgroundImageView.image = image;
//}






@end
