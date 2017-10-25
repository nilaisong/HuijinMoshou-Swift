//
//  MessageTableViewCell.m
//  MoShou2
//
//  Created by Aminly on 16/2/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "HMTool.h"
@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"]) {
       self.redDot =[[UIImageView alloc]initWithFrame:CGRectMake(8-3, 20, 6, 6)];
        [self.redDot setImage:[UIImage imageNamed:@"椭圆-7"]];
        [self addSubview:self.redDot];
  
        self.title = [[UILabel alloc]init];
        [self.title setText:@""];
        [self.title setFont:[UIFont systemFontOfSize:14]];
        CGSize titleSize =[HMTool getTextSizeWithText:self.title.text andFontSize:14];
        [self.title setFrame:CGRectMake(kFrame_XWidth(self.redDot)+10, 20, titleSize.width, titleSize.height)];
        [self addSubview:self.title];
        
        self.time = [[UILabel alloc]init];
        [self.time setText:@""];
        [self.time setFont:[UIFont systemFontOfSize:12]];
        [self.time setTextColor:POINTMALLGRAYLABELCOLOR];
        
        CGSize timeSize =[HMTool getTextSizeWithText:self.time.text andFontSize:12];
        [self.time setFrame:CGRectMake(kMainScreenWidth-timeSize.width-16, 20, timeSize.width, timeSize.height)];
        [self addSubview:self.time];
        
        self.content = [[UILabel alloc]init];
        [self.content  setFont:[UIFont systemFontOfSize:12]];
        [self.content  setTextColor:POINTMALLGRAYLABELCOLOR];
        [self.content  setFrame:CGRectMake(16, kFrame_YHeight(self.title)+8, kMainScreenWidth-32, 96-(kFrame_YHeight(self.title)+16)-10)];
        self.content .numberOfLines = 0;
        [self.content  setText:@""];
        [self addSubview:self.content ];
        
        self.line =[HMTool getLineWithFrame:CGRectMake(16, 96.5, kMainScreenWidth-32, 0.5) andColor:LINECOLOR];
        [self addSubview:self.line];
        
    }
    return self;
}


@end
