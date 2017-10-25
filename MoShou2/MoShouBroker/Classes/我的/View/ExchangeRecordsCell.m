//
//  ExchangeRecordsCell.m
//  MoShou2
//
//  Created by Aminly on 16/1/26.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ExchangeRecordsCell.h"
#import "HMTool.h"
@implementation ExchangeRecordsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init{

    if (self= [super init]) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth, 105);
        self.exchangeImage =[[MyImageView alloc]initWithFrame:CGRectMake(16, 15, 100, 75)];
        self.exchangeImage.layer.cornerRadius = 10;
        self.exchangeImage.layer.masksToBounds = YES;
        [self addSubview:self.exchangeImage];
        
        self.nameLabel = [[UILabel alloc]init];
        [self.nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self.nameLabel setTextColor:NAVIGATIONTITLE];
        [self.nameLabel setFrame:CGRectMake(kFrame_XWidth(self.exchangeImage)+15, self.exchangeImage.centerY-50,100,50)];
        [self addSubview:self.nameLabel];
        
        self.coastLabel = [[UILabel alloc]init];
        [self.coastLabel setFont:[UIFont systemFontOfSize:14]];
        [self.coastLabel setFrame:CGRectMake(kFrame_X(self.nameLabel), self.exchangeImage.centerY+50, 100, 50)];
        [self addSubview:self.coastLabel];
        
        self.numLabel =[[UILabel alloc]init];
        [self.numLabel setText:@"x1"];
        [self.numLabel setTextColor:POINTMALLGRAYLABELCOLOR];
        [self.numLabel setFont:[UIFont systemFontOfSize:12]];
        CGSize remainNumSize =[self.numLabel.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [self.numLabel setFrame:CGRectMake(kMainScreenWidth-16-remainNumSize.width,kFrame_Y(self.nameLabel), remainNumSize.width, remainNumSize.height)];
        [self addSubview:self.numLabel];
        
        self.timeLabel =[[UILabel alloc]init];
        [self.timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.timeLabel setTextColor:[UIColor colorWithHexString:@"888888"]];
        [self.timeLabel setFrame:CGRectMake(kMainScreenWidth-16-100,kFrame_Y(self.numLabel), 100, 50)];
        [self addSubview:self.timeLabel];
        self.statusLabel = [[UILabel alloc]init];
        [self.timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:self.statusLabel];
        
        UIView *line = [HMTool getLineWithFrame:CGRectMake(10, 105-0.5, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
        [self addSubview:line];
        
        
    }
    return  self;
}

@end
