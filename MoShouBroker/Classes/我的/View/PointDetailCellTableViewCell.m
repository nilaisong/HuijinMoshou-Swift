//
//  PointDetailCellTableViewCell.m
//  MoShou2
//
//  Created by Aminly on 16/6/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "PointDetailCellTableViewCell.h"
#import "HMTool.h"
@implementation PointDetailCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (void)initLayout{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, 60);
    self.titleLabel =[[UILabel alloc]init];
//    [self.titleLabel setTextColor:NAVIGATIONTITLE];
//    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [self.titleLabel setText:pointDate.ruleName];
//    CGSize size = [HMTool getTextSizeWithText:title.text andFontSize:14];
//    [self.titleLabel setFrame:CGRectMake(25, 15, size.width, size.height)];
    [self addSubview:self.titleLabel];
    
    self.timeLabel =[[UILabel alloc]init];
//    [time setTextColor:POINTMALLGRAYLABELCOLOR];
//    [time setFont:[UIFont systemFontOfSize:14]];
//    [time setText:pointDate.operationTime];
//    CGSize timeSize = [HMTool getTextSizeWithText:time.text andFontSize:14];
//    [time setFrame:CGRectMake(25, kFrame_YHeight(title)+10, timeSize.width, timeSize.height)];
    [self addSubview:self.timeLabel];
    
    self.pointLabel =[[UILabel alloc]init];
//    [num setTextColor:BLUEBTBCOLOR];
//    [num setFont:[UIFont systemFontOfSize:14]];
//    
//    [num setText:[NSString stringWithFormat:@"%@%@",pointDate.ruleOpt,pointDate.point ]];
//    CGSize numSize = [HMTool getTextSizeWithText:num.text andFontSize:14];
//    [num setFrame:CGRectMake(kMainScreenWidth-25-numSize.width, kFrame_YHeight(title)+10, numSize.width, numSize.height)];
    [self addSubview:self.pointLabel];
//    if (size.width>(kMainScreenWidth-numSize.width)) {
//        [title setFrame:CGRectMake(25, 15,kMainScreenWidth-numSize.width, size.height)];
//    }
    
    UIView *line = [HMTool getLineWithFrame:CGRectMake(16, 59.5, kMainScreenWidth-32,0.5) andColor:LINECOLOR];
    [self addSubview:line];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
