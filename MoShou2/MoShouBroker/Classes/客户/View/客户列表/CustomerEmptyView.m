//
//  CustomerEmptyView.m
//  MoShou2
//
//  Created by wangzz on 16/1/14.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerEmptyView.h"



@implementation CustomerEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = BACKGROUNDCOLOR;//[UIColor whiteColor];
        [self layoutUI];
    }
    return self;
}
#pragma mark 空白也没有数据
-(void)layoutUI{
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(140.0/375 * self.width, 17.0/60 * self.height, 98.0/600*self.height, 111.0/600*self.height)];
    [tempImage setCenterX:self.width/2];
    [self addSubview:tempImage];
    
    _tip = [[UILabel alloc]initWithFrame:CGRectMake(10, tempImage.bottom+20, self.width - 20, 20)];
    [_tip setTextAlignment:NSTextAlignmentCenter];
    [_tip setFont:[UIFont systemFontOfSize:13]];
    [_tip setCenterX:self.width/2];
    [_tip setTextColor:LINECOLOR];
    [_tip setText:@"没有符合要求客户"];
    [self addSubview:_tip];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
