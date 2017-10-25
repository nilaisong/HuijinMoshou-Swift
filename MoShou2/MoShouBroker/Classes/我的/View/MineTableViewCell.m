//
//  MineTableViewCell.m
//  MoShou2
//
//  Created by Aminly on 16/1/25.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MineTableViewCell.h"
#import "UserData.h"
#import "HMTool.h"
@implementation MineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mincell"]) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22-8.5, 17, 17)];
//        [self.iconImage setImage:[UIImage imageNamed:iconName]];
        [self addSubview:self.iconImage];
        
        self.titleLabel = [[UILabel alloc]init];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:NAVIGATIONTITLE];
//        [self.titleLabel setText:title];
        CGSize titleSize =[@"把APP分享给朋友" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        [self.titleLabel setFrame:CGRectMake(kFrame_XWidth(self.iconImage)+10, 22-titleSize.height/2, titleSize.width, titleSize.height)];
        [self addSubview:self.titleLabel];
        
        self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-titleSize.height/2, 22-titleSize.height/2, titleSize.height/2, titleSize.height)];
        [self.arrowImage setImage:[UIImage imageNamed:@"arrow-right"]];
        [self addSubview:self.arrowImage];
        
        self.detailLabel = [[UILabel alloc]init];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.detailLabel setFont:[UIFont systemFontOfSize:12]];
        [self.detailLabel setFrame:CGRectMake(kFrame_X(self.arrowImage)-150, 0, 140, 44)];
        [self.detailLabel setTextColor:[UIColor colorWithHexString:@"888888"]];
        [self addSubview:self.detailLabel];
        self.line = [HMTool creareLineWithFrame:CGRectMake(10, 44-0.5, kMainScreenWidth-10, 0.5) andColor:VIEWBGCOLOR];
        [self addSubview:self.line];

    }
    return self;
}

@end
