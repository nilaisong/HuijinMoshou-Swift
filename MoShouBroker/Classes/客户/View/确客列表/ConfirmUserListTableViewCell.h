//
//  ConfirmUserListTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 16/9/20.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^selectConfirmUserBlock)(NSInteger);

@interface ConfirmUserListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *confirmPhoneL;//手机号码显示label
@property (nonatomic, strong) UILabel       *confirmNameL;//确客姓名
@property (nonatomic, strong) UIImageView   *selectImgView;//选中图片

//@property (nonatomic, copy) selectConfirmUserBlock didSelectConfirmUser;

//-(void)selectConfirmUserCellBlock:(selectConfirmUserBlock)ablock;

@end
