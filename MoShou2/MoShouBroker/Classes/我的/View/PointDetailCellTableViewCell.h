//
//  PointDetailCellTableViewCell.h
//  MoShou2
//
//  Created by Aminly on 16/6/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointDetailCellTableViewCell : UITableViewCell
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@property(strong,nonatomic)UILabel *pointLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
