//
//  HouseTypeListTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 2016/12/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"

@interface HouseTypeListTableViewCell : UITableViewCell

@property (nonatomic,strong) MyImageView      *picImgView;//户型图
@property (nonatomic,strong) UILabel          *titleLabel;//例如：2室1厅1卫  72平
@property (nonatomic,strong) UILabel          *detailLabel;//name  type例如：A-02  简装修
@property (nonatomic,strong) UILabel          *priceLabel;//销售价格

@end
