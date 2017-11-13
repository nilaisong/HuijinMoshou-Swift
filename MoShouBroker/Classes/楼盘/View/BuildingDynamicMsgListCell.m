//
//  BuildingDynamicMsgListCell.m
//  MoShou2
//
//  Created by Mac on 2016/12/18.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BuildingDynamicMsgListCell.h"

@implementation BuildingDynamicMsgListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}



-(void)setMsgModel:(EstateDynamicMsgModel *)msgModel
{
    _msgModel = msgModel;
    
    UIView *topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 86/2)];
    [self.contentView addSubview:topView];
    
    UILabel *nameLabel = [UILabel createLabelWithFrame:CGRectMake(10, 0, kMainScreenWidth/2, topView.height) text:nil textAlignment:NSTextAlignmentLeft fontSize:15.f textColor:UIColorFromRGB(0x333333)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [topView addSubview:nameLabel];
    
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom, kMainScreenWidth, 0)];
    [self.contentView addSubview:middleView];

    UILabel *contentLabel = [[UILabel alloc]init];
//WithFrame:CGRectMake(10, 15, kMainScreenWidth-30, middleView.height)];
    contentLabel.textColor = UIColorFromRGB(0x333333);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = FONT(13.f);
    contentLabel.text = _msgModel.info;
    contentLabel.numberOfLines = 0;
    CGSize size = [contentLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-30, 0)];
    
    contentLabel.frame = CGRectMake(10, 0, size.width, size.height);
    
    middleView.height = contentLabel.height;
    [middleView addSubview:contentLabel];
    
    
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, middleView.bottom+10, kMainScreenWidth, 10)];
    bottonView.backgroundColor = UIColorFromRGB(0xefeff4);
    
    [self.contentView addSubview:bottonView];
    
    if([_msgModel.fromType isEqualToString:@"confirm"]) //确客
    {
        nameLabel.text =_msgModel.chatUserNick;
        if (_msgModel.chatUserNick.length>=6) {
            nameLabel.width = 15.3*6.5;
        }else{
            CGSize size = [nameLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
            nameLabel.width = size.width;
        }
        
        UILabel *quekeLabel = [UILabel createLabelWithFrame:CGRectMake(nameLabel.right+10, 14, 60, 15) text:@"确客专员" textAlignment:NSTextAlignmentCenter fontSize:12.f textColor:UIColorFromRGB(0x888888) bgColor:[UIColor clearColor] cornerRadius:15/2];
        quekeLabel.layer.borderWidth = 1;
        quekeLabel.layer.borderColor =UIColorFromRGB(0x888888).CGColor;
        [topView addSubview:quekeLabel];
        
        UILabel *timelabel = [UILabel createLabelWithFrame:CGRectMake(quekeLabel.right+10, 0, kMainScreenWidth/2, topView.height) text:_msgModel.createTime textAlignment:NSTextAlignmentLeft fontSize:12.f textColor:UIColorFromRGB(0x888888)];
        [topView addSubview:timelabel];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-topView.height, 0, topView.height, topView.height)];
        button.userInteractionEnabled = NO;
        [button setImage:[UIImage imageNamed:@"在线咨询"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onLineChat) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
    }else if ([_msgModel.fromType isEqualToString:@"system"]){// 系统消息
    
        nameLabel.text = @"系统消息";
        CGSize size = [nameLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
        nameLabel.width = size.width;

        UILabel *timelabel = [UILabel createLabelWithFrame:CGRectMake(nameLabel.right+10, 0, kMainScreenWidth-nameLabel.right-20, topView.height) text:_msgModel.createTime textAlignment:NSTextAlignmentLeft fontSize:12.f textColor:UIColorFromRGB(0x888888)];
        [topView addSubview:timelabel];
        

    }else if ([_msgModel.fromType isEqualToString:@"pc"]){
        
        nameLabel.text = @"系统管理员";
        CGSize size = [nameLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
        nameLabel.width = size.width;
        
        UILabel *timelabel = [UILabel createLabelWithFrame:CGRectMake(nameLabel.right+10, 0, kMainScreenWidth-nameLabel.right-20, topView.height) text:_msgModel.createTime textAlignment:NSTextAlignmentLeft fontSize:12.f textColor:UIColorFromRGB(0x888888)];
        [topView addSubview:timelabel];

        
    }
    
    
}

-(void)onLineChat
{
    
    
    
    
}





+ (CGFloat)buildingCellHeightWithModel:(EstateDynamicMsgModel *)model;
{
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = UIColorFromRGB(0x333333);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = FONT(13.f);
    contentLabel.text = model.info;
    contentLabel.numberOfLines = 0;
    CGSize size = [contentLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-30, 0)];
    
    return 43+20+size.height;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
