//
//  MessageTableViewCell.h
//  MoShou2
//
//  Created by Aminly on 16/2/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)UIImageView *redDot;
@property(nonatomic,strong)UIView *line;
@end
