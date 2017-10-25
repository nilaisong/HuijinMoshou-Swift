//
//  ConfirmUserListTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 16/9/20.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ConfirmUserListTableViewCell.h"

@implementation ConfirmUserListTableViewCell
@synthesize confirmNameL;
@synthesize confirmPhoneL;
@synthesize selectImgView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer
{
    confirmNameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth-20-150, 30)];//CGRectMake(headImageView.right+10, 5, kMainScreenWidth-headImageView.right-20, 20)
    confirmNameL.textColor = NAVIGATIONTITLE;
    confirmNameL.textAlignment = NSTextAlignmentLeft;
    //        customerNameLabel.backgroundColor = [UIColor yellowColor];
    confirmNameL.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:confirmNameL];
    
    confirmPhoneL = [[UILabel alloc] initWithFrame:CGRectMake(confirmNameL.left, confirmNameL.bottom, 120, 20)];
    confirmPhoneL.backgroundColor = [UIColor clearColor];
    confirmPhoneL.textAlignment = NSTextAlignmentLeft;
    confirmPhoneL.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    confirmPhoneL.textColor = LABELCOLOR;//[UIColor colorWithHexString:@"0e0e0e"];
    [self.contentView addSubview:confirmPhoneL];
    
    selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-20-20-10, 25, 20, 20)];
    [selectImgView setImage:[UIImage imageNamed:@"img_select"]];
    selectImgView.hidden = YES;
    [self.contentView addSubview:selectImgView];
    
}

//-(void)selectConfirmUserCellBlock:(selectConfirmUserBlock)ablock
//{
//    self.didSelectConfirmUser = ablock;
//}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
