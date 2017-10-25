//
//  EditCustomerView.m
//  MoShou2
//
//  Created by wangzz on 15/12/2.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "EditCustomerView.h"

@implementation EditCustomerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.1];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(self.width-15-140, 64, 140, 120)];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.alpha = 0.97;
    [btnView.layer setCornerRadius:6.0];
    [btnView.layer setMasksToBounds:YES];
    [self addSubview:btnView];
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn0 setFrame:CGRectMake(0, 0, btnView.width, 39.5)];
    [btn0 setTitle:@"添加组成员" forState:UIControlStateNormal];
    [btn0 setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
    [btn0.titleLabel setFont:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]];
    btn0.tag = 100;
    [btn0 addTarget:self action:@selector(ToggleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn0];
    
    UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, btn0.bottom, btn0.width, 0.5)];
    [lineLb setBackgroundColor:LINECOLOR];
    [btnView addSubview:lineLb];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 40, btnView.width, 40)];
    [btn1 setTitle:@"重命名" forState:UIControlStateNormal];
    [btn1 setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]];
    btn1.tag = 101;
    [btn1 addTarget:self action:@selector(ToggleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn1];
    
    UILabel *lineLb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, btn1.bottom, btn1.width, 0.5)];
    [lineLb1 setBackgroundColor:LINECOLOR];
    [btnView addSubview:lineLb1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(0, 81, btnView.width, 39.5)];
    [btn2 setTitle:@"删除组" forState:UIControlStateNormal];
    [btn2 setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]];
    btn2.tag = 102;
    [btn2 addTarget:self action:@selector(ToggleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn2];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissAction)];
    
    [self addGestureRecognizer:tap];
}

- (void)ToggleBtnAction:(UIButton*)sender
{
    NSInteger btnTag = sender.tag-100;
    _didSelectedAtIndex(btnTag);
    [self disMissAction];
}

-(void)editCustomerBlock:(btnSelectedBlock)ablock
{
    self.didSelectedAtIndex = ablock;
}

-(void)disMissAction
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
