//
//  MineTableViewCell.h
//  MoShou2
//
//  Created by Aminly on 16/1/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"
@interface MineTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic ,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UIImageView *arrowImage;
@property(nonatomic,strong)UIView *line;
-(id)init;
@end
