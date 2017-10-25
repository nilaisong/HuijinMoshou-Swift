//
//  CreateCallView.m
//  MoShou2
//
//  Created by wangzz on 16/5/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CreateCallView.h"

@interface CreateCallView()

@property (nonatomic, strong) UIView *groupView;
@property (nonatomic, strong) UIButton *telBtn;

@end

@implementation CreateCallView
@synthesize groupView;
@synthesize telBtn;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.3];
        
    }
    return self;
}

-(void)setTelArray:(NSArray *)telArray
{
    _telArray = telArray;
    [self layoutUI];
}

-(void)callCustomerBlock:(callBtnSelectedBlock)ablock
{
    self.didSelectedCall = ablock;
}

-(void)cancelViewBlock:(cancelBtnBlock)ablock
{
    self.didCancel = ablock;
}

- (void)layoutUI
{
    groupView = [[UIView alloc] initWithFrame:CGRectMake(0.1*self.width, self.height/3, 0.8*self.width, 0)];
    if (_telArray.count==2) {
        groupView.height = 188;
        groupView.top = (self.height-188)/2;
    }else
    {
        groupView.height = 232;
        groupView.top = (self.height-232)/2;
    }
    groupView.backgroundColor = [UIColor whiteColor];
    groupView.alpha = 0.95;
    [groupView.layer setMasksToBounds:YES];
    [groupView.layer setCornerRadius:8.0];
    [self addSubview:groupView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, groupView.width, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"拨打号码";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = NAVIGATIONTITLE;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [groupView addSubview:titleLabel];
    
    [groupView addSubview:[self createLineView:titleLabel.bottom+4.5]];
    
    for (int i=0; i<_telArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[[_telArray objectForIndex:i] substringWithRange:NSMakeRange(0, 3)],[[_telArray objectForIndex:i] substringWithRange:NSMakeRange(3, 4)],[[_telArray objectForIndex:i] substringWithRange:NSMakeRange(7, 4)]];//[_telArray objectForIndex:i];
        telBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50+44*i, groupView.width, 43.5)];
        telBtn.tag = 1000+i;
        telBtn.backgroundColor = [UIColor clearColor];
        [telBtn setTitle:str forState:UIControlStateNormal];
        [telBtn setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
        [telBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateHighlighted];
        telBtn.titleLabel.font = FONT(18);
        [telBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:telBtn];
        
        [groupView addSubview:[self createLineView:telBtn.bottom]];
    }
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, telBtn.bottom+0.5, groupView.width, 50)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [cancleBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(toggleCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:cancleBtn];
}

- (void)toggleCallBtn:(UIButton*)sender
{
    NSInteger tag = sender.tag-1000;
    _didSelectedCall(tag);
}

-(void)toggleCancleBtn
{
    _didCancel();
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, groupView.width, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
